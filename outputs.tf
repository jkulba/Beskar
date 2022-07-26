output "function_url" {
  value = "https://${local.function_app_name}.azurewebsites.net/api/${local.function_name}"
}
