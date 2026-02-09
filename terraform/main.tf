terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

#Creates S3 bucket
resource "aws_s3_bucket" "s3bucket" {
    bucket = var.bucket_name
}

#Sets up the bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "static_website_bucket" {
    bucket = aws_s3_bucket.s3bucket.id

    index_document{
        suffix = var.index_main #htlm main file
    }
    error_document {
        key = var.error_main    #html error file
    }
}
#Defines the ownership controls
resource "aws_s3_bucket_ownership_controls" "static_website_bucket" {
  bucket = aws_s3_bucket.s3bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Prevents public access to the bucket
resource "aws_s3_bucket_public_access_block" "static_website_bucket" {
    bucket                  = aws_s3_bucket.s3bucket.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

#Allows CloudFront access the S3 bucket
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 bucket"
}

#Policies applied to the public
resource "aws_s3_bucket_policy" "public_read"{
    bucket = aws_s3_bucket.s3bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowCloudFrontOAI"
                Effect = "Allow"
                Principal ={
                  AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
                }
                Action = "s3:GetObject"       #allows only reading
                Resource = "${aws_s3_bucket.s3bucket.arn}/*"
            }]
    })
}


#Uploads the files into the S3 bucket
resource "aws_s3_object" "website_files" {
  bucket = aws_s3_bucket.s3bucket.id
  for_each = fileset("AWS website/", "**/*.*")
  key    = each.value
  source = "AWS website/${each.value}"
  content_type = each.value
}

#Creates a local variable for the origin id
locals {
    s3_origin_id = var.s3_origin_id
}



#Creates the CloudFront content delivery network
resource "aws_cloudfront_distribution" "cdn" {
  depends_on = [
  aws_s3_bucket.s3bucket,
  aws_cloudfront_origin_access_identity.oai
  ]
  enabled             = true
  is_ipv6_enabled = true
  default_root_object = var.index_main


  default_cache_behavior {      #Defining the cache behavior
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id       = "s3origin"
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  origin {            #defines the origin of the distribution
    domain_name = aws_s3_bucket.s3bucket.bucket_regional_domain_name
    origin_id   = "s3origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  viewer_certificate {      #defines viewer certificate
    cloudfront_default_certificate = true
  }
  restrictions {           #allows access from all locations
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

}


