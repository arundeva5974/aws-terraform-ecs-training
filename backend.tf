terraform {
  backend "s3" {
    bucket         = "terraform-state-ecs-demo-arun-20250731"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}