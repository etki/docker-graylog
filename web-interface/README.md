# Graylog 2 server docker image

This repository contains docker image for [Graylog][graylog] 2 web interface
component.

## Configuration

Containers are configured in regular way, via environment variables:

| Variable                 | Default value   | Example                               | Note                                                      |
|--------------------------|-----------------|---------------------------------------|-----------------------------------------------------------|
| `GRAYLOG2_SERVER_URI`    |                 | `http://172.17.0.1,http://172.17.0.2` | Comma-separated list of graylog server URIs to connect to | 
| `GRAYLOG2_JVM_HEAP_SIZE` | `1g`            | `2g`                                  | Amount of memory dedicated for Java heap                  |
| `GRAYLOG2_TIMEZONE`      | `UTC`           | `Europe/Moscow`                       | Timezone server is located in                             |

Please note that `GRAYLOG2_SERVER_URI` is ***required*** to be set for server to
operate.

## Usage

```
docker run -p 80:80 -e GRAYLOG_SERVER_URI=http://172.17.0.1:8080 \
    etki/graylog-web-interface
```

Nobody forbids container linking, of course.

## TODOs

* More JVM options

  [graylog]: https://www.graylog.org