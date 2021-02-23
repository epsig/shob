package Sport_Functions::List_Available_Pages;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
use Sport_Functions::Range_Available_Seasons;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.0';
# (c) Edwin Spee.

@EXPORT =
(#========================================================================
  '&EkWkTopMenu',
  '&OSTopMenu',
  '&get_voetbal_list',
  '$link_stats_eredivisie',
  '$link_jaarstanden',
  '$link_uit_thuis',
 #========================================================================
);

our $link_stats_eredivisie = qq(<a href="sport_voetbal_nl_stats.html">Statistieken Eredivisie vanaf $global_first_year</a>);
our $link_jaarstanden      = qq(<a href="sport_voetbal_nl_jaarstanden.html">Winterkampioen en jaarstanden vanaf $global_first_year</a>);
our $link_uit_thuis        = qq(<a href="sport_voetbal_nl_uit_thuis.html">uit- en thuis standen vanaf $global_first_year</a>);

sub EkWkTopMenu($)
{
  my ($year) = @_;

  my $skip = ($year == -1 ? -1 : ($year - 1996) / 2);

  return '<hr>' . get_menu ('', $skip, 2, -1, (
'sport_voetbal_EK_1996.html', 'EK 1996',
'sport_voetbal_WK_1998.html', 'WK 1998',
'sport_voetbal_EK_2000.html', 'EK 2000',
'sport_voetbal_WK_2002.html', 'WK 2002',
'sport_voetbal_EK_2004.html', 'EK 2004',
'sport_voetbal_WK_2006.html', 'WK 2006',
'sport_voetbal_EK_2008.html', 'EK 2008',
'sport_voetbal_WK_2010.html', 'WK 2010',
'sport_voetbal_EK_2012.html', 'EK 2012',
'sport_voetbal_WK_2014.html', 'WK 2014',
'sport_voetbal_EK_2016.html', 'EK 2016',
'sport_voetbal_WK_2018.html', 'WK 2018',
'sport_voetbal_EK_2020_voorronde.html', 'EK 2021',
'sport_voetbal_WK_2022_voorronde.html', 'WK 2022',
)).'<hr>';
}

sub OSTopMenu($)
{
  my ($jaar) = @_;

  my $os_volgnr = ($jaar - 1994) / 4;

  return join('', '<hr> andere winterspelen: ',
get_menu ('', $os_volgnr, 2, -1, (
'sport_schaatsen_OS_1994.html', 'OS 1994',
'sport_schaatsen_OS_1998.html', 'OS 1998',
'sport_schaatsen_OS_2002.html', 'OS 2002',
'sport_schaatsen_OS_2006.html', 'OS 2006',
'sport_schaatsen_OS_2010.html', 'OS 2010',
'sport_schaatsen_OS_2014.html', 'OS 2014',
'sport_schaatsen_OS_2018.html', 'OS 2018',
)) , "<hr>\n");
}

sub get_voetbal_list($$)
{
  my ($type, $comp) = @_;

  my $ranges = get_sport_range();
  my $key    = ($comp eq 'NL' ? 'voetbal_nl' : 'europacup');
  my @parts_first = split(/-/, $ranges->{$key}[0]);
  my @parts_last  = split(/-/, $ranges->{$key}[1]);
  my $first_year = $parts_first[0];
  my $last_year = $parts_last[0];

  my $url_comp = ($comp eq 'NL' ? 'nl' : 'europacup');

  my $list_nl = '';
  if ($type eq 'overzicht')
  {
    for (my $i = $first_year; $i <= $last_year; $i++)
    {
     my $j = $i+1;
     my $i2 = sprintf('%02d', $i%100);
     my $j2 = sprintf('%02d', $j%100);
     my $komma = ',';
     if ($i == $first_year) {$komma = '.';}
     $list_nl = qq(<a href="sport_voetbal_${url_comp}_${i}_${j}.html">$i2-$j2</a>$komma\n) . $list_nl;
    }
  }
  elsif ($type eq 'hopa')
  {
    my $i = $first_year;
    my $j = $i+1;
    my $k = $last_year;
    my $l = $k+1;
    $list_nl = qq(    <a href="sport_voetbal_${url_comp}_${i}_${j}.html">$i/$j</a> t/m\n) .
               qq(    <a href="sport_voetbal_${url_comp}_${k}_${l}.html">$k/$l</a>.\n);
  }
  elsif ($type eq 'menu_format')
  {
    my @menu = ();
    for (my $i = $first_year; $i <= $last_year; $i++)
    {
      my $j = $i+1;
      my $i2 = sprintf('%02d', $i%100);
      my $j2 = sprintf('%02d', $j%100);
      push @menu, ( "sport_voetbal_${url_comp}_${i}_${j}.html", "$i2-$j2" );
    }
    $list_nl = \@menu;
  }

  return $list_nl;
}

return 1;
