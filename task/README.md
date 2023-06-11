# Task

## How to deploy

### Functions

#### Develop

```shell
gcloud functions deploy detect \
    --project colomney-my-pet-melody-dev \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=2048MB \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --project colomney-my-pet-melody-dev \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=512MB \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --project colomney-my-pet-melody-dev \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=1024MB \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
```

#### Production

```shell
gcloud functions deploy detect \
    --project colomney-my-pet-melody \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=2048MB \
    --min-instances=1 \
    --env-vars-file=.env.prod.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --project colomney-my-pet-melody \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=512MB \
    --min-instances=1 \
    --env-vars-file=.env.prod.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --project colomney-my-pet-melody \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=1024MB \
    --env-vars-file=.env.prod.yaml \
    --allow-unauthenticated
```

To delete a deployed function for a temporary operation check, execute the following command.

```shell
gcloud functions delete detect
gcloud functions delete submit
gcloud functions delete piece
```

## How to maintenance

### Install pip packages depends on requirements.txt

```shell
pip install --ignore-installed -r requirements.txt
```
