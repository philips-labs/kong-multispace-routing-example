locals {
  services = {
    for n in range(0, var.teams) :
    n => {
      "name"  = "space${n}",
      "url"   = "http://${random_pet.deploy.id}-team${n}.apps.internal:8080"
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

resource "random_pet" "deploy" {
  separator = "-"
}

module "kong" {
  source  = "philips-labs/kong/cloudfoundry"
  version = "3.0.0"

  cf_org_name   = var.cf_org_name
  cf_space_name = var.cf_space_name
  name_postfix  = random_pet.deploy.id
  strategy      = "blue-green"

  kong_declarative_config_string = local.declarative_config_string
}

resource "cloudfoundry_space" "spaces" {
  count = var.teams

  name = "${random_pet.deploy.id}-team${count.index}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space_users" "users" {
  count      = var.teams
  space      = cloudfoundry_space.spaces[count.index].id
  developers = [var.cf_user]
}

resource "cloudfoundry_app" "teams" {
  count = var.teams

  space = cloudfoundry_space.spaces[count.index].id
  name  = "go-hello-world"

  docker_image = "loafoe/go-hello-world:latest"
  memory       = 64

  routes {
    route = cloudfoundry_route.internal[count.index].id
  }
  depends_on = [cloudfoundry_space_users.users]
}

resource "cloudfoundry_route" "internal" {
  count = var.teams

  space    = cloudfoundry_space.spaces[count.index].id
  domain   = data.cloudfoundry_domain.internal.id
  hostname = "${random_pet.deploy.id}-team${count.index}"

  depends_on = [cloudfoundry_space_users.users]
}


resource "cloudfoundry_network_policy" "policies" {
  count = var.teams

  policy {
    source_app      = module.kong.kong_app_id
    destination_app = cloudfoundry_app.teams[count.index].id
    port            = 8080
    protocol        = "tcp"
  }
}
