FROM binarybabel/oracle-jdk:8-alpine

#    ____  ____  ____      ____  _   __        _
#   |_  _||_  _||_  _|    |_  _|(_) [  |  _   (_)
#     \ \  / /    \ \  /\  / /  __   | | / ]  __
#      > `' <      \ \/  \/ /  [  |  | '' <  [  |
#    _/ /'`\ \_     \  /\  /    | |  | |`\ \  | |
#   |____||____|     \/  \/    [___][__|  \_][___]

ENV APP_DIR=/xwiki DATA_DIR=/xwiki-data \
    JAVA_XMX=1024m JETTY_PORT=8080 \
    INSTALL_DEMO=0 FS_ATTACHMENTS=1
WORKDIR ${APP_DIR}
VOLUME ${DATA_DIR}
EXPOSE 8080

#COPY xwiki.zip /xwiki.zip
ENV XWIKI_VERSION=10.6
RUN cd / \
    && XWIKI_DOWNLOAD="http://download.forge.ow2.org/xwiki/xwiki-${XWIKI_VERSION:-$(curl -s https://lv.binarybabel.org/catalog-api/xwiki/stable.txt?p=version)}.zip" \
    && echo Downloading ${XWIKI_DOWNLOAD} \
    && curl -fsSLo xwiki.zip "${XWIKI_DOWNLOAD}" \
    && unzip xwiki.zip \
    && rm xwiki.zip \
    && rmdir xwiki \
    && ln -s xwiki-platform-* ./xwiki

COPY docker-entrypoint.sh ${APP_DIR}
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD []

# ------------------------------------------------------
# Accept the Oracle License for all users of this image,
# per Section C of the BCLA, permitting Oracle Java:
#   "(i) ... bundled as part of, and for the
#    sole purpose of running, your Programs"
# ------------------------------------------------------
ENV ACCEPT_ORACLE_BCLA=true
