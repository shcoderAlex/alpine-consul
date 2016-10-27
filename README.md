# Consul

### ENV
* **CONSUL_NODE_NAME** 
* **CONSUL_DATACENTER** 
* **CONSUL_DATA_DIR** 
* **CONSUL_LOG_LEVEL** 
* **CONSUL_ENABLE_SYSLOG** 
* **CONSUL_LEAVE_ON_TERMINATE** 
* **CONSUL_CLIENT_ADDR** 
* **CONSUL_ADVERTISE_ADDR** 
* **CONSUL_NETWORK_INTERFACE** 
* **CONSUL_ADVERTISE_ADDR_WAN** 
* **CONSUL_BOOTSTRAP_EXPECT** - *number*
* **CONSUL_BOOTSTRAP** - *true|false (default: false)*
* **CONSUL_SERVER** - *true|false (default: false)*
* **CONSUL_ENCRYPT** - *use "docker run --rm consul keygen"*
* **CONSUL_CLUSTER_IPS** - *list ip addresses, delimiter - ","*

### Example
***Consul Server 1***

```
docker run -ti --rm --name node-1 -p 8500:8500 \
	-e CONSUL_NODE_NAME=node-1 \
	-e CONSUL_BOOTSTRAP_EXPECT=3 \
	-e CONSUL_SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.3,172.17.0.4 \
	-e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul
```

***Consul Server 2***

```
docker run -ti --rm --name node-2 \
	-e CONSUL_NODE_NAME=node-2 \
	-e CONSUL_BOOTSTRAP_EXPECT=3 \
	-e CONSUL_SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.4 \
	-e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \

shcoder/alpine-consul
```

***Consul Server 3***

```
docker run -ti --rm --name node-3 \
	-e CONSUL_NODE_NAME=node-3 \
	-e CONSUL_BOOTSTRAP_EXPECT=3 \
	-e CONSUL_SERVER=true \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.3 \
	-e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul
```

***Consul Client***

```
docker run -ti --rm --name client \
	-e CONSUL_NODE_NAME=client \
	-e CONSUL_CLUSTER_IPS=172.17.0.2,172.17.0.3,172.17.0.4 \
	-e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul
```

***Or***
```
docker-compose up -d
```

####If you use Swarm

```
docker network create -d overlay --opt encrypted consul-net
```

```
docker service create --name consul --network consul-net -p 8500:8500 --replicas=3  \
	-e CONSUL_BOOTSTRAP_EXPECT=3 \
	-e CONSUL_SERVER=true \
	-e CONSUL_CLUSTER_IPS=consul \
	-e CONSUL_ENCRYPT=q7Gsg6LSdrtWFvBpw7vmdA== \
shcoder/alpine-consul
```
