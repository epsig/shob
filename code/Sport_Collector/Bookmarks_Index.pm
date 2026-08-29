package Sport_Collector::Bookmarks_Index;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General qw(&min &max);
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob::Functions;
use Sport_Functions::List_Available_Pages;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Functions::Range_Available_Seasons qw(&get_sport_range);
use Sport_Functions::List_Available_Pages qw(&EkWkList);
use Sport_Collector::Archief_Voetbal_NL_Standen;
use Sport_Functions::Seasons;
use Sport_Functions::Get_Land_Club;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_sport_index',
 #========================================================================
);

sub create_input_club($$$)
{
  my ($clubs, $default, $order) = @_;

  my $out = qq(<select name="c$order">);
  foreach my $club (@{$clubs})
  {
    my $selected = ($club eq $default ? 'selected ' : '');
    $out .= qq(<option ${selected}value="$club">$club\n);
  }
  $out .= qq(</select>\n);
}

sub get_list_eredivisie_clubs()
{
  my $ranges = get_sport_range();
  my $first_yr = szn2yr($ranges->{eredivisie}[0]);
  my $last_yr  = szn2yr($ranges->{eredivisie}[1]);

  my @clubs = ();
  for my $yr ($first_yr .. $last_yr)
  {
    my $szn = yr2szn($yr);
    my $s = standen_eredivisie($szn);
    for (my $c=1; $c < scalar @$s; $c++)
    {
      my $club = expand($s->[$c][0], 0);
      if ( ! grep /$club/, @clubs)
      {
        push @clubs, $club;
      }
    }
  }

  @clubs = sort @clubs;
  return @clubs;
}

sub get_sport_index($$$)
{# (c) Edwin Spee

 my ($search_data, $both, $sort) = @_;

 my $dd = $u_nl->{laatste_speeldatum};

 my $nl_list = get_voetbal_list('overzicht', 'NL');
 my $ec_list = get_voetbal_list('overzicht', 'EC');
 my $ekwk_list = EkWkList();
 my $os_list = OSlist();
 my $host = (get_host_id() eq 'local' ? 'https://www.epsig.nl' : '');
 my $out = << "EOF";
 <ul>
  <li>Wedstrijden Nederlands Elftal:
   <br>
$ekwk_list
  <li>Nederlandse clubteams in de Europacup voetbal;
   <br>seizoen:
$ec_list
  <li>Eindstand eredivisie, KNVB-beker en nacompetitie;
   <br>seizoen:
$nl_list
  <li>$link_stats_eredivisie
  en <a href="sport_voetbal_nl_stats_more.html">nog meer stats</a>.
  <li>$link_jaarstanden |
      $link_uit_thuis
  <li>Uitslagen schaatsen:
$os_list
  <li>Zie verder: <a href="bookmarks_sport.html">sport links</a>
 </ul>
EOF

 my $title = "Sportpagina's op www.epsig.nl";

 my $baseurl;
 if ($search_data eq '')
 {
  $baseurl = 0;
  $out = [[$title, bespaar_bandbreedte($out)]];
 }
 else
 {
  $baseurl = 3;
  $out = [ ['Zoek resultaten', $search_data],
           [$title, bespaar_bandbreedte($out)]];
 }

 return maintxt2htmlpage($out, $title,
  'std', $dd, {type1 => 'std_menu', skip1 => 3, baseurl => $baseurl, pjs => [2, '/validate_sport.js']});
}

return 1;
