#!/bin/bash

# utilファイル読み込み
. $(dirname $0)/util.sh

# debug
echo $1

# dataset_id 解析
tmp_dir=`dirname $1`
dataset_id=`basename ${tmp_dir}`

# dataset_access.json のパス設定
dataset_access_json=`echo "$(dirname $1)/dataset_access.json"`

# yaml 読み込み
dataset_description=`yaml_to_json < $1 | jq -r .description`

# check exists
file_not_exists_then_error ${dataset_access_json}

# bq command 作成
command=`echo "bq mk --force --dataset ${dataset_id}"`
run_command "${command}"

command=`echo "bq update --description ${dataset_description} --source ${dataset_access_json} ${dataset_id}"`
run_command "${command}"
