provider "hsdp" {
  region    = var.region
  debug_log = "/tmp/router.log"
}

provider "cloudfoundry" {
  api_url  = data.hsdp_config.cf.url
  user     = var.cf_user
  password = var.cf_password
}
