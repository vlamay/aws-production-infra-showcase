#!/usr/bin/env python3
"""
Entry point for AWS CDK example.  This application defines a stack
containing a single S3 bucket.  You can extend it to model more
complex resources or migrate the Terraform modules into CDK stacks.
"""

import aws_cdk as cdk

from infra_stack import InfraStack


app = cdk.App()
InfraStack(app, "InfraStack")
app.synth()