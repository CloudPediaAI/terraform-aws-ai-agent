variable "agent_name" {
  type = string
}

variable "foundation_model" {
  type    = string
  default = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "agent_instruction" {
  type    = string
  default = "You are an office assistant in an insurance agency. You are friendly and polite. You help with managing insurance claims and coordinating pending paperwork."

  validation {
    condition     = length(var.agent_instruction) >= 40
    error_message = "The agent_instruction must be at least 40 characters long."
  }
}

variable "knowledge_base_ids" {
  type        = list(string)
  default     = null
  description = "IDs of existing Bedrock Knowledge Base"
}

variable "functions" {
  type = map(object({
    parameters = list(string)
  }))
}

variable "bucket_name" {
  type    = string
  default = null
}

variable "bucket_object_key" {
  type    = string
  default = null
}

# variable "agent_role_arn" {
#   type    = string
#   default = null
# }

variable "knowledge_base_id" {
  type    = string
  default = null
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "lambda_arn" {
  type    = string
  default = null
}

variable "idle_session_timeout" {
  type    = number
  default = 600

  validation {
    condition     = var.idle_session_timeout >= 60 && var.idle_session_timeout <= 3600
    error_message = "Specify any duration between 60 and 3600 seconds (between 1 and 60 minutes)."
  }
}

variable "tags" {
  type        = map(any)
  description = "Key/Value pairs for the tags"
  default = {
    created_by = "Terraform Module CloudPediaAI/AI-Agent/aws"
  }
}
