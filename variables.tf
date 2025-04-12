variable "agent_name" {
  type = string
}

variable "foundation_model" {
  type = string
}

variable "bucket_name" {
  type    = string
  default = null
}

variable "bucket_object_key" {
  type    = string
  default = null
}

variable "agent_role_arn" {
  type    = string
  default = null
}

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

variable "tags" {
  type        = map(any)
  description = "Key/Value pairs for the tags"
  default = {
    created_by = "Terraform Module CloudPediaAI/AI-Agent/aws"
  }
}
