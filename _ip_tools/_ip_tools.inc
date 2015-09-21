#
# IP Tools - bash IP / subnet manipulation and CIDR conversion functions
#
# Depends on: egrep, sed, bc
#
# rob@zwissler.org - 8/19/15

# _ipt_isInNet - Determines if an IP is in a subnet
#
# Args: $1 = CIDR, IP, IP/netmask   $2 = IP to test
# Returns: return code - true if the IP is in the network, false otherwise
#
_ipt_isInNet () {
  local net_ip=`_ipt_IPToBinstring $1`
  local net_nm=`_ipt_getNM $1`
  local net_net=`_ipt_binstringApplyNM "$net_ip" "$net_nm"`
  local ip_ip=`_ipt_IPToBinstring $2`
  local ip_net=`_ipt_binstringApplyNM "$ip_ip" "$net_nm"`
  [ "$ip_net" == "$net_net" ]
}

# _ipt_type - Inspects argument for data type and validates range
#
# Args: $1 = CIDR, IP, IP/netmask 
# Returns: string - "cidr", "ip", "ip/netmask", "netbits", "binstring", "invalid"
#
_ipt_type () {
  local x nm valid=1
  if echo "$1" | egrep -q '^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' ; then
    for x in 1 2 3 4 ; do [ "`_ipt_getOctet $1 $x`" -lt 0 -o "`_ipt_getOctet $1 $x`" -gt 255 ] && valid=0 ; done
    if [ $valid == 1 ] ; then echo ip ; else echo invalid && return $(false) ; fi
  elif echo "$1" | egrep -q '^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' ; then
    echo ip/netmask
  elif echo "$1" | egrep -q '^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/[0-9][0-9]*$' ; then
    for x in 1 2 3 4 ; do [ "`_ipt_getOctet $1 $x`" -lt 0 -o "`_ipt_getOctet $1 $x`" -gt 255 ] && valid=0 ; done
    x=`echo $1 | cut -f2 -d/`
    [ $x -lt 0 -o $x -gt 32 ] && valid=0
    if [ $valid == 1 ] ; then echo cidr ; else echo invalid && return $(false) ; fi
  elif echo "$1" | egrep -q '^[01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01][01]$' ; then
    echo binstring
  elif echo "$1" | egrep -q '^[0-9][0-9]?$' && [ $1 -ge 0 -a $1 -le 32 ] ; then
    echo netbits
  else
    echo invalid
    return $(false)
  fi
  true
}

# _ipt_getNM - Returns Netmask in bit-count format (ex: 24 for a /24)
#
# Args: $1 = CIDR, bitcount, IP/netmask, netmask
#
# Returns: string - netmask in bit count style (0 <= bit count <= 32)
#
_ipt_getNM () {
  local bitCount=-1
  case "`_ipt_type $1`" in 
    cidr) bitCount=`echo $1 | cut -f2 -d/`
      ;;
    ip/netmask) (( bitCount=`_ipt_IPToBinstring "\`echo $1 | sed 's/^.*\///'\`" | sed 's/[^1].*//' | wc -c` - 1 ))
      ;;
    ip) (( bitCount=`_ipt_IPToBinstring "$1" | sed 's/[^1].*//' | wc -c` - 1 ))
      ;;
    netbits) bitCount=`echo $1 | sed s/^\\//`
      ;;
    invalid) bitCount=-1
      ;;
  esac 
  echo $bitCount
}

### Internal functions ###

# Args:    $1 = IP address (does NOT validate)  $2 = octet (1-4)
# Returns: string - just the octet
_ipt_getOctet () { echo $1 | cut -f1 -d/ | cut -f$2 -d\. ; }

# Args:    $1 = CIDR, IP, IP/netmask
# Returns: string - binstring representation of IP
_ipt_IPToBinstring () { 
  local x 
  for x in 1 2 3 4 ; do 
    _ipt_getOctet $1 $x | xargs echo obase=2\; | bc | xargs printf '%08s' 
  done
  echo
}

# Args:    $1 = binstring
# Returns: string - IP representation of binstring
_ipt_binstringToIP () { 
  local x
  _ipt_type "$1" >/dev/null || { echo "invalid" ; return ;} 
  for x in 1 9 17 ; do echo $1 | cut -c$((x))-$((x+7)) | xargs echo ibase=2\; | bc | xargs printf "%s." ; done
  echo $1 | cut -c25-32 | xargs echo ibase=2\; | bc | xargs printf "%s\n"
}

# Args:    $1 = binstring, $2 = netmask
# Returns: string - binstring representation of network IP with netmask bitwise filtering applied
_ipt_binstringApplyNM () { 
  local nm=`_ipt_getNM $2` ;
  echo $1 | cut -c1-$nm | xargs echo -n
  [ $nm -lt 32 ] && printf \%0$((32 - nm))s 0
  echo
}
