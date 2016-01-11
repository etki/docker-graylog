# Graylog server docker image

This repository contains docker image for [Graylog][graylog] server component.

## Configuration

Graylog provides neat, 12-factorish way to configure application via
environment variables, and [every configuration option][docs-configuration] may
be overriden by environmental variable with same name and `GRAYLOG2_` prefix, so
`elasticsearch_shards` can be overriden by `GRAYLOG2_ELASTICSEARCH_SHARDS`
environment variable. The most important configuration options are listed in
following table:

| Option                                           | Default value                  | Note |
|--------------------------------------------------|--------------------------------|-|
| `is_master`                                      | `true`                         | Whether this is node or master and is capable of processing cluster-wide tasks (it is implied that only one node in cluster may be master) |
| `root_username`                                  | `admin`                        | Default user login |
| `root_password_sha2`                             |                                | SHA-2 hash of password for default user. Calculated automatically (see *environment variables*) |
| `root_email`                                     |                                | Default user email |
| `root_timezone`                                  | `UTC`                          ||
| `rest_enable_cors`                               | `false`                        | Whether to enable Cross-Origin Resource Sharing |
| `rest_enable_gzip`                               | `false`                        | Whether to enable gzip compression |
| `plugin_dir`                                     | `plugin`                       | Directory to store plugins, if you'll need any, most probably you're going to specify this dir as a persistent volume |
| `elasticsearch_discovery_zen_ping_unicast_hosts` |                                | List of hosts to check for Elasticsearch instances, please see `$GRAYLOG2_ELASTICSEARCH_HOSTS` lower ||
| `mongodb_uri`                                    | `mongodb://localhost/graylog`  ||
| `transport_email_enabled`                        | `false`                        ||
| `transport_email_hostname`                       |                                ||
| `transport_email_port`                           | `25`                           ||
| `transport_email_use_auth`                       | `false`                        ||
| `transport_email_use_tls`                        | `false`                        ||
| `transport_email_use_ssl`                        | `true`                         ||
| `transport_email_auth_username`                  |                                ||
| `transport_email_auth_password`                  |                                ||

In addition, this particular image provides extra environment variables:

| Variable                         | Default value     | Example                           | Note                                            |
|----------------------------------|-------------------|-----------------------------------|-------------------------------------------------|
| `GRAYLOG2_ROOT_PASSWORD`         | `bruteful`        | `mah-super-passwrd`               | Admin password. Won't have any effect if `GRAYLOG2_ROOT_PASSWORD_SHA2` is set |
| `GRAYLOG2_PASSWORD_SECRET`       | openssl-generated | `aaaabbbbcccdddd`...              | Secret crypto value with length of at least 64 characters. **Has to be the same value on all nodes** |
| `GRAYLOG2_JVM_HEAP_SIZE`         | `1g`              | `2g`                              | Amount of RAM dedicated for Java heap           |
| `GRAYLOG2_ELASTICSEARCH_HOSTS`   |                   | `127.0.0.1:9300,192.168.0.1:9300` | A shortcut for `elasticsearch_discovery_zen_ping_unicast_hosts` configuration option |

Please note that `GRAYLOG2_MONGODB_URI` and `GRAYLOG2_ELASTICSEARCH_HOSTS` are
***required*** to be set for server to operate (however, most probably you'll
need to tune `GRAYLOG2_ELASTICSEARCH_CLUSTER_NAME` and other settings as well).

Please also note that you may require to expose more ports than are exposed now
to allow network inputs.

## Usage

```
docker run -p 80:80 -e GRAYLOG2_ELASTICSEARCH_HOSTS=172.17.0.1:9200 \
    -e GRAYLOG2_MONGODB_URI=mongodb://172.17.0.2:27017/test etki/graylog-server
```

Nobody forbids container linking, of course.

## TODOs

* More JVM options
* Plugin directory creation
* Plugin usage in detail
* Is it really necessary to expose port 9350?

  [graylog]: https://www.graylog.org
  [docs-configuration]: http://docs.graylog.org/en/1.3/pages/installation/manual_setup.html#configuration
  [configuration-source]: https://github.com/Graylog2/graylog2-server/blob/master/misc/graylog2.conf