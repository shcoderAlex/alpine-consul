#!/bin/bash

sed -i -e "s#\"node_name\":.*#\"node_name\": \"${NODE_NAME}\",#" /etc/consul.d/agent.json

if [ ! -z "${BOOTSTRAP_EXPECT}" ]; then 
	sed -i -e "s#\"bootstrap\":.*#\"bootstrap_expect\": ${BOOTSTRAP_EXPECT},#" /etc/consul.d/agent.json
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
