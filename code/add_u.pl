#!/usr/local/bin/perl -T -I../../shobdir
$| = 1;
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:all);
use Shob_Tools::Idate;

print header;

my $c1 = param('c1');
my $c2 = param('c2');
my $dd = handle_dd(param('dd'));
my $u1 = param('u1');
my $u2 = param('u2');
my $ts = param('ts');
my $opm = param('opm');

my $info = '';
if ($c1 ne '' and $c2 ne '' and $u1 =~ m/^\d+$/ and $u2 =~ m/^\d+$/ )
{
 my $extra = '';
 if ($ts =~ m/^\d+$/ and $opm ne '')
 {
  $extra = qq(,{publiek => ) . sprintf('%5u', $ts) . qq(, opm => "$opm"});
 }
 elsif ($ts =~ m/^\d+$/)
 {
  $extra = sprintf(',%5u', $ts);
 }
 elsif ($opm ne '')
 {
  $extra = qq(,{opm => "$opm"});
 }

 open (OUT, ">>add_u.txt") or die "can't open file add_u.txt.\n";
 print OUT qq(['$c1','$c2',[$dd,$u1,$u2$extra]],\n);
 close OUT or die "can't close file add_u.txt.\n";
}
elsif ($c1 ne '' and $c2 ne '' and $opm ne '')
{
 open (OUT, ">>add_u.txt") or die "can't open file add_u.txt.\n";
 print OUT qq(['$c1','$c2',[$dd,-1,-1,{opm => "$opm"}]],\n);
 close OUT or die "can't close file add_u.txt.\n";
}
else
{
 $info = "<p> Helaas, ongeldige invoer.</p>\n";
}

print "<html><head><title> form add_u handler </title></head>\n";
print "<body> <pre>\n";

open (IN, "<add_u.txt") or die "can't open file add_u.txt.\n";
while (<IN>)
{
 print $_ ;
}
close IN or die "can't close file add_u.txt.\n";

print $info;
print "</pre> <p> Volgende: </p>\n";

print << "END";
<form action=/cgi-bin/shob/add_u.pl method=post>
<table>
<tr> <td> club1: <td> <input type=text name=c1 size=5 value="">
<tr> <td> club2: <td> <input type=text name=c2 size=5 value="">
<tr> <td> datum: <td> <input type=text name=dd size=2 value="">
<tr> <td> u1: <td> <input type=text name=u1 size=2 value="">
<tr> <td> u2: <td> <input type=text name=u2 size=2 value="">
<tr> <td> publiek: <td> <input type=text name=ts size=6 value="">
<tr> <td> opm: <td> <input type=text name=opm size=15 value="">
<tr> <td colspan=2> <input type=submit value="OK, verstuur!">
</table>
</form>
END

print "</body> </html>\n";

open (LOG, ">>add_u.log") or die "can't open log file.\n";
print LOG scalar localtime, "\n";
my $ip = $ENV{REMOTE_ADDR};
my $homeip = '86.87.212.35';
if ($ip eq $homeip)
{
 print LOG "$ip (thuis)\n";
}
else
{
 print LOG $ip, "\n";
}
print LOG $ENV{QUERY_STRING},"\n\n";
close LOG or die "can't close log file.\n";

