#!/bin/bash

. _spin.inc
function showTest {
  for ((y = $1 * 3; y > 0; y--)) ; do _spin .1 ; done
  _spin clear
  echo
}

_spinMakeBanner ".oOo."
echo -n 'Testing one: ' ; showTest 10
unset spinStyle

_spinMakeBanner "Watching..."
echo -n 'Testing two: ' ; showTest 10
unset spinStyle

declare -a spinStyle=('-' '\' '|' '/')
echo -n 'Testing three: ' ; showTest 8

declare -a spinStyle=('-' '*' '#' '*')
echo -n 'Testing four: ' ; showTest 8

declare -a spinStyle=('-' '+')
echo -n 'Testing five: ' ; showTest 8

declare -a spinStyle=(' ' '.' 'o' 'O' 'o' '.')
echo -n 'Testing six: ' ; showTest 8

declare -a spinStyle=('  ' ' .' '.o' 'oO' 'Oo' 'o.' '. ')
echo -n 'Testing seven: ' ; showTest 8

