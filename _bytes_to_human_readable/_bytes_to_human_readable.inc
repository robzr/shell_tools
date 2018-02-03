# Arg1 = bytes (integer) to convert to human readable
#
_bytes_to_human_readable() { 
  if [ `echo $1 / 1024^5 | bc` -ge 1  ] ; then
    printf '%.1f PB' `echo $1 / 1024^5 | bc -l`
  elif [ `echo $1 / 1024^4 | bc` -ge 1  ] ; then
    printf '%.1f TB' `echo $1 / 1024^4 | bc -l`
  elif [ `echo $1 / 1024^3 | bc` -ge 1  ] ; then
    printf '%.1f GB' `echo $1 / 1024^3 | bc -l`
  elif [ `echo $1 / 1024^2 | bc` -ge 1  ] ; then
    printf '%.1f MB' `echo $1 / 1024^2 | bc -l`
  elif [ `echo $1 / 1024 | bc` -ge 1  ] ; then
    printf '%.1f KB' `echo $1 / 1024 | bc -l`
  else
    printf '%s Bytes' $1
  fi
}
