import json
import boto3

def lambda_handler(event, context):
    path_param = event.get('pathParameters')
    todo_id = path_param.get('todo_id')
    client = boto3.resource('dynamodb')
    table = client.Table('todo122022')
    result = table.get_item(Key={'id': todo_id})
    if 'Item' in result:
        item = result['Item']
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }
    return {
        'statusCode': 404,
        'body': "{} not found".format(todo_id)
    }

