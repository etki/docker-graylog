#!/usr/bin/env bash

if [ -z $GRAYLOG2_SERVER_URI ]; then
    echo "Please specify graylog server(s) URI to connect to via GRAYLOG2_SERVER_URI environment variable"
    exit 1;
fi

GRAYLOG2_DIRECTORY="$(dirname "$(dirname $0)")"
GRAYLOG2_CONFIGURATION_FILE=/etc/graylog/web-interface.conf

GRAYLOG2_HTTP_PORT=${GRAYLOG2_HTTP_PORT:=80}
GRAYLOG2_HTTP_ADDRESS=${GRAYLOG2_HTTP_ADDRESS:=0.0.0.0}
GRAYLOG2_CLASSPATH=$(find $GRAYLOG2_DIRECTORY/lib -type f -name '*.jar' | paste -s -d ':')
GRAYLOG2_APPLICATION_SECRET=$(openssl rand -base64 48)$(openssl rand -base64 48)

GRAYLOG2_TIMEZONE=${GRAYLOG2_TIMEZONE:=UTC}
GRAYLOG2_JVM_HEAP_SIZE=${GRAYLOG2_JVM_HEAP_SIZE:=1g}

mkdir -p $(dirname $GRAYLOG2_CONFIGURATION_FILE)

cat $GRAYLOG2_DIRECTORY/graylog.conf.template \
    | sed s@%graylog2_server_uris%@$GRAYLOG2_SERVER_URI@g \
    | sed s@%application_secret%@$GRAYLOG2_APPLICATION_SECRET@g \
    | sed s/%timezone%/$GRAYLOG2_TIMEZONE/g \
    | tee $GRAYLOG2_CONFIGURATION_FILE > /dev/null

exec java -Xmx$GRAYLOG2_JVM_HEAP_SIZE -Xms$GRAYLOG2_JVM_HEAP_SIZE \
    -XX:ReservedCodeCacheSize=128m \
    -Duser.dir=$GRAYLOG2_DIRECTORY -Dconfig.file=/etc/graylog/web-interface.conf \
    -Dhttp.address=$GRAYLOG2_HTTP_ADDRESS -Dhttp.port=$GRAYLOG2_HTTP_PORT \
    -Dpidfile.path=/tmp/graylogweb.pid \
    -cp $GRAYLOG2_CLASSPATH play.core.server.NettyServer
