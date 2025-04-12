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

locals {
  functions_for_action = flatten([
    for fname, fdetails in var.functions : [
      {
        name        = fname
        description = fname
        parameters = {
          for param in fdetails.parameters :
          param => { "type" = "string", "description" = "${param}" }
        }
        require_confirmation = "DISABLED"
    }]
  ])
}
