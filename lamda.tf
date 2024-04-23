
# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/s3imageupload.zip"
  source {
    content  = file("${path.module}/s3imageupload.py")
    filename = "s3imageupload.py"
  }
}

#Create IAM role for Lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Create IAM policy for Lambda function

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Create the log group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/lambda_handler"
}



#Attach IAM policy to IAM role

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

#Create IAM policy for S3 getobject and rekognisation

resource "aws_iam_policy" "s3_access" {
  name        = "s3_access"
  path        = "/"
  description = "IAM policy for S3 access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "rekognition:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


#Attach IAM policy to IAM role

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Create allow aws lambda permission
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3imageupload.arn
  principal     = "s3.amazonaws.com"
  source_arn    =  aws_s3_bucket.Name.arn
 
}



#Create Lambda function
resource "aws_lambda_function" "s3imageupload" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "lambda_handler"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "s3imageupload.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.8"
  #depends_on       = [aws_iam_role_policy_attachment.lambda_logs]
  depends_on       = [data.archive_file.lambda_zip]
}










  

  








  








  









