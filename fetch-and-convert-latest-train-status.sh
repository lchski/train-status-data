#!/bin/bash

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

curl 'https://tsimobile.viarail.ca/data/allData.json' > statuses/json/$timestamp.json

jq '[to_entries[] | {train: .key} + .value]' statuses/json/$timestamp.json | npx json2csv > statuses/csv/$timestamp.csv
