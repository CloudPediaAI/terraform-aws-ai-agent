data "aws_iam_policy_document" "agent_invoke" {
  statement {
    sid    = "AmazonBedrockAgentFoundationModelInvokePolicy"
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]
    resources = [
      "arn:aws:bedrock:${data.aws_region.default.name}::foundation-model/${var.foundation_model}"
    ]
  }
}

data "aws_iam_policy_document" "kb_retrieve" {
  statement {
    sid    = "AmazonBedrockAgentKBRetrievePolicy"
    effect = "Allow"
    actions = [
      "bedrock:Retrieve"
    ]
    resources = flatten([
      for kbid in var.knowledge_base_ids : [
        "arn:aws:bedrock:${data.aws_region.default.name}:${data.aws_caller_identity.current.account_id}:knowledge-base/${kbid}"
        # "arn:aws:bedrock:${data.aws_region.default.name}::foundation-model/${var.foundation_model}"
      ]
    ])
  }
}

locals {
  policies_for_agent_role = flatten([
    {
      policy_name     = "${var.agent_name}-bedrock-agent-invoke-policy"
      policy_document = data.aws_iam_policy_document.agent_invoke.json
    },
    length(local.knowledge_bases) < 1 ? [] : [{
      policy_name     = "${var.agent_name}-bedrock-kb-retrieve-policy"
      policy_document = data.aws_iam_policy_document.kb_retrieve.json
    }]
  ])
}

resource "awscc_iam_role" "bedrock_agent" {
  role_name   = "${var.agent_name}-bedrock-agent-execution-role"
  description = "This role is to execute Bedrock Agent - ${var.agent_name}"
  path        = "/"
  assume_role_policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AmazonBedrockAgentFoundationModelAssumeRole"
        Principal = {
          Service : "bedrock.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          },
          ArnLike : {
            "aws:SourceArn" : "arn:aws:bedrock:${data.aws_region.default.name}:${data.aws_caller_identity.current.account_id}:agent/*"
          }
        }
      },
    ]
  })
  
  policies = local.policies_for_agent_role

  # tags = var.tags

}
