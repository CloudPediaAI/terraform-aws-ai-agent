# create amazon bedrock agent
resource "awscc_bedrock_agent" "agent" {
  agent_name              = var.agent_name
  description             = var.agent_name
  agent_resource_role_arn = awscc_iam_role.bedrock_agent.arn
  foundation_model        = var.foundation_model
  instruction             = var.agent_instruction
  knowledge_bases         = local.knowledge_bases

  idle_session_ttl_in_seconds = var.idle_session_timeout
  auto_prepare                = true

  action_groups = [{
    action_group_name = "actions-group-1"
    description       = "actions-group-1"
    # api_schema = {
    #   s3 = {
    #     s3_bucket_name = var.bucket_name
    #     s3_object_key  = var.bucket_object_key
    #   }
    # }
    function_schema = {
      functions = local.functions_for_action
    }
    action_group_executor = {
      lambda = var.lambda_arn
    }

  }]

  tags = var.tags

}
