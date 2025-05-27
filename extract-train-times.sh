#!/bin/bash

# Directory containing the downloaded JSON files
DATA_DIR="statuses/json"

# Output files
TIMES_OUTPUT="statuses/times.json"

# Initialize empty arrays for combined data
echo "[]" > $TIMES_OUTPUT

# Process each JSON file
for file in $DATA_DIR/*.json; do
    # echo "Processing $file..."
    
    # Skip empty or invalid files
    if [ ! -s "$file" ] || ! jq empty "$file" 2>/dev/null; then
        echo "Skipping $file (empty or invalid JSON)"
        continue
    fi
    
    # Extract times data and combine with existing data
    jq -c -f scripts/jq/extract-train-times.jq "$file" > "temp_times.json"
    jq -c -s '.[0] + .[1]' $TIMES_OUTPUT "temp_times.json" > "temp_combined_times.json"
    mv "temp_combined_times.json" $TIMES_OUTPUT
done

# Clean up temporary files
rm -f temp_times.json

echo "Processing complete!"
echo "Combined times data saved to $TIMES_OUTPUT"
