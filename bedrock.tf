# create amazon bedrock agent
resource "awscc_bedrock_agent" "agent" {
  agent_name              = var.agent_name
  description             = var.agent_name
  agent_resource_role_arn = awscc_iam_role.bedrock_agent.arn
  foundation_model        = var.foundation_model
  instruction             = var.agent_instruction
  # knowledge_bases = [{
  #   description          = "example knowledge base"
  #   knowledge_base_id    = var.knowledge_base_id
  #   knowledge_base_state = "ENABLED"
  # }]

  customer_encryption_key_arn = var.kms_key_arn
  idle_session_ttl_in_seconds = 600
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
      # functions = [{
      #   name        = "function1"
      #   description = "function1"
      #   parameters = {
      #     seller_id = {
      #       description = "test"
      #       type        = "string"
      #     }
      #   }
      #   require_confirmation = "DISABLED"
      # }]
    }
    action_group_executor = {
      lambda = var.lambda_arn
    }

  }]

  tags = var.tags

}
