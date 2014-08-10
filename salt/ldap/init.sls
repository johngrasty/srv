#List of what to do:
#1. pkgs: openldap, git

# cd /opt/
# git clone https://github.com/benr/ldap_kit.git

# Make CA
# cd ldap_kit/easy-rsa
# vim vars
# source vars
# ./clean-all
# ./build_ca
# ./build-key-server <server-name>
# cd .. && vim Makefile.config
# cd pki && make-certdb.sh
#Make sure to change all the dirs from /etc to /opt/local/etc
# make install in DirectoryBuilder