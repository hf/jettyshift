#!/bin/sh

JAVA="/usr/lib/jvm/java-1.7.0/bin/java"
LOG=$OPENSHIFT_DIY_LOG_DIR/server.log

echo
echo "START"
echo "====="
echo

cd ${OPENSHIFT_DATA_DIR}jetty

if [ -L webapps ]; then
  rm webapps
else
  rm -rf webapps
fi

ln -s ${OPENSHIFT_REPO_DIR}deployments webapps

CMD="$JAVA -jar start.jar -Djetty.host=$OPENSHIFT_DIY_IP -Djetty.port=$OPENSHIFT_DIY_PORT"

echo
echo "Starting Jetty, see log at $LOG"
echo $CMD
echo

nohup $CMD > $LOG 2>&1 &

echo $! > jetty.pid
