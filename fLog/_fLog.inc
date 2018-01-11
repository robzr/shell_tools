fLog () {
  [ "$1" = -l ] && { case $2 in standard)fLL=1;;verbose)fLL=2;;debug)fLL=3;;*)fLL=$2;esac
   [ $fLL -gt ${fLogLevel:-999} ]&&return;shift 2;}
  if [ -p /dev/stdin ];then sed "s/^/${fLogPrefix}$@${fLogDelim:- -> }/";
  else echo "${fLogPrefix}$@";fi
}
fLogger () { fLog $@ | logger ; }
