#!/bin/bash 
#
# reusable PID file locking routine --robzr 7/29/13
#
# Issues:
#
# the /var/run /tmp search order depending on write perms can result in two different users using two different PID files
#
#
#
#

. _pidLock.sh

#
# example usage:
#

#echo -n Checking lockfile...
#_pidLock -c
#echo returned $?

if ! _pidLock -c -f /tmp/mylock.pid ; then
  echo Sorry, it\'s locked.
  exit -1
else
  echo -n Locking...
  _pidLock -l
  echo returned $?
fi

echo -n Re-locking...
_pidLock -l
echo returned $?

echo -n Checking lockfile...
_pidLock -c
echo returned $?

echo -n Removing lock...
_pidLock -r
echo returned $?

echo -n Checking lockfile...
_pidLock -c
echo returned $?

echo -e \\nYou can simulate a valid lock by running:\\n
echo '  echo 1 > /tmp/mylock.pid'
echo -e \\nThen, rerun this script.

