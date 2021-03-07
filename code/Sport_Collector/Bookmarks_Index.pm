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
 '&get_sport_links',
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

sub get_sport_index($$$$$$$)
{# (c) Edwin Spee

 my ($search_data, $c1, $c2, $dd1, $dd2, $both, $sort) = @_;

 my $dd = $u_nl->{laatste_speeldatum};
 if ($dd1 < 0) {$dd1 = 20010101;}
 if ($dd2 < 0) {$dd2 = $dd;}

 my $ranges = get_sport_range();
 my $first_eredivisie_season = $ranges->{eredivisie}[0];

 my @clubs = get_list_eredivisie_clubs();

 my $input1 = create_input_club(\@clubs, $c1, 1);
 my $input2 = create_input_club(\@clubs, $c2, 2);

 my @checked_both = ('', '');
 $both = max(0, min($both, 1));
 $checked_both[$both] = 'checked';

 my @checked_sort = ('', '', '');
 $sort = max(0, min($sort, 2));
 $checked_sort[$sort] = 'checked';

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
  <li>$link_jaarstanden |
      $link_uit_thuis
  <li>Uitslagen schaatsen:
$os_list
  <li>Zie verder: <a href="bookmarks_sport.html">sport links</a>
  <li> Zoek Eredivisie uitslagen (vanaf seizoen $first_eredivisie_season):
<form name="myForm" action=$host/cgi-bin/shob/sport_search.pl method=get onsubmit="return validateForm()">
<p> clubs:
$input1
$input2
</p>
<p> start-datum: <input type=text name=dd1 size=9 value="$dd1">
eind-datum: <input type=text name=dd2 size=9 value="$dd2"> (formaat datum = yyyymmdd) </p>
<p>uit en thuis:
<input type="radio" id="both" name="both" value="1" $checked_both[1]>
<label for="1">beide wedstrijden</label>
<input type="radio" id="both" name="both" value="0" $checked_both[0]>
<label for="0">1e speelt thuis</label></p>
<p> sorteren:
<input type="radio" id="both" name="sort" value="0" $checked_sort[0]>
<label for="0">datum</label>
<input type="radio" id="both" name="sort" value="1" $checked_sort[1]>
<label for="1">datum (recent eerst)</label>
<input type="radio" id="both" name="sort" value="2" $checked_sort[2]>
<label for="2">grote uitslagen eerst</label></p>
<p> <input type=submit value="OK, verstuur!"> </p>
</form>
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

sub urls2txt($)
{# (c) Edwin Spee
 # versie 1.0 23-sep-2003 initiele versie

 my $urls = $_[0];
 my $out = '';
 for (my $i=0; $i<scalar @$urls; $i++)
 {
  my $ry = $urls->[$i];

  my $adres = $ry->[0];
  my $text  = $ry->[1];

  if ($adres !~ m/http/iso) {$adres = "http://$adres";}

  $out .= qq(<li><a href="$adres">$text</a>\n);
 }
 return "<ul>$out</ul>\n";
}

sub get_sport_links
{# (c) Edwin Spee

#erg seizoensafhankelijk:
 my $tt434 = ttlink(434,'Toertochten op NOS Teletekst', 'tekst');
 $tt434 = '<li>' . $tt434;

 my $schaatsen = [
'schaats-links',
<< "EOF"
<ul>
 <li>Uitslagen schaatsen OS:
     <a href="sport_schaatsen_OS_1994.html">1994</a>,
     <a href="sport_schaatsen_OS_1998.html">1998</a>,
     <a href="sport_schaatsen_OS_2002.html">2002</a>,
     <a href="sport_schaatsen_OS_2006.html">2006</a>,
     <a href="sport_schaatsen_OS_2010.html">2010</a>,
     <a href="sport_schaatsen_OS_2014.html">2014</a> en
     <a href="sport_schaatsen_OS_2018.html">2018</a>
 <li><a href="http://www.knsb.nl/">KNSB</a>
 <li><a href="http://www.isu.org/">ISU</a>
$tt434
</ul>
EOF
];

#<a href="http://www.planet.nl/planet/0,1114,82_486,00.html">
#Athletiek bij Planet Internet</a>
#<a href="http://www.larch.nl/hermes/">
#Atletiekvereniging Hermes</a> (Utrecht)
 my $trimlopen_nl = [
['www.rondjebergen.nl','Rondje Bergen'],
['www.4mijl.nl','4 Mijl Haren-Groningen'],
['www.bergrace.nl','van Berg tot Berg race'],
['www.bridgetobridge.nl','Bridge to Bridge'],
['www.cityrunutrecht.nl','Cityrun Utrecht'],
['www.cpcloop.nl','City-Pier-City loop'],
['www.damloop.nl','Dam tot Dam loop'],
['www.derdekerstdagloop.nl','Derde kerstdag loop Arnhem'],
['www.dijkenloop.nl','Dijkenloop Beneden Leeuwen '],
['www.egmondhalvemarathon.nl','Halve Marathon Egmond'],
['www.marikenloop.nl','Marikenloop'],
['www.montferlandrun.nl','Montferland run'],
['www.royalten.nl','The Hague Royal Ten'],
['www.sevenaerrun.nl','Sevenaerrun'],
['https://www.halvemarathoncapelle.nl','Halve marathon Capelle ad IJ.'],
['www.zevenheuvelenloop.nl', 'Zevenheuvelenloop'],
];
 my $marathons_nl = [
['https://www.nnmarathonrotterdam.nl','Marathon Rotterdam'],
['www.marathoneindhoven.nl','Marathon Eindhoven'],
['www.amsterdammarathon.nl','Marathon Amsterdam'],
['www.ultraned.org','Ultraned'],
];
 my $rest = [
['www.iaaf.org','IAAF'],
['www.nyrrc.org','New York City marathon'],
['www.ra.nl','Rotterdam athletiek'],
['www.haagatletiek.nl','Haag atletiek',],
['atletiek.beginthier.nl','Startpagina atletiek'],
];

 my $trimlopen_nl_html = ['trimlopen', urls2txt($trimlopen_nl)];
 my $marathons_nl_html = ['Nederlandse marathons', urls2txt($marathons_nl)];
 my $athletiek_rest = ['overige athletiek-sites', urls2txt($rest)];

 my $hopa_nl_bvo = [
'sites betaald voetbalclubs',
<< 'EOF'
  <a href="http://www.adodenhaag.nl/">ADO Den Haag</a>,
  <a href="http://www.agovv.nl/">AGOVV</a>,
  <a href="http://www.ajax.nl/">Ajax</a>,
  <a href="http://www.almerecity.nl/">Almere City</a>,
  <a href="http://www.az-alkmaar.nl/">AZ</a>,
  <a href="http://www.cambuur.nl/">Cambuur</a>,
  <a href="http://www.fcdenbosch.nl/">Den Bosch</a>,
  <a href="https://fcemmen.nl/">FC Emmen</a>,
  <a href="http://www.feyenoord.nl/">Feyenoord</a>,
  <a href="http://www.fcgroningen.nl/">Groningen</a>,
  <a href="http://www.fortuna-sittard.nl/">Fortuna Sittard</a>,
  <a href="http://www.graafschap.nl/">De Graafschap</a>,
  <a href="http://www.sc-heerenveen.nl/">Heerenveen</a>,
  <a href="http://www.heracles.nl/">Heracles</a>,
  <a href="http://www.mvv.nl/">MVV</a>,
  <a href="http://www.nac.nl/">NAC</a>,
  <a href="http://www.nec-nijmegen.nl/">NEC</a>,
  <a href="http://www.psv.nl/">PSV</a>,
  <!-- <a href="http://www.rbc-online.nl/">RBC</a>, -->
  <a href="http://www.rkcwaalwijk.nl/">RKC</a>,
  <a href="http://www.rodajc.nl/">Roda JC</a>,
  <a href="http://www.sparta-rotterdam.nl/">Sparta</a>,
  <a href="http://www.fctwente.nl/">Twente</a>,
  <a href="http://www.fc-utrecht.nl/">Utrecht</a>,
  <a href="http://www.sbv-vitesse.nl/">Vitesse</a>,
  <a href="http://www.fcvolendam.nl/">Volendam</a>,
  <a href="http://www.willem-II.nl/">Willem-II</a>,
  <a href="http://www.fczwolle.nl/">FC Zwolle</a>.
EOF
];

 my $voetbal_rest = [
"Enkele andere voetbal pagina's",
<< 'EOF'
 <ul>
  <li><a href="http://www.vi.nl/">Voetbal International</a>
  <li><a href="http://www.eredivisie.nl/">Eredivisie</a>
  <li><a href="http://www.knvb.nl/">KNVB</a>,
    <a href="http://www.uefa.com/">UEFA</a> en
    <a href="http://www.fifa.com/">FIFA</a>
  <li><a href="http://www.soccerway.com/">Soccerway: just soccer!</a>
  <li><a href="http://www.rsssf.com/archive.html">RSSF-archive</a>;
      <a href="http://www.rsssf.com/histdom.html">RSSF-histdom</a>
  <li><a href="http://euro.futbal.org/">European competitions</a> (C-L, UEFA cup)
 </ul>
EOF
];

 my $tt601 = ttlink(601, 'Laatste sportnieuws', 'tekst');

 my $sport_links_rest = [
"enkele andere sport pagina's",
<< "EOF"
 <ul>
  <li> $tt601 bij NOS-Teletekst
   | <a href="http://www.rtlsport.nl/">RTL Sport</a>
   | <a href="http://www.oranje.nl/">Oranje.nl</a>
  <li><a href="http://www.olympic.org/">The olympics</a>
  <li> Tennis:
   <a href="http://www.atptour.com/">ATP-Tour</a>,
   <a href="http://www.ausopen.org/">Australian Open</a>,
   <a href="http://www.rolandgarros.org/">Roland Garros</a>,
   <a href="http://www.wimbledon.org/">Wimbledon</a>,
   <a href="http://www.usopen.org/">US Open</a>,
   <a href="http://www.daviscup.org/">Daviscup</a>
  <li><a href="http://www.letour.fr/">Tour de France</a>
<!-- <li><a href="http://www.knltb.nl/">www.knltb.nl: Koninklijke Nederlandse Lawn Tennis Bond</a> -->
<!-- <li><a href="http://www.knkv.nl/">www.knkv.nl: Koninklijk Nederlands Korfbal Verbond</a> -->
<!-- <li><a href="http://www.nba.com/">National Basketball Association</a> -->
  <li><a href="https://www.sportsline.com/">www.sportsline.com</a>
 </ul>
</ul>
EOF
];

 my $out = [$schaatsen, $trimlopen_nl_html, $marathons_nl_html, $athletiek_rest,
 $hopa_nl_bvo, $voetbal_rest, $sport_links_rest];

 return maintxt2htmlpage($out, 'Bookmarks: sport', 'std',
  20200502, {type1 => 'std_menu'});
}

return 1;
