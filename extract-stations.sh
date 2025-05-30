#!/bin/bash

# Initialize log file
LOG_DIR="data/logs"

TIMESTAMP_START=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$LOG_DIR/$TIMESTAMP_START-stations.txt"

echo "Processing started at $TIMESTAMP_START"
echo "Processing started at $TIMESTAMP_START" >> $LOG_FILE

# Directory containing the downloaded JSON files
DATA_DIR="statuses/json"

# Output files
STATIONS_OUTPUT="data/out/stations.tsv"
STATIONS_OUTPUT_UNIQ="data/out/stations-uniq.tsv"

# Initialize TSV with pre-set columns
echo "station_code	station_name" > $STATIONS_OUTPUT

# Process each JSON file
for file in $DATA_DIR/*.json; do
    # Skip empty or invalid files
    if [ ! -s "$file" ] || ! jq empty "$file" 2>/dev/null; then
        echo "Skipping $file (empty or invalid JSON)" >> $LOG_FILE
        continue
    fi
    
    # Extract times data and combine with existing data
    jq -r -f scripts/jq/extract-stations.jq "$file" >> $STATIONS_OUTPUT
done

TIMESTAMP_EXTRACTION_END=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Extraction complete at $TIMESTAMP_EXTRACTION_END"
echo "Extraction complete at $TIMESTAMP_EXTRACTION_END" >> $LOG_FILE
echo "Combined stations data saved to $STATIONS_OUTPUT"

cat $STATIONS_OUTPUT | awk 'NR<3{print $0;next}{print $0| "sort -r"}' | uniq > $STATIONS_OUTPUT_UNIQ

TIMESTAMP_UNIQ_END=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Unique complete at $TIMESTAMP_UNIQ_END"
echo "Unique complete at $TIMESTAMP_UNIQ_END" >> $LOG_FILE
echo "Unique stations data saved to $STATIONS_OUTPUT_UNIQ"
