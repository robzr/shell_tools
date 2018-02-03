# Arg1 = human readable size format
#
_human_readable_to_bytes() {
  printf "%.0f" `sed -e 's/[Pp][Bb]/* 1024^5/' -e 's/[Tt][Bb]/* 1024^4/' \
                   -e 's/[Gg][Bb]/* 1024^3/' -e 's/[Mm][Bb]/* 1024^2/' \
                   -e 's/[Kk][Bb]/* 1024/' <<< "$1" | bc -l`
}
