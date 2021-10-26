#!/bin/sh

dataset_id=`pwd | sed "s/.*\///g"`
bq mk --dataset ${dataset_id}
