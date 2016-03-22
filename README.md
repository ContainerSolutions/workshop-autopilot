Applications on Autopilot
==========

*A demonstration of the autopilot pattern for self-operating microservices, designed as a workshop or tutorial.*


Microservices and Docker go together like chocolate and peanut butter: microservice architectures provide organizations a tool to manage complexity of the development process, and application containers provide a new means to manage the dependencies and deployment of those microservices. But deploying and connecting those services together is still a challenge because it forces developers to design for operationalization.

Autopiloting applications are a powerful design pattern to solving this problem. By pushing the responsibility for understanding startup, shutdown, scaling, and recovery from failure into the application, we can build intelligent architectures that minimize human intervention in operation. But we can't rewrite all our applications at once, so we need a way to build application containers that can knit together legacy and greenfield applications alike.

This project demonstrates this design pattern by applying it to a simple microservices deployment using Nginx and two Node applications.


### Getting started

This project requires a Docker host and client, as well as Docker Compose. The [Docker Toolbox](https://www.docker.com/products/docker-toolbox) will provide a suitable environment for users on OS X or Windows.

### Project architecture

The project is broken into 4 subsystems. Web clients communicate only with Nginx, which serves as a reverse proxy and load balancer to two microservices -- Customers and Sales. The microservices should be able to be scaled to arbitrary numbers of nodes and the virtualhost configuration in Nginx will be updated to suit. Also, the Customers application needs data from Sales and the Sales application needs data from Customers. This means that when we scale up Sales nodes, all the Customer nodes must learn of the change (and vice-versa). We use Joyent's [Containerbuddy](https://github.com/joyent/containerbuddy) to orchestrate this process and Hashicorps' [Consul](https://www.consul.io/) as a discovery service.

![Completed project architecture](docs/arch.png)

The `master` branch of this repo contains only an incomplete skeleton of services as a starting point. The configuration for Nginx and the Sales microservice are left incomplete, whereas the Customer microservice is complete and already includes the Containerbuddy configuration. Other branches will include the completed application as demonstrated at various workshops.

## Running on mantl
It is possible to run these containerbuddy examples on top of mantle.io, and use mantle's consul for service discovery.

However, each mantle cluster has it's own certificate authority, and consul is can only be accesed through an nginx proxy via https. The certificate used by nginx is signed by mantle's certificate authority. Hence, each container wishing to interact with mantl's consul in a safe manner, eg, not ignoring uknown CA's, must import this CA.

### Steps
1. Copy `<mantleroot>/ssl/cacert.pem` to `<workshop-autopilot-root>/mantle_base_images/cacert.pem`
2. Set the env vars `MANTL_CONTROL_HOST`, `MANTL_LOGIN`, `MANTL_PASSWORD` and `IMAGE_PREFIX` to correct values.
3. Run `make build` to build the containers from the Dockerfiles
4. Run `make publish` to publish to the docker hub
5. run `make add` to add the containers to mantl via the marathon scripts

Cleanup:
1. run `make del` to add the remove the containers from marathon, when you're done.
