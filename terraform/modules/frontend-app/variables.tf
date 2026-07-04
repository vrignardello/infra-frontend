variable "project_name" {
  description = "Frontend project name."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository URL connected to Amplify."
  type        = string
}

variable "github_access_token" {
  description = "GitHub token used by Amplify to connect to the repository."
  type        = string
  sensitive   = true
}

variable "environment_variables" {
  description = "Environment variables shared by all Amplify branches."
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = "Amplify branches by environment."
  type = map(object({
    branch_name = string
    stage       = string
  }))
  default = {
    dev = {
      branch_name = "develop"
      stage       = "DEVELOPMENT"
    }
    prod = {
      branch_name = "main"
      stage       = "PRODUCTION"
    }
  }
}

variable "tags" {
  description = "Additional tags for frontend resources."
  type        = map(string)
  default     = {}
}

