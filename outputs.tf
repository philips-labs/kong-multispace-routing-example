output "api_gateway" {
  value = "https://${module.kong.kong_endpoint}"
}
