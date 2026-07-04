locals {
  common_tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "terraform"
    },
    var.tags
  )

  build_spec = <<-YAML
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
          - .next/cache/**/*
  YAML
}

resource "aws_amplify_app" "frontend" {
  name         = var.project_name
  repository   = var.github_repository
  access_token = var.github_access_token
  platform     = "WEB_COMPUTE"

  enable_branch_auto_build = true
  build_spec               = local.build_spec

  environment_variables = var.environment_variables

  tags = local.common_tags
}

resource "aws_amplify_branch" "environment" {
  for_each = var.environments

  app_id            = aws_amplify_app.frontend.id
  branch_name       = each.value.branch_name
  display_name      = each.key
  framework         = "Next.js"
  stage             = each.value.stage
  enable_auto_build = true

  environment_variables = merge(
    var.environment_variables,
    {
      NEXT_PUBLIC_ENVIRONMENT = each.key
    }
  )

  tags = merge(
    local.common_tags,
    {
      Environment = each.key
    }
  )
}

