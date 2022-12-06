import json
import boto3

def lambda_handler(event, context):
    path_param = event.get('pathParameters')
    todo_id = path_param.get('todo_id')
    body = json.loads(event.get('body'))
    title = body.get('title')
    description = body.get('description')
    if not title and not description:
        return {
                'statusCode': 400,
                'body': "both title and description empty"
                }

    client = boto3.resource('dynamodb')
    table = client.Table('todo122022')

    result = table.get_item(Key={'id': todo_id})
    if 'Item' not in result:
        return {
                'statusCode': 400,
                'body': "{} not existing".format(todo_id)
                }
    if not title:
        title = result['Item']['title']
    if not description:
        description = result['Item']['description']

    result = table.update_item(
        Key={
            'id': todo_id
        },
        UpdateExpression="set title=:t, description=:d",
        ExpressionAttributeValues={
            ':t': title,
            ':d': description,
        },
        ReturnValues="UPDATED_NEW"
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
        'body': '{} updated'.format(todo_id)
    }

