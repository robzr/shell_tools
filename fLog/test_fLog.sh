#!/bin/sh
#
# f(lexible)Log for ash/bash - simply pipe command output to it, or 
# run standalone to log commands and statements in (b)ash scripts
#
# Args:
#    [-l level] only logs if the level exceeds (optional) predefined $fLogLevel
#        level can be numeric or a mnemonic; $fLogLevel must be a number
#        1=standard 2=verbose 3=debug for mnemonics
#
# Optional Variables: 
#    $fLogPrefix prefixes piped output
#    $fLogPipeDelib is used immediately before pipe'd output
#
. _fLog.inc

echo Example of basic usage with arguments:
fLog just a random comment

echo ; echo Example of basic usage with piped input:
egrep -v ^# /etc/passwd | head -2 | fLog passwdFile

echo ; echo Example of using fLogLevel
fLogLevel=2   # define maximum log level to output (ex: 2=verbose, 3=debug)
fLog -l 1 just a level 1 \(standard\) comment
fLog -l 2 just a level 2 \(verbose\) comment
fLog -l 3 just a level 3 \(debug\) comment

echo ; echo Example of using fLogLevel with mnemonics
fLogLevel=2   # define maximum log level to output (ex: 2=verbose, 3=debug)
fLog -l standard just a level 1 \(standard\) comment
fLog -l verbose just a level 2 \(verbose\) comment
fLog -l debug just a level 3 \(debug\) comment

echo ; echo Examples of using global variables to customize output
fLogPrefix="(critical) "
fLogDelim=": "
fLog just a random comment
egrep -v ^# /etc/passwd | head -2 | fLog -l verbose passwdFile
