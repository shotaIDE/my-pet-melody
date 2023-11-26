# Function

## How to deploy

### Develop

```shell
gcloud functions deploy detect \
    --project colomney-my-pet-melody-dev \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=2048MB \
    --max-instances=1 \
    --min-instances=0 \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --project colomney-my-pet-melody-dev \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=512MB \
    --max-instances=1 \
    --min-instances=0 \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --project colomney-my-pet-melody-dev \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.dev \
    --trigger-http \
    --runtime=python39 \
    --memory=1024MB \
    --max-instances=1 \
    --min-instances=0 \
    --env-vars-file=.env.dev.yaml \
    --allow-unauthenticated
```

### Production

```shell
gcloud functions deploy detect \
    --project colomney-my-pet-melody \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=2048MB \
    --max-instances=1 \
    --min-instances=0 \
    --env-vars-file=.env.prod.yaml \
    --allow-unauthenticated
gcloud functions deploy submit \
    --project colomney-my-pet-melody \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=512MB \
    --max-instances=1 \
    --min-instances=0 \
    --env-vars-file=.env.prod.yaml \
    --allow-unauthenticated
gcloud functions deploy piece \
    --project colomney-my-pet-melody \
    --docker-registry=artifact-registry \
    --region=asia-east1 \
    --source=. \
    --ignore-file=.gcloudignore.prod \
    --trigger-http \
    --runtime=python39 \
    --memory=1024MB \
    --max-instances=1 \
    --min-instances=0 \
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
