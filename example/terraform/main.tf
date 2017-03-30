provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

module "consul" {
  source         = "../consul/terraform"
  environment_id = "${layer0_environment.dev.id}"
}

resource "layer0_environment" "dev" {
  name = "dev"
}

resource "layer0_load_balancer" "hello-world" {
  name        = "hello-world"
  environment = "${layer0_environment.dev.id}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

resource "layer0_service" "hello-world" {
  name          = "hello-world"
  environment   = "${layer0_environment.dev.id}"
  load_balancer = "${layer0_load_balancer.hello-world.id}"
  deploy        = "${layer0_deploy.hello-world.id}"
  scale         = 1
  wait          = false
}

resource "layer0_deploy" "hello-world" {
  name    = "hello_world"
  content = "${data.template_file.hello-world.rendered}"
}

data "template_file" "hello-world" {
  template = "${file("HelloWorld.Dockerrun.aws.json.template")}"

  vars {
    consul_agent_container       = "${module.consul.agent_container}"
    consul_registrator_container = "${module.consul.registrator_container}"
    docker_volume                = "${module.consul.docker_volume}"
  }
}
