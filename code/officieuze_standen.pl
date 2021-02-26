#!/usr/local/bin/perl -T -I../../shobdir
$| = 1;
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:all);
use Sport_Functions::Search;
use Shob_Tools::Settings;
use Sport_Data::Archief_Voetbal_NL;
use Sport_Data::Stats_Eredivisie;

print header;

# usage:
# type is 'jaarstanden', 'officieus', 'uit_thuis'
# year is 4 digits
#
my $type = lc(param('type'));
my $year = param('year');

my $data = 0;
if (($type eq 'officieus' or $type eq 'jaarstanden'  or $type eq 'uit_thuis') and ($year =~ m/^\d{4}/iso))
{
 set_laatste_speeldatum;
 init_settings(0, 2, 0, 'n');

 $data = officieuze_standen($type, $year);
 print $data;
}
else
{
 print "<html><body>Sorry, problem with your arguments. Try again.</body></html>\n";
}

if (defined $ENV{REMOTE_ADDR} and defined $ENV{QUERY_STRING})
{
 open (LOG, ">>officieuze_standen.log") or die "can't open log file.\n";
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
 print LOG $ENV{QUERY_STRING},"\n";
 print LOG length($data), "\n\n";
 close LOG or die "can't close log file.\n";
}
