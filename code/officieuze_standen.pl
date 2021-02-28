#!/usr/bin/perl -T -I.
$| = 1;
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:all);
use Sport_Functions::Search;
use Shob_Tools::Settings;
use Sport_Functions::InitSport;
use Sport_Collector::Archief_Voetbal_NL;
use Sport_Collector::Stats_Eredivisie;

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
 sport_init();
 init_settings(0, 2, 0, 'n');

 $data = officieuze_standen($type, $year);
 print $data;
}
else
{
 print "<html><body>Sorry, problem with your arguments. Try again.</body></html>\n";
}

