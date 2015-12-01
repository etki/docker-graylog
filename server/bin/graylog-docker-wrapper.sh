#!/usr/bin/env bash

GRAYLOG2_ELASTICSEARCH_DISCOVERY_ZEN_PING_UNICAST_HOSTS=${GRAYLOG2_ELASTICSEARCH_DISCOVERY_ZEN_PING_UNICAST_HOSTS:=$GRAYLOG2_ELASTICSEARCH_HOSTS}

if [ -z $GRAYLOG2_ELASTICSEARCH_DISCOVERY_ZEN_PING_UNICAST_HOSTS ]; then
    echo "Please specify Elasticsearch host addresses via GRAYLOG2_ELASTICSEARCH_HOSTS or GRAYLOG2_ELASTICSEARCH_DISCOVERY_ZEN_PING_UNICAST_HOSTS environment variable"
    echo "Example: GRAYLOG2_ELASTICSEARCH_HOSTS=127.0.0.1:9300,127.0.0.1:19300"
    exit 1
fi

if [ -z $GRAYLOG2_MONGODB_URI ]; then
    echo "Please specify MongoDB connection URI via GRAYLOG2_MONGODB_URI environment variable"
    echo "Example: GRAYLOG2_MONGODB_URI=mongodb://localhost:27017/test"
    exit 1
fi

GRAYLOG2_DIRECTORY="$(dirname "$(dirname $0)")"
GRAYLOG2_CONFIGURATION_PATH=${GRAYLOG2_CONFIGURATION_PATH:=/etc/graylog/server/server.conf}
GRAYLOG2_JVM_HEAP_SIZE=${GRAYLOG2_JVM_HEAP_SIZE:=1g}

export GRAYLOG2_ROOT_PASSWORD=${GRAYLOG2_ROOT_PASSWORD:=bruteful}

export GRAYLOG2_PASSWORD_SECRET=${GRAYLOG2_PASSWORD_SECRET:=$(openssl rand -base64 48)$(openssl rand -base64 48)}
export GRAYLOG2_ROOT_PASSWORD_SHA2=${GRAYLOG2_ROOT_PASSWORD_SHA2:=$(echo -n $GRAYLOG2_ROOT_PASSWORD | shasum -a 256 | awk '{print $1}')}

export GRAYLOG2_REST_LISTEN_URI=${GRAYLOG2_REST_LISTEN_URI:="http://0.0.0.0:80"}
export GRAYLOG2_PLUGIN_DIR=${GRAYLOG2_PLUGIN_DIR:="plugin"}

# Checking if specified path is absolute or not
if [[ "$GRAYLOG2_PLUGIN_DIR" = /* ]]; then
    mkdir -p $GRAYLOG2_PLUGIN_DIR
else
    mkdir -p $GRAYLOG2_DIRECTORY/$GRAYLOG2_PLUGIN_DIR
fi

exec java -Djava.library.path=${GRAYLOG2_DIRECTORY}/lib/sigar \
    -Xms$GRAYLOG2_JVM_HEAP_SIZE -Xmx$GRAYLOG2_JVM_HEAP_SIZE -XX:NewRatio=1 -server \
    -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled \
    -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC \
    -XX:-OmitStackTraceInFastThrow \
    -jar $GRAYLOG2_DIRECTORY/graylog.jar \
    server -f "${GRAYLOG2_CONFIGURATION_PATH}" -np

