#!/bin/bash

NETWORK_INTERFACE=${CONSUL_NETWORK_INTERFACE-eth0}

if [ -z "${CONSUL_NODE_NAME}" ]; then 
  CONSUL_NODE_NAME="${HOSTNAME}"
fi

if [ -z "${ADVERTISE_ADDR}" ]; then 
  IPv4=$(ip -o -4 addr show ${NETWORK_INTERFACE})
  ADVERTISE_ADDR=$(echo ${IPv4}|egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"|head -n1)
fi

sed -i -e "s#\"node_name\":.*#\"node_name\": \"${CONSUL_NODE_NAME}\",#" /etc/consul.d/agent.json
sed -i -e "s#\"advertise_addr\":.*#\"advertise_addr\": \"${ADVERTISE_ADDR}\",#" /etc/consul.d/agent.json

if [ ! -z "${CONSUL_BOOTSTRAP_EXPECT}" ]; then 
  sed -i -e "s#\"bootstrap\":.*#\"bootstrap_expect\": ${CONSUL_BOOTSTRAP_EXPECT},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_DATACENTER}" ]; then 
  sed -i -e "s#\"datacenter\":.*#\"datacenter\": ${CONSUL_DATACENTER},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_DATA_DIR}" ]; then 
  sed -i -e "s#\"data_dir\":.*#\"data_dir\": ${CONSUL_DATA_DIR},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_LOG_LEVEL}" ]; then 
  sed -i -e "s#\"log_level\":.*#\"log_level\": ${CONSUL_LOG_LEVEL},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_ENABLE_SYSLOG}" ]; then 
  sed -i -e "s#\"enable_syslog\":.*#\"enable_syslog\": ${CONSUL_ENABLE_SYSLOG},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_LEAVE_ON_TERMINATE}" ]; then 
  sed -i -e "s#\"leave_on_terminate\":.*#\"leave_on_terminate\": ${CONSUL_LEAVE_ON_TERMINATE},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_CLIENT_ADDR}" ]; then 
  sed -i -e "s#\"client_addr\":.*#\"client_addr\": ${CONSUL_CLIENT_ADDR},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_ADVERTISE_ADDR_WAN}" ]; then 
	sed -i -e "s#\"advertise_addr_wan\":.*#\"advertise_addr_wan\": ${CONSUL_ADVERTISE_ADDR_WAN},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_BOOTSTRAP}" ]; then 
	sed -i -e "s#\"bootstrap\":.*#\"bootstrap\": ${CONSUL_BOOTSTRAP},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_SERVER}" ]; then 
	sed -i -e "s#\"server\":.*#\"server\": ${CONSUL_SERVER},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_ENCRYPT}" ]; then 
	sed -i -e "s#\"encrypt\":.*#\"encrypt\": \"${CONSUL_ENCRYPT}\",#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_CLUSTER_IPS}" ]; then
  RETRY_JOIN=""

  for IP in $(echo ${CONSUL_CLUSTER_IPS} | sed -e 's/,/ /g');do
    RETRY_JOIN="${RETRY_JOIN} ${IP}"
  done

  RETRY_JOIN=$(echo ${RETRY_JOIN}|sed -e 's/ /\",\"/g')
  sed -i -e "s#\"retry_join\":.*#\"retry_join\": [\"${RETRY_JOIN}\"],#" /etc/consul.d/agent.json
fi

trap 'consul leave' SIGTERM

consul agent -config-file=/etc/consul.d/agent.json -config-dir=/etc/consul.d
