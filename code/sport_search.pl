#!/usr/bin/perl -T -I.
$| = 1;
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:all);
use Sport_Functions::Search;
use Shob_Tools::Settings;
use Sport_Collector::Bookmarks_Index;
use Sport_Functions::InitSport;
use Sport_Collector::Archief_Voetbal_NL;

print header;

my $c1 = param('c1');
my $c2 = param('c2');
my $dd1 = param('dd1');
my $dd2 = param('dd2');

# some defaults:
$c1 = 'az1' if $c1 eq '';
$c2 = 'twn' if $c2 eq '';
#my $dd = handle_dd(param('dd'));
#my $u1 = param('u1');
#my $u2 = param('u2');

sport_init();
init_settings(0, 2, 0, 'n');

my $data = sport_search_results($c1, $c2, $dd1, $dd2);
my $page = get_sport_index($data, $c1, $c2, $dd1, $dd2);
print $page;

