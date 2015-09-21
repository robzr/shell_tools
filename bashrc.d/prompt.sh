bashrc_d_prompt_sh=1

if [ ! -n "$bashrc_d_colors_sh" ] ; then
  if [ -r /xb/bin/bashrc.d/colors.sh ] ; then
    . /xb/bin/bashrc.d/colors.sh 
  elif [ -r ~/bin/bashrc.d/colors.sh ] ; then
    . ~/bin/bashrc.d/colors.sh }
  fi
fi 

if [ ! -n "$bashrc_d_xbvars_sh" ] ; then
  if [ -r /xb/bin/bashrc.d/xbvars.sh ] ; then
    . /xb/bin/bashrc.d/xbvars.sh 
  elif [ -r ~/bin/bashrc.d/xbvars.sh ] ; then
    . ~/bin/bashrc.d/xbvars.sh }
  fi
fi 

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
  case `ip route list to 0.0.0.0/0 | tail -1 | cut -f3 -d\ ` in
    10.14.50.1)   XB_ENV="QA"
      ;;
    10.16.50.1)   XB_ENV="Prod"
      ;;
  esac
fi

if [ "$0" != "-bash" -a "$0" != "/bin/bash" -a "$0" != "bash" ] ; then
 echo
 echo To run, include this in your .bashrc with optional arguments:
 echo . /path/to/prompt.sh [ Prompt_Color Dev_Color QA_Color Prod_Color Unknown_Color ]
 echo
 echo Color names must begin with a cap.  Example:
 echo . prompt.sh Gray Green Yellow Red Black 
 echo
fi

if [ "$1" != "" ] ; then
  pStd=\$fg$1
else 
  pStd=\$fgGray
fi
if [ "$2" != "" ] ; then
  pDev=\$fg$2
else 
  pDev=\$fgGreen
fi
if [ "$3" != "" ] ; then
  pQA=\$fg$2
else 
  pQA=\$fgYellow
fi
if [ "$4" != "" ] ; then
  pProd=\$fg$2
else 
  pProd=\$fgRed
fi
if [ "$5" != "" ] ; then
  pUnknown=\$fg$2
else 
  pUnknown=\$fgBlack
fi

case "$XB_ENV" in 
  Dev)   PS1='\[$clrReset'$pStd'\][\u@\['$pDev'\]\h\['$pStd'\] \W]\$ \[$clrReset\]'
    ;;
  QA)    PS1='\[$clrReset'$pStd'\][\u@\['$pQA'\]\h\['$pStd'\] \W]\$ \[$clrReset\]'
    ;;
  Prod)  PS1='\[$clrReset'$pStd'\][\u@\['$pProd'\]\h\['$pStd'\] \W]\$ \[$clrReset\]'
    ;;
  *)     PS1='\[$clrReset'$pStd'\][\u@\['$pUnknown'\]\h\['$pStd'\] \W]\$ \[$clrReset\]'
    ;;
esac

unset pStd pDev pQA pProd pUnknown

