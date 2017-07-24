# XWiki [v9.6] Standalone – Docker Image

**[The Advanced Open Source Enterprise Wiki](http://www.xwiki.org/xwiki/bin/view/Main/WebHome)**

[![Latestver](https://lv.binarybabel.org/catalog-api/xwiki/stable.svg?v=9.6)](https://github.com/binarybabel/docker-xwiki/releases)

This image is rebuilt automatically when new versions of XWiki are released, through the use of webhooks provided by the [Latestver](https://lv.binarybabel.org) dependency tracking tool, a [BinaryBabel OSS Project](https://github.com/binarybabel/latestver#readme).

**Pulling a specific tag of this image is recommended**, which will ensure you are not unexpectedly updated to a newer version of XWiki. Check the [Docker Tags](https://hub.docker.com/r/binarybabel/xwiki/tags/) or [Github Releases](https://github.com/binarybabel/docker-xwiki/releases) for available versions.

## Recommended Audience

This image is aimed at small-scale deployments, perfect for teams or private usage. It uses the **standalone** edition of XWiki and an embedded HSQLDB database saved to the connected data volume. [See the XWiki documentation for other deployment options.](http://platform.xwiki.org/xwiki/bin/view/AdminGuide/Installation)

## Usage

By default the application will be available from `http://localhost:8080`

**Running Directly**

```
# docker run -p 8080:8080 -v $(pwd):/xwiki-data binarybabel/xwiki:v9.6
```

**Using** `docker-compose.yml`

```
version: '2'
services:
  app:
    image: binarybabel/xwiki:v9.6
    volumes:
      - .:/xwiki-data
    ports:
      - "8080:8080"

```

```
# docker-compose up
```

## Configuration

Environmental Variables

* __FS\_ATTACHMENTS__
  * default: '1' (YES) - store attachments as files in data volume (instead of database)
* __INSTALL\_DEMO__
  * default: '0' (NO) - install demo user and content
* __JAVA\_XMX__
  * default: '1024m' - amount of memory to allocate to Java

Volumes

* __/xwiki-data__
  * XWiki database, attachments, logs, extensions, etc.

### Security

Encryption keys for login cookies are generated automatically on container startup. User browser sessions will expire when a container is updated or otherwise recreated.
