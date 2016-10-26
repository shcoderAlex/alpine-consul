# Consul

### ENV
* **NODE_NAME** 
* **BOOTSTRAP_EXPECT** - *number*
* **BOOTSTRAP** - *true|false (default: false)*
* **SERVER** - *true|false (default: false)*
* **ENCRYPT** - *use "docker run --rm consul keygen"*
* **CONSUL_CLUSTER_IPS** - *list ip addresses, delimiter - ","*

### Example
***Consul Bootstrap Server 1***

```
docker run -ti --rm --name node-1 -p 8500:8500 \
	-e NODE_NAME=node-1 \
	-e BOOTSTRAP_EXPECT=2 \
	-e SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.3,172.17.0.4 \
	-e ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul

```
***Consul Server 2***

```
docker run -ti --rm --name node-2 \
	-e NODE_NAME=node-2 \
	-e SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.4 \
	-e ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \

shcoder/alpine-consul
```
***Consul Server 3***

```
docker run -ti --rm --name node-3 \
	-e NODE_NAME=node-3 \
	-e SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.3 \
	-e ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul

```
***Consul Client***

```
docker run -ti --rm --name client \
	-e NODE_NAME=client \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.3,172.17.0.4 \
	-e ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul

```
***Or***
```
docker-compose up -d
```