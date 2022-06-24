terraform {
  required_version = ">= 1.0.0"
}

resource "aws_cloudtrail" "cloudtrail" {
  enable_log_file_validation    = var.enable_log_file_validation
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  kms_key_id                    = var.kms_key_id
  name                          = var.name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_s3_bucket.id
  s3_key_prefix                 = var.s3_key_prefix
}

resource "aws_s3_bucket" "cloudtrail_s3_bucket" {
  bucket_prefix = var.bucket_prefix

  versioning {
    enabled    = var.enabled
    mfa_delete = var.mfa_delete
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_acl" "cloudtrail_bucket_acl" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_public_access_block" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id

  rule {
    id     = "30_day_delete"
    status = "Enabled"

    filter {}
    expiration {
      days = 30
    }    
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_bucket_versioning" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id
  versioning_configuration {
    status = var.enabled
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_s3_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail_s3_bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrail_s3_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
