#!/bin/bash

# utilファイル読み込み
. $(dirname $0)/util.sh

dataset_id=$1
wf_type=$2

query_path="bigquery"
query_name="table_config.yml"

schedule_daily_json=`yaml_to_json < schedule/daily.yml`
dataset_tables=$(echo ${schedule_daily_json} | jq .${dataset_id})

for table_id in $(echo ${dataset_tables} | jq -c -r '.[]'); do
    bash $(dirname $0)/run_query.sh "${query_path}/${dataset_id}/${table_id}/${query_name}" "${wf_type}"
done
