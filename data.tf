data "cloudfoundry_space" "spaces" {
  count = local.total_teams
  name  = "space${count.index}"
  org   = data.cloudfoundry_org.org.id
}

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
