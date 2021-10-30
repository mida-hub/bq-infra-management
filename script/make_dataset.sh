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

command=`echo "bq ls | grep -o '[[:<:]]${dataset_id}[[:>:]]'"`
echo ${command}
dataset_exists=`eval ${command}`

# dataset が存在しなければ作成する
if [ "_${dataset_exists}" = "_" ]; then
    # dataset 作成
    command=`echo "bq mk --dataset ${dataset_id}"`
    run_command "${command}"
fi

# description セット
command=`echo "bq update --description '${dataset_description}' ${dataset_id}"`
run_command "${command}"

# access 権限セット
command=`echo "bq update --source ${dataset_access_json} ${dataset_id}"`
run_command "${command}"
