# aws-envinroment

This project generate a infrastructure on aws  


## Initializing the environment

Run it

```bash
terraform init
```
so run this below command to analyze all changes on infrastructure

```bash
terraform plan
```
to execute and create or update all resources on aws

```bash
terraform apply
```
if you wish remove all resources 

```bash
terraform destroy
```


### ECR - Build and Push Image 

Firstly you need to change your profile in aws-cli, then run it

```bash
export AWS_PROFILE=default-personal
```
Now, let's to do login with o profile 

```bash
 $(aws ecr get-login --no-include-email --region us-east-1)
```

Build, tag and push your image to this repository your Docker image using the following command.

```bash
docker build -t my-repository .
docker tag my-repository:latest 123456789.dkr.ecr.us-east-1.amazonaws.com/my-repository:latest
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/my-repository:latest
```


