#!/usr/bin/env bash

# Tokenize json line files.
# To be used with hyperqueue.
# Example:
# hq submit --cpus 32 --each-line files.txt  ./tokenize.sh
# files.txt contain on .jsonl.zst file per line

#IN_PREFIX=/scratch/project_462000953/training/catalogue
IN_PREFIX=/scratch/project_462000963/datasets/
OUT_PREFIX=/scratch/project_462000963/users/magnrune/data/tokenized/oellm-256k-sampled-10p

mkdir -p $(dirname ${OUT_PREFIX}/${HQ_ENTRY})

module purge
export PYTHONNOUSERSITE=1
export PYTHONPATH=""
module use /appl/local/csc/modulefiles; module load pytorch/2.5

python -c "import sys; print(sys.executable); print('\n'.join(sys.path))"

# Set Hugging Face token
export HUGGING_FACE_HUB_TOKEN=$(cat ~/.huggingface/token)

# Optional: Set the cache directory for Hugging Face models (if you want to specify a custom path)
export HIP_VISIBLE_DEVICES=0

#OUTPUT=${OUT_PREFIX}/${HQ_ENTRY}
OUTPUT=${OUT_PREFIX}/allenai/dolma3_dolmino_mix-100B-1125/$1/$1
# SAMPLED is the temporary sampled file
SAMPLED=$(dirname ${OUTPUT})/$(basename ${HQ_ENTRY})

mkdir -p $(dirname ${OUTPUT})

echo Entry: ${HQ_ENTRY}

function cleanup()
{
  rm ${SAMPLED}
}
trap cleanup EXIT
trap cleanup SIGINT


awk 'BEGIN {srand()} !/^$/ { if (rand() <= 0.1) print $0}' < "${IN_PREFIX}/${HQ_ENTRY}" > ${SAMPLED}

python3 $MEGATRON/tools/preprocess_data.py \
  --input "${SAMPLED}" \
  --output-prefix  ${OUTPUT} \
  --tokenizer-type HuggingFaceTokenizer \
	--tokenizer-model openeurollm/tokenizer-256k  \
	--append-eod \
	--log-interval 10000 \
	--workers 32 \
	--json-keys text
