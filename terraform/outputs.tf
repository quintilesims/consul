output "agent_container" {
  value = "${data.template_file.agent_container.rendered}"
}

output "registrator_container" {
  value = "${data.template_file.registrator_container.rendered}"
}

output "docker_volume" {
  value = "${data.template_file.docker_volume.rendered}"
}

output "load_balancer_id" {
  value = "${layer0_load_balancer.consul.id}"
}

output "load_balancer_url" {
  value = "${layer0_load_balancer.consul.url}"
}

output "service_id" {
  value = "${layer0_service.consul.id}"
}

output "deploy_id" {
  value = "${layer0_deploy.consul.id}"
}
