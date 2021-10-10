package Shob::Bookmarks;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Shob_Tools::Error_Handling;
use Shob::Functions;
use Sport_Functions::Readers;
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
 '&get_bkmrks_html',
 '&get_actueel',
 '&get_bkmrks_media',
 '&get_bkmrks_milieu',
 '&get_bkmrks_science',
 '&get_bkmrks_treinen',
 #========================================================================
);

sub get_bkmrks_html
{# (c) Edwin Spee

 my $html_js = [
'HTML (en CSS en JavaScript)',
<< "EOF"
<ul><li><a href="http://www.handleidinghtml.nl/">www.handleidinghtml.nl</a>
<li><a href="http://developer.irt.org/script/">JavaScript FAQ</a>
<li><a href="http://www.selfhtml.org">selfhtml.org</a>
<li><a href="http://www.w3.org/TR/">Technische documentatie bij W3C</a>
<li><a href="http://wsabstract.com">wsabstract.com</a>
<li><a href="http://www.webreference.com">webreference.com</a>
<li><a href="http://www.htmlcenter.com">htmlcenter.com</a>
<li><a href="http://browserwatch.internet.com">browserwatch.internet.com</a>
<li><a href="http://www.jsworkshop.com">www.jsworkshop.com</a>
<li><a href="http://www.mijnhomepage.nl">mijnhomepage.nl</a>
<li><a href="http://www.mijnhomepage.nl/csscursus/abbr-acronym.php">Abbr, Acronym Tags en CSS</a>
<li><a href="anybrowser.html">Special characters in HTML</a>
</ul>
EOF
];

 my $io_stds = [
'Invoer/uitvoer standards',
<< 'EOF'
<ul>
 <li><a href="http://www.w3.org/TR/xmlschema-0/">XML-Schema</a>
 <li><a href="http://www.opengis.net/gml/">GML: a Markup Language for Geography</a>
 <li><a href="http://www.cgd.ucar.edu/cms/eaton/cf-metadata/">NetCDF Climate and Forecast (CF) Metadata Convention</a>
 <li><a href="http://ferret.wrc.noaa.gov/noaa_coop/coop_cdf_profile.html">NetCDF Coards convention</a>
</ul>
EOF
];

 my $f90 = [
'Fortran-90',
<< 'EOF'
<ul><li><a href="http://www.nsc.liu.se/~boein/f77to90/f77to90.html">Fortran 90 for the Fortran 77 Programmer</a>
<li><a href="http://www.star.le.ac.uk/~cgp/f90course/f90.html">Fortran 90 for the Fortran 77 Programmer II</a>
<li><a href="http://wwwinfo.cern.ch/asdoc/f90.html">Fortran 90 Tutorials</a>
<li><a href="http://www.polyhedron.co.uk/compare/linux/f90bench_p4.html">Compiler Comparisons: Performance</a>
<li><a href="http://www.polyhedron.co.uk/compare/linux/diagnose.html">Compiler Comparisons: Diagnose Capabilities</a>
</ul>
</ul>
EOF
];

 my $perllinks = [
'Perl',
<< 'EOF'
<ul><li><a href="http://www.perl.com/">perl.com</a>:
 <a href="http://perldoc.perl.org/">documentation</a> en
 <a href="http://perldoc.perl.org/index-faq.html">FAQ</a>
<li><a href="http://perldoc.perl.org/index-functions.html">overzicht perl functies</a>
</ul>
EOF
];

 my $versiebeheerlinks = [
'Versiebeheer',
<< 'EOF'
<ul>
 <li><a href="http://wiht.link/CVS-resources">CVS</a>
 <li><a href="https://git-scm.com/">Git</a>
 <li><a href="http://subversion.apache.org/">Subversion</a>:
     <a href="http://svnbook.red-bean.com/">svnbook</a>
 <li><a href="http://en.wikipedia.org/wiki/Comparison_of_issue_tracking_systems">Vergelijking bij wikipedia</a>
</ul>
EOF
];

 my $overig = [
'Overig',
<< 'EOF'
<ul>
<li><a href="http://www.allenware.com/">demo-cursus Batch-files en HTML</a>
<li><a href="http://www.archive.org/">Way back machine</a>:
<a href="http://www.archive.org/web/*/http://www.xs4all.nl/~spee">mijn homepage daar</a>
<li><a href="https://mindprod.com/jgloss/unmain.html">How to write unmaintainable code</a>
<li><a href="http://www.squarebox.co.uk/javatips.html">Tips for maintainable Java code</a>
<li><a href="http://www.pha.jhu.edu/sysadmin/security/ssh-users.html">Getting started with SSH</a>
</ul>
EOF
];

 my $pout = [$html_js, $io_stds, $versiebeheerlinks, $perllinks, $f90, $overig];
 my $title = 'Bookmarks: Computers en internet';
 return maintxt2htmlpage($pout, $title, 'std', 20161012, {type1 => 'std_menu'});
}

sub get_actueel($)
{# (c) Edwin Spee

  my ($edition) = @_; # 'hopa' or 'media'

  my $fileWithPath = File::Spec->catfile(File::Spec->updir(), 'data', 'bookmarks', 'current.csv');
  my $links = read_csv_with_header($fileWithPath);

# datum gefixeerd om uit CVS te kunnen reproduceren:
  my $datum_fixed = get_datum_fixed();
  my ($yr, $deze_maand_fixed, $day) = split_idate($datum_fixed);
  my $deze_maand = 1+(localtime())[4];
  my $deze_mday  = (localtime())[3];
  $deze_maand_fixed += $day / 31;
  $deze_maand += $deze_mday / 31;

  if (($yr % 2) == 0 || $yr == 2021)
  {
    $yr = min(2020, $yr);
    my $EK_WK = $yr % 4;
    my $EK_WK_str = ($EK_WK ? 'WK' : 'EK');
    my $ekwk_url = "sport_voetbal_${EK_WK_str}_${yr}.html";
    my $webdir = get_webdir();
    my $voorronde = '_voorronde';
    if (-f File::Spec->catfile($webdir, $ekwk_url))
    {$voorronde = '';}
    $ekwk_url = "sport_voetbal_${EK_WK_str}_${yr}$voorronde.html";
    if (not -f File::Spec->catfile($webdir, $ekwk_url))
    # {shob_error('notfound', [$ekwk_url]);}
    {return '';}
    if ($edition eq 'media')
    {$ekwk_url = "$www_epsig_nl/$ekwk_url";}
    push @$links, {url => $ekwk_url, description => "$EK_WK_str-voetbal", date1 => 5.5, date2 => 7.5};
    if ($yr % 4 == 2)
    {
      my $ospage = "sport_schaatsen_OS_$yr.html";
      if (-f File::Spec->catfile($webdir, $ospage))
      {
        push @$links, {url => $ospage, description => 'Olymp. Winterspelen', date => 2.0, date => 3.3};
      }
    }
  }

  my $totaal = 0; my $totaal2 = 0;
  my $found_diff = 0;
  my $actueel = '';
  foreach my $rij (@$links)
  {
    my $in_between = ($rij->{date1} <= $deze_maand_fixed && $deze_maand_fixed <= $rij->{date2});
    $in_between = 1 if ($rij->{date2} > 13 and $deze_maand_fixed <= $rij->{date2} - 12);
    if ($in_between)
    {
      $totaal++;
      if (defined $rij->{url})
      {
        $actueel .= qq(<li><a href="$rij->{url}">$rij->{description}</a>\n);
      }
      else
      {
        $actueel .= qq(<li>$rij->{description}\n);
      }
      if ($rij->{description} =~ m/brexit/iso)
      {
        $actueel .= qq(over (onder voorbehoud): <div id="brexit"> </div>\n);
      }
    }
    elsif ($rij->{date1} <= $deze_maand && $deze_maand  <= $rij->{date2})
    {
      print "Skipping: $rij->[1]\n";
      $found_diff = 1;
    }
  }

  if ($found_diff and $edition ne 'media' and not get_history())
  {
    print "Datum in bookmarks-media is niet up-to-date! Druk op ENTER.\n";
    lees_stdin;
  }

  if ($totaal == 0)
  {
    $actueel = "<li>geen grote evenementen deze maand.\n";
  }

  return $actueel;
}

sub get_bkmrks_media()
{# (c) Edwin Spee

my $actueel = get_actueel('media');

my $tt101 = ttlink(101, 'NOS Teletekst');
my $out = << "EOF";
<table>
<tr> <td valign=top> <center> <b> Het laatste nieuws </b> </center>
<ul>
 <li> $tt101
 <li><a href="http://www.rtlnieuws.nl/">RTL Nieuws</a>
 <li><a href="http://www.omroep.nl/nos/nieuws/">NOS Nieuws: hoofdpunten</a>
 <li><a href="http://www.text.nl/">Teletekst RTL4, 5 en Yorin</a>
 <li><a href="http://www.vrt.be/">Vlaamse Radio- en TV</a>
 <li><a href="http://news.bbc.co.uk/">BBC News</a>
 <li><a href="http://www.cnn.com/">CNN</a>
 <li><a href="http://dailynews.yahoo.com/">Yahoo</a>
 <li><a href="http://news.lycos.com/headlines/TopNews/">Lycos</a>
 <li><a href="http://www.anp.nl/">ANP</a>
</ul>
<td valign=top> <center> <b>Kalender / Actueel</b> </center>
<ul>
$actueel</ul>
<td valign=top> <center> <b>Divers</b> </center>
<ul>
 <li><a href="http://www.planet.nl/multimedia/">Planet Multimedia</a>
 <li><a href="http://www.webwereld.nl/">WebWereld</a>
 <li><a href="http://www.jorislange.nl/media/">Adressen Nederlandse media</a>
 <li><a href="http://www.eurotv.com/">The most complete European TV Guide Web</a>
 <li><a href="http://www.radiowereld.nl/">www.radiowereld.nl</a>
 <li><a href="http://www.amibo.demon.nl/juinen/">Juiner Courant</a>
</ul>
<tr> <td valign=top> <center> <b>Kranten op Internet</b> </center>
<ul>
 <li><a href="http://www.volkskrant.nl/">De Volkskrant</a>
 <li><a href="http://www.nrc.nl/">NRC</a>
 <li><a href="http://www.trouw.nl/">Trouw</a>
 <li><a href="http://www.ad.nl/">Algemeen Dagblad</a>
 <li><a href="http://www.sdu.nl/staatscourant/vandaag/">Staatscourant</a>
 <li><a href="http://www.telegraaf.nl/">De Telegraaf</a>
 <li><a href="http://www.gelderlander.nl/">De Gelderlander</a>
 <li><a href="http://www.leidschdagblad.nl/">Leidsch Dagblad</a>
 <li><a href="http://www.eindhovensdagblad.nl/">Eindhovens Dagblad</a>
 <li><a href="http://www.rotterdamsdagblad.nl/">Rotterdams Dagblad</a>
 <li><a href="http://www.stem.nl/">Dagblad De Stem</a>
</ul>
<td valign=top> <center> <b>TV</b> </center>
<ul>
 <li>De Nederlandse <a href="http://www.omroep.nl/">Publieke Omroep</a>
 <li><a href="http://www.rtl4.nl/">RTL 4</a>
 <li><a href="http://www.rtl5.nl/">RTL 5</a>
 <li><a href="http://www.yorin.nl/">Yorin</a>
 <li><a href="http://www.sbs6.nl/">SBS 6</a>
 <li><a href="http://www.tmf.nl/">TMF</a>
 <li><a href="http://www.foxtv.nl/">Fox TV</a>
 <li><a href="http://www.sire.nl/">SIRE</a>
</ul>
</td>
<td valign=top> <center> <b>Radio</b> </center>
<ul>
 <li><a href="http://www.concertzender.nl/">Concertzender</a>
 <li><a href="http://www.skyradio.nl/">Sky Radio</a>
 <!-- <li><a href="http://www.veronica.nl/veronicafm/">Radio Veronica</a> -->
 <li><a href="http://www.radio538.nl/">Radio 538</a>
 <li><a href="http://www.radio10.nl/">Radio 10 FM</a>
 <li><a href="http://www.radio-noordzee.nl/">Radio Noordzee Nationaal</a>
</ul>
</tr>
</table>
EOF
return maintxt2htmlpage(bespaar_bandbreedte($out), 'Bookmarks: media', 'title2h1',
 get_datum_fixed(), {type1 => 'std_menu'});
}

sub get_bkmrks_milieu()
{# (c) Edwin Spee
 # versie 1.0 19-aug-2003 initiele versie

my $tt711 = ttlink(711, 'Actuele smog voorspelling');
my $out = << "EOF";
<table>
<tr> <th> Algemeen </th> <th> Onderzoek </th> </tr>
<tr> <td valign=top>
<ul>
 <li><a href="http://www.knmi.nl/">KNMI</a>:
     <a href="http://www.knmi.nl/voorl/weer/aktueel.html">weer vandaag</a>,
     <a href="http://www.knmi.nl/voorl/weer/verwachting.html">overzicht</a>,
     <a href="http://www.knmi.nl/voorl/weer/meerdaagse.html">lange termijn</a> en
     <a href="http://www.knmi.nl/voorl/weer/extreem.html">extremen</a>
 <li><a href="http://weerkamer.nl/radar/">Radarbeelden (regenbuien)</a>
 <li> $tt711
 <li><a href="http://www.meteocon.nl/">Meteo Consult</a>
 <li><a href="http://www.rivm.nl/">RIVM</a>
 <li><a href="http://www.milieuloket.nl/">www.milieuloket.nl</a>
 <li><a href="http://www.milieuonline.nl/">www.milieuonline.nl</a>
 <li><a href="http://www.fema.gov/fema/trop.htm">FEMA - Tropical Storm and Hurricane Watch Information</a>
 <li><a href="http://www.nhc.noaa.gov/products.html">National Hurricane Center</a>
 <li><a href="http://earthsystems.org/Environment.shtml">The World-Wide Web Virtual Library: Environment</a>
 <li><a href="http://www.geo.ucalgary.ca/VL-EarthSciences.html">The World-Wide Web Virtual Library: Earth Sciences</a>
 <li><a href="http://www.ugems.psu.edu/~owens/WWW_Virtual_Library/">The World-Wide Web Virtual Library: Meteorology</a>
 <li><a href="http://www.envirolink.org/">Environmental Web Resources</a>
</ul>
</td>
<td valign=top>
<ul>
 <li><a href="http://www.phys.uu.nl/~wwwimau/">The Institute for Marine and Atmospheric research Utrecht (IMAU)</a>
 <li><a href="http://www.nop.nl/">NOP: Nationaal Onderzoek Programma Mondiale Luchtverontreiniging en Klimaatverandering</a>
 <li><a href="http://www.sron.nl/divisions/eos/">Earth Oriented Science Division</a> (EOS at SRON, RU Utrecht)
 <li><a href="http://www.cwi.nl/~gollum/MaE.html">CWI Research Program Mathematics & the Environment</a>
 <li><a href="http://www.ucar.edu/">NCAR</a> (National Centre for Atmospheric Research, Boulder, Co, USA)
 <li><a href="http://www.dkrz.de/">Deutsches Klimarechenzentrum</a>
 <li><a href="http://www.mep.tno.nl/">TNO Institute of Environmental Sciences, Energy Research and Process Innovation </a>
</ul>
</td> </tr>

<tr> <th> Tijdschriften </th> <th> Organisaties </th> </tr>
<tr> <td valign=top>
<ul>
 <li><a href="http://www.nature.com/">Nature</a>
 <li><a href="http://www.elsevier.nl/locate/atmosenv">Atmospheric Environment</a>
 <li><a href="http://www.agu.org/pubs/jgrcntrb.html">Journal of Geophysical Research</a>
</ul>
</td>
<td valign=top>
<ul>
 <li><a href="http://www.greenpeace.org/">Greenpeace</a>
 <li><a href="http://www.panda.org/">WWF (World Wildlife Fund)</a>,
     <a href="http://www.wnf.nl/">Wereld Natuurfonds (WNF)</a>
 <li><a href="http://www.milieudefensie.nl/">www.milieudefensie.nl</a>
 <li><a href="http://www.milieunet.nl/">www.milieunet.nl</a>
 <li><a href="http://www.xs4all.nl/~foeint/">Friends of the earth International</a>
 <li><a href="http://www.sociamedia.nl/agenda.html">Aktie agenda (omslag)</a>
 <li><a href="http://www.pz.nl/dekleineaarde/">Stichting de kleine aarde</a>
</ul>
</td> </tr>
<tr> <th colspan=2 align=center>
Milieuvriendelijk transport: de fiets </th> </tr>
<tr> <td colspan=2 align=center>
<ul>
 <li><a href="http://www.fietsnet.nl/">www.fietsnet.nl</a>
 <li><a href="http://www.fietsrai.nl/">www.fietsrai.nl</a>
 <li><a href="http://www.batavus.com/">www.batavus.com</a>
 <li><a href="http://www.gazelle.nl/">www.gazelle.nl</a>
</ul>
</td> </tr>
</table>
EOF
return maintxt2htmlpage(bespaar_bandbreedte($out), 'Bookmarks: Meteorologie en Milieu',
 'title2h1', 20030819, {type1 => 'std_menu'});
}

sub get_bkmrks_science()
{# (c) Edwin Spee

 my $tt777 = ttlink(777, 'Wereldklok');
 my $out = << "EOF";
<ul>
 <li><a href="http://www.xs4all.nl/~carlkop/astronet.html">Astronet</a>
 <li><a href="http://www.eswo.org/astro/">ESWO - Astro site (incl. kalender)</a>
 <li><a href="http://umbra.nascom.nasa.gov/eclipse/">Zonsverduisteringen</a>
 <li><a href="http://riemann.usno.navy.mil/AA/data/docs/UpcomingEclipses.html">Zon- en Maansverduisteringen</a>
 <li><a href="http://spaceflight.nasa.gov/">NASA spaceflight</a>
 <li><a href="http://seds.lpl.arizona.edu/nineplanets/nineplanets/">The nine planets</a>
 <li><a href="http://www.ee.ryerson.ca:8080/~elf/abacus/">Abacus (telraam)</a>
 <li><a href="http://www.nnv.nl/">Natuurkunde nieuws (NNV)</a>
 <li><a href="http://natuurkunde.pagina.nl/">natuurkunde.pagina.nl</a>
 <li><a href="http://www.amara.com/science/science.html">Amara's Science Links</a>
 <li><a href="http://physics.nist.gov/cuu/">SI eenheden</a>
 <li><a href="http://evlweb.eecs.uic.edu/EVL/supercomp/WAVE/EINSTEIN.html">Realitiviteis theorie</a>
 <li><a href="http://www.cs.cmu.edu/afs/cs.cmu.edu/user/mleone/web/how-to.html">Advice on Research and Writing</a>
 <ul>
  <li><a href="ftp://parcftp.xerox.com/pub/popl96/vanLeunenLipton">How to have your abstract rejected</a>
 </ul>
 <li><a href="http://www.cs.indiana.edu/mit.research.how.to/section3.13.html">Emotional factors</a>
 <li> $tt777 lokale tijden.
 <li><a href="http://www.timeanddate.com/">Tijd en datum</a>
 <li><a href="http://mapweb.parc.xerox.com/map/">Zoom-world-map</a>,
     <a href="http://www.indo.com/distance/">How far is it?</a>
 <li><a href="http://www.s9.com/biography/">Biographical Dictionary</a>
</ul>
EOF
 return maintxt2htmlpage($out, 'Bookmarks: wetenschap', 'title2h1', 20070802, {type1 => 'std_menu'});
}

sub get_bkmrks_treinen
{# (c) Edwin Spee

 my $tt751 = ttlink(751, 'actueel');

 my $reisplanner = [
'reisplanners',
<< "EOF"
<ul>
 <li> <a href="http://www.ns.nl/">NS reisplanner</a>
 <li> <a href="https://9292.nl/">9292.nl: OV reis info</a>
 <li> <a href="http://bahn.hafas.de/">Duitse internationale reisplanner</a>
 <li> Actuele NS info via NOS-TT: $tt751.
</ul>
EOF
];

 my $spoorbedrijven = [
'spoorwegbedrijven (reizigers)',
<< 'EOF'
<ul>
 <li> NL: <a href="https://www.ns.nl/">NS</a>,
          <a href="https://www.keolis.nl/">Keolis (vh. Syntus)</a>
 <li>  B: <a href="http://www.belgianrail.be/">NMBS-SNCB</a>
 <li>  D: <a href="http://www.bahn.de/">Deutsche Bahn</a>
 <li> FR: <a href="https://www.sncf.fr/">SNCF</a>
 <li> CH: <a href="https://www.sbb.ch/">SBB</a>
 <li> UK: <a href="http://www.rail.co.uk/">Rail</a>,
          <a href="http://www.britrail.com/">BritRail</a>,
          <a href="https://www.scotrail.co.uk/">ScotRail</a>
 <li> EU: <a href="http://www.thalys.com/">thalys</a>,
          <a href="http://www.eurotunnel.com/">eurotunnel</a>
</ul>
EOF
];

 my $lightrail = [
'light rail',
<< 'EOF'
<ul>
 <li><a href="https://www.ret.nl/">RET (Rotterdam)</a>
 <li><a href="https://www.amsterdam.nl/noordzuidlijn/">Noord-Zuidlijn Amsterdam</a>
 <li><a href="http://www.lightrail.nl/">www.lightrail.nl</a>
 <li><a href="http://www.lightrail.nl/lightrailatlas/index-english.htm">Light Rail Atlas</a>
 <li><a href="http://subway.umka.org/">Subway maps</a>
 <li><a href="https://www.ratp.fr/">Metro Parijs</a>
</ul>
EOF
];

 my $nw_infra = [
'nieuwe infrastructuur',
<< 'EOF'
<ul>
 <li><a href="http://www.infrasite.nl/">infrasite.nl</a>
 <li><a href="http://www.prorail.nl/">Prorail (-> publiek)</a>
</ul>
EOF
];

 my $rest1 = [
'overige trein-sites-I',
<< 'EOF'
<ul>
 <li><a href="https://www.ns.nl/deur-tot-deur/ov-fiets/">OV-Fiets</a>
 <li><a href="http://www.connexxion.nl/">ConneXXion</a>
 <li><a href="http://www.haaglanden.nl/">Haaglanden</a>
 <li><a href="http://ov-wereld.pagina.nl/">ov-wereld.pagina.nl</a>
 <li><a href="https://trein.startpagina.nl/">trein.startpagina.nl</a>
 <li><a href="https://www.rover.nl/">Rover</a>
 <li><a href="http://www.railfaneurope.net/">European Railway Server / Rail fan Europe</a>
 <li><a href="https://railmagazine.nl/">Rail Magazine</a>
</ul>
EOF
];

 my $rest2 = [
'overige trein-sites-II',
<< 'EOF'
<ul>
 <li><a href="http://www.railforum.nl/">Railforum</a>
 <li><a href="http://www.verkeerskunde.com/">vakblad Verkeerskunde</a>
 <li><a href="http://www.railway-technology.com">www.railway-technology.com</a>
 <li><a href="http://www.eurail.com/">Europe by rail</a>
 <li><a href="http://bemorail.nl">Bemo Rail BV</a>
</ul>
EOF
];

 my $pout = [$reisplanner, $nw_infra, $lightrail, $spoorbedrijven, $rest1, $rest2];
 my $title = 'Bookmarks: treinen';
 return maintxt2htmlpage($pout, $title, 'std', 20180527, {type1 => 'std_menu'});
}

return 1;
