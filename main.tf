terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.94.1"
      configuration_aliases = [aws.us-east-1, aws]
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.36.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "default" {}

resource "awscc_bedrock_agent" "agent" {
  agent_name              = var.agent_name
  description             = "Example agent configuration"
  agent_resource_role_arn = var.agent_role_arn
  foundation_model        = var.foundation_model
  instruction             = "You are an office assistant in an insurance agency. You are friendly and polite. You help with managing insurance claims and coordinating pending paperwork."
  # knowledge_bases = [{
  #   description          = "example knowledge base"
  #   knowledge_base_id    = var.knowledge_base_id
  #   knowledge_base_state = "ENABLED"
  # }]

  customer_encryption_key_arn = var.kms_key_arn
  idle_session_ttl_in_seconds = 600
  auto_prepare                = true

  action_groups = [{
    action_group_name = "example-action-group"
    description       = "Example action group"
    # api_schema = {
    #   s3 = {
    #     s3_bucket_name = var.bucket_name
    #     s3_object_key  = var.bucket_object_key
    #   }
    # }
    function_schema = {
      functions = [{
        name        = "e-comm-selleer-actions"
        description = "eCommerce seller actions"
        parameters = {
          seller_id = {
            description = "test"
            type        = "string"
          }
        }
        require_confirmation = "DISABLED"
      }]
    }
    action_group_executor = {
      lambda = var.lambda_arn
    }

  }]

  tags = var.tags

}
