locals {
  total_teams = 2

  services = {
    for n in range(0, local.total_teams) :
    n => {
      "name"  = "space${n}",
      "url"   = "http://multispace-team${n}.apps.internal:8080"
      "route" = "/team${n}"
    }
  }
  plugins = []

  config = templatefile("${path.module}/kong.yml", {
    services = local.services
    plugins  = local.plugins
  })

  declarative_config_string = jsonencode(yamldecode(local.config))
}

module "kong" {
  source        = "/Users/andy/DEV/Philips/terraform/terraform-cloudfoundry-kong"
  cf_org_name   = "hsdp-demo-org"
  cf_space_name = "test"
  name_postfix  = "multispace"
  strategy      = "blue-green"

  kong_declarative_config_string = local.declarative_config_string
}

resource "cloudfoundry_app" "teams" {
  count = local.total_teams

  space = data.cloudfoundry_space.spaces[count.index].id
  name  = "team${count.index}"

  docker_image = "loafoe/go-hello-world:latest"
  memory       = 64

  routes {
    route = cloudfoundry_route.internal[count.index].id
  }
}

resource "cloudfoundry_route" "internal" {
  count = local.total_teams

  space    = data.cloudfoundry_space.spaces[count.index].id
  domain   = data.cloudfoundry_domain.internal.id
  hostname = "multispace-team${count.index}"
}


resource "cloudfoundry_network_policy" "policies" {
  count = local.total_teams


  policy {
    source_app      = module.kong.kong_app_id
    destination_app = cloudfoundry_app.teams[count.index].id
    port            = 8080
    protocol        = "tcp"
  }
}
