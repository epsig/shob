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
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_bkmrks',
 '&get_bkmrks_geld',
 '&get_bkmrks_html',
 '&get_actueel',
 '&get_bkmrks_media',
 '&get_bkmrks_milieu',
 '&get_bkmrks_overheid',
 '&get_bkmrks_science',
 '&get_bkmrks_treinen',
 #========================================================================
);

sub kopA()
{# (c) Edwin Spee

 my $tt101 = ttlink(101, 'NOS Teletekst', 'tekst');
 return << "EOF";
<tr> <th colspan=2 class=h> Handige plekken op het Nederlandse deel van Internet </th></tr>
<tr> <td colspan=2 class=c>
<h2> $tt101,
<a href="http://www.nu.nl/">Nu.nl</a> </h2>
<h2> <a href="http://www.detelefoongids.nl/">Telefoonboek</a> &amp;
<a href="http://www.tpgpost.nl/zoeken/">Postcodeboek</a>
<br> <a href="http://www.lokatienet.nl/">lokatienet</a> &amp;
<a href="http://www.routenet.nl/">routenet</a> /
<a href="http://route.anwb.nl/">routeplanner ANWB</a> </h2>
<h2> <a href="https://www.ns.nl/">NS reisplanner</a> ;
<a href="https://9292.nl/">OV reis info</a> ;
<a href="http://www.anwb.nl/servlet/Satellite?pagename=OpenMarket/ANWB_verkeer/Entree">File info ANWB</a> </h2> </td></tr>
EOF
}

sub kopB($)
{# (c) Edwin Spee

 my ($type) = @_;

 my $out = << 'EOF';
<tr> <th colspan=2 class=h> Startpunten </th></tr>
<tr> <td> <h2> Portals </h2>
<a href="http://www.startpagina.nl/">Startpagina</a>
| <a href="http://www.directie.nl/">Directie</a>
| <a href="http://www.startlinks.nl/">Startlinks</a>
| <a href="http://www.track.nl/">Track</a>
<br> <a href="http://www.markt.nl/">Markt</a>
| <a href="http://www.lycos.nl/">Lycos</a>
| <a href="http://www.excite.com/">Excite</a>
| <a href="http://www.yahoo.com/">Yahoo !</a>
| <a href="http://www.altavista.nl/">Alta Vista</a> </td>
<td> <h2> Divers </h2>
<a href="http://www.lekkerweg.nl/">Welcome to Holland</a>
| <a href="http://www.vtourist.com/">Virtual Tourist</a>
<br> <a href="http://www.ibiblio.org/wm/">WebMuseum</a>
| <a href="http://www.vlib.org/">Virtual Library</a>
| <a href="https://www.cia.gov/library/publications/the-world-factbook">CIA Factbook </a> </td> </tr>
<tr> <td> <h2> Providers </h2>
<a href="http://www.xs4all.nl/">XS4ALL</a>
| <a href="http://www.planet.nl/">Planet</a>
| <a href="http://www.hetnet.nl/">Het Net</a>
| <a href="http://www.freeler.nl/">Freeler</a>
| <a href="http://www.tiscali.nl/">Tiscali</a> </td>
<td> <h2> Op deze site </h2>
EOF
if ($type == 0)
{$out .= << "EOF";
 <a href="sport.html">Sport</a> ,
 <a href="tmp_bookmarks_geld.html">geld</a> ,
 <a href="bookmarks_media.html">media</a> ,
 <a href="bookmarks_treinen.html">treinen</a> ,
 <a href="tmp_bookmarks_milieu.html">milieu</a> ,
 <a href="tmp_bookmarks_science.html">wetenschap</a>,
 <a href="tmp_bookmarks_overheid.html">overheid</a>
&amp;
 <a href="bookmarks_computers.html">computers en internet</a> </td> </tr>
EOF
}
elsif ($type == 2)
{$out .= << "EOF";
 <a href="overzicht.html">Overzicht</a> ,
 <a href="sport.html">sport</a> ,
 <a href="tmp_bookmarks_geld.html">geld</a> ,
 <a href="bookmarks_media.html">media</a> ,
 <a href="bookmarks_treinen.html">treinen</a> ,
 <a href="tmp_bookmarks_milieu.html">milieu</a> ,
 <br>
 <a href="$www_xs4all_nl_spee/p-b/index.html">index politiek</a>,
 <a href="tmp_bookmarks_science.html">wetenschap</a>,
 <a href="tmp_bookmarks_overheid.html">overheid</a>
&amp;
 <a href="bookmarks_computers.html">computers en internet</a> </td> </tr>
EOF
}
else
{$out .= << "EOF";
 <a href="sport.html">Sport</a> ,
 <a href="overzicht.html">overzicht</a> ,
 <a href="$www_xs4all_nl_spee/p-b/index.html">index politiek</a>,
 <a href="bookmarks_media.html">media</a>,
 <a href="bookmarks_treinen.html">treinen</a>
&amp;
 <a href="bookmarks_computers.html">computers en internet</a>
</td> </tr>
EOF
}
$out .= << 'EOF';
<tr> <th colspan=2 class=h> Direct zoeken </th></tr>
<tr> <td> <form action="http://www.google.nl/search" name=f>
<input maxLength=256 size=35 name=q value="">
<input type=hidden name=ie value="UTF-8">
<input type=hidden name=oe value="UTF-8">
<input name=hl type=hidden value=nl>
<input type=submit value="Google" name=btnG>
<input type="reset" value="wis">
<input type=hidden name=lr value="">
</form> </td>
<td> <form method=GET action="http://www.ilse.nl/searchresults.dbl">
<input name="search_for" size=35>
<input type="submit" value="Ilse">
<input type="reset" value="wis">
</form> </td> </tr>
<tr> <td> <form method=GET action="http://nl.altavista.com/q">
 <input type="hidden" name=pg value=q>
 <input name=q size=35 maxlength=200 value="">
 <input name=kl value=XX type="hidden">
 <input name=what value=web type="hidden">
 <input type="submit" VALUE="Alta Vista">
 <input type="reset" value="wis">
</form> </td>
<td> <form method=GET action="http://www.lycos.nl/cgi-bin/pursuit">
 <input size=35 type="text" name="query">
 <input type="submit" value="Lycos">
 <input type="reset" value="wis">
</form>
</td> </tr>
EOF
## <!-- <form method=GET action="http://search.yahoo.com/bin/search">
##  <input size=35 name=p>
##  <input type="submit" value="Yahoo!">
##  <input type="reset" value="wis">
## </form> -->
return $out;
}

sub prive()
{# (c) Edwin Spee

 my $familie_fotos = "fotoalbum/index.html";
 my $citrix_link = 'https://webaccess.minvenw.nl/rikz';
 if (get_host_id() eq 'werk')
 {$citrix_link    = 'http://kzdlic.rikz.rws.minvenw.nl/';
  $familie_fotos  = 'http://www.epsig.nl/fotoalbum/';}

 return << "EOF";
<tr> <th colspan=2 class=h> Priv&eacute; </th></tr>
<tr> <td> <ul>
<li> <a href="http://www.amnesty.nl/">www.amnesty.nl</a>:
<a href="http://www.amnesty.nl/schrijf.htm">schrijven</a>,
<a href="http://www.amnesty.nl/rsvp.htm">RSVP</a>.
<li><a href="http://www.vandale.nl/redir/woordenboek.htm">Van Dale Lexicografie bv</a>
<li><a href="http://www.britannica.com/">Britannica.co.uk Ltd</a>
<li><a href="$www_epsig_nl/klaverjas_faq.html">klaverjassen</a>
</ul> </td>
<td> <ul>
<li> <a href="$citrix_link">Telewerken RIKZ</a> |
<a href="https://webmail.xs4all.nl/">WebMail</a> |
<a href="https://service.xs4all.nl/">self-service</a>
<li><a href="$familie_fotos">Familie-fotoos</a>
<li>
<a href="http://www.lachvandedag.com/">lachvandedag.com</a>
| <a href="http://www.moppen.com/">moppen.com</a>
| <a href="http://www.humor.nl/">humor.nl</a>
</ul> </tr>
EOF
}

sub werk1()
{# (c) Edwin Spee

return <<'EOF';
<tr> <th colspan=2 class=h> RWS / RIKZ </th></tr>
<tr> <td>
<ul>
<li>RIKZ: <a href="http://www.rikz.nl/">internet</a> en
<a href="http://intranet.rijkswaterstaat.nl/wd">intranet</a>
<li> Deltares:
 <a href="http://www.deltares.nl/">homepage</a>,
 <a href="http://smoelenboek.deltares.nl/">smoelenboek</a> en
 <a href="http://deltadesk.sharepointsite.com/welkom.aspx">delta-desk</a>
</li>
<li> SIMONA HoPa:
<a href="http://www.helpdeskwater.nl/waqua/">internet</a>,
<li> <a href="http://www.rws-atlantis.nl/">Atlantis</a>
| <a href="http://donar.minvenw.nl:8080/Naut/home.html">Nautilus ingang Donar</a>

<li> <a href="http://matroos.rikz.rws.minvenw.nl/">Matroos</a>
| <a href="http://matroos2.rikz.rws.minvenw.nl/mapbender/frames/login.php">matroos: geo-ingang</a>
|
EOF
}

sub werk4($)
{# (c) Edwin Spee

my $type = $_[0];
my $x = <<'EOF';
<li><a href="http://www.waterbase.nl/">Waterbase</a>
EOF
my $s = qq(</ul></td><td><ul>\n);
if ($type == 2) {$x .= $s;}
$x .= qq(<li><a href="http://intranet.minvenw.nl/">intranet-home</a> | \n) .
 qq(<a href="http://www.startpagina.sap.minvenw.nl/">SAP</a>\n);
if ($type == 1) {$x .= $s;}
$x .= <<'EOF';
<li><a href="http://adresgids.venwnet.minvenw.nl/">adresgids</a>
<li><a href="http://intranet.rijkswaterstaat.nl/knmi/home/">KNMI</a>
<li><a href="http://www.trendsinwater.nl/">Trends in water</a>
<li><a href="http://www.haringvlietsluizen.nl/">Haringvlietsluizen</a>
<li>
 <a href="http://kennisplein.venwnet.minvenw.nl/">kennisplein.venwnet.minvenw.nl</a> |
 <a href="http://intra.ryx.nl/nieuws/bladeren.phtm?bron=dagbladen">Bladeren door kranten</a>
<li><a href="http://www.cf.ac.uk/engin/news/confs/hydro/">hydroinfomatics</a>
</ul></td></tr>
EOF
return $x;
}

sub get_bkmrks($)
{# (c) Edwin Spee

 my $type = $_[0];

 my $is_werk = $type =~ m/werk/iso;

 my ($typenr, $index, $prive, $werk_unix, $werk_pc) = (0, 0, 1, 2, 3);
 if    ($type =~ m/index/iso) {$typenr = $index;}
 elsif ($type =~ m/prive/iso) {$typenr = $prive;}
 elsif ($type =~ m/unix/iso)  {$typenr = $werk_unix;}
 else                         {$typenr = $werk_pc;}

 my @dd = (20080912, 20081228, 20080912, 20081228);

 my $skip = ($typenr == $index ? 3 : -1);
 my $footer = ftr ( ftd({cols=>2, class=>'c'},
  menu_bottum('./', $skip, 3, $dd[$typenr], 0 )))
  . "</table> \n";
 my $out = '<table width="100%">';
 if ($typenr == $index)
 {$out .= kopA() . kopB(0);}
 elsif ($typenr == $prive )
 {$out .= kopA() . kopB(2) . prive();}
 elsif ($typenr == $werk_unix )
 {$out .= kopA() . werk1() . werk4(1) . kopB(1) . prive();}
 else
 {
  my $werk2 =
qq(<li><a href="file:///\\\\gwdcfa/programs/matlab.53/help/helpdesk.html">MATLAB helpdesk</a>\n);
  $out .= kopA() . werk1() . $werk2 . werk4(2) . kopB(1) . prive();
 }

return maintxt2htmlpage($out, $typenr >= $werk_unix ?  'Startpagina' : 'Startpunten', 'std',
 -1, {mymenu => $footer});
}

sub get_bkmrks_geld()
{# (c) Edwin Spee

my $tt501 = ttlink(501, 'financieel nieuws', 'tekst');
my $tt502 = ttlink(502, 'indices', 'tekst');
my $tt504 = ttlink(504, 'stemming Damrak', 'tekst');
my $out = << "EOF";
<ul>
<h2> <li>Vacatures </h2>
<a href="http://www.intermediair.nl/">Intermediair</a>
| <a href="http://www.jobnews.nl/">Jobnews</a>
| <a href="http://www.monsterboard.nl/">Monsterboard.nl</a>
| <a href="http://www.executivesonly.nl/">executivesonly.nl</a>
| <a href="http://vacature.overzicht.nl/">vacature.overzicht.nl</a>

<h2> <li>On-line winkels </h2>
<a href="http://www.nl.bol.com/">bol.com</a>
| <a href="http://www.shop.nl/">shop.nl</a>
| <a href="http://www.proxis.nl/">proxis.nl</a>
| <a href="http://www.davista.nl/">davista.nl</a>
| <a href="http://www.amazon.com/">amazon</a>
| <a href="http://www.letsbuyit.nl/">Letsbuyit</a>

<h2> <li>On-line veilingen </h2>
<a href="http://www.ibazar.nl/">ibazar</a>
| <a href="http://www.ricardo.nl/">ricardo</a>

<h2> <li>Banken </h2>
<a href="http://www.abnamro.nl/">ABN-AMRO</a>
| <a href="http://www.gwk.nl/">GWK</a>
| <a href="http://www.ing.nl/">ING</a>
| <a href="http://www.rabobank.nl/">Rabobank</a>
| <a href="http://www.snsbank.nl/">SNS Bank</a>
<br>
Groen sparen:
<a href="http://www.asnbank.nl/">ASN Bank</a> en
<a href="http://www.triodos.nl/">Triodos Bank</a>

<h2> <li>Effectenbeurs </h2>
<a href="http://www.euronext.com/">EuroNext</a>
<br>
<a href="http://www.behr.nl/cgi-bin/pp?ppix=1&showap=0">Persoonlijk Portefeuille</a>
<br>
<a href="http://www.behr.nl/Beurs/Fondsh/">Grafiek slotkoersen</a>
<br>
NOS-Teletekst: $tt501, $tt502 en $tt504
<br> <a href="http://pacific.commerce.ubc.ca/xr/data.html">Historische wisselkoersen</a>

<h2> <li>Overig </h2>
<a href="http://www.eurodiffusie.nl/Content/herkennen.php">Afbeeldingen op de Euro-munten</a>
<br>
<a href="http://www.cbf-keur.nl/instelling.html">Goede doelen met cbf-keur</a>
</ul>
EOF
return maintxt2htmlpage($out, 'Bookmarks: Geldzaken', 'title2h1', 20110411, {type1 => 'std_menu'});
}

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
<li><a href="http://mindprod.com/unmain.html">How to write unmaintainable code</a>
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

 my $links = [
['https://www.google.com/search?q=corona', 'Corona',1,13],
['https://www.bbc.com/news/politics/uk_leaves_the_eu', 'Einde overgangsperiode Brexit',1,13],
#['http://www.wimbledon.org/','Wimbledon', 6, 7.3],
['http://www.letour.fr/','Tour de France', 8.5, 10], #6.8, 8
#['http://www.ilgiroditalia.nl/', "Giro d'Italia", 5, 6.2], # met 1e week juni
['http://www.nostour.nl/','Tour de France (NOS)', 8.5, 10], #6.8, 8
['http://valentijnsdag.pagina.nl/','14 feb Valentijnsdag', 2.3, 2.8],
#['https://www.verkiezingen2015.nl/', '18 maart Staten-verkiezingen', 3, 4],
['http://www.knsb.nl/', 'Schaatsen: EK/WK sprint/all-round', 1, 3.9], # tot half maart
#[ ttlink(434,'', 'tekst'), 'Toertochten op NOS Teletekst', 1, 2.9],
['http://www.ausopen.org/','Australian Open', 1, 2],
['http://www.4en5mei.nl/','vier en vijf mei', 4.7, 5.5],
#['http://www.examenblad.nl/','Eindexamens', 5.5, 6.3],
#['http://www.rolandgarros.org/','Roland Garros', 4.7, 6.4],
#['http://www.nocnsf.nl/london2012','Olympische Zomerspelen Londen', 7.5, 8.9],
#['http://www.sport.be/binckbanktour/','Ronde van Belgi&euml; en Nederland', 8, 9],
['http://www.usopen.org/','US Open', 8.5, 9.5],
['http://prinsjesdag.minfin.nl/','Prinsjesdag', 9.25, 9.9],
['http://www.lavuelta.com/','Vuelta (Ronde van Spanje)', 9, 9.9],
#['http://www.koorhemelsbreed.nl/agenda.html', 'Najaarsconcert van oa Hemelsbreed', 11, 12],
['http://sinterklaas.pagina.nl/','5 december Sinterklaas', 11.3, 12.3],
['http://kerst.pagina.nl/','25-26 december Kerstfeest', 12.5, 13],
['http://kerst.pagina.nl/','25-26 december Kerstfeest', 0, 0.3]]; #TODO op een regel kunnen opgeven

# datum gefixeerd om uit CVS te kunnen reproduceren:
 my $datum_fixed = get_datum_fixed();
 my ($yr, $deze_maand_fixed, $day) = split_idate($datum_fixed);
 my $deze_maand = 1+(localtime())[4];
 my $deze_mday  = (localtime())[3];
 $deze_maand_fixed += $day / 31;
 $deze_maand += $deze_mday / 31;

 if ($yr != 2020 and not ($yr % 2))
 {
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
  push @$links, [$ekwk_url, "$EK_WK_str-voetbal", 5.5, 7.5];
  if ($yr % 4 == 2)
  {
   my $ospage = "sport_schaatsen_OS_$yr.html";
   if (-f File::Spec->catfile($webdir, $ospage))
   {push @$links, [$ospage, 'Olymp. Winterspelen', 2.0, 3.3];}
  }
 }

 my $totaal = 0; my $totaal2 = 0;
 my $found_diff = 0;
 my $actueel = '';
 foreach my $rij (@$links)
 {
  if ($rij->[2] <= $deze_maand_fixed && $deze_maand_fixed <= $rij->[3])
  {
   $totaal++;
   my ($url, $descr, undef, undef) = @$rij;
   $actueel .= qq(<li><a href="$url">$descr</a>\n);
   if ($descr =~ m/brexit/iso)
   {$actueel .= qq(over (onder voorbehoud): <div id="brexit"> </div>\n);}
  }
  elsif ($rij->[2] <= $deze_maand && $deze_maand  <= $rij->[3])
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
 {$actueel = "<li>geen grote evenementen deze maand.\n";
 }
 return $actueel;
}

sub get_bkmrks_media()
{# (c) Edwin Spee

my $actueel = get_actueel('media');

my $tt101 = ttlink(101, 'NOS Teletekst', 'tekst');
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

my $tt711 = ttlink(711, 'Actuele smog voorspelling', 'gif');
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

sub get_bkmrks_overheid()
{# (c) Edwin Spee

my $out = << 'EOF';
<ul>
 <li>De ministeries:
  <a href="http://www.minaz.nl/">Algemene Z.</a>
  | <a href="http://www.minocw.nl/">Onderwijs</a>
  | <a href="http://www.minez.nl/">Economische Z.</a>
  | <a href="http://www.minvenw.nl/">Verkeer en Waterstaat</a>
  | <a href="http://www.minvrom.nl/">VROM</a>
  | <a href="http://www.minbzk.nl/">Binnenlandse Z.</a>
  | <a href="http://www.minbuza.nl/">Buitenlandse Z.</a>
  | <a href="http://www.minvws.nl/">VWS</a>
  | <a href="http://www.mindef.nl/">Defensie</a>
  | <a href="http://www.minjust.nl/">Justitie</a>
  | <a href="http://www.minfin.nl/">Financi&euml;n</a>
  | <a href="http://www.minlnv.nl/">Landbouw</a>
 <li>Politieke partijen:
  | <a href="http://www.cda.nl/">CDA</a>
  | <a href="http://www.christenunie.nl/">ChristenUnie (GVP &amp; RPF)</a>
  | <a href="http://www.d66.nl/">D66</a>
  | <a href="http://www.groenlinks.nl/">Groenlinks</a>
  | <a href="http://www.pvda.nl/">PvdA</a>
  | <a href="http://www.sp.nl/">Socialistische Partij (SP)</a>
  | <a href="http://www.vvd.nl/">VVD</a>
 <li><a href="http://www.parlement.com/">parlement.com</a>
 <li><a href="http://www.parlement.nl/">Parlement</a>:
  <a href="http://www.eerstekamer.nl/">Eerste Kamer</a>,
  <a href="http://www.tweede-kamer.nl/">Tweede Kamer</a> en
  <a href="http://www.regering.nl/">Regering.nl</a>.
 <li><a href="http://www.overheid.nl/">Overheid.nl</a>
 <li><a href="http://www.koninklijkhuis.nl/">Koninklijk Huis</a>
 <li><a href="http://www.postbus51.nl/">Postbus 51</a>
 <li> onderdelen ministeries:
  <ul>
   <li><a href="http://www.minocw.nl/spelling/">De nieuwe spelling</a>
   <li><a href="http://www.studiefinanciering.nl/">Studiefinanciering</a>
   <li><a href="http://www.openbaarministerie.nl/">www.openbaarministerie.nl</a>
   <li><a href="http://www.meldpunt.org/">Internet Meldpunt Kinderpornografie</a>
   <li><a href="http://www.belastingdienst.nl/">Belastingdienst</a>
  </ul>
 <li><a href="http://www.archief.nl/">Rijksarchiefdienst</a>
 <li><a href="http://www.ol2000.nl/">het Overheidsloket 2000</a>
 <li><a href="http://www.awt.nl/">De Adviesraad voor het Wetenschaps- en Technologiebeleid (AWT)</a>
 <li><a href="http://www.eur.nl/frg/grondwet.html">Grondwet voor het Koninkrijk der Nederlanden</a>
 <li><a href="http://wettenbank.sdu.nl/">wettenbank.sdu.nl</a>
 <li><a href="http://www.wetten.nu/">Nederlandse wet- en regelgeving</a>
 <li><a href="http://www.sdu.nl/">SDU</a>
 <li><a href="http://www.sdu.nl/staatscourant/vandaag/">Staatscourant</a>
 <li><a href="http://www.amsterdam.nl/">Gemeente Amsterdam</a>
</ul>
EOF
return maintxt2htmlpage($out, 'Bookmarks: politiek en overheid', 'title2h1',
 20031209, {type1 => 'std_menu'});
}

sub get_bkmrks_science()
{# (c) Edwin Spee

 my $tt777 = ttlink(777, 'Wereldklok', 'tekst');
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

 my $tt751 = ttlink(751, 'actueel', 'tekst');

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
