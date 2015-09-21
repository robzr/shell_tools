# Lightweight file rotation function --robzr
#
# Usage: _rotate file_or_directory [#_of_rotations_to_keep]
#
# Returns: -1 for error, otherwise, # of rotations
#
_rotate () {
  maxRots=9999
  target=$1
  [[ $2 =~ ^[0-9]+$ ]] && maxRots=$2
  [ -a "$target" ] || return 0
  for (( foundRot=0; $foundRot < $maxRots; foundRot++ )) ; do
    [ -a "$target".$foundRot ] || break
  done
  [ $foundRot -eq $maxRots ] && ( rm -rf "$target".$foundRot &>/dev/null || return -1 )
  for (( rot=((foundRot - 1)); rot >= 0; rot-- )) ; do
    mv -f "$target".$rot "$target".$(( rot + 1 )) &>/dev/null || return -1
  done
  mv -f "$target" "$target".0 &>/dev/null || return -1
  return $foundRot
}
