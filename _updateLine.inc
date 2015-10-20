# Searches and updates a line in a file, for lightweight "configuration management" :)
#
# Syntax: _updateLine filename testString [searchString] replaceString
#           filename       - filename to be searched/updated
#           testString     - the egrep regex used to find a valid line
#           searchString   - optionally, the sed regex search string to be replaced (normally this is testString)
#           replaceString  - what replaces searchString (do not use backreferences, ex: \1 or &)
#
#         returns true if it ran successfully, otherwise false
#
# Example: _updateLine /etc/passwd "^nobody:.*$" "nobody:*:65535:65535:/dev/null:/bin/false"
#
function _updateLine {
  local verbose=0
  [ "$1" == "-v" ] && { verbose=1 ; shift ; }
  local file="$1"
  local testString="$2"
  local searchString="$2"
  local replaceString="$3"
  [ -n "$4" ] && { searchString="$3" ; replaceString="$4" ; }

  existingString=`egrep -qs "$testString" "$file"` 2>/dev/null
  if [ $? ] ; then
    [ $verbose == 1 ] && echo -n _updateLine: testString found,\
    if egrep -qs "^$replaceString$" "$file" 2>/dev/null ; then
      [ $verbose == 1 ] && echo -n replaceString already matches - skipping...
    else
      [ $verbose == 1 ] && echo -n change detected - updating,\
      if sed -i -e s/"$searchString"/"$replaceString"/ "$file" 2>/dev/null ; then
        [ $verbose == 1 ] && echo -n success
      else
        [ $verbose == 1 ] && echo ERROR encountered during change - aborting
        return 1
    fi ; fi
    [ $verbose == 1 ] && echo
  fi
  true
}
