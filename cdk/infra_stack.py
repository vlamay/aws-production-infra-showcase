"""
Infrastructure stack for the CDK example.  Creates a simple S3
bucket.  Use this file as a starting point to build CDK constructs
mirroring the Terraform modules in this repository.
"""

from aws_cdk import (aws_s3 as s3, Stack, Aws, RemovalPolicy)
from constructs import Construct


class InfraStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create a sample S3 bucket
        s3.Bucket(
            self,
            "SampleCdkBucket",
            bucket_name=f"sample-cdk-bucket-{Aws.ACCOUNT_ID}",
            versioned=True,
            removal_policy=RemovalPolicy.DESTROY,
            auto_delete_objects=True,
        )