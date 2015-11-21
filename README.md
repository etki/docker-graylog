# Graylog Docker images collection

Hi there. This repository contains unofficial [graylog][graylog] Docker images
that can be used in various deployments.

## Graylog? What's that?

Graylog 2 is a beautiful java-based tool for collecting and searching
application logs (and even more).
In short, if you've ever scratched your head trying to recall that *Tr0ub4dor&3*
password for that old server on the other side of continent just to read what
application has written into `/var/log/` before it has died - Graylog is just
what you need.
  
## So how do I operate?

Graylog has been split into [server][hub-server] and
[web-interface][hub-web-interface] Docker images to stay within
single-container-single-process philosophy.
Be aware that you'll need MongoDB and Elasticsearch to run the server component.

After you've run and connected both images (passing the server's host to
web-interface container via environment variable), you're all set and ready to
experiment, just be aware that you may need to forward more ports than already
`expose`'d for additional inputs (not if you're playing with AMQP broker).

Backing GitHub repository contains both images, so documentation for each
component may be read over there ([server][server-readme],
[web-interface][web-interface-readme]). The documentation for Graylog is hosted
[by Graylog itself][graylog-documentation];

Oh, by the way, there's single-node docker-compose file included in
[repository][repository] for those who wanna play (even though server container
coughs on mongo dying faster than it).

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
