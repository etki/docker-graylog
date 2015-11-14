FROM java:8

# you may probably need more than that for inputs
EXPOSE 80 9350

ENV GRAYLOG_ADMIN_USERNAME=graylog-admin GRAYLOG_ADMIN_PASSWORD=bruteful \
    IS_MASTER=true \
    MONGODB_URI= \
    ELASTICSEARCH_HOSTS= ELASTICSEARCH_CLUSTER_NAME=graylog2

ADD https://packages.graylog2.org/releases/graylog2-server/graylog-1.2.2.tgz \
    /tmp/graylog-server.tgz

# you may use following instruction for direct archive copying instead of
# downloading it every time

#COPY graylog-1.2.2.tgz /tmp/graylog-server.tgz

RUN tar -xzvf /tmp/graylog-server.tgz -C /tmp \
    && mv /tmp/graylog-1.2.2 /usr/local/graylog \
    && rm /tmp/graylog-server.tgz
ADD bin/* /usr/local/graylog/bin
ADD configuration/graylog.conf.template /usr/local/graylog/graylog.conf.template

CMD ["/usr/local/graylog/bin/graylog-docker-wrapper.sh"]

