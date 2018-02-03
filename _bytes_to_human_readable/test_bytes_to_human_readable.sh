#!/bin/bash

. _bytes_to_human_readable.inc
. _human_readable_to_bytes.inc

bytes=$1
[ -z "$bytes" ] && echo Error - specify bytes on command line && exit -1 

converted_to_human_readable=`_bytes_to_human_readable "$bytes"`

printf "Human Readable: %s\n" "$converted_to_human_readable"

converted_back_to_bytes=`_human_readable_to_bytes "$converted_to_human_readable"`

printf "Back to Bytes: %s\n" "$converted_back_to_bytes"
