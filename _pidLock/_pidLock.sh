#
# reusable PID file locking routine --robzr 7/29/13
#
# Notes:
# - default lock file will search for a writeable directory (/var/run; /tmp).  If different users run this, it could
#   result in different lock files.  If this is expected, use -f to specify a lock file name manually.
#

_pidLock () {
  local _pidLock_action _pidLock_PidToCheck
  OPTIND=0
  while getopts :crlf:h opt ; do
    case "$opt" in
      h|\?) 
        echo "Syntax: _pidLock [-f lockfilename] [-c|-r|-l]"
        echo "        -f  overrides lockfile name (persistent)"
        echo "        -c  checks lockfile only"
        echo "        -r  removes existing lockfile"    
        echo "        -l  checks & locks the lockfile (default action)"
        echo "        returns 0 if there is no lock; 1 for existing lock, 255 for error"
        return 255
        ;;
      c) _pidLock_action='c' ;;
      r) _pidLock_action='r' ;;
      l) _pidLock_action='l' ;;
      f) [ -z "$_pidLock_action" ] && _pidLock_action='l'
        _pidLock_PID_FILE="$OPTARG" 
        ;;
    esac
  done

  # default PID file based on program name
  if [ -d /var/run -a -w /var/run ] ; then
    _pidLock_PID_FILE=${_pidLock_PID_FILE-"/var/run/${0##*/}.pid"}
  else
    _pidLock_PID_FILE=${_pidLock_PID_FILE-"/tmp/${0##*/}.pid"}
  fi

  if [ "$_pidLock_action" == "r" ] ; then
    [ -a "$_pidLock_PID_FILE" ] || return 0
    rm -f "$_pidLock_PID_FILE" ; return $?
  fi

  unset _pidLock_PidToCheck
  if [ -a "$_pidLock_PID_FILE" ] ; then
    [ ! -r "$_pidLock_PID_FILE" ] && return 255
    _pidLock_PidToCheck=`tail -1 "$_pidLock_PID_FILE"`
    [[ "$_pidLock_PidToCheck" =~ ^[0-9][0-9]*$ ]] && ps -o comm= -p "$_pidLock_PidToCheck" &>/dev/null && return 1
    [[ "$_pidLock_action" =~ ^[xl]$ ]] && ! ( echo $$ > "$_pidLock_PID_FILE" ) &> /dev/null && return 255
    return 0
  else
    [ "$_pidLock_action" == "c" ] && return 0
    ( echo $$ > "$_pidLock_PID_FILE" ) &> /dev/null && return 0 || return 255
  fi
}
