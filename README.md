# Private Docker Registry for DS0

## Terraform
This is a terraform template and requires to be run by terraform plan/apply.
[Download Terraform](https://www.terraform.io/downloads.html)

### States
We now use an s3 bucket to store current infrastructure states. You can use the state-cfg.sh script to setup with the octanner s3 bucket.  Otherwise use the configuration below.

```bash
./state-cfg.sh d1
```
[terraform state info](https://www.terraform.io/docs/state/remote/s3.html)

```bash
terraform remote config \
-backend=s3 \
-backend-config="bucket=mah_bucket" \
-backend-config="key=datacenter/d1/<repo>/terraform.tfstate" \
-backend-config="region=us-west-2"
```
Once the backend has been connected too, your local state will be located in *./.terraform/terraform.tfstate*

Please sync with
```bash
terraform remote pull
```

Push changes with 
```bash
terraform remote push
```
##### Note: You must use the state files, otherwise you will overwrite the current state, and or create duplicate resources.

### Terraform CLI
See current status with
```bash
terraform show
```

See what will be updated with 
```bash
terraform plan
```

Update config with 
```bash
terraform apply
```

## Certificates
Certificates can be pulled from vault.  Please follow instructions for setting up your access to vault.  You will not be able to pull the correct certs if you are not authorized.

[Vault Setup](https://confluence.octanner.com/display/COBRA/Vault)

Run
```bash
./getcert.sh
```
