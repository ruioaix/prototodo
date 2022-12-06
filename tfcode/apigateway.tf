resource "aws_api_gateway_rest_api" "todo"{
    name = "${var.project_name}"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.todo.id
  parent_id = aws_api_gateway_rest_api.todo.root_resource_id
  path_part = "v1"
}
resource "aws_api_gateway_resource" "todo" {
  rest_api_id = aws_api_gateway_rest_api.todo.id
  parent_id = aws_api_gateway_resource.v1.id
  path_part = "todo"
}
resource "aws_api_gateway_resource" "todoitem" {
  rest_api_id = aws_api_gateway_rest_api.todo.id
  parent_id = aws_api_gateway_resource.todo.id
  path_part = "{todo_id}"
}

# list
resource "aws_api_gateway_method" "list"{
  rest_api_id = aws_api_gateway_rest_api.todo.id
  resource_id = aws_api_gateway_resource.todo.id
  http_method = "GET"
  authorization = "NONE"
}
resource "aws_lambda_permission" "list" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.list.function_name
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo.id}/*/${aws_api_gateway_method.list.http_method}${aws_api_gateway_resource.todo.path}"
}
resource "aws_api_gateway_integration" "list" {
  rest_api_id             = aws_api_gateway_rest_api.todo.id
  resource_id             = aws_api_gateway_resource.todo.id
  http_method             = aws_api_gateway_method.list.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.list.invoke_arn
}

# get
resource "aws_api_gateway_method" "get"{
  rest_api_id = aws_api_gateway_rest_api.todo.id
  resource_id = aws_api_gateway_resource.todoitem.id
  http_method = "GET"
  authorization = "NONE"
}
resource "aws_lambda_permission" "get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.get.function_name
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo.id}/*/${aws_api_gateway_method.get.http_method}${aws_api_gateway_resource.todoitem.path}"
}
resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.todo.id
  resource_id             = aws_api_gateway_resource.todoitem.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get.invoke_arn
}

# create
resource "aws_api_gateway_method" "create"{
  rest_api_id = aws_api_gateway_rest_api.todo.id
  resource_id = aws_api_gateway_resource.todo.id
  http_method = "PUT"
  authorization = "NONE"
}
resource "aws_lambda_permission" "create" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.create.function_name
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo.id}/*/${aws_api_gateway_method.create.http_method}${aws_api_gateway_resource.todo.path}"
}
resource "aws_api_gateway_integration" "create" {
  rest_api_id             = aws_api_gateway_rest_api.todo.id
  resource_id             = aws_api_gateway_resource.todo.id
  http_method             = aws_api_gateway_method.create.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create.invoke_arn
}

# delete
resource "aws_api_gateway_method" "delete"{
  rest_api_id = aws_api_gateway_rest_api.todo.id
  resource_id = aws_api_gateway_resource.todoitem.id
  http_method = "DELETE"
  authorization = "NONE"
}
resource "aws_lambda_permission" "delete" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.delete.function_name
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo.id}/*/${aws_api_gateway_method.delete.http_method}${aws_api_gateway_resource.todoitem.path}"
}
resource "aws_api_gateway_integration" "delete" {
  rest_api_id             = aws_api_gateway_rest_api.todo.id
  resource_id             = aws_api_gateway_resource.todoitem.id
  http_method             = aws_api_gateway_method.delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.delete.invoke_arn
}

# update
resource "aws_api_gateway_method" "update"{
  rest_api_id = aws_api_gateway_rest_api.todo.id
  resource_id = aws_api_gateway_resource.todoitem.id
  http_method = "PUT"
  authorization = "NONE"
}
resource "aws_lambda_permission" "update" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.update.function_name
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.todo.id}/*/${aws_api_gateway_method.update.http_method}${aws_api_gateway_resource.todoitem.path}"
}
resource "aws_api_gateway_integration" "update" {
  rest_api_id             = aws_api_gateway_rest_api.todo.id
  resource_id             = aws_api_gateway_resource.todoitem.id
  http_method             = aws_api_gateway_method.update.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update.invoke_arn
}

resource "aws_api_gateway_deployment" "todo" {
  rest_api_id = aws_api_gateway_rest_api.todo.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.todo.id,
      aws_api_gateway_resource.todoitem.id,
      aws_api_gateway_method.list.id,
      aws_api_gateway_integration.list.id,
      aws_api_gateway_method.get.id,
      aws_api_gateway_integration.get.id,
      aws_api_gateway_method.create.id,
      aws_api_gateway_integration.create.id,
      aws_api_gateway_method.delete.id,
      aws_api_gateway_integration.delete.id,
      aws_api_gateway_method.update.id,
      aws_api_gateway_integration.update.id
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "todo" {
  deployment_id = aws_api_gateway_deployment.todo.id
  rest_api_id   = aws_api_gateway_rest_api.todo.id
  stage_name    = "${var.project_name}"
}
