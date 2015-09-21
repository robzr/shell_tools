#!/usr/bin/perl

use Switch;
use Getopt::Std;

#
# -n means no color
#
getopts('n');

my $type;
my $fix_yp = 0;

if(! defined $opt_n) {
  $bold="\033[1m";
  $boldend="\033[0m";
  $black="\e[30m";
  $red="\e[31m";
  $green="\e[32m";
  $yellow="\e[33m";
  $blue="\e[34m";
  $magenta="\e[35m";
  $cyan="\e[36m";
  $white="\e[37m";
}

sub reset_color { 
  system("tput -T vt100 sgr0") if(! defined $opt_n);
}

chomp(my $hostname = `hostname`);
print "${bold}Hostname:${boldend}\t${blue}$hostname\n";

chomp(my $build = `head -1 /etc/redhat-release`);
$build = ($build eq "")?"${red}Unknown":${green}.$build;
print "${black}${bold}Build:\t\t${boldend}$build\n";

chomp($dnsdomain = `hostname -d`);
if($dnsdomain eq "") {
  chomp(my $dnsdomain = `grep domain /etc/resolv.conf`);
  $dnsdomain =~ s/^\s*domain\s*\([^\s]*\).*$/\1/;
}
switch($dnsdomain) {
  case "xpressbetonline.com"	{ $type = "${black}(${green}QA${black})${green}" }
  case "xpressbet.com"		{ $type = "${black}(${green}Prod${black})${green}" }
  case "xb-online.com"		{ $type = "${black}(${green}Prod${black})${green}" }
  else				{ $type = "${black}(${red}Unknown${black})${red}" }
}
print "${black}${bold}DNS Domain:${boldend}\t$type $dnsdomain\n";

chomp(my $domain = `domainname`);
chomp(my $nisserver = `ypwhich`);
switch($domain) {
  case "xpressbetonline.com"	{ $type = "${red}Old QA" }
  case "qa.xpressbet.com"	{ $type = "${green}QA"; $fix_yp = 1; }
  case "xpressbet.com"		{ $type = "${green}Prod" }
  else				{ $type = "${red}Unknown" }
}
print "${black}${bold}NIS Domain:${boldend}\t$green${black}(${type}${black})${green} $domain ${black}(${green}$nisserver${black})\n";

chomp(my $ns_count = `grep nameserver /etc/resolv.conf | wc -l`);
chomp(my $ns_count_prod = `grep nameserver /etc/resolv.conf | egrep 10.16.50.42\\|10.16.50.43 | wc -l`);
chomp(my $ns_count_qa = `grep nameserver /etc/resolv.conf | egrep 10.14.50.55\\|10.14.50.56 | wc -l`);
chomp(my $ns_count_dev = `grep nameserver /etc/resolv.conf | egrep 10.14.50.14[56789] | wc -l`);
chomp(my $nameservers = `egrep -i nameserver /etc/resolv.conf | sed 's/^nameserver *//' | awk '{printf \$1", "}' | sed 's/, \$//'`);
switch($ns_count) {
  case "$ns_count_qa"	{ $type = "${black}(${green}QA${black})${green}" }
  case "$ns_count_prod"	{ $type = "${black}(${green}Prod${black})${green}" }
  case "$ns_count_dev"	{ $type = "${black}(${green}Dev${black})${green}" }
  else			{ $type = "${black}(${red}Unknown${black})${red}" }
}
print "${black}${bold}Nameservers:${boldend}\t$type $nameservers\n";

print "${black}${bold}Krb5 Config:${boldend}\t";
switch(`cat /etc/krb5.conf | sum`) {
  case "09360     2\n"	{ print "${red}Old Universal Version\n" }
  case "48445     2\n"	{ print "${red}Old Universal Version\n" }
  case "32462     1\n"	{ print "${red}Old Universal Version\n" }
  case "44362     1\n"	{ print "(${red}Prod${black})${red} old version\n" }
  case "03550     1\n"	{ print "(${red}QA${black})${red} old version\n" }
  case "22867     1\n"  { print "(${red}QA${black})${red} old version\n" }
  else			{ print "(${red}Unknown${black})${red} unknown version\n" }  
}

my $cmd = 'sed -n \'s/^[ \t]*default_realm[ \t]*=[ \t]*\([^ \t]*\)[ \t]*$/krb5.conf:\1/p\' /etc/krb5.conf';
chomp(my $def_realm=`$cmd`);
if($def_realm == "") {
  $cmd='dig TXT _kerberos.'.$dnsdomain.' | sed -n \'s/^[^;]*TXT.*"\([^"]*\)"$/\1/p\'';
  chomp($def_realm=`$cmd`);
  $def_realm = "${black}(${green}DNS${black}) ${green}$def_realm";
} else {
  $def_realm = "${black}(${red}DNS${black}) ${green}$def_realm";
}
print "${black}${bold}Default Realm:${boldend}\t$def_realm\n";

system("klist -s");
my $kerb_stat = $?;
print "${black}${bold}Krb5 Principle:${boldend}\t";
if($kerb_stat == 0) {
  chomp($kerb_princ = `(klist | grep Default) 2>/dev/null`);
  $kerb_princ =~ s/^Default principal: //;
  print "${green}$kerb_princ\n";
} else {
  print "${red}none - no host principle?\n";
}


print "${black}${bold}yp.conf:${boldend}\t";
switch(`cat /etc/yp.conf | sum`) {
  case "09618     1\n" { print "${green}Universal Version\n" }
  case "05099     1\n" { print "${green}Universal Version\n" }
  case "23139     1\n" { print "${red}Old Universal Version\n" }
  case "13097     1\n" { print "${red}Old Universal Version\n" }
  case "34366     1\n" { print "${green}Production Version\n" }
  case "47938     1\n" { print "${red}Temp Version\n"  }
  else  { print "${red}unknown version\n" }
}

system("egrep -q '^passwd:[ \t]*compat\$' /etc/nsswitch.conf"); 
my $r1 = $?;
system("egrep -q '^group:[ \t]*compat\$' /etc/nsswitch.conf"); 
my $r2 = $?;
print "${black}${bold}nsswitch:${boldend}\t";
if($r1 == 0 && $r2 == 0) {
  print "${green}Compat\!\n";
} else {
  print "${red}Old-School\!\n";
}

print "${black}${bold}Passwd Compat:${boldend}\t";
switch(`egrep '^passwd:[ \t]*compat' /etc/nsswitch.conf | wc -l`) {
  case "1\n"	{ print "${green}Compat\!\n" }
  else		{ chomp(my $tmp = `egrep ^passwd: /etc/nsswitch.conf`);
                  $tmp =~ s/^[^:]*:\s*//;
                  print "${red}Not Compat ($tmp)\n"; 
}               }

print "${black}${bold}Group Compat:${boldend}\t";
switch(`egrep '^group:[ \t]*compat' /etc/nsswitch.conf | wc -l`) {
  case "1\n"	{ print "${green}Compat\!\n" }
  else		{ chomp(my $tmp = `egrep ^group: /etc/nsswitch.conf`);
                  $tmp =~ s/^[^:]*:\s*//;
                  print "${red}Not Compat ($tmp)\n"; 
}               }

my $nis_uids = "${red}Old"; 
$nis_uids = "${green}New" if(`getent passwd rzwissler | grep 6041 | wc -l` > 0);
my $file_uids = "${red}Old QA"; 
$file_uids = "${green}Prod" if(`ls -and ~ | grep 6041 | wc -l`);

print "${black}${bold}UIDs Files/NIS: ${boldend}${nis_uids}${black}/${file_uids}\n";

print ${black};
reset_color();

#if($fix_yp > 0) {
#  system("sudo /etc/init.d/ypbind restart");
#  system("sudo /etc/init.d/nscd restart");
#  system("sudo /etc/init.d/nscd reload");
#}

