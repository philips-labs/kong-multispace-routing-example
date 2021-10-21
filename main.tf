locals {
  total_teams = 4

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
  source  = "philips-labs/kong/cloudfoundry"
  version = "2.3.3"

  cf_org_name   = var.cf_org_name
  cf_space_name = var.cf_space_name
  name_postfix  = "multispace"
  strategy      = "blue-green"

  kong_declarative_config_string = local.declarative_config_string
}

resource "cloudfoundry_space" "spaces" {
  count = local.total_teams

  name = "multispace-team${count.index}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space_users" "users" {
  count      = local.total_teams
  space      = cloudfoundry_space.spaces[count.index].id
  developers = [var.cf_user]
}

resource "cloudfoundry_app" "teams" {
  count = local.total_teams

  space = cloudfoundry_space.spaces[count.index].id
  name  = "team${count.index}"

  docker_image = "loafoe/go-hello-world:latest"
  memory       = 64

  routes {
    route = cloudfoundry_route.internal[count.index].id
  }
  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "internal" {
  count = local.total_teams

  space    = cloudfoundry_space.spaces[count.index].id
  domain   = data.cloudfoundry_domain.internal.id
  hostname = "multispace-team${count.index}"

  depends_on = [cloudfoundry_space_users.users]
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
