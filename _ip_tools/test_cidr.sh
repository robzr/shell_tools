#!/bin/bash
#
# Arg1 = network (in cidr or ip/netmask)
# Arg2 = IP to compare/test [optional]

. _ip_tools.inc

binstring=`_ipt_IPToBinstring $1`
echo binstring: $binstring
_ipt_type $binstring
echo back to IP: `_ipt_binstringToIP $binstring`

echo Input type: `_ipt_type "$1"`
echo Network netmask: `_ipt_getNM $1`
echo Network binstring: `_ipt_IPToBinstring $1`
##echo Network binstring with netmask applied: $net_binstring_netmask_applied
##net_binstring_netmask_applied=`_ipt_binstringApplyNM $net_binstring $net_netmask`

if [ -n "$2" ] ; then
  echo 'IP binstring: '`_ipt_IPToBinstring $2`
  echo -n "IP ($2) in net $1: "
  _ipt_isInNet $2 $1 && echo Yes || echo No
fi

