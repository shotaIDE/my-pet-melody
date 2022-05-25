# Task

デプロイ方法

```shell
gcloud functions deploy detect --runtime python39 --trigger-http --env-vars-file .env.yaml --allow-unauthenticated
gcloud functions deploy submit --runtime python39 --trigger-http --env-vars-file .env.yaml --allow-unauthenticated
gcloud functions deploy piece --runtime python39 --trigger-http --env-vars-file .env.yaml
```

後片付け方法

```shell
gcloud functions delete detect
gcloud functions delete submit
gcloud functions delete piece
```
