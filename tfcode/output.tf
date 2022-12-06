output "rest_api_url" {
  value = "${aws_api_gateway_deployment.todo.invoke_url}${aws_api_gateway_stage.todo.stage_name}${aws_api_gateway_resource.todo.path}"
}
