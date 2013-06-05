#!/bin/bash

declare -a spinStyle
function makeBanner {
  strOrig=$1
  strLen=${#1}
  for ((x=0; x < strLen; x++)) ; do
    str1=''
    str2=$1
    for ((y=strLen - x; y > 0; y--)); do str1="$str1"' '; done
    for ((y=x; y < strLen; y++)); do str2=${str2%?}; done
    spinStyle[${#spinStyle[*]}]="${str1}${str2}"
  done
  for ((x=0; x < strLen; x++)) ; do
    str1=''
    str2=$1
    for ((y=0; y < x; y++)); do str1="$str1"' '; done
    for ((y=x; y > 0; y--)); do str2=${str2#?}; done
    spinStyle[${#spinStyle[*]}]="${str2}${str1}"
  done
}

function spin {
  if [ "$1" == 'clear' ] ; then 
    spinDex=$spinState
    [ $((spinDex--)) -eq 0 ] && spinDex=$((${#spinStyle[@]} - 1))
    for ((x=1; x <= ${#spinStyle[$spinDex]}; x++)); do echo -ne '\b \b'; done
    unset spinState
    return
  fi
  if [ -z "$spinState" -o "$1" == 'init' ] ; then spinState=0 
  else 
    spinDex=$spinState
    [ $((spinDex--)) -eq 0 ] && spinDex=$((${#spinStyle[@]} - 1))
    for ((x=1; x <= ${#spinStyle[$spinDex]}; x++)); do echo -ne '\b \b'; done
  fi
  echo -ne "${spinStyle[$((spinState++))]}"
  [ $spinState -ge ${#spinStyle[@]} ] && spinState=0
  sleep .15
}

