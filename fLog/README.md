# fLog 
f(lexible)Log function for ash/bash - auto-detects piped input or arguments,
supports arbitrary log levels for adjusting verbosity/debugging output.

```
 fLog Args:
    [-l level] only logs if the level exceeds (optional) predefined $fLogLevel
        level can be numeric or a mnemonic; $fLogLevel must be a number
        1=standard 2=verbose 3=debug for mnemonics

 Optional Variables: 
    $fLogPrefix prefixes piped output
    $fLogPipeDelib is used immediately before pipe'd output
```

fLogger - busybox/OpenWRT version, uses logger with easily settable facility,
overrideable with stdout/stderr.

