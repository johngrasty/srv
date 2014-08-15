#!/usr/bin/bash

/usr/sbin/svccfg import /opt/local/share/icecast/manifest.xml
/usr/sbin/svcadm refresh icecast
