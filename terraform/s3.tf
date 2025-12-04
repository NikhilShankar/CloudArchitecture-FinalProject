# S3 Buckets - 4 private buckets with versioning enabled

# S3 Bucket 1
resource "aws_s3_bucket" "bucket_1" {
  bucket = "${var.project_prefix}-bucket-1"

  tags = {
    Name = "${var.project_prefix}-bucket-1"
  }
}

# Enable versioning for bucket 1
resource "aws_s3_bucket_versioning" "bucket_1_versioning" {
  bucket = aws_s3_bucket.bucket_1.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access for bucket 1
resource "aws_s3_bucket_public_access_block" "bucket_1_public_access" {
  bucket = aws_s3_bucket.bucket_1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket 2
resource "aws_s3_bucket" "bucket_2" {
  bucket = "${var.project_prefix}-bucket-2"

  tags = {
    Name = "${var.project_prefix}-bucket-2"
  }
}

# Enable versioning for bucket 2
resource "aws_s3_bucket_versioning" "bucket_2_versioning" {
  bucket = aws_s3_bucket.bucket_2.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access for bucket 2
resource "aws_s3_bucket_public_access_block" "bucket_2_public_access" {
  bucket = aws_s3_bucket.bucket_2.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket 3
resource "aws_s3_bucket" "bucket_3" {
  bucket = "${var.project_prefix}-bucket-3"

  tags = {
    Name = "${var.project_prefix}-bucket-3"
  }
}

# Enable versioning for bucket 3
resource "aws_s3_bucket_versioning" "bucket_3_versioning" {
  bucket = aws_s3_bucket.bucket_3.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access for bucket 3
resource "aws_s3_bucket_public_access_block" "bucket_3_public_access" {
  bucket = aws_s3_bucket.bucket_3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket 4
resource "aws_s3_bucket" "bucket_4" {
  bucket = "${var.project_prefix}-bucket-4"

  tags = {
    Name = "${var.project_prefix}-bucket-4"
  }
}

# Enable versioning for bucket 4
resource "aws_s3_bucket_versioning" "bucket_4_versioning" {
  bucket = aws_s3_bucket.bucket_4.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access for bucket 4
resource "aws_s3_bucket_public_access_block" "bucket_4_public_access" {
  bucket = aws_s3_bucket.bucket_4.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
