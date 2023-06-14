#!/bin/bash

# HOWTORUN
# ./benchmark.sh ip1 ip2 ... ipN
# where ip[i] is the ip address of the CH server node to run the script on it
# The script tries to connect to ip[i]:9000 with the clickhouse-client binary

# Install

curl https://clickhouse.com/ | sh
./clickhouse install --noninteractive

# Load the data
for node in "$@"
do
    echo "Initializing table on node: $node"
    clickhouse-client -h $node --port 9000 < create.sql
    wget --continue 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz'
    gzip -d hits.tsv.gz
    clickhouse-client -h $node --port 9000 --time --query "INSERT INTO hits FORMAT TSV" < hits.tsv
done

# Run the queries
for node in "$@"
do
    echo "Running queries on node: $node"
    export HOST=$node
    ./run.sh
    clickhouse-client -h $node --port 9000 --query "SELECT total_bytes FROM system.tables WHERE name = 'hits' AND database = 'default'"
done