# output "api_arn" {
#   value       = aws_api_gateway_rest_api.main.arn
#   description = "ARN of API created by this module"
# }

output "iam_role_arn" {
  value       = awscc_iam_role.bedrock_agent.arn
  description = "ARN of IAM role created to Invoke AI Agent"
}

# output "api_endpoints" {
#   value       = local.api_endpoints
#   description = "List of API endpoints created to Invoke AI Agent"
# }

