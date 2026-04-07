#!/bin/bash


# Set input and output directories
IN_DIR="$1"
OUT_DIR="$2"

# Check that input directory exists
if [ ! -d "$IN_DIR" ]; then
  echo "Error: Input directory does not exist: $IN_DIR"
  exit 1
fi

# Create output directory (and parents if needed)
mkdir -p "$OUT_DIR"
echo "Output directory created (if not existing): $OUT_DIR"

# Count number of .jsonl.zst files in input directory
NUM_FILES=$(ls -1 "$IN_DIR" 2>/dev/null | wc -l)

# Validate file count
if [ "$NUM_FILES" -eq 0 ]; then
  echo "No .jsonl.zst files found in $IN_DIR"
  exit 1
fi

# Export directories as environment variables for SLURM job
export IN_DIR
export OUT_DIR

# Submit SLURM array job
sbatch --export=ALL --array=0-$(($NUM_FILES - 1)) decompress.sh
