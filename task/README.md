# Task

## How to deploy

### Functions

```shell
gcloud builds submit --project colomney-my-pet-melody-dev --config cloudbuild.yaml
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
