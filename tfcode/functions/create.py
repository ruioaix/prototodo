import json
import boto3
import uuid

def lambda_handler(event, context):
    body = json.loads(event.get('body'))
    title = body.get('title')
    desc = body.get('description')
    if not title:
        return {
                'statusCode': 400,
                'body': "title missing"
                }
    if not desc:
        return {
                'statusCode': 400,
                'body': "description missing"
                }

    client = boto3.resource('dynamodb')
    table = client.Table('todo122022')
    result= table.put_item(
        Item={
            'id': str(uuid.uuid1()),
            'title': title,
            'description': desc,
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
            'body': '{} created'.format(title)
            }

