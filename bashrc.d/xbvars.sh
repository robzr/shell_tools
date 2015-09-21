bashrc_d_xbvars_sh=1

if [ -f /etc/sysconfig/xbvars ] ; then
  . /etc/sysconfig/xbvars
elif [ -x /usr/local/bin/parse_xbvars ] ; then
  /usr/local/bin/parse_xbvars -s > /tmp/parse_xbvars.$$
  . /tmp/parse_xbvars.$$
  rm /tmp/parse_xbvars.$$
else 
  . /etc/sysconfig/network

  if [ ! -n "$XB_ENV" ] ; then
    case `hostname` in
      xor-d*)   XB_ENV="Dev"
        ;;
      xor-q*)   XB_ENV="QA"
        ;;
      xor-p*)   XB_ENV="Prod"
        ;;
    esac
  fi

  if [ ! -n "$XB_ENV" ] ; then
    case "$NISDOMAIN" in 
      prod.xpressbet.com)  export XB_ENV="Prod"
        ;;
      qa.xpressbet.com)  export XB_ENV="QA"
        ;;
      dev.xpressbet.com)  export XB_ENV="Dev"
        ;;
      *)  export XB_ENV="Unknown"
        ;;
    esac
  fi

  if [ ! -n "$XB_ENV" ] ; then
    case `ip route list to 0.0.0.0/0 | tail -1 | cut -f3 -d\ ` in
      10.14.50.1)   XB_ENV="QA"
        ;;
      10.16.50.1)   XB_ENV="Prod"
        ;;
    esac
  fi
fi


