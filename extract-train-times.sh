#!/bin/bash

# Initialize log file
LOG_DIR="data/logs"

TIMESTAMP_START=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$LOG_DIR/$TIMESTAMP_START.txt"

echo "Processing started at $TIMESTAMP_START"
echo "Processing started at $TIMESTAMP_START" >> $LOG_FILE

# Directory containing the downloaded JSON files
DATA_DIR="statuses/json"

# Output files
TIMES_OUTPUT="data/out/times.tsv"
TIMES_OUTPUT_UNIQ="data/out/times-uniq.tsv"

# Initialize TSV with pre-set columns
echo "train_id	stop_code	arrival_scheduled	arrival_actual" > $TIMES_OUTPUT

# Process each JSON file
for file in $DATA_DIR/*.json; do
    # Skip empty or invalid files
    if [ ! -s "$file" ] || ! jq empty "$file" 2>/dev/null; then
        echo "Skipping $file (empty or invalid JSON)" >> $LOG_FILE
        continue
    fi
    
    # Extract times data and combine with existing data
    jq -r -f scripts/jq/extract-train-times.jq "$file" >> $TIMES_OUTPUT
done

TIMESTAMP_EXTRACTION_END=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Extraction complete at $TIMESTAMP_EXTRACTION_END"
echo "Extraction complete at $TIMESTAMP_EXTRACTION_END" >> $LOG_FILE
echo "Combined times data saved to $TIMES_OUTPUT"

cat $TIMES_OUTPUT | awk 'NR<3{print $0;next}{print $0| "sort -r"}' | uniq > $TIMES_OUTPUT_UNIQ

TIMESTAMP_UNIQ_END=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Unique complete at $TIMESTAMP_UNIQ_END"
echo "Unique complete at $TIMESTAMP_UNIQ_END" >> $LOG_FILE
echo "Unique times data saved to $TIMES_OUTPUT_UNIQ"
