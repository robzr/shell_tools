#!/bin/bash

. spin.sh
function showTest {
  for ((y = $1 * 3; y > 0; y--)) ; do spin ; done
  spin clear
  echo
}

makeBanner ".oOo."
echo -n 'Testing one: ' ; showTest 10
unset spinStyle

makeBanner "Watching..."
echo -n 'Testing one: ' ; showTest 10
declare -a spinStyle=('-' '\' '|' '/')
echo -n 'Testing two: ' ; showTest 8
declare -a spinStyle=('-' '*' '#' '*')
echo -n 'Testing three: ' ; showTest 8
declare -a spinStyle=('-' '+')
echo -n 'Testing four: ' ; showTest 8
declare -a spinStyle=(' ' '.' 'o' 'O' 'o' '.')
echo -n 'Testing five: ' ; showTest 8
declare -a spinStyle=('  ' ' .' '.o' 'oO' 'Oo' 'o.' '. ')
echo -n 'Testing six: ' ; showTest 8
declare -a spinStyle=('  ' ' .' '.o' 'oO' 'Oo' 'o.' '. ')
echo -n 'Testing seven: ' ; showTest 8

