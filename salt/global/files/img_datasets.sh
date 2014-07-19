#!/bin/bash
#
echo "Working hard...to makesure that datasets.at has been added."

# writing the state line
imgadm sources -a http://datasets.at/
imgadm sources -d https://images.joyent.com
imgadm update

echo "Done."