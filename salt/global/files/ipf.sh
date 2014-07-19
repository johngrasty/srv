#!/bin/bash
#
echo "Working hard...to update the IPF tables through svcs"

# writing the state line

svccfg -s ipfilter:default setprop firewall_config_default/policy = astring: "custom"

svccfg -s ipfilter:default setprop firewall_config_default/custom_policy_file = astring: "/opt/salt/srv/salt/global/files/ipf.conf"

svcadm refresh ipfilter:default

echo  # an empty line here so the next line will be the last.
echo "changed=yes comment='something has changed' whatever=123"