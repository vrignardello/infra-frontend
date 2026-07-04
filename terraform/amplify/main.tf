provider "aws" {
  region  = "us-east-1"
  profile = "paraderos-admin"
}

module "frontend_app" {
  source = "../modules/frontend-app"

  project_name        = "paraderos-frontend-demo"
  github_repository   = "https://github.com/vrignardello/infra-front"
  github_access_token = var.github_access_token

  environment_variables = {
    NEXT_PUBLIC_APP_NAME = "paraderos-frontend-demo"
  }
}

