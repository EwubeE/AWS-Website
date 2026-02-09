#Hosting region
variable "aws_region" {
  description ="AWS region"
  default     = "eu-north-1"
}

#Bucket name
variable "bucket_name" {
  description = " Distinct S3 bucket name"
  default = "ewube-bucket"
}

#The html error file
variable "index_main" {
  description = "The home page code name"
  default = "index.html"
}

#The html error file
variable "error_main" {
  description = "The home page code name"
  default = "error.html"
}


#Gives the origin bucket an id
variable "s3_origin_id" {
  description = "S3 bucket origin ID"
  default     = "bucket-origin"
}





