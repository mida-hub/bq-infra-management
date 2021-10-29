#!/bin/bash

# utilファイル読み込み
. $(dirname $0)/util.sh

# debug
echo $1

# dataset_id, table_id 解析
tmp_dir=`dirname $1`
table_id=`basename ${tmp_dir}`

tmp_dir=`dirname ${tmp_dir}`
dataset_id=`basename ${tmp_dir}`

# table_schema.json のパス設定
table_schema_json=`echo "$(dirname $1)/table_schema.json"`

# table_view.sql のパス設定
table_view_sql=`echo "$(dirname $1)/table_view.sql"`

# yaml 読み込み
table_description=`yaml_to_json < $1 | jq -r .description`
table_type=`yaml_to_json < $1 | jq -r .type`
time_partitioning_type=`yaml_to_json < $1 | jq -r .time_partitioning_type`
time_partitioning_field=`yaml_to_json < $1 | jq -r .time_partitioning_field`

# table_schema.json の存在チェック
file_not_exists_then_error ${table_schema_json}

# bq command 作成
case ${table_type} in
    TABLE)
        command=`echo bq mk --force --table --description ${table_description} --schema ${table_schema_json}`

        if [ ! "_${time_partitioning_type}" = "_null" ]; then
            command=`echo ${command} --time_partitioning_type ${time_partitioning_type}`
        fi

        if [ ! "_${time_partitioning_field}" = "_null" ]; then
            command=`echo ${command} --time_partitioning_field ${time_partitioning_field}`
        fi

        command=`echo ${command} ${dataset_id}.${table_id}`
        run_command "${command}"

        ;;
    VIEW)
        # table_view.sql の存在チェック
        file_not_exists_then_error ${table_view_sql}

        # echo を使って変数にSQL文を格納すると、結果として Too many positional args というエラーになる
        command='bq mk --force --use_legacy_sql=false --view " `cat ${table_view_sql}` " '${dataset_id}.${table_id}
        run_command "${command}"

        # View に Descriptionをセットする
        command=`echo bq update --description ${table_description} ${dataset_id}.${table_id} ${table_schema_json}`
        run_command "${command}"
        ;;
    *)
        echo "table_type is not TABLE or VIEW"
        exit 1
        ;;
esac
