variable "environment_id" {
  description = "ID of the Layer0 environment to build the service"
}

variable "load_balancer_name" {
  description = "Name of the Layer0 load balancer to create"
  default     = "consul-server"
}

variable "service_name" {
  description = "Name of the Layer0 service to create"
  default     = "consul-server"
}

variable "deploy_name" {
  description = "Name of the Layer0 deploy to create"
  default     = "consul-server"
}

variable "consul_version" {
  description = "Dockerhub Consul Version"
  default     = "consul:0.9.3"
}
