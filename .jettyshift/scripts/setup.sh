#!/bin/sh

JETTY_MAJOR="9"
JETTY_VERSION="9.0.5.v20130815"

JETTYSHIFT_DIR=$OPENSHIFT_REPO_DIR/.jettyshift/

echo
echo "SETUP"
echo "====="
echo

cd $OPENSHIFT_DATA_DIR

if [ -d "jetty" ] && [ "`cat jetty/VERSION`" == $JETTY_VERSION ]; then
  echo "Jetty $JETTY_VERSION already installed."
else
  echo "Jettyshift's directory is: $JETTYSHIFT_DIR"

  echo
  echo "Installing Jetty $JETTY_VERSION"

  if [ -d "jetty" ]; then
    rm -rf jetty
  fi

  DOWNLOAD="http://download.eclipse.org/jetty/stable-${JETTY_MAJOR}/dist/jetty-distribution-${JETTY_VERSION}.tar.gz"

  echo
  echo "Downloading Jetty $JETTY_VERSION from $DOWNLOAD ..."
  echo

  curl -f -o jetty.tar.gz $DOWNLOAD

  DOWNLOAD_SUCCESS=$?

  if [ $DOWNLOAD_SUCCESS -gt 0 ]; then
    echo
    echo "Jetty could not be downloaded from the location $DOWNLOAD."
    echo "Please check the \$JETTY_MAJOR ($JETTY_MAJOR) and \$JETTY_VERSION ($JETTY_VERSION) variables in .jettyshift/config/setup.sh"
    exit 1
  fi

  if ! ( tar -xf jetty.tar.gz ); then
    echo
    echo "Cannot extract Jetty distribution. Please check the start script and whether the link to download Jetty is live."
    exit 1
  fi

  rm jetty.tar.gz

  mv "jetty-distribution-$JETTY_VERSION" jetty

  echo $JETTY_VERSION > jetty/VERSION

  cd jetty

  # JETTY CONFIGURATION

  rm -rf contexts/*

  rm -rf webapps
  rm -rf webapps.demo

  rm -rf start.ini
  rm -rf start.d

  cp -r $JETTYSHIFT_DIR/config/* .

  echo
  echo 'Jetty configuration is updated.'
  echo "See: $OPENSHIFT_DATA_DIR/jetty/start.ini"
  echo
fi

cd $OPENSHIFT_DATA_DIR

if ! [ -f "maven.xml" ]; then
  cp $JETTYSHIFT_DIR/maven.xml .
fi