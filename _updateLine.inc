# Searches and updates a line in a file, for lightweight "configuration management" :)
#
# Syntax: _updateLine [-a] [-f] [-v] filename testString [searchString] replaceString
#           -a             - (optional) Add mode - append if the line does not exist (normally updates only)
#           -f             - (optional) Force - create file if it doesn't exist (if append mode is used)
#           -v             - (optional) Verbose mode - print status line to stdout
#           filename       - filename to be searched/updated
#           testString     - the egrep regex used to find a valid line
#           searchString   - (optional) the sed regex search string to be replaced (normally this is testString)
#           replaceString  - what replaces searchString (do not use backreferences, ex: \1 or &)
#
#         If you do not specify searchString, make sure you make testString match a complete line (see example).
#
#         Returns true if it ran successfully, otherwise false.
#
# Example: _updateLine /etc/passwd "^nobody:.*$" "nobody:*:65535:65535:/dev/null:/bin/false"
#
function _updateLine {
  local addMode=0 verbose=0 force=0 opt
  while getopts afv opt ; do
    [ "$opt" == "a" ] && addMode=1
    [ "$opt" == "f" ] && force=1
    [ "$opt" == "v" ] && verbose=1
  done
  shift $((OPTIND - 1))
  local file="$1" testString="$2" searchString="$2" replaceString="$3"
  [ -n "$4" ] && { searchString="$3" ; replaceString="$4" ; }

  [ $verbose == 1 ] && echo -n _updateLine:\ 

  if [ ! -f "$file" ] ; then
    [ $verbose == 1 ] && echo -n WARNING: file does not exist,\ 
    [ $force == 0 ] && { [ $verbose == 1 ] && echo aborting. ; return 1 ; }
  fi
  if [ ! -w "$file" ] ; then
    [ $verbose == 1 ] && echo -n WARNING: file or directory is read only,\ 
    [ $force == 0 ] && { [ $verbose == 1 ] && echo aborting. ; return 1 ; }
  fi

  if existingString=`egrep -qs "$testString" "$file"` 2>/dev/null ; then
    [ $verbose == 1 ] && echo -n testString found,\ 
    if egrep -qs "^$replaceString$" "$file" 2>/dev/null ; then
      [ $verbose == 1 ] && echo -n replaceString already matches - skipping...
    else
      [ $verbose == 1 ] && echo -n change detected - updating,\ 
      if sed -i "" -e s/"$searchString"/"$replaceString"/ "$file" 2>/dev/null ; then
        [ $verbose == 1 ] && echo -n success.
      else
        [ $verbose == 1 ] && echo ERROR encountered during change - aborting.
        return 1
    fi ; fi
    [ $verbose == 1 ] && echo
  elif [ $addMode == 1 ] ; then
    [ $verbose == 1 ] && echo -n testString not found -\  
    if ( echo "$replaceString" >>"$file" ) 2>/dev/null ; then
      echo appended.
    else
      echo ERROR appending.
    fi
  else
    [ $verbose == 1 ] && echo testString not found - skipping...
  fi
  true
}
