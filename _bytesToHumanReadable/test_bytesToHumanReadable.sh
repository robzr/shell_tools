#!/bin/bash

. _bytesToHumanReadable.inc

bytes=$1
[ -z "$bytes" ] && echo Error - specify bytes on command line && exit -1 

_bytesToHumanReadable $bytes

printf "Human Readable Bytes: %s (%s)\n" "$bytesToHumanReadableResult" "$bytes"
