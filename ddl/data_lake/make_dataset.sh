#!/bin/sh

file_name=$0
tmp_dir=`echo ${file_name%/*}`
dataset_id=`echo ${tmp_dir##*/}`

bq mk --force --dataset ${dataset_id}
