#!/bin/bash -x
#SBATCH --partition=small
#SBATCH --job-name=decompress
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/decompress_%A_%a.out
#SBATCH --time=01:59:00
#SBATCH --mem=10G
#SBATCH --account=project_462000963

# Ensure input/output directories are set
if [ -z "$IN_DIR" ] || [ -z "$OUT_DIR" ]; then
  echo "IN_DIR and OUT_DIR must be set"
  exit 1
fi

# Check if the path is a directory or a file
if [ -d "$IN_DIR" ]; then
    echo "$IN_DIR is a directory. Unpacking all .zst files inside..."
    mkdir -p $OUT_DIR/$IN_DIR
    for sub_file in "$IN_DIR"/*.jsonl.zst; do
        # Skip the loop if no files match the pattern
        [ -e "$sub_file" ] || continue

        OUT_FILE=$(basename "$sub_file" .zst)
        echo "Decompressing $sub_file -> $OUT_DIR/$IN_DIR/$OUT_FILE"
        zstd -d -c "$sub_file" > "$OUT_DIR/$IN_DIR/$OUT_FILE"
    done
else
    echo "Error: $IN_DIR is not a valid directory."
    exit 1
fi

