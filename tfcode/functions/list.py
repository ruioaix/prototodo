import json
import boto3

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('todo122022')
    results = table.scan()
    return {
        'statusCode': 200,
        'body': json.dumps(results.get("Items", []))
    }
