#!/bin/bash
#
# Arg1 = network (in cidr or ip/netmask)
# Arg2 = IP to compare/test [optional]

[ -z "$1" ] && { 
  cat <<-_EOF_
	Usage: $0 network [ip]
	  network is in CIDR or old-school network/sub.n.e.t format
	  if ip is supplied, it will be compared to the network
	_EOF_
  exit -1
}

. _ip_tools.inc

echo Detected input type: `_ipt_type "$1"`

binstring=`_ipt_IPToBinstring $1`

echo Converted to binstring: $binstring

echo Converted binstring back to IP: `_ipt_binstringToIP $binstring`

netmask=`_ipt_getNM $1`
echo Extracting netmask: $netmask

net_binstring_netmask_applied=`_ipt_binstringApplyNM $binstring $netmask`
echo Network binstring with netmask applied: $net_binstring_netmask_applied

if [ -n "$2" ] ; then
  echo -n "Is IP ($2) in net $1: "
  _ipt_isInNet "$1" "$2"  && echo Yes || echo No
fi
