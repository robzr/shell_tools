# _searchPath - searches an optionally provided path for a command, returns pathed result --robzr
#
# Example: 
# 
# . _searchPath.inc
# _searchPath cutx /bin:/usr/bin:/usr/sbin:/usr/local/sbin
# cutCMD=`_searchPath cut /bin:/usr/bin`
# echo cutCMD: $cutCMD

function _searchPath {
  # Usage: programCmd=`_searchPath program [path1[:path2...]]`
  local cmd="$1" pathToSearch="$2" IFS=: foundCmd path
  [ -z "$pathToSearch" ] && pathToSearch="$PATH"
  for path in $pathToSearch ; do 
    [ -x "$path/$cmd" ] && foundCmd="$path/$cmd" && break ; done
  echo "$foundCmd"
}
