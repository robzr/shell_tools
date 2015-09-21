function _bytesToHumanReadable { 
  # Arg1 = bytes (integer) to convert to human readable
  # Arg2 (optional) = variable to return human readable form in
  # If Arg2 is not specified, it will use bytesToHumanReadableResult
  # Example: bytesToHumanReadable 10240 humanReadableVariable
  # -or-     bytesToHumanReadable 10240 
  bTHRv=${2-bytesToHumanReadableResult}

  if [ `echo $1 / 1024^5 | bc` -ge 1  ] ; then
    printf -v $bTHRv "%.1f PiB" `echo $1 / 1024^5 | bc -l`
  elif [ `echo $1 / 1024^4 | bc` -ge 1  ] ; then
    printf -v $bTHRv "%.1f TiB" `echo $1 / 1024^4 | bc -l`
  elif [ `echo $1 / 1024^3 | bc` -ge 1  ] ; then
    printf -v $bTHRv "%.1f GiB" `echo $1 / 1024^3 | bc -l`
  elif [ `echo $1 / 1024^2 | bc` -ge 1  ] ; then
    printf -v $bTHRv "%.1f MiB" `echo $1 / 1024^2 | bc -l`
  elif [ `echo $1 / 1024 | bc` -ge 1  ] ; then
    printf -v $bTHRv "%.1f KiB" `echo $1 / 1024 | bc -l`
  else
    printf -v $bTHRv "%s Bytes" $1
  fi
}
