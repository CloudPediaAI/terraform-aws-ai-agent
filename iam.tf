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
  policies = [{
    policy_name     = "${var.agent_name}-bedrock-agent-invoke-policy"
    policy_document = data.aws_iam_policy_document.agent_invoke.json
  }]
}
