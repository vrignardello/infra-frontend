output "amplify_app_id" {
  description = "Amplify app ID."
  value       = module.frontend_app.amplify_app_id
}

output "amplify_default_domain" {
  description = "Amplify default domain."
  value       = module.frontend_app.amplify_default_domain
}

output "amplify_branch_urls" {
  description = "Amplify branch URLs by environment."
  value       = module.frontend_app.amplify_branch_urls
}

