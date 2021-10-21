data "cloudfoundry_org" "org" {
  name = var.cf_org_name
}

data "cloudfoundry_domain" "internal" {
  name = "apps.internal"
}

data "hsdp_config" "cf" {
  region  = var.region
  service = "cf"
}
