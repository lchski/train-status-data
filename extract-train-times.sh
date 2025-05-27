#!/bin/bash

# Directory containing the downloaded JSON files
DATA_DIR="statuses/json"

# Output files
TIMES_OUTPUT="data/out/times.tsv"

# Initialize empty arrays for combined data
echo "train_id	station_code	time_scheduled	time_actual" > $TIMES_OUTPUT

# Process each JSON file
for file in $DATA_DIR/*.json; do
    echo "Processing $file..."
    
    # Skip empty or invalid files
    if [ ! -s "$file" ] || ! jq empty "$file" 2>/dev/null; then
        echo "Skipping $file (empty or invalid JSON)"
        continue
    fi
    
    # Extract times data and combine with existing data
    jq -r -f scripts/jq/extract-train-times.jq "$file" >> $TIMES_OUTPUT
done

echo "Processing complete!"
echo "Combined times data saved to $TIMES_OUTPUT"
