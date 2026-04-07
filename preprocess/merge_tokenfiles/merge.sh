#!/bin/bash
#SBATCH --job-name=merge
#SBATCH --nodes=1
#SBATCH --cpus-per-task=7
#SBATCH --mem=120G
#SBATCH --gpus-per-node=1
#SBATCH --partition=small-g
#SBATCH --time=5:00:00
#SBATCH --account=project_462000963
#SBATCH --output=logs/merge_output_%j.log

module purge
module use /appl/local/csc/modulefiles; module load pytorch/2.5
export PYTHONNOUSERSITE=1
export PYTHONPATH=""

# Set Hugging Face token
export HUGGING_FACE_HUB_TOKEN=$(cat ~/.huggingface/token)

# -------- Argument parsing --------
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --input) INPUT="$2"; shift ;;
        --output-prefix) OUTPUT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check for required arguments
if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: sbatch merge.sh --input <input_dir> --output-prefix <output_path>"
    exit 1
fi

# -------- Run the merging script --------
echo "Running merge with:"
echo "  Input: $INPUT"
echo "  Output: $OUTPUT"

time python3 $MEGATRON/tools/merge_datasets.py --input "$INPUT" --output-prefix "$OUTPUT"