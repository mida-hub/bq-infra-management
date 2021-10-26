# bq-infra-managemnet
## 概要
BigQueryを分析基盤として開発運用するときに、なるべく少ないコストで実現することを考える。
例えば、terraformでDatasetやTableを管理し、日次JobをCloud Composerなどのワークフローエンジンで制御するのは、ある程度の予算・人員がないと難しい。
これをDatasetやTable管理および日次JobをGit管理およびGithub Actionsで制御することを考える。

フェーズとしては、データ分析というニーズが浮上し、分析基盤の立ち上げの時期で、予算も人員も少ない中で分析基盤の開発運用をすることを想定している。

## 前提
DataLakeには、Cloud SQLからFederationでBigQueryにデータを持ってくる、AWS S3からTransfer ServiceでBigQueryにデータを持ってくるなどを想定している。つまりこのリポジトリではデータ連携のための処理を書かない前提とする。

## 何ができるか
- Workflow
  - github actionsを利用して無料の範囲内でDaily Workflowを動かす
  - push時は差分のSQLのみ処理を実行する
  - 手動でWorkflowを動かしたいときがあるのでEndpointを叩くと手動実行できる
  - 失敗時にSlackに通知する
- DDL
  - mergeのタイミングでCreate Dataset / Tableを発行する
  - Datasetにpermissionを適用する

## 制限
- Workflowの途中から動かし直すが難しいので、リランは頭から再実行となる

## directory structure
- .github
  - workflows
    - continuous_delivery.yml
    - bq_workflow.yml
- ddl
  - dataset_id
    - create_table_id.sql
    - permission.yml
- etl
  - dataset_id
    - table_id.sql

## setup

## 参考
- CIでデータマートを自動生成する : https://tech.hey.jp/entry/2021/04/30/174918
- [GitHub Actions]ファイルの差分や更新状態を元にStepの実施を切り分けてみる : https://dev.classmethod.jp/articles/switch-step-by-file-conditions/
