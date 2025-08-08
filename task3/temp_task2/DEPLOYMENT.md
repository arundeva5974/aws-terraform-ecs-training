# Deployment Guide

This guide provides detailed steps to deploy the AWS ECS infrastructure using Terraform and GitHub Actions.

## 1. AWS Credentials Setup

### Generate AWS IAM Access Keys

1. Log in to the AWS Management Console
2. Navigate to IAM (Identity and Access Management)
3. Create a new IAM user or use an existing one
4. Attach the following policies to the user:
   - `AmazonECR-FullAccess`
   - `AmazonECS-FullAccess`
   - `AmazonEC2FullAccess`
   - `AmazonVPCFullAccess`
   - `AmazonS3FullAccess`
   - `AmazonDynamoDBFullAccess`
   - `AmazonRoute53FullAccess` (if using custom domains)
   - `IAMFullAccess` (for creating service roles)
5. Generate and securely save the Access Key ID and Secret Access Key

## 2. Local Terraform Setup

### Set Environment Variables

```bash
# Windows PowerShell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_REGION="us-east-1"

# Windows Command Prompt
set AWS_ACCESS_KEY_ID=your-access-key
set AWS_SECRET_ACCESS_KEY=your-secret-key
set AWS_REGION=us-east-1

# Linux/macOS
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

### Initialize Remote State Backend

First, create the S3 bucket and DynamoDB table for remote state:

```bash
# Navigate to the project directory
cd terraform-aws-ecs

# Apply only the remote state resources
terraform apply -target=aws_s3_bucket.terraform_state -target=aws_dynamodb_table.terraform_locks
```

After the S3 bucket and DynamoDB table are created, initialize Terraform with the backend:

```bash
terraform init
```

## 3. GitHub Repository Setup

### Create GitHub Repository

1. Go to GitHub and create a new repository
2. Initialize it with a README if desired

### Add AWS Credentials to GitHub Secrets

1. In your GitHub repository, go to Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

### Push Code to GitHub

```bash
# Initialize git repository (if not already done)
git init

# Rename gitignore.txt to .gitignore
mv gitignore.txt .gitignore

# Add all files
git add .

# Commit changes
git commit -m "Initial commit"

# Add remote repository
git remote add origin https://github.com/yourusername/your-repo-name.git

# Push to GitHub
git push -u origin main
```

## 4. Deployment Process

### Local Deployment

To deploy from your local machine:

```bash
# Preview changes
terraform plan

# Apply changes
terraform apply
```

### GitHub Actions Deployment

The GitHub Actions workflow will automatically:

1. Run `terraform plan` when you create a pull request to the main branch
2. Run `terraform apply` when changes are merged to the main branch

To trigger a deployment:

1. Create a new branch: `git checkout -b feature/my-changes`
2. Make your changes
3. Commit and push: `git commit -am "My changes" && git push origin feature/my-changes`
4. Create a pull request on GitHub
5. Review the plan in the GitHub Actions output
6. Merge the pull request to deploy

## 5. Verify Deployment

After deployment completes:

1. Check the Terraform outputs for the ALB DNS name:
   ```
   application_url = "http://<alb-dns-name>"
   ```

2. Open the URL in a browser to verify the Hello World application is running

3. Verify in the AWS Console:
   - ECS cluster is running with the desired number of tasks
   - ALB is properly configured and healthy
   - Security groups are correctly set up

## 6. Clean Up

To destroy all resources when no longer needed:

```bash
terraform destroy
```

## Troubleshooting

- **S3 Bucket Name Conflict**: If the S3 bucket name is already taken, modify the bucket name in `remote_state_setup.tf`
- **Task Definition Failures**: Check CloudWatch Logs for container errors
- **ALB Health Check Failures**: Verify security groups allow traffic between ALB and ECS instances
- **GitHub Actions Failures**: Ensure AWS credentials are correctly set in GitHub Secrets
