#!/bin/bash

sed -i -e "s#\"node_name\":.*#\"node_name\": \"${NODE_NAME}\",#" /etc/consul.d/agent.json

if [ ! -z "${BOOTSTRAP_EXPECT}" ]; then 
  sed -i -e "s#\"bootstrap\":.*#\"bootstrap_expect\": ${BOOTSTRAP_EXPECT},#" /etc/consul.d/agent.json
fi

if [ ! -z "${DATACENTER}" ]; then 
  sed -i -e "s#\"datacenter\":.*#\"datacenter\": ${DATACENTER},#" /etc/consul.d/agent.json
fi

if [ ! -z "${DATA_DIR}" ]; then 
  sed -i -e "s#\"data_dir\":.*#\"data_dir\": ${DATA_DIR},#" /etc/consul.d/agent.json
fi

if [ ! -z "${LOG_LEVEL}" ]; then 
  sed -i -e "s#\"log_level\":.*#\"log_level\": ${LOG_LEVEL},#" /etc/consul.d/agent.json
fi

if [ ! -z "${ENABLE_SYSLOG}" ]; then 
  sed -i -e "s#\"enable_syslog\":.*#\"enable_syslog\": ${ENABLE_SYSLOG},#" /etc/consul.d/agent.json
fi

if [ ! -z "${LEAVE_ON_TERMINATE}" ]; then 
  sed -i -e "s#\"leave_on_terminate\":.*#\"leave_on_terminate\": ${LEAVE_ON_TERMINATE},#" /etc/consul.d/agent.json
fi

if [ ! -z "${CLIENT_ADDR}" ]; then 
  sed -i -e "s#\"client_addr\":.*#\"client_addr\": ${CLIENT_ADDR},#" /etc/consul.d/agent.json
fi

if [ ! -z "${ADVERTISE_ADDR}" ]; then 
  sed -i -e "s#\"advertise_addr\":.*#\"advertise_addr\": ${ADVERTISE_ADDR},#" /etc/consul.d/agent.json
fi

if [ ! -z "${ADVERTISE_ADDR_WAN}" ]; then 
	sed -i -e "s#\"advertise_addr_wan\":.*#\"advertise_addr_wan\": ${ADVERTISE_ADDR_WAN},#" /etc/consul.d/agent.json
fi

if [ ! -z "${BOOTSTRAP}" ]; then 
	sed -i -e "s#\"bootstrap\":.*#\"bootstrap\": ${BOOTSTRAP},#" /etc/consul.d/agent.json
fi

if [ ! -z "${SERVER}" ]; then 
	sed -i -e "s#\"server\":.*#\"server\": ${SERVER},#" /etc/consul.d/agent.json
fi

if [ ! -z "${ENCRYPT}" ]; then 
	sed -i -e "s#\"encrypt\":.*#\"encrypt\": \"${ENCRYPT}\",#" /etc/consul.d/agent.json
fi

if [ ! -z "${CONSUL_CLUSTER_IPS}" ]; then
  RETRY_JOIN=""

  for IP in $(echo ${CONSUL_CLUSTER_IPS} | sed -e 's/,/ /g');do
    RETRY_JOIN="${RETRY_JOIN} ${IP}"
  done

  RETRY_JOIN=$(echo ${RETRY_JOIN}|sed -e 's/ /\",\"/g')
  sed -i -e "s#\"retry_join\":.*#\"retry_join\": [\"${RETRY_JOIN}\"],#" /etc/consul.d/agent.json
fi

consul agent -config-file=/etc/consul.d/agent.json -config-dir=/etc/consul.d
