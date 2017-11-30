# Layer0 Consul

Consul is a service discovery tool created by [HashiCorp](https://www.consul.io/intro/). In this repository, we've provided a pre-configured implementation of Consul's service backend, as well as example configurations for using Consul with your own Layer0 services. 

# Overview

For a practical applications of Consul, see our [Layer0 Consul Documentation](http://docs.xfra.ims.io/guides/consul/).

# Enabling a Service to use Consul

In order to automatically register services with Consul, you need to add two extra containers to any given service: 
[Registrator](https://github.com/gliderlabs/registrator) and the [Consul Agent](https://www.consul.io/docs/agent/basics.html). 
The Registrator container takes care of detecting new Layer0 services and registering them with the Consul backend, 
while the Consul Agent is a localhost interface for performing Consul-based HTTP and DNS queries. 

# Examples
We have 2 walkthroughs in this repo that create a Consul server and a simple web application that registers itself with the Consul server:
* The walkthrough using the Layer0 cli can be found [here](https://github.com/quintilesims/consul/tree/master/example/cli)
* The walkthrough using Terraform can be found [here](https://github.com/quintilesims/consul/tree/master/example/terraform)

# Troubleshooting

## Outage Recovery

If a Consul server cluster node goes down, some manual intervention is typically required. The following docs have a good step-by-step of what to do:

- [https://www.consul.io/docs/guides/outage.html](https://www.consul.io/docs/guides/outage.html)
- [https://sitano.github.io/2015/10/06/abt-consul-outage/](https://sitano.github.io/2015/10/06/abt-consul-outage/)
- If a former cluster member is continually triggering `serf: attempting reconnect to _nodename_` messages, you can remove it. First, inspect Consul cluster logs and issue `consul force-leave nodename` within one of the cluster node containers. Use the nodename specified in the logs (i.e. ip-10-100-3-34.dc1)