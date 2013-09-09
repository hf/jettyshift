#!/bin/bash

# Ensure the previous startup succeeded and this actually exists.
if [ -d "${OPENSHIFT_DATA_DIR}jetty" ]; then
    cd ${OPENSHIFT_DATA_DIR}jetty

    # Ensure the process is actually running.
    if ps -p `cat jetty.pid` > /dev/null
    then
       kill `cat jetty.pid`
    fi
fi


