#!/bin/bash
#SBATCH --partition=small
#SBATCH --job-name=compress
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/compress_%A_%a.out
#SBATCH --error=logs/compress_%A_%a.out
#SBATCH --time=00:59:00
#SBATCH --mem=1G
#SBATCH --account=project_462000963

# Ensure input/output directories are set
if [ -z "$DIR" ] || [-z "$BATCH_SIZE" ]; then
  echo "DIR and BATCH_SIZE must be set"
  exit 1
fi

echo Directory: $DIR
echo Batch size: $BATCH_SIZE

# Check if the path is a directory or a file
if [ -d "$DIR" ]; then
    echo "$DIR is a directory. Packing all .jsonl files inside..."
    echo Array id $SLURM_ARRAY_TASK_ID
    FILES=($(find $DIR -type f -name "*.jsonl" | sort))
    START_INDEX=$(($SLURM_ARRAY_TASK_ID * $BATCH_SIZE))
    echo Start index: $START_INDEX
    for FILE in ${FILES[@]:$START_INDEX:$BATCH_SIZE}; do
        echo "Compressing $FILE"
        zstd -z $FILE
        rm $FILE
    done
else
    echo "Error: $DIR is not a valid directory."
    exit 1
fi
