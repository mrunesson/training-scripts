# Example to convert all parquet files in a dir.
# for l in $(ls *.parquet);do python3 parquet2jsonl.py $l ${l%.*}.jsonl.zstd ; done

import sys
import argparse
import pyarrow.parquet as pq
import zstandard as zstd
import json


def stream_parquet_to_jsonl_zst(input_path, output_path, chunk_size=10000):
    """
    Streams data from Parquet to a Zstd-compressed JSONL file.
    """
    # 1. Initialize the Zstd compressor
    cctx = zstd.ZstdCompressor(level=3)

    try:
        # 2. Open the Parquet file as a stream
        parquet_file = pq.ParquetFile(input_path)

        print(f"Streaming {input_path} to {output_path}...")

        with open(output_path, 'wb') as f:
            with cctx.stream_writer(f) as compressor:
                for i, batch in enumerate(parquet_file.iter_batches(batch_size=chunk_size)):
                    # Only 'chunk_size' rows are in RAM
                    data = batch.to_pylist()

                    for record in data:
                        line = json.dumps(record, ensure_ascii=False) + "\n"
                        compressor.write(line.encode('utf-8'))

                    if (i + 1) % 10 == 0:
                        print(f"Processed {(i + 1) * chunk_size} rows...", end='\r')

        print(f"\nFinished! Output saved to {output_path}")

    except Exception as e:
        print(f"\nAn error occurred: {e}")
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Memory-efficient Parquet to JSONL.zst converter")
    parser.add_argument("input", help="Path to input .parquet file")
    parser.add_argument("output", help="Path to output .jsonl.zst file")
    parser.add_argument("--chunk", type=int, default=10000, help="Rows to process at a time (default: 10000)")

    args = parser.parse_args()
    stream_parquet_to_jsonl_zst(args.input, args.output, args.chunk)