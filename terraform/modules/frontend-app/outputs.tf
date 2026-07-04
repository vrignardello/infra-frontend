output "amplify_app_id" {
  description = "Amplify app ID."
  value       = aws_amplify_app.frontend.id
}

output "amplify_default_domain" {
  description = "Amplify default domain."
  value       = aws_amplify_app.frontend.default_domain
}

output "amplify_branch_urls" {
  description = "Amplify branch URLs by environment."
  value = {
    for environment, branch in aws_amplify_branch.environment :
    environment => "https://${branch.branch_name}.${aws_amplify_app.frontend.default_domain}"
  }
}

