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
            - npm ci --cache .npm --prefer-offline
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - .next/cache/**/*
          - .npm/**/*
  YAML
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "amplify_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "amplify.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "amplify_ssr_logging" {
  statement {
    sid    = "PushLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/amplify/*:log-stream:*",
    ]
  }

  statement {
    sid    = "CreateLogGroup"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/amplify/*",
    ]
  }

  statement {
    sid    = "DescribeLogGroups"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*",
    ]
  }
}

resource "aws_iam_role" "amplify_service" {
  name               = "${var.project_name}-amplify-ssr-logging"
  path               = "/service-role/"
  description        = "The service role that will be used by AWS Amplify for Web Compute app logging."
  assume_role_policy = data.aws_iam_policy_document.amplify_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_policy" "amplify_ssr_logging" {
  name   = "${var.project_name}-amplify-ssr-logging"
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.amplify_ssr_logging.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "amplify_service" {
  role       = aws_iam_role.amplify_service.name
  policy_arn = aws_iam_policy.amplify_ssr_logging.arn
}

resource "aws_amplify_app" "frontend" {
  name                 = var.project_name
  repository           = var.github_repository
  access_token         = var.github_access_token
  platform             = "WEB_COMPUTE"
  iam_service_role_arn = aws_iam_role.amplify_service.arn

  enable_branch_auto_build = false
  build_spec               = local.build_spec

  environment_variables = var.environment_variables

  custom_rule {
    source = "/<*>"
    target = "/index.html"
    status = "404-200"
  }

  tags = local.common_tags

  depends_on = [
    aws_iam_role_policy_attachment.amplify_service,
  ]
}

resource "aws_amplify_branch" "environment" {
  for_each = var.environments

  app_id            = aws_amplify_app.frontend.id
  branch_name       = each.value.branch_name
  display_name      = each.key
  framework         = "Next.js - SSR"
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
