#!/bin/bash

bashrc_d_colors_sh=1

# Foreground Colors
fgBlack=$'\e[0;30m'
fgGray=$'\e[1;30m'
fgLtGray=$'\e[0;37m'
fgBlue=$'\e[0;34m'
fgLtBlue=$'\e[1;34m'
fgGreen=$'\e[0;32m'
fgLtGreen=$'\e[1;32m'
fgCyan=$'\e[0;36m'
fgLtCyan=$'\e[1;36m'
fgRed=$'\e[0;31m'
fgLtRed=$'\e[1;31m'
fgPurple=$'\e[0;35m'
fgLtPurple=$'\e[1;35m'
fgBrown=$'\e[0;33m'
fgYellow=$'\e[1;33m'
fgWhite=$'\e[1;37m'

# Background colors
bgBlack=$'\e[40m'
bgBlue=$'\e[44m'
bgGreen=$'\e[42m'
bgCyan=$'\e[46m'
bgRed=$'\e[41m'
bgPurple=$'\e[45m'
bgBrown=$'\e[43m'
bgWhite=$'\e[47m'

# Reset colors
clrReset=$'\e[0m'

# Attributes
#attrBlink=$'\e[1m'
#attrUL=$'\e[2m'

if [ "$0" != "-bash" -a "$0" != "/bin/bash" -a "$0" != "bash" ] ; then
 for BG in Black Blue Green Cyan Red Purple Brown White ; do
  printf " bg%-6s " $BG
 done
 echo
 for FG in Black Gray LtGray Blue LtBlue Green LtGreen Cyan LtCyan Red LtRed Purple LtPurple Brown Yellow White ; do
  eval FGc=\$fg$FG
   for BG in Black Blue Green Cyan Red Purple Brown White ; do
    eval BGc=\$bg$BG
    printf " $FGc$BGc%-8s$clrReset " $FG
   done
   echo
 done
 echo
 echo To run, include this in your .bashrc with optional arguments:
 echo . /path/to/colors.sh [fg_color [bg_color]]
 echo
 echo Color names must begin with a cap.  Example:
 echo . colors.sh Red Blue \; echo Test
 echo
else
  if [ "$1" != "" ] ; then
    eval FGc=\$fg$1
    echo -n $FGc
  fi
  if [ "$2" != "" ] ; then
    eval BGc=\$bg$2
    echo -n $BGc
  fi
fi
