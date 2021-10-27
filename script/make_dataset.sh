#!/bin/bash

# dataset_id 解析
tmp_dir=`dirname $1`
dataset_id=`basename ${tmp_dir}`

# dataset_access.json のパス設定
access_json=`echo "$(dirname $1)/dataset_access.json"`

# check exists
if [ ! -e ${access_json} ]; then
    echo "${access_json} is not found"
    exit 1
fi

# bq command 作成
command=`echo "bq mk --force --dataset ${dataset_id}"`
echo ${command}
$(echo ${command})

command=`echo "bq update ${dataset_id} ${access_json}"`
echo ${command}
$(echo ${command})
