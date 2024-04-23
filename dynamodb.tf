# create dynamodb table with attributes Label and Image
resource "aws_dynamodb_table" "image_table" {
  name           = "image_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Label"
  range_key      = "Image"
  
  attribute {
    name = "Label"
    type = "S"
  }

  attribute {
    name = "Image"
    type = "S"
  }
  
  
}
