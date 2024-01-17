#!/bin/sh

if [ ${PIP_PACKAGES:+x} ]; then
    echo "-- INSTALLING PIP PACKAGES $PIP_PACKAGES --"
    python3 -m pip install --no-cache --upgrade --break-system-packages $PIP_PACKAGES
fi

exec "$@"
