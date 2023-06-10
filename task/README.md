# Task

## How to deploy

### Functions

```shell
gcloud functions deploy detect \
    --project colomney-my-pet-melody-dev \
    --memory 2048MB \
    --runtime python310 \
    --region asia-east1 \
    --trigger-http \
    --env-vars-file .env.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --project colomney-my-pet-melody-dev \
    --memory 512MB \
    --runtime python310 \
    --region asia-east1 \
    --trigger-http \
    --env-vars-file .env.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --project colomney-my-pet-melody-dev \
    --memory 1024MB \
    --runtime python310 \
    --region asia-east1 \
    --trigger-http \
    --env-vars-file .env.yaml \
    --allow-unauthenticated
```

To delete a deployed function for a temporary operation check, execute the following command.

```shell
gcloud functions delete detect
gcloud functions delete submit
gcloud functions delete piece
```

### Firestore rules

```shell
firebase deploy --only firestore:rules
```

### Storage rules

```shell
firebase deploy --only storage
```

## How to maintenance

### Install pip packages depends on requirements.txt

```shell
pip install --ignore-installed -r requirements.txt
```
