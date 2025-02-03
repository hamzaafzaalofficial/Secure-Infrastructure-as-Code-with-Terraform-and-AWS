provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c614dee691cbbf37"   #AmazonLinux2023, id will differ in regions
  instance_type = "t2.micro"
  tags = {
    Name = "example-instance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-2024-xyz"
  tags = {
    Name = "My Test Bucket"
  }
}

resource "aws_kms_key" "example" {
  description             = "KMS key for encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "example" {
  name          = "alias/my-key"
  target_key_id = aws_kms_key.example.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.example.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_db_instance" "example" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"  # Free tier eligible
  db_name             = "mydatabase"
  username            = "admin"
  password            = "password123"
  skip_final_snapshot = true
  publicly_accessible = false
  storage_encrypted   = true
  kms_key_id         = aws_kms_key.example.arn
}
