#!/bin/sh

tmp_dir=`dirname $0`
dataset_id=`basename ${tmp_dir}`

command=`echo "bq mk --force --dataset ${dataset_id}"`
echo ${command}
$(echo ${command})
