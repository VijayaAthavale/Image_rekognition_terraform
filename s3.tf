#Create a s3 Bucket for uploading images into it s3-bucket-2024-03-23-2024
resource "aws_s3_bucket" "Name" {
  bucket = "${var.s3_bucket_name}-${var.tagNameDate}-2024"


  #object_lock_enabled = false
  tags = {
    Name = "${var.s3_bucket_name}_${var.tagNameDate}"
  }
}
resource "aws_s3_bucket_versioning" "versioningS3" {
  bucket = aws_s3_bucket.Name.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Create event notification for s3 bucket for destination Lambda function

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.Name.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3imageupload.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"
    filter_suffix       = ".jpg"
  

         
  }
  depends_on = [aws_lambda_permission.allow_bucket]
  
}






 
