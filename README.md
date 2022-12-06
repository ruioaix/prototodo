# Todo

Platform: AWS

Design: API Gateway + Lambda + DynamoDB

Implementation: Terraform

Usage:
```
# config aws credentials
cd tfcode
terraform init
# modify variables.tf if necessary
terraform apply # REST API URL will be outputed.
...
terraform destroy
```

Note:

The name of DynamoDB used in `tfcode/functions/*.py` has to be same as `dynamodb_name` in `tfcode/variables.tf`.  
This inconvenience could be solved in Jenkinsfile.

Further development:

1. Improve logs
2. Consider SQS
3. Error handling
4. Testing
5. Doc
6. Jenkinsfile
