#!/usr/bin/env bash

DIR_LIST=$1

IN_PREFIX=/scratch/project_462000963/users/magnrune/data/tokenized/oellm-256k-sampled-10p/the-stack/1.2/data
OUT_PREFIX=/scratch/project_462000963/users/magnrune/data/tokenized/oellm-256k/the-stack/1.2/data/sampled-10p



for f in $(cat $DIR_LIST); do
  mkdir -p ${OUT_PREFIX}/${f}/
  echo merge.sh --input ${IN_PREFIX}/${f} --output-prefix ${OUT_PREFIX}/${f}/${f}
  sbatch merge.sh --input ${IN_PREFIX}/${f} --output-prefix ${OUT_PREFIX}/${f}/${f}
done