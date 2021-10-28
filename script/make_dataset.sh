#!/bin/bash

# debug
echo $1

# dataset_id 解析
tmp_dir=`dirname $1`
dataset_id=`basename ${tmp_dir}`

# dataset_access.json のパス設定
dataset_access_json=`echo "$(dirname $1)/dataset_access.json"`

# check exists
if [ ! -e ${dataset_access_json} ]; then
    echo "${dataset_access_json} is not found"
    exit 1
fi

# bq command 作成
command=`echo "bq mk --force --dataset ${dataset_id}"`
echo ${command}
$(echo ${command})

command=`echo "bq update --source ${dataset_access_json} ${dataset_id}"`
echo ${command}
$(echo ${command})
