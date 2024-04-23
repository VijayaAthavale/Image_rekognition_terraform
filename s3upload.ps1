# # #!/bin/bash

# # # Bucket and local folder variables
# # BUCKET=mybucket
# # FOLDER=/path/to/local/folder

# # # Upload files in a loop
# # for file in $(ls $FOLDER); do

# #   # Copy file to S3
# #   aws s3 cp $FOLDER$file s3://$BUCKET/$file

# #   # Print status
# #   echo "Uploaded $file to S3"

# # done

# # echo "All files uploaded to S3"


# # Bucket and folder variables
# $BUCKET = "s3-bucket-2024-04-23-2024"
# $FOLDER = "D:\Aws_Backup\Terraform\Project_Recognito-main\picture" 

# # Create S3 client
# #$s3 = New-Object Amazon.S3.AmazonS3Client

# # # Create "image" folder in S3 bucket
# New-S3BucketFolder -BucketName $BUCKET -Folder "image"

# # Loop through files and upload
# Get-ChildItem -Path $FOLDER -Recurse | ForEach-Object {
#  Write-Host "I am printing"
#   # Copy file to S3 under "image" folder  
#   Copy-S3Object `
#     -BucketName $BUCKET `
#     -Key "image/$($_.Name)" `
#     -File $($_.FullName)

#   # Print status
#   Write-Host "Uploaded $($_.Name) to S3"

# }

Write-Host "All files to be uploaded to S3"

# # Install AWS Tools for PowerShell module if you haven't already
Install-Module -Name AWSPowerShell.NetCore -Force -AllowClobber
# # Import the AWS Tools for PowerShell module
Import-Module AWSPowerShell.NetCore
# # Set your AWS credentials (access key ID and secret access key)
# Set-AWSCredentials -AccessKey YourAccessKeyId -SecretKey YourSecretAccessKey -StoreAs "MyCredentials"
# # Set the AWS region
# Set-DefaultAWSRegion -Region YourRegion
# Define your S3 bucket and source/destination directories
$bucketName = "s3-bucket-2024-04-23-2024"
$sourceDirectory = "D:\Aws_Backup\Terraform\Project_Recognito-main\picture"
$destinationDirectory = "images"
# List all files in the source directory
$fileList = Get-ChildItem -Path $sourceDirectory -File
# Iterate through each file in the source directory
foreach ($file in $fileList) {
    # Construct the source and destination S3 object keys
    $sourceKey = $file.FullName.Replace($sourceDirectory, "").TrimStart("\")
    $destinationKey = $destinationDirectory + "/" + $file.Name
    # Copy the file to S3 bucket
    Write-host $sourceKey
    Copy-S3Object -BucketName $bucketName -Key $destinationKey -SourceKey $sourceKey  -Region us-west-2 }
    #Copy-S3Object -BucketName $bucketName -Key $destinationKey,$sourceKey  -Region us-west-2 }

