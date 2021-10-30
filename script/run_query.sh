#!/bin/bash

# utilファイル読み込み
. $(dirname $0)/util.sh

# debug
echo $1
wf_type=$2

# table_query.sql のパス設定
table_query_sql=`echo "$(dirname $1)/table_query.sql"`
# 追加条件を設定している場合のパス設定
table_query_where=`echo "$(dirname $1)/table_query_where.sql"`

# table_query.sql の存在チェック -> 存在しなければ処理を終了
file_not_exists_then_exit ${table_query_sql}

# CI時はSQL文の{append_where}文字列を除去
append_where=""
if [ ! "_${wf_type}" = "_CI" -a -e ${table_query_where} ]; then
   # 追加のWHERE条件句内の改行コードをスペースに置換
   append_where=`cat ${table_query_where} | tr '\n' ' ' `
fi

# SQL内の{append_where}文字列を置換
tmp_sql="tmp.sql"
cat ${table_query_sql} | sed -e "s|{append_where}|${append_where}|g" > ${tmp_sql}

command='bq query --use_legacy_sql=false " `cat ${tmp_sql}` "'
run_command "${command}"
