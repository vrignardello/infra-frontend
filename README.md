# Paraderos Frontend Demo Infra

Blueprint for a Next.js SSR frontend hosted on AWS Amplify Hosting.

This folder is intentionally shaped as a standalone repository.

## Structure

```text
terraform/
  amplify/
  modules/
    frontend-app/
```

The Amplify app is managed in a single Terraform state because the app is shared, while branches represent environments:

```text
develop -> dev
main    -> prod
```

## Terraform State

Remote state bucket:

```text
paraderos-terraform-state-225989346053
```

State key:

```text
paraderos-frontend-demo/amplify/terraform.tfstate
```

## Usage

Login with AWS SSO:

```bash
aws sso login --profile paraderos-admin
```

Initialize and plan:

```bash
terraform -chdir=terraform/amplify init
terraform -chdir=terraform/amplify plan
```

Apply when the plan looks correct:

```bash
terraform -chdir=terraform/amplify apply
```

## GitHub Token

The Terraform module expects a GitHub token only if Amplify is connected to the repo through Terraform.

Example:

```bash
export TF_VAR_github_access_token="github_pat_xxx"
```

For production use, prefer a narrowly scoped token and rotate it if needed.

