import json
import boto3

def lambda_handler(event, context):
    path_param = event.get('pathParameters')
    todo_id = path_param.get('todo_id')

    client = boto3.resource('dynamodb')
    table = client.Table('todo122022')

    result = table.get_item(Key={'id': todo_id})
    if 'Item' not in result:
        return {
                'statusCode': 400,
                'body': "{} not existing".format(todo_id)
                }

    result = table.delete_item(
        Key={
            'id': todo_id
        }
    )
    if "ResponseMetadata" not in result or \
            "HTTPStatusCode" not in result["ResponseMetadata"] or \
            result["ResponseMetadata"]["HTTPStatusCode"] != 200:
                return {
                        'statusCode': 400,
                        'body': "something is wrong"
                        }
    return {
        'statusCode': 200,
        'body': '{} deleted'.format(todo_id)
    }

