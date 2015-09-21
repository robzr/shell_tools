bashrc_d_homesync_sh=1

function homesync {
  [ -n "$PS1" ] || return
  if [ `netstat -ln -t | grep :9873 | wc -l` -gt 0 ] ; then
    [ -n "$PS1" ] && echo -n Syncing home directory...
    RSYNC_PASSWORD=3Ca40Zp9 rsync -az --port 9873 localhost::unix_home ~
    [ -n "$PS1" ] && [ $? -eq 0 ] && echo done || echo Error \($?\)\!
  else
    [ -n "$PS1" ] && echo Bypassing home directory sync...
  fi
}

[ -n "$PS1" ] && {
  before=`sum ~/.bashrc`
  [ ! `find . -maxdepth 1 -wholename ~/.homesync_last -mtime -1 | wc -l` -gt 0 ] && { homesync ; touch ~/.homesync_last ; }
  after=`sum ~/.bashrc`
  if [ "$before" != "$after" ] ; then
    echo Detected change in .bashrc\; rerunning...
    . ~/.bashrc
    return 9
  fi
  unset before after homesync
}
