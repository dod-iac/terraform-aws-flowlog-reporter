variable "tags" {
  type = object({
    Project     = string
    Environment = string
    Application = string
  })
  default = {
    Project     = "elmo"
    Environment = "dev"
    Application = "infra"
  }
}


variable "role_arn" {
  type        = string
  description = "ARN of the role to be assumed for setting up the publication. This would be provided by the central account"
}
variable "kinesis_stream_arn" {
  type        = string
  description = "ARN of the kinesis stream to publish to. This would be provided by the central account"
}
variable "cloudwatch_name" {
  type        = string
  description = "name of the cloudwatch group to subscribe to"
}

locals {
  project     = var.tags.Project
  environment = var.tags.Environment
  application = var.tags.Application
  name_prefix = format("%s-%s-%s-%s", random_string.prefix.id, local.project, local.application, local.environment)
}

//This should help ensure that all names are unique and prevent conflicts with multiple deployments
resource "random_string" "prefix" {
  keepers = {
    project     = local.project
    environment = local.environment
    application = local.application
  }
  length  = 8
  special = false
  upper   = false

}
