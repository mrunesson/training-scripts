#!/bin/bash -x

# Set input and output directories
IN_FILE="$1"
OUT_DIR="$2"

# Check that input directory exists
if [ ! -f "$IN_FILE" ]; then
  echo "Error: Input file does not exist: $IN_FILE"
  exit 1
fi

# Create output directory (and parents if needed)
mkdir -p "$OUT_DIR"
echo "Output directory created (if not existing): $OUT_DIR"

# Export directories as environment variables for SLURM job
export IN_DIR
export OUT_DIR

for p in $(cat $IN_FILE)
do
  IN_DIR=$p sbatch --export=ALL ./decompress.sh
done
