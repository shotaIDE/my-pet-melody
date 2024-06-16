Install Terraform.

https://developer.hashicorp.com/terraform/install

Install Google Cloud CLI.

https://cloud.google.com/sdk/docs/install-sdk?hl=ja

Install dependencies.

```shell
terraform init -backend-config=dev.tfbackend
```

Plan.

```shell
terraform plan -var-file=env/dev.tfvars
```
