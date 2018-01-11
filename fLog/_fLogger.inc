include _fLog.inc
fLogger () { 
 case $fLoggerFacility in
   stdout) fLog $@ ;;
   stderr) fLog $@ >/dev/stderr ;;
   default) fLog $@ | logger -t ${fLogFacility:-fLogger[$$]} ;;
 esac
}
