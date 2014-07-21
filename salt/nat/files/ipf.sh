#!/bin/bash
#
echo "Working hard...to update the IPF tables through svcs"

# writing the state line

svccfg -s ipfilter:default setprop firewall_config_default/policy = astring: "custom"
svccfg -s network/ipfilter:default setprop firewall_config_default/custom_policy_file = astring: "/etc/ipf/ipf.conf"
svcadm refresh ipfilter:default

echo  # an empty line here so the next line will be the last.
echo "Fixed the firewall" 
 
 
