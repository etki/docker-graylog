#!/usr/bin/env bash

if [ -z $GRAYLOG_SERVER_URI ]; then
    echo "Please specify graylog server URI to connect to via GRAYLOG_SERVER_URI environment variable"
    exit 1;
fi

APPLICATION_SECRET=$(openssl rand -base64 48)$(openssl rand -base64 48)
TIMEZONE=${TIMEZONE:=UTC}
GRAYLOG_DIR="$(dirname "$(dirname $0)")"
GRAYLOG_CONFIGURATION_FILE=/etc/graylog/web-interface.conf
CLASSPATH=$(find $GRAYLOG_DIR/lib -type f -name '*.jar' | paste -s -d ':')
JAVA_HEAP_SIZE=${JAVA_HEAP_SIZE:=1g}
HTTP_PORT=${HTTP_PORT:=80}
HTTP_ADDRESS=${HTTP_ADDRESS:=0.0.0.0}

mkdir -p $(dirname $GRAYLOG_CONFIGURATION_FILE)

cat $GRAYLOG_DIR/graylog.conf.template \
    | sed s@%graylog2_server_uris%@$GRAYLOG_SERVER_URI@g \
    | sed s@%application_secret%@$APPLICATION_SECRET@g \
    | sed s/%timezone%/$TIMEZONE/g \
    | tee $GRAYLOG_CONFIGURATION_FILE > /dev/null

exec java -Xmx$JAVA_HEAP_SIZE -Xms$JAVA_HEAP_SIZE \
    -XX:ReservedCodeCacheSize=128m \
     -Duser.dir=$GRAYLOG_DIR -Dconfig.file=/etc/graylog/web-interface.conf \
    -Dhttp.address=$HTTP_ADDRESS -Dhttp.port=$HTTP_PORT \
    -cp $CLASSPATH play.core.server.NettyServer