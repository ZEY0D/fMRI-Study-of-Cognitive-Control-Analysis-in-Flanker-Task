#!/bin/bash

echo "===== SCRIPT STARTED ====="
echo "Current directory: $(pwd)"
echo

for id in $(seq -w 1 26); do
    subj="sub-$id"

    echo "----------------------------------------"
    echo "Processing subject: $subj"
    echo "----------------------------------------"

    # Check if subject folder exists
    if [ ! -d "$subj" ]; then
        echo "WARNING: Directory $subj does not exist. Skipping..."
        continue
    fi

    cd "$subj" || { echo "ERROR: Failed to enter $subj"; exit 1; }
    echo "Entered directory: $(pwd)"

    # ==============================
    # Brain extraction check
    # ==============================
    if [ ! -f "anat/${subj}_T1w_brain_f02.nii.gz" ]; then
        echo "[INFO] Brain file not found."
        echo "[INFO] Running BET..."
        
        bet2 "anat/${subj}_T1w.nii.gz" \
             "anat/${subj}_T1w_brain_f02.nii.gz" -f 0.2

        echo "[DONE] BET completed for $subj"
    else
        echo "[SKIP] Brain file already exists."
    fi

    # ==============================
    # Copy design files
    # ==============================
    echo "[INFO] Copying design files..."
    cp ../design_run1.fsf . && echo "Copied design_run1.fsf"
    cp ../design_run2.fsf . && echo "Copied design_run2.fsf"

    # ==============================
    # Modify design files
    # ==============================
    echo "[INFO] Updating subject ID in design files..."

    sed -i "s|sub-07|${subj}|g" design_run1.fsf
    echo "Updated design_run1.fsf"

    sed -i "s|sub-07|${subj}|g" design_run2.fsf
    echo "Updated design_run2.fsf"

    # ==============================
    # Run FEAT (In Parallel!)
    # ==============================
    echo "[INFO] Starting FEAT run 1 & 2 simultaneously..."
    
    feat design_run1.fsf &
    feat design_run2.fsf &
    
    wait # This tells the script to pause here until BOTH background jobs finish
    
    echo "[DONE] Both FEAT runs completed for $subj"
    echo "Finished processing $subj"
    echo

    cd ..
    echo "Returned to parent directory: $(pwd)"
    echo
done

echo "===== SCRIPT FINISHED ====="