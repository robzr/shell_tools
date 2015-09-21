# _spin library - displays simple ascii moving banners or single character animations for status output
#                                                                                  --robzr 2013
#
# Usage: include this file in a bash script like:
#
# . _spin.inc
#
# Then either run _spinMakeBanner "argument", which will construct the _spinStyle array, or manually create 
# the _spinStyle array for more control.  The array format is each element is a single display unit:
#
# _spinMakeBanner "Please wait"
#   -or-
# declare -a spinStyle=('  ' ' .' '.o' 'oO' 'Oo' 'o.' '. ')
#
# With the manual declaration above, each animation frame will be two characters long.  Each animation would 
# be accomplished with a a single call to _spin, with the argument "clear" being called at the end to clean 
# up any residual text.  Here's an example 2 second routine:
#
# echo -n Example...
# for((x=0; x<20; x++)); do _spin .1; done
# _spin clear
# echo

declare -a _spinStyle

# Usage: _spinMakeBanner "argument"
#
function _spinMakeBanner {
  local x y str1 str2 strOrig strLen
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

# Usage: _spin [clear|init] [##]
#
#  init - optionally used to restart a spin sequence
#  clear - optionally used when ready to complete a spin sequence to clear
#  ### - optional number of seconds to add to each spin cycle, in order
#        to adjust the animation speed, or compensate for tasks being done
#        mid cycle.  Default is .15 (150 ms), floating numbers are OK.
#
function _spin {
  local spinDex x
  if [ "$1" == 'clear' ] ; then 
    shift
    spinDex=$spinState
    [ $((spinDex--)) -eq 0 ] && spinDex=$((${#spinStyle[@]} - 1))
    for ((x=1; x <= ${#spinStyle[$spinDex]}; x++)); do echo -ne '\b \b'; done
    unset spinState
    return
  fi
  if [ -z "$spinState" -o "$1" == 'init' ] ; then 
    shift
    spinState=0 
  else 
    spinDex=$spinState
    [ $((spinDex--)) -eq 0 ] && spinDex=$((${#spinStyle[@]} - 1))
    for ((x=1; x <= ${#spinStyle[$spinDex]}; x++)); do echo -ne '\b \b'; done
  fi
  echo -ne "${spinStyle[$((spinState++))]}"
  [ $spinState -ge ${#spinStyle[@]} ] && spinState=0
  if [ -n "$1" ] ; then
    sleep "$1"
  else 
    sleep .15
  fi
}

