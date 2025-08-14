import json
import os


def lambda_handler(event, context):
    """Sample Lambda function for SAM example."""
    message = {
        "message": "Hello from AWS SAM!",
        "input": event
    }
    return {
        "statusCode": 200,
        "body": json.dumps(message),
        "headers": {
            "Content-Type": "application/json"
        }
    }