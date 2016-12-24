#!/bin/sh
## Vars: APP_DIR, DATA_DIR, JAVA_XMX, JETTY_PORT, INSTALL_DEMO
echo "Starting XWIKI-DOCKER ..."
echo "|"
if [ ! -z "${XWIKI_VERSION}" ] ; then
echo "|    VERSION: ${XWIKI_VERSION}" ; fi
echo "|    APP_DIR: ${APP_DIR}"
echo "|   DATA_DIR: ${DATA_DIR}"
echo "|   JAVA_XMX: ${JAVA_XMX}"
echo "| JETTY_PORT: ${JETTY_PORT}"
echo "|"

mkdir -p "${DATA_DIR}"

if [ -z "$(ls ${DATA_DIR}/)" -a ${INSTALL_DEMO} -gt 0 ] ; then
  echo "XWIKI-DOCKER: Empty data directory detected..."
  echo "* Demo configuration will be installed:"
  echo "*   Username: Admin   Password: admin"
  echo "* Press Ctrl-C to cancel"
  sleep 10
  cp -Ra ${APP_DIR}/data/* ${DATA_DIR}/ >/dev/null
  rm -f ${DATA_DIR}/jobs/status/distribution/status.xml >/dev/null
  echo "DONE."
fi

# Ensure required directories exist.
for X in logs jetty ; do
  mkdir -p $DATA_DIR/$X ; done
for X in lib/ext logs resources webapps ; do
  mkdir -p $DATA_DIR/jetty/$X ; done

# Change default cookie encryption keys.
CONFIG_FILE="${APP_DIR}/webapps/xwiki/WEB-INF/xwiki.cfg"
gen_key () {
  < /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-32}
}

if [ ! -z "$(mount | grep xwiki.cfg)" ] ; then
  echo "XWIKI-DOCKER: xwiki.cfg mounted externally"
else
  sed -i.bak "s/totototototototototototototototo/$(gen_key)/" ${CONFIG_FILE}
  sed -i.bak "s/titititititititititititititititi/$(gen_key)/" ${CONFIG_FILE}
  if [ "${FS_ATTACHMENTS}" == "1" ] ; then
    echo "XWIKI-DOCKER: Configured for filesystem attachments"
    echo "xwiki.store.attachment.hint = file" >> ${CONFIG_FILE}
    echo "xwiki.store.attachment.versioning.hint = file" >> ${CONFIG_FILE}
    echo "xwiki.store.attachment.recyclebin.hint = file" >> ${CONFIG_FILE}
    echo "xwiki.store.attachment.versioning=0" >> ${CONFIG_FILE}
    echo "storage.attachment.recyclebin=0" >> ${CONFIG_FILE}
  fi
fi

# MAIN
exec java \
  -Xmx${JAVA_XMX} \
  -Dxwiki.data.dir=${DATA_DIR} \
  -Djetty.home=${APP_DIR}/jetty \
  -Djetty.base=${DATA_DIR}/jetty \
  -Dfile.encoding=UTF8 \
  -Djetty.port=${JETTY_PORT} \
  -jar jetty/start.jar \
  --module=xwiki \
  jetty.port=${JETTY_PORT} \
  STOP.KEY=xwiki STOP.PORT=8079
