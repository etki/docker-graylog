#!/usr/bin/env bash

if [ -z $ELASTICSEARCH_HOSTS ]; then
    echo "Please specify Elasticsearch host addresses via ELASTICSEARCH_HOSTS environment variable"
    exit 1
fi

if [ -z $MONGODB_URI ]; then
    echo "Please specify MongoDB connection URI via MONGODB_URI environment variable"
    exit 1
fi

GRAYLOG_DIR="$(dirname "$(dirname $0)")"

GRAYLOG_CONFIGURATION_PATH=${GRAYLOG_CONFIGURATION_PATH:=/etc/graylog/server.conf}
TIMEZONE=${TIMEZONE:=UTC}
ELASTICSEARCH_CLUSTER_NAME=${ELASTICSEARCH_CLUSTER_NAME:=graylog2}
JAVA_HEAP_SIZE=${JAVA_HEAP_SIZE:=1g}
EMAIL_TRANSPORT_ENABLED=${EMAIL_TRANSPORT_ENABLED:=false}
EMAIL_TRANSPORT_HOSTNAME=${EMAIL_TRANSPORT_HOSTNAME:=}
EMAIL_TRANSPORT_PORT=${EMAIL_TRANSPORT_PORT:=587}
EMAIL_TRANSPORT_AUTH_ENABLED=${EMAIL_TRANSPORT_AUTH_ENABLED:=true}
EMAIL_TRANSPORT_TLS_ENABLED=${EMAIL_TRANSPORT_TLS_ENABLED:=true}
EMAIL_TRANSPORT_SSL_ENABLED=${EMAIL_TRANSPORT_SSL_ENABLED:=true}
EMAIL_TRANSPORT_AUTH_USERNAME=${EMAIL_TRANSPORT_AUTH_USERNAME:=}
EMAIL_TRANSPORT_AUTH_PASSWORD=${EMAIL_TRANSPORT_AUTH_PASSWORD:=}
EMAIL_TRANSPORT_SUBJECT_PREFIX=${EMAIL_TRANSPORT_SUBJECT_PREFIX:=[graylog]}
EMAIL_TRANSPORT_SENDER=${EMAIL_TRANSPORT_SENDER:=}

PASSWORD_SECRET=${PASSWORD_SECRET:=$(openssl rand -base64 48)$(openssl rand -base64 48)}
PASSWORD_SHA2=$(echo -n $GRAYLOG_ADMIN_PASSWORD | shasum -a 256 | awk '{print $1}')

mkdir -p $(dirname $GRAYLOG_CONFIGURATION_PATH)

cat $GRAYLOG_DIR/graylog.conf.template \
    | sed s@%password_secret%@PASSWORD_SECRET@g \
    | sed s/%root_username%/$GRAYLOG_ADMIN_USERNAME/g \
    | sed s@%root_password_sha2%@$PASSWORD_SHA2@g \
    | sed s/%root_email%/$GRAYLOG_ROOT_EMAIL/g \
    | sed s/%root_timezone%/$TIMEZONE/g \
    | sed s/%is_master%/$IS_MASTER/g \
    | sed s@%mongodb_uri%@$MONGODB_URI@g \
    | sed s@%elasticsearch_unicast_hosts%@$ELASTICSEARCH_HOSTS@g \
    | sed s@%elasticsearch_cluster_name%@$ELASTICSEARCH_CLUSTER_NAME@g \
    | sed s@%transport_email_enabled%@$EMAIL_TRANSPORT_ENABLED@g \
    | sed s@%transport_email_hostname%@$EMAIL_TRANSPORT_HOSTNAME@g \
    | sed s@%transport_email_port%@$EMAIL_TRANSPORT_PORT@g \
    | sed s@%transport_email_use_auth%@$EMAIL_TRANSPORT_USE_AUTH@g \
    | sed s@%transport_email_use_tls%@$EMAIL_TRANSPORT_USE_TLS@g \
    | sed s@%transport_email_use_ssl%@$EMAIL_TRANSPORT_USE_SSL@g \
    | sed s@%transport_email_auth_username%@$EMAIL_TRANSPORT_AUTH_USERNAME@g \
    | sed s@%transport_email_auth_password%@$EMAIL_TRANSPORT_AUTH_PASSWORD@g \
    | sed s@%transport_email_subject_prefix%@$EMAIL_TRANSPORT_SUBJECT_PREFIX@g \
    | sed s/%transport_email_from_email%/$EMAIL_TRANSPORT_FROM_EMAIL/g \
    | tee $GRAYLOG_CONFIGURATION_PATH > /dev/null

exec java -Djava.library.path=${GRAYLOG_DIR}/lib/sigar \
    -Xms$JAVA_HEAP_SIZE -Xmx$JAVA_HEAP_SIZE -XX:NewRatio=1 -server \
    -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled \
    -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC \
    -XX:-OmitStackTraceInFastThrow \
    -jar $GRAYLOG_DIR/graylog.jar \
    server -f "${GRAYLOG_CONFIGURATION_PATH}" -np

