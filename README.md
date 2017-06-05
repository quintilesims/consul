# Layer0 Consul

Consul is a service discovery tool created by [HashiCorp](https://www.consul.io/intro/). In this repository, we've provided a pre-configured implementation of Consul's service backend, as well as example configurations for using Consul with your own Layer0 services. 

# Overview

When you have multiple services in a Layer0 environment, how do you get them to connect to each other? One simple answer is that you hardcode service endpoints (i.e. a Loadbalancer URL) in your application configurations. That may be OK for testing, but ultimately hardcoding endpoints is not portable, annoying to maintain, and not in line with the [guidelines of a 12-factor app](https://12factor.net/). A much better solution is to use a service like Consul, which along with another tool called Registrator, can automatically detect your services when they come online and add them to a service registry. You can then 'discover' these services using catalog endpoints via [DNS](https://www.consul.io/docs/agent/dns.html) or [HTTP](https://www.consul.io/docs/agent/http.html).

For a practical applications of Consul, see our [Layer0 Consul Documentation](http://docs.xfra.ims.io/guides/consul/).

# Enabling a Service to use Consul

In order to automatically register services with Consul, you need to add two extra containers to any given service: 
[Registrator](https://github.com/gliderlabs/registrator) and the [Consul Agent](https://www.consul.io/docs/agent/basics.html). 
The general idea here is that the Registrator container takes care of detecting new Layer0 services and registering them with the Consul backend, 
while the Consul Agent is a localhost interface for performing Consul-based HTTP and DNS queries. 

# Examples
We have 2 walkthroughs in this repo that create a Consul server and a simple web application that registers itself with the Consul server:
* The walkthrough using the Layer0 cli can be found [here](https://github.com/quintilesims/consul/tree/master/example/cli)
* The walkthrough using Terraform can be found [here](https://github.com/quintilesims/consul/tree/master/example/terraform)

# Troubleshooting

Please send an email to <carbon@us.imshealth.com> with any issues.
