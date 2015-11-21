# Graylog 2 server docker image

This repository contains docker image for [graylog][graylog] 2 server component.

## Configuration

Containers are configured in regular way, via environment variables:

| Variable                         | Default value     | Example                           | Note                                            |
|----------------------------------|-------------------|-----------------------------------|-------------------------------------------------|
| `ELASTICSEARCH_HOSTS`            |                   | `172.17.0.1:9300,172.17.0.2:9300` | List of Elasticsearch hosts, separated by comma |
| `ELASTICSEARCH_CLUSTER_NAME`     | `graylog2`        | `elasticsearch`                   | Name of the cluster server has to connect to    |
| `MONGODB_URI`                    |                   | `mongodb://172.17.0.1:27017/test` | Mongo DB connection URI                         |
| `GRAYLOG_ADMIN_USERNAME`         | `graylog-admin`   | `admin`                           | Admin login                                     |
| `GRAYLOG_ADMIN_PASSWORD`         | `bruteful`        | `mah-super-passwrd`               | Admin password                                  |
| `PASSWORD_SECRET`                | openssl-generated | `aaaabbbbcccdddd`...              | Secret crypto value,                            |
| `IS_MASTER`                      | `true`            | `false`                           | Whether node should be master, **only one node in cluster may act as master** |
| `JAVA_HEAP_SIZE`                 | `1g`              | `2g`                              | Amount of memory dedicated for Java heap        |
| `TIMEZONE`                       | `UTC`             | `Europe/Moscow`                   | Timezone server is located in                   |
| `EMAIL_TRANSPORT_ENABLED`        | `false`           | `true`                            |                                                 |
| `EMAIL_TRANSPORT_HOSTNAME`       |                   | `mail.iamdevloper.name`           | Mail server host                                |
| `EMAIL_TRANSPORT_PORT`           | `587`             | `25`                              | Port used to deliver messages                   |
| `EMAIL_TRANSPORT_AUTH_ENABLED`   | `true`            | `false`                           | Whether auth is enabled                         |
| `EMAIL_TRANSPORT_TLS_ENABLED`    | `true`            | `false`                           |                                                 |
| `EMAIL_TRANSPORT_SSL_ENABLED`    | `true`            | `false`                           |                                                 |
| `EMAIL_TRANSPORT_AUTH_USERNAME`  |                   | `jgraham`                         | Username to log in                              |
| `EMAIL_TRANSPORT_AUTH_PASSWORD`  |                   | `pentexplorer`                    | Password to use                                 |
| `EMAIL_TRANSPORT_SUBJECT_PREFIX` | `[graylog]`       | `[Houston, we can haz a problem]` | Prefix to every email launched from Graylog     |
| `EMAIL_TRANSPORT_SENDER`         |                   | `graylog@iamdevloper.name`        | Who's sending those bulk emails?                |

Please note that `MONGODB_URI` and `ELASTICSEARCH_HOSTS` (and, depending on 
setup, `ELASTICSEARCH_CLUSTER_NAME`) are ***required*** to be set for server to
operate.

Please also note that you may require to expose more ports than are exposed now
to allow network inputs.

## Usage

```
docker run -p 80:80 -e ELASTICSEARCH_HOSTS=172.17.0.1:9200 \
    -e MONGODB_URI=mongodb://172.17.0.2:27017/test etki/graylog-server
```

Nobody forbids container linking, of course.

## How does it work?

I simply `sed` out configuration variables in configuration file in startup
script.

## TODOs

* More JVM options

  [graylog]: https://www.graylog.org