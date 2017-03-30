# CLI Walkthrough

This walkthrough will show you how to deploy a Consul server and a Hello World service that gets registered to the Consul server using the [Layer0 CLI](http://layer0.ims.io/reference/cli/). 

**NOTICE:** This walkthrough assumes you have [Layer0 v0.9.0](http://layer0.ims.io/releases/) or greater installed. 

## Create the Consul Server
Run the following steps in your shell:

```bash
 # create a new environment named dev
 l0 environment create dev

 # create a private load balancer for the consul server
 l0 loadbalancer create --port 8500:8500/tcp --port 8301:8301/tcp --private --healthcheck-target "TCP:8500" dev consul-lb 
```

Get the load balancer's URL by running:
```bash
l0 loadbalancer get dev:consul-lb
```

Edit the `CONSUL_SEVER_URL` environment variable in the file `Server.Dockerrun.aws.json.template` with the URL:
```
...
{
    "name": "CONSUL_SERVER_URL",
    "value": "load balancer url here!"
},
...
```
Rename the edited file to `Server.Dockerrun.aws.json`, and continue to create the Consul Server:

```bash
# create a deploy for the consul server
l0 deploy create Server.Dockerrun.aws.json consul-server
 
# create the consul service 
l0 service create --wait --loadbalancer dev:consul-lb dev consul-server consul-server:latest

# scale the consul server to size 3
l0 service scale --wait dev:consul-server 3
```


# Create the 'Hello World' Service
Edit the `CONSUL_SEVER_URL` environment variable in the file `HelloWorld.Dockerrun.aws.json.template` with the consul server's load balancer URL used in the previous section:
```
...
{
    "name": "CONSUL_SERVER_URL",
    "value": "load balancer url here!"
},
...
```
Rename the edited file to `HelloWorld.Dockerrun.aws.json`, and continue to create the Hello World service:
```bash
# create a load balancer for the service
l0 loadbalancer create --port 80:80/http dev hello-world

# create a deploy for the hello-world service
l0 deploy create HelloWorld.Dockerrun.aws.json hello-world

# create the hello-world service 
l0 service create --wait --loadbalancer dev:hello-world dev hello-world hello-world:latest
```
