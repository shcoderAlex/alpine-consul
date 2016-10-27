FROM shcoder/alpine:glibc.supervisor

MAINTAINER shcoder.alex@gmail.com

ENV CONSUL_VERSION=0.7.0 \
		CONSUL_TEMPLATE_VERSION=0.16.0

RUN apk --no-cache add curl unzip jq nmap && \
    curl -fso /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip /tmp/consul.zip -d /sbin/ && \
    chmod +x /sbin/consul && \
    rm -f /tmp/consul.zip && \
    mkdir -p /opt/consul-web-ui && \
    curl -Lso /tmp/consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip && \
    cd /opt/consul-web-ui && \
    unzip /tmp/consul-web-ui.zip && \
    rm -f /tmp/consul-web-ui.zip && \
    curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    unzip /tmp/consul-template.zip -d /sbin/ && \
    rm -f /tmp/consul-template.zip 

ADD agent.json /etc/consul.d/
ADD start.sh /opt/consul/
ADD consul.ini /etc/supervisor.d/
RUN chmod +x /opt/consul/start.sh

EXPOSE 8500

CMD /usr/bin/supervisord -n -c /etc/supervisor.d/supervisord.conf