### Graylog Docker images collection

Hi there. This repository contains unofficial [Graylog][graylog] Docker images
that can be used in various deployments.

#### Graylog? What's that?

Graylog is a beautiful java-based tool for collecting and searching
application logs (and even more).
In short, if you've ever scratched your head trying to recall that *Tr0ub4dor&3*
password for that old server on the other side of continent just to read what
application has written into `/var/log/` before it has died - Graylog is just
what you need.  
Graylog is an application that lets you collect logs from your code in various
ways - syslog, HTTP requests, AMQP messages - and then organize them, search
them, stream them and even send alert whenever user-set thresholds are hit.
  
#### So how do I operate?

Graylog has been split into [server][hub-server] and
[web-interface][hub-web-interface] Docker images to stay within
single-container-single-process philosophy.  
The server component contains main Graylog functionality - it is the part that
accepts incoming logs, manages streams and sends alerts. The web-interface
component contains neat Web UI that lets you manage Graylog in
human-understandable HTML way.
Server component requires MongoDB and ElasticSearch cluster (that cluster may
consist of single node, don't be afraid) to operate.

After you've run and connected both images (passing the server's host to
web-interface container via environment variable), you're all set and ready to
experiment, just be aware that you may need to forward more ports than already
`expose`'d for additional inputs (not if you're playing with AMQP broker).

Backing GitHub repository contains both images, so documentation for each
component may be read over there ([server][server-readme],
[web-interface][web-interface-readme]). The documentation for Graylog is hosted
[by Graylog itself][graylog-documentation].

By the way, there's single-node docker-compose file included in
[repository][repository] for those who want to just press-and-play (even though
server container coughs on mongo dying faster than it).

## Links

* [etki/graylog-server][hub-server] / Docker Hub // [Documentation][server-readme] / GitHub
* [etki/graylog-web-interface][hub-web-interface] / Docker Hub // [Documentation][web-interface-readme] / GitHub

  [graylog]: https://www.graylog.org
  [graylog-documentation]: https://docs.graylog.org
  [hub-server]: https://hub.docker.com/r/etki/graylog-server/
  [hub-web-interface]: https://hub.docker.com/r/etki/graylog-web-interface/
  [server-readme]: https://github.com/etki/docker-graylog/blob/master/server/README.md
  [web-interface-readme]: https://github.com/etki/docker-graylog/blob/master/web-interface/README.md
  [repository]: https://github.com/etki/docker-graylog
