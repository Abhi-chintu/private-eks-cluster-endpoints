terraform {
  backend "s3" {
    bucket = "test-backend-terraform-5256"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}