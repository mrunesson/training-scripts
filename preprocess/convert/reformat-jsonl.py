import json
import argparse
import sys


def process_jsonl(input_path, output_path):
    try:
        # 'with' statements ensure files are closed properly even if an error occurs
        with open(input_path, 'r', encoding='utf-8') as infile, \
                open(output_path, 'w', encoding='utf-8') as outfile:

            print(f"Reading from {input_path}...")

            for line_number, line in enumerate(infile, 1):
                if not line.strip():
                    continue

                try:
                    data = json.loads(line)
                    json.dump(data, outfile, ensure_ascii=False)
                    outfile.write('\n')

                except json.JSONDecodeError as e:
                    print(f"Error decoding JSON on line {line_number}: {e}")
                    continue

                if line_number % 10000 == 0:
                    print(f"Processed {line_number} lines...", end='\r')

            print(f"\nSuccessfully wrote all lines to {output_path}")

    except FileNotFoundError:
        print(f"Error: The file {input_path} was not found.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read and write JSONL files line-by-line.")
    parser.add_argument("input", help="Source JSONL file")
    parser.add_argument("output", help="Destination JSONL file")

    args = parser.parse_args()
    process_jsonl(args.input, args.output)