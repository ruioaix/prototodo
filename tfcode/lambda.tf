# s3 bucket
resource "aws_s3_bucket" "functions" {
  bucket = "${var.project_name}"
}
resource "aws_s3_bucket_acl" "functions" {
  bucket = aws_s3_bucket.functions.id
  acl    = "private"
}

# role
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.project_name}-lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "dynamodb" {
  name = "${var.project_name}-lambda-access-dynamodb"
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.todo.arn
      },
    ]
  })
}


# list
data "archive_file" "list" {
  type        = "zip"
  source_file  = "${path.module}/functions/list.py"
  output_path = "${path.module}/archive/list.zip"
}
resource "aws_s3_object" "list" {
  bucket = aws_s3_bucket.functions.id
  key    = "list.zip"
  source = data.archive_file.list.output_path
  etag   = filemd5(data.archive_file.list.output_path)
}
resource "aws_lambda_function" "list" {
  function_name    = "${var.project_name}-list"
  s3_bucket        = aws_s3_bucket.functions.id
  s3_key           = aws_s3_object.list.key
  runtime          = "python3.9"
  handler          = "list.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.list.output_base64sha256
}

# get
data "archive_file" "get" {
  type        = "zip"
  source_file = "${path.module}/functions/get.py"
  output_path = "${path.module}/archive/get.zip"
}
resource "aws_s3_object" "get" {
  bucket = aws_s3_bucket.functions.id
  key    = "get.zip"
  source = data.archive_file.get.output_path
  etag   = filemd5(data.archive_file.get.output_path)
}
resource "aws_lambda_function" "get" {
  function_name    = "${var.project_name}-get"
  s3_bucket        = aws_s3_bucket.functions.id
  s3_key           = aws_s3_object.get.key
  runtime          = "python3.9"
  handler          = "get.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.get.output_base64sha256
}

#create
data "archive_file" "create" {
  type        = "zip"
  source_file = "${path.module}/functions/create.py"
  output_path = "${path.module}/archive/create.zip"
}
resource "aws_s3_object" "create" {
  bucket = aws_s3_bucket.functions.id
  key    = "create.zip"
  source = data.archive_file.create.output_path
  etag   = filemd5(data.archive_file.create.output_path)
}
resource "aws_lambda_function" "create" {
  function_name    = "${var.project_name}-create"
  s3_bucket        = aws_s3_bucket.functions.id
  s3_key           = aws_s3_object.create.key
  runtime          = "python3.9"
  handler          = "create.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.create.output_base64sha256
}

#delete
data "archive_file" "delete" {
  type        = "zip"
  source_file = "${path.module}/functions/delete.py"
  output_path = "${path.module}/archive/delete.zip"
}
resource "aws_s3_object" "delete" {
  bucket = aws_s3_bucket.functions.id
  key    = "delete.zip"
  source = data.archive_file.delete.output_path
  etag   = filemd5(data.archive_file.delete.output_path)
}
resource "aws_lambda_function" "delete" {
  function_name    = "${var.project_name}-delete"
  s3_bucket        = aws_s3_bucket.functions.id
  s3_key           = aws_s3_object.delete.key
  runtime          = "python3.9"
  handler          = "delete.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.delete.output_base64sha256
}

# update
data "archive_file" "update" {
  type        = "zip"
  source_file = "${path.module}/functions/update.py"
  output_path = "${path.module}/archive/update.zip"
}
resource "aws_s3_object" "update" {
  bucket = aws_s3_bucket.functions.id
  key    = "update.zip"
  source = data.archive_file.update.output_path
  etag   = filemd5(data.archive_file.update.output_path)
}
resource "aws_lambda_function" "update" {
  function_name    = "${var.project_name}-update"
  s3_bucket        = aws_s3_bucket.functions.id
  s3_key           = aws_s3_object.update.key
  runtime          = "python3.9"
  handler          = "update.lambda_handler"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.update.output_base64sha256
}
