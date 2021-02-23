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
  '&EkWkList',
  '&get_last_ekwk_page',
  '$link_stats_eredivisie',
  '$link_jaarstanden',
  '$link_uit_thuis',
 #========================================================================
);

our $link_stats_eredivisie = qq(<a href="sport_voetbal_nl_stats.html">Statistieken Eredivisie vanaf $global_first_year</a>);
our $link_jaarstanden      = qq(<a href="sport_voetbal_nl_jaarstanden.html">Winterkampioen en jaarstanden vanaf $global_first_year</a>);
our $link_uit_thuis        = qq(<a href="sport_voetbal_nl_uit_thuis.html">uit- en thuis standen vanaf $global_first_year</a>);

sub EkWkPlainList()
{
  my $ranges = get_sport_range();

  my $first_yr = min($ranges->{ekwk}[0], $ranges->{ekwk_qf}[0]);
  my $last_yr  = max($ranges->{ekwk}[1], $ranges->{ekwk_qf}[1]);

  my @out = ();

  for (my $yr = $first_yr; $yr <= $last_yr; $yr += 2)
  {
    my $year = ($yr == 2020 ? 2021 : $yr); # postponed due to Corona
    my $ekwk = ($yr % 4 == 0 ? 'EK' : 'WK');
    my $voorronde = ($yr >= $ranges->{ekwk}[0] && $yr <= $ranges->{ekwk}[1] ? '' : '_voorronde');
    push @out, ("sport_voetbal_${ekwk}_${yr}${voorronde}.html", "${ekwk} ${year}");
  }
  return @out;
}

sub EkWkList()
{
  my @ekwk_pages = EkWkPlainList();

  my $out = '';
  for (my $i = scalar @ekwk_pages -1 ; $i > 0; $i -= 2)
  {
    my $prepend = ($out eq '' ? '     ' : '   | ');
    my $link = $ekwk_pages[$i-1];
    my $name = $ekwk_pages[$i];
    $out .= qq($prepend<a href="$link">$name</a>\n);
  }

  return $out;
}

sub EkWkTopMenu($)
{
  my ($year) = @_;

  my $ranges = get_sport_range();
  my $first_yr = min($ranges->{ekwk}[0], $ranges->{ekwk_qf}[0]);

  my $skip = ($year == -1 ? -1 : ($year - $first_yr) / 2);

  my @ekwk_pages = EkWkPlainList();

  return '<hr>' . get_menu ('', $skip, 2, -1, @ekwk_pages).'<hr>';
}

sub get_last_ekwk_page()
{
  my @ekwk_pages = EkWkPlainList();
  my $link = $ekwk_pages[-2];
  my $year = $ekwk_pages[-1];
     $year =~ s/[EW]K //;

  return qq(<a href="$link">$year</a>);
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
