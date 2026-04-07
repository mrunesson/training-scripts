#!/bin/bash

DIR="$1"
BATCH_SIZE=$2

# TODO: Check args are provided

# Check that input directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: Input directory does not exist: $DIR"
  exit 1
fi

# Count number of .jsonl files in input directory
NUM_FILES=$(find $DIR -type f -name "*.jsonl" 2>/dev/null | wc -l)

# Validate file count
if [ "$NUM_FILES" -eq 0 ]; then
  echo "No .jsonl files found in $IN_DIR"
  exit 1
fi

# Export directories as environment variables for SLURM job
export DIR
export BATCH_SIZE

# Calculate ceil(NUM_FILES/BATCH_SIZE) for integers
ARRAYS=$(( ($NUM_FILES + $BATCH_SIZE - 1) / $BATCH_SIZE ))
echo Arrays needed $ARRAYS

# Submit SLURM array job
sbatch --export=ALL --array=0-$(($ARRAYS - 1)) compress.sh