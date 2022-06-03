# Task

## デプロイ方法

### Functions

```shell
gcloud functions deploy detect \
    --memory 2048MB \
    --runtime python39 \
    --trigger-http \
    --env-vars-file .env.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --memory 512MB \
    --runtime python39 \
    --trigger-http \
    --env-vars-file .env.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --memory 1024MB \
    --runtime python39 \
    --trigger-http \
    --env-vars-file .env.yaml
```

後片付け方法

```shell
gcloud functions delete detect
gcloud functions delete submit
gcloud functions delete piece
```

### Firestore のルール

```shell
firebase deploy --only firestore:rules
```

### Storage のルール

```shell
firebase deploy --only storage
```
