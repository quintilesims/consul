resource "layer0_load_balancer" "consul" {
  name        = "${var.load_balancer_name}"
  environment = "${var.environment_id}"
  private     = true

  port {
    host_port      = 8500
    container_port = 8500
    protocol       = "tcp"
  }

  port {
    host_port      = 8301
    container_port = 8301
    protocol       = "tcp"
  }

  health_check {
    target              = "tcp:8500"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "layer0_service" "consul" {
  name          = "${var.service_name}"
  environment   = "${var.environment_id}"
  deploy        = "${layer0_deploy.consul.id}"
  load_balancer = "${layer0_load_balancer.consul.id}"
  scale         = 3

  provisioner "local-exec" {
    command = "l0 service scale --wait ${layer0_service.consul.id} 1 && l0 service scale --wait ${layer0_service.consul.id} 3"
  }
}

resource "layer0_deploy" "consul" {
  name    = "${var.deploy_name}"
  content = "${data.template_file.consul.rendered}"
}

data "template_file" "consul" {
  template = "${file("${path.module}/Server.Dockerrun.aws.json.template")}"

  vars {
    consul_server_url = "${layer0_load_balancer.consul.url}"
  }
}

data "template_file" "agent_container" {
  template = "${file("${path.module}/Agent.json.template")}"

  vars {
    consul_server_url = "${layer0_load_balancer.consul.url}"
  }
}

data "template_file" "registrator_container" {
  template = "${file("${path.module}/Registrator.json.template")}"
}

data "template_file" "docker_volume" {
  template = "${file("${path.module}/Volume.json.template")}"
}
