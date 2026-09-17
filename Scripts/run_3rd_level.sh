#!/bin/bash

echo "===== STARTING 3RD-LEVEL THRESHOLD AUTOMATION ====="
echo "Current directory: $(pwd)"
echo

# Define the targets
copes=("cope1" "cope2" "cope3")
thresholds=("None" "Uncorrected" "Voxel" "Cluster")

# Safeguard to ensure the template exists
if [ ! -f "template_3rd.fsf" ]; then
    echo "ERROR: template_3rd.fsf not found! Please save it from the GUI."
    exit 1
fi

for cope in "${copes[@]}"; do
    
    echo "----------------------------------------"
    echo "Processing $cope..."
    echo "----------------------------------------"

    for thresh_name in "${thresholds[@]}"; do

        # The Smart Skip: Ignores the cope3 + Cluster analysis you already finished
        if [ "$cope" == "cope3" ] && [ "$thresh_name" == "Cluster" ]; then
            echo "[SKIP] Skipping $cope with $thresh_name thresholding (Already completed!)."
            echo
            continue
        fi

        # Map the text name to FSL's internal integer
        if [ "$thresh_name" == "None" ]; then
            thresh_val=0
        elif [ "$thresh_name" == "Uncorrected" ]; then
            thresh_val=1
        elif [ "$thresh_name" == "Voxel" ]; then
            thresh_val=2
        elif [ "$thresh_name" == "Cluster" ]; then
            thresh_val=3
        fi

        # Define file and folder names
        out_dir="/mnt/d/Dr.Makary/fMRI/flanker_dataset/Flanker_3rdLevel_${cope}_${thresh_name}"
        fsf_file="design_3rd_${cope}_${thresh_name}.fsf"

        echo "[INFO] Setting up: $thresh_name thresholding"

        # Duplicate the master template
        cp template_3rd.fsf $fsf_file

        # Inject the new parameters into the .fsf file using sed

        # 1. Update the Output Directory
        sed -i "s|set fmri(outputdir) \".*\"|set fmri(outputdir) \"${out_dir}\"|g" $fsf_file

        # 2. Update the Input Directory to point to the correct lower-level cope
        sed -i "s|Flanker_2ndLevel.gfeat/cope.*\.feat|Flanker_2ndLevel.gfeat/${cope}.feat|g" $fsf_file

        # 3. Update the Thresholding Option (0, 1, 2, or 3)
        sed -i "s|set fmri(thresh) .*|set fmri(thresh) ${thresh_val}|g" $fsf_file

        echo "[INFO] Running FEAT for $fsf_file..."
        
        # Execute FEAT sequentially to protect system memory
        feat $fsf_file
        
        echo "[DONE] Finished $thresh_name for $cope"
        echo
    done
done

echo "===== ALL 11 ANALYSES COMPLETED SUCCESSFULLY ====="
