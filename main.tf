provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "icon" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "icon.png"
  source = "${path.module}/icon.png"
  content_type = "image/png"
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_site.bucket}.s3-website-us-east-1.amazonaws.com"
}
