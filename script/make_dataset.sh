#!/bin/bash

# dataset_id 解析
tmp_dir=`dirname $1`
dataset_id=`basename ${tmp_dir}`

# dataset_access.json のパス設定
access_json=`echo "$(dirname $1)/dataset_access.json"`

command=`echo "bq mk --force --dataset ${dataset_id}"`
echo ${command}
$(echo ${command})

command=`echo "bq update ${dataset_id} ${access_json}"`
echo ${command}
$(echo ${command})
