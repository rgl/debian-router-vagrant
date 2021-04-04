#!/bin/bash
set -euxo pipefail

router_ip_address="${1:-10.100.100.254}"; shift || true

# make sure dhclient does not set the default route.
cat >>/etc/dhcp/dhclient.conf <<EOF
# make sure our default gateway is always our router.
# NB for some reason dhclient does not seem to like our router address, so this
#    will have the side-effect of not setting the default route, which will be
#    in the interfaces file.
supersede routers $router_ip_address;
EOF
ifdown eth0 && ifup eth0

# set the default route.
# NB for some reason the routers are not set by dhclient, so we have to
#    manually set the route.
cat >>/etc/network/interfaces <<EOF
# NB we cannot specify this stanza again despite what is told in the man page.
#iface eth1 inet static
    gateway $router_ip_address
EOF
ifdown eth1 && ifup eth1

# show the result.
ip route
