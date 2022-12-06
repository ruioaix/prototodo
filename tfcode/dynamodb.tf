resource "aws_dynamodb_table" "todo" {
    name = "${var.dynamodb_name}"
    billing_mode = "PROVISIONED"
    read_capacity= "30"
    write_capacity= "30"
    hash_key = "id"
    attribute {
        name = "id"
        type = "S"
    }
}
