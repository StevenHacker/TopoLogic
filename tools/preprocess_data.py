import argparse
import json
import os
import sys

# Add the project root to python path to ensure openlanev2 can be imported
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from openlanev2.centerline.preprocessing import collect
    from openlanev2.io import io
except ImportError:
    print("Error: Could not import openlanev2. Please ensure you are running this script from the project root or have installed the dependencies.")
    sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description='Preprocess OpenLane-V2 dataset for TopoLogic')
    parser.add_argument('--root_path', type=str, required=True, help='Path to OpenLane-V2 dataset root directory (containing train/val folders)')
    parser.add_argument('--meta_file', type=str, required=True, help='Path to the meta json file (e.g., data_dict_subset_A_train.json)')
    parser.add_argument('--collection_name', type=str, required=True, help='Name of the output collection (e.g., data_dict_subset_A_train)')
    
    args = parser.parse_args()

    if not os.path.exists(args.root_path):
        print(f"Error: Root path '{args.root_path}' does not exist.")
        sys.exit(1)

    if not os.path.exists(args.meta_file):
        print(f"Error: Meta file '{args.meta_file}' does not exist.")
        print("Please download the meta files (data_dict_subset_A_*.json) from the OpenLane-V2 repository.")
        sys.exit(1)

    print(f"Loading meta data from {args.meta_file}...")
    try:
        data_dict = io.json_load(args.meta_file)
    except Exception as e:
        print(f"Failed to load meta file: {e}")
        # Try standard json load as fallback if io.json_load behaves unexpectedly
        with open(args.meta_file, 'r') as f:
            data_dict = json.load(f)

    print(f"Starting collection for {args.collection_name}...")
    print(f"Root path: {args.root_path}")
    
    # Call the collect function from openlanev2 library
    # Note: topologic uses standard centerline preprocessing
    collect(args.root_path, data_dict, args.collection_name)
    
    output_path = os.path.join(args.root_path, f"{args.collection_name}.pkl")
    if os.path.exists(output_path):
        print(f"Successfully generated {output_path}")
    else:
        print(f"Warning: Output file {output_path} was not found. Something might have gone wrong.")

if __name__ == '__main__':
    main()
