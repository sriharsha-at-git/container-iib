#!/bin/bash

if [ -z "$MQSI_VERSION" ]; then
  echo "Sourcing profile"
  source /opt/ibm/iib-10.0.0.6/server/bin/mqsiprofile
fi
