# bq-infra-managemnet
## 概要
BigQueryを分析基盤として開発運用するときに、なるべく少ないコストで実現することを考える。
例えば、terraformでDatasetやTableを管理し、日次JobをCloud Composerなどのワークフローエンジンで制御するのは、ある程度の予算・人員がないと難しい。
これをDatasetやTable管理および日次JobをGit管理およびGithub Actionsで制御することを考える。

フェーズとしては、データ分析というニーズが浮上し、分析基盤の立ち上げの時期で、予算も人員も少ない中で分析基盤の開発運用をすることを想定している。

## 前提
DataLakeには、Cloud SQLからFederationでBigQueryにデータを持ってくる、AWS S3からTransfer ServiceでBigQueryにデータを持ってくるなどを想定している。つまりこのリポジトリではデータ連携のための処理を書かない前提とする。

## 何ができるか
- 共通
  - push時に差分のファイルを検知して処理を実行する
  - 手動実行ができる
  - 失敗時にSlackに通知する
- Workflow
  - 依存関係をもとにSQLを実行する
- DDL
  - Create Dataset / Create Tableを発行する
  - Datasetにpermissionを適用する

## 制限
- Workflowの途中から動かし直すが難しいので、リランは頭から再実行となる

## ディレクトリ構造
- .github
  - workflows
    - ci.yml
    - daily.yml
- bigquery
  - dataset_id
    - dataset_config.yml
    - dataset_access.json
    - table_id
      - table_config.yml
      - table_schema.json
      - table_query.sql
      - table_view.sql
- script

## 残タスク
- daily
- error

## 参考
- CIでデータマートを自動生成する : https://tech.hey.jp/entry/2021/04/30/174918
- [GitHub Actions]ファイルの差分や更新状態を元にStepの実施を切り分けてみる : https://dev.classmethod.jp/articles/switch-step-by-file-conditions/
- BigQueryで一般公開データセット(気象データ)を使用してみよう : https://techblog.gmo-ap.jp/2020/05/12/weatherbigdata/
- [小ネタ] シェルスクリプト内で YAML -> JSON 変換する #ruby : https://dev.classmethod.jp/articles/201904_yaml-to-json-converter-on-shellscript/
- sed でエスケープ処理をしないでURLの置換を行う : https://hacknote.jp/archives/8163/
