#!/bin/bash

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

curl 'https://tsimobile.viarail.ca/data/allData.json' > statuses/json/$timestamp.json
