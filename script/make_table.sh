#!/bin/bash

function yaml_to_json() {
    ruby -rjson -ryaml -e 'print YAML.load(STDIN.read).to_json'
}

# debug
echo $1

# dataset_id, table_id 解析
tmp_dir=`dirname $1`
table_id=`basename ${tmp_dir}`

tmp_dir=`dirname ${tmp_dir}`
dataset_id=`basename ${tmp_dir}`

# table_schema.json のパス設定
table_schema_json=`echo "$(dirname $1)/table_schema.json"`

# yaml 読み込み
table_type=`yaml_to_json < $1 | jq -r .type`
time_partitioning_type=`yaml_to_json < $1 | jq -r .time_partitioning_type`
time_partitioning_field=`yaml_to_json < $1 | jq -r .time_partitioning_field`

# check exists
if [ ! -e ${table_schema_json} ]; then
    echo "${table_schema_json} is not found"
    exit 1
fi

# bq command 作成
if [ "_${table_type}" = "_TABLE" ]; then
    command=`echo "bq mk --force ${dataset_id}.${table_id}"`

    if [ ! "_${time_partitioning_type}" = "_null" ]; then
        command=`echo ${command} --time_partitioning_type ${time_partitioning_type}`
    fi

    if [ ! "_${time_partitioning_field}" = "_null" ]; then
        command=`echo ${command} --time_partitioning_field ${time_partitioning_field}`
    fi
fi

echo ${command}
$(echo ${command})

command=`echo "bq update ${dataset_id}.${table_id} ${table_schema_json}"`
echo ${command}
$(echo ${command})
