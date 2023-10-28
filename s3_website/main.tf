terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "~> 4.0"
    }
  }
}

# Configure AWS provider and creds
provider "aws" {
  region = "us-east-1"
  shared_config_files = ["../aws/config"]
  shared_credentials_files = ["../aws/credentials"]
  profile = "default"
}

# Creating bucket
resource "aws_s3_bucket" "website" {
  bucket = "terraform-bucket-shyshakov"
  tags = {
    Name = "Website"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.website.id
  key = "index.html"
  source = "./src/index.html"
  content_type = "text/html"
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
