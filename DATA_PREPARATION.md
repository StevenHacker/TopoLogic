# OpenLane-V2 Data Preparation Guide for TopoLogic

Since the OpenLane-V2 dataset is very large, it cannot be automatically downloaded in this environment. Please follow the steps below to prepare the data on your server.

## 1. Download Data

You need to download the OpenLane-V2 dataset from the official source.

1.  Visit the [OpenLane-V2 Repository](https://github.com/OpenDriveLab/OpenLane-V2).
2.  Follow their instructions to download the **Subset A** (or Subset B) dataset.
3.  You also need the meta files (e.g., `data_dict_subset_A_train.json`, `data_dict_subset_A_val.json`). These are usually provided in the `data/` folder of the OpenLane-V2 repo or downloadable alongside the dataset.

Your data directory structure should look like this:

```
/path/to/OpenLane-V2/
├── train/
│   ├── segment-xxxxxxxx/
│   │   ├── info/
│   │   ├── sensor/
│   │   └── ...
├── val/
│   └── ...
├── data_dict_subset_A_train.json
└── data_dict_subset_A_val.json
```

## 2. Preprocess Data

TopoLogic requires the data to be preprocessed into `.pkl` files. We have provided a helper script `tools/preprocess_data.py` to do this.

You need to run this for both training and validation sets.

### Command

```bash
# Preprocess Training Data
python tools/preprocess_data.py \
  --root_path /path/to/OpenLane-V2 \
  --meta_file /path/to/OpenLane-V2/data_dict_subset_A_train.json \
  --collection_name data_dict_subset_A_train

# Preprocess Validation Data
python tools/preprocess_data.py \
  --root_path /path/to/OpenLane-V2 \
  --meta_file /path/to/OpenLane-V2/data_dict_subset_A_val.json \
  --collection_name data_dict_subset_A_val
```

This will generate `data_dict_subset_A_train.pkl` and `data_dict_subset_A_val.pkl` in your `/path/to/OpenLane-V2` directory.

## 3. Configure Path in TopoLogic

Once you have the `.pkl` files, update the config file or create a symbolic link.

The config file `projects/configs/topologic_r50_8x1_24e_olv2_subset_A.py` expects data at `/data/TopoNet/data/OpenLane-V2/`.

You can either:

**Option A: Link your data to the expected path**

```bash
mkdir -p /data/TopoNet/data/
ln -s /path/to/OpenLane-V2 /data/TopoNet/data/OpenLane-V2
```

**Option B: Modify the config file**

Edit `projects/configs/topologic_r50_8x1_24e_olv2_subset_A.py`:

```python
dataset_type = 'OpenLaneV2_subset_A_Dataset'
data_root = '/path/to/your/OpenLane-V2/'  # Update this line
```
