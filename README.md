# Layer0 Consul

Consul is a service discovery tool created by [HashiCorp](https://www.consul.io/intro/). In this repository, we've provided a pre-configured implementation of Consul's service backend, as well as example configurations for using Consul with your own Layer0 services. 

# Overview

When you have multiple services in a Layer0 environment, how do you get them to connect to each other? One simple answer is that you hardcode service endpoints (i.e. a Loadbalancer URL) in your application configurations. That may be OK for testing, but ultimately hardcoding endpoints is not portable, annoying to maintain, and not in line with the [guidelines of a 12-factor app](https://12factor.net/). A much better solution is to use a service like Consul, which along with another tool called Registrator, can automatically detect your services when they come online and add them to a service registry. You can then 'discover' these services using catalog endpoints via [DNS](https://www.consul.io/docs/agent/dns.html) or [HTTP](https://www.consul.io/docs/agent/http.html).

For a practical applications of Consul, see our [Layer0 Consul Documentation](http://docs.xfra.ims.io/guides/consul/).

# Installation

**NOTICE:** in order to install Consul, you must have [Layer0 v0.8.2](http://docs.xfra.ims.io/releases/) or greatest installed with the proper environment variables set from `l0-setup`. In the following instructions, we assume you will be installing Consul into a new Layer0 environment.

```bash
 # create a new environment
 l0 environment create prod

 # create a private load balancer for bootstraping Consul
 l0 loadbalancer create prod consul-lb --port 8500:8500/tcp --port 8301:8301/tcp --private --wait

 # get the loadbalancer's URL; replace blank string @ line 18 of `consul-master.json`'s EXTERNAL_URL value
 l0 loadbalancer get consul-lb

 # after editing consul-master.json, upload the Layer0 Consul deploy from this repository
 l0 deploy create consul-master.json consul-master

 # create the Consul service 
 l0 service create prod consul-master consul-master --loadbalancer consul-lb --wait

 # scale the Consul service to 3
 l0 service scale consul-master 3

 # wait until the service reads 3/3 under 'scale'
 l0 service get consul-master

 # if something goes wrong, you can troubleshoot the Consul service with `service logs` 
 l0 service logs consul-master
 ```

# Enabling a Service to use Consul

In order to automatically register services with Consul, you need to add two extra containers to any given service: [Registrator](https://github.com/gliderlabs/registrator) and the Consul Agent. We've included a [base template](example-service.json) that you can use to do this, although it is recommended that you also read up on the [Consul Agent](https://www.consul.io/docs/agent/basics.html) as well. The general idea here is that the Registrator container takes care of detecting new Layer0 services and registering them with the Consul backend, while the Consul Agent is a localhost interface for performing HTTP and DNS queries. 

For additional examples of Layer0 services that use Consul:
- [Guestbook with Consul](http://docs.xfra.ims.io/guides/guestbook_consul/)
- [Splunk with Consul](https://gitlab.imshealth.com/tools/ImsHealth.Logging/tree/master/infrastructure/splunk-distributed)

# Troubleshooting

Please get in touch in #xfra on Slack for any issues.
