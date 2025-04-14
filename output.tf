# output "api_arn" {
#   value       = aws_api_gateway_rest_api.main.arn
#   description = "ARN of API created by this module"
# }

output "iam_role_arn" {
  value       = awscc_iam_role.bedrock_agent.arn
  description = "ARN of IAM role created to Invoke AI Agent"
}

output "agent_arn" {
  value       = awscc_bedrock_agent.agent.agent_arn
  description = "ARN of AI Agent created by this module"
}

# output "api_endpoints" {
#   value       = local.api_endpoints
#   description = "List of API endpoints created to Invoke AI Agent"
# }
