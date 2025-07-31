# AWS ECS Terraform Deployment

This project deploys a containerized application on AWS ECS using Terraform and GitHub Actions for CI/CD.

## Architecture

The infrastructure consists of:

- VPC with public and private subnets across two availability zones
- ECS cluster running on EC2 instances in private subnets
- Application Load Balancer (ALB) in public subnets
- Security groups for ALB, ECS tasks, and EC2 instances
- CloudWatch Logs for container logs
- S3 and DynamoDB for Terraform remote state management

## Prerequisites

- AWS account with appropriate permissions
- AWS CLI installed and configured
- Terraform installed (v1.0.0 or later)
- GitHub account for CI/CD

## Local Setup

1. Generate AWS IAM access and secret keys with appropriate permissions
2. Set AWS credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

3. Initialize Terraform with remote state:

```bash
# First, apply the remote state setup
terraform apply -target=aws_s3_bucket.terraform_state -target=aws_dynamodb_table.terraform_locks

# Then initialize with the backend
terraform init
```

## GitHub Actions Setup

1. Push this code to a GitHub repository
2. Add the following secrets to your GitHub repository:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

## Deployment

### Local Deployment

```bash
terraform plan    # Preview changes
terraform apply   # Apply changes
```

### CI/CD Deployment

The GitHub Actions workflow will:
- Run `terraform plan` on pull requests to the main branch
- Run `terraform apply` when changes are merged to the main branch

## Accessing the Application

After deployment, the application will be accessible at the ALB DNS name, which is output at the end of the Terraform apply:

```
application_url = "http://<alb-dns-name>"
```

## Clean Up

To destroy all resources:

```bash
terraform destroy
```

## Security Considerations

- AWS credentials are stored securely in GitHub Secrets
- ECS containers run in private subnets
- Security groups follow least privilege principle
- SSH access to EC2 instances should be restricted to specific IPs in production
