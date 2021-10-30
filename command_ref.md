# Project設定
```
gcloud config set project <project_id>
```

# データセット作成
```
bq mk --dataset <dataset_id>
```

# テーブル作成
```
bq mk <dataset_id>.<table_id>
bq update <dataset_id>.<table_id> schema.json
```
