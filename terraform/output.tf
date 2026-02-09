#Gives the public URL for the S3 statis website
output "s3_url" {
  description = "Static website URL"
  value = aws_s3_bucket_website_configuration.static_website_bucket.website_endpoint
}

#Unique CloudFront distribution ID
output "CloudFront_distribution_id" {
  description = "CloudFront ID"
  value = aws_cloudfront_distribution.cdn.id
}

#Usable HTTPS URL to access the website
output "CloudFront_domain_name"{
  description = "CloudFront domain name"
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

#Shows the current deployment state
output "CloudFront_status" {
  description = "Current deployment status of the CloudFront distribution"
  value = aws_cloudfront_distribution.cdn.status
}

