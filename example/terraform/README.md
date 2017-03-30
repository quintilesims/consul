# Terraform Walkthrough

This walkthrough will show you how to deploy a Consul server and a Hello World service that gets registered to the Consul server using the [Layer0 Terraform Plugin](http://layer0.ims.io/reference/terraform-plugin/). 
It is assumed you are running all commands from this directory. 

**NOTICE:** This walkthrough assumes you have [Layer0 v0.9.0](http://layer0.ims.io/releases/) and [Terraform v0.9.0](https://www.terraform.io/downloads.html) or greater installed.

## The Consul Module
This section will detail some of the terraform configuration found in this example.
To simply create everything, feel free to jump to the next section.

The configuration in `terraform` directory in this repo holds a [Terraform Module](https://www.terraform.io/intro/getting-started/modules.html). 
In short, Terraform modules allow you to import and reuse Terraform configurations; it's similar to importing packages/modules in source code.

### Inputs
To import the Layer0 Consul module, just add the following lines to your local terraform configuration: 
```
module "consul" {
  source         = "github.com/quintilesims/consul/terraform"
  environment_id = "<environment id here>"
}
```

This module will create a Consul deploy, service, and load balancer in the specified environment.
The name for each of these entities is `consul-server`, but they can be overwitten with variables:
```
module "consul" {
  source             = "github.com/quintilesims/consul/terraform"
  environment_id     = "<environment id here>"
  load_balancer_name = "my_consul_lb"
  service_name       = "my_consul_svc"
  deploy_name        = "my_consul_dpl"
}
```

The module variables are located at [variables.tf](https://github.com/quintilesims/consul/blob/master/terraform/variables.tf).

### Outputs
The outputs from the module can be consumed in your local terraform configuration.
For example, you can get the URL of the consul server with the following:
```
module "consul" {
  source         = "github.com/quintilesims/consul/terraform"
  environment_id = "<environment id here>"
}
...
url = ${module.consul.load_balancer_url}
```

### The Container and Volume Outputs
The consul module has 3 outputs that can be used to simplify your task definitions: `registrator_container`, `agent-container`, and `docker-volume`. 

These outputs are simply json text blocks that can be templated into your `Dockerrun.aws.json` files. 
In this example, the `HelloWorld.Dockerrun.aws.json.template` uses all three of these text blocks.

First, we create a terraform template using `HelloWorld.Dockerrun.aws.json.template`.
Notice that we pass in the `agent_container`, `registrator_container`, and `docker_volume` blocks from the consul module:
```
data "template_file" "hello-world" {
  template = "${file("HelloWorld.Dockerrun.aws.json.template")}"

  vars {
    consul_agent_container       = "${module.consul.agent_container}"
    consul_registrator_container = "${module.consul.registrator_container}"
    docker_volume                = "${module.consul.docker_volume}"
  }
}
```

Our `HelloWorld.Dockerrun.aws.json.template` file is setup to include the container and volume definitions:
```
{
  "AWSEBDockerrunVersion": 2,
  "containerDefinitions": [
    {
      "name": "hello-world",
      "image": "dockercloud/hello-world",
       ...
    },
    ${consul_agent_container},
    ${consul_registrator_container}
  ],
  "volumes": [
    ${docker_volume}
  ]
}
```

When this file is rendered, it is the **exact same** as the file located in the [CLI Walkthrough](https://github.com/quintilesims/consul/blob/master/example/cli/HelloWorld.Dockerrun.aws.json.template). In addition to the benefit that we didn't manually need to update the load balancer url - this also places all of our consul agent configuration into a single spot!

## Run Terraform
This walkthrough requires you give terraform your Layer0 endpoint and token variables.
These can be gathered using the `l0-setup endpoint` command. 
Setting variables can be done via the command line, environment variables, or through a file named `terraform.tfvars` (see terraform documentation [here](https://www.terraform.io/docs/configuration/variables.html)).
It doesn't matter which method you choose, just be sure to have those variables ready before running `terraform apply`. 

When you are ready, simply run:
```
terraform apply
...
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```

This will create all of the resources described in the [CLI Walkthrough](https://github.com/quintilesims/consul/tree/master/example/cli) with a single command!
