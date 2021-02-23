package Shob::Algemeen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Shob_Tools::Html_Head_Bottum;
use Sport_Functions::List_Available_Pages;
use Shob::Bookmarks;
use Shob::Klaverjas_Funcs;
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
 '&get_hopa',
 '&get_epsig',
 '&get_std_search_page',
 '&get_overzicht',
 '&get_reactie',
 '&get_dank',
 '&get_samenvatting_proefschrift',
 '&get_letters',
 '&get_ascii_codes',
 '&get_tech_doc_shob',
 '&get_tech_doc_kj',
 '&get_tech_doc_adressen',
 #========================================================================
);

sub get_hopa()
{# (c) Edwin Spee

 my $voetbal_nl_list = get_voetbal_list('hopa', 'NL');
 my $voetbal_ec_list = get_voetbal_list('hopa', 'EC');
 my $last_ekwk       = get_last_ekwk_page();
 my $sport = [
'Sport en spel',
<< "EOF"
<ul>
 <li> Een <a href="klaverjas_faq.html">klaverjasspel</a> </li>
 <li> Een <a href="sport.html">sport-archief</a> met onder andere: </li>
  <ul>
   <li> Schaatsen op de Olympische Spelen in:
    <a href="sport_schaatsen_OS_1994.html">1994</a> t/m
    <a href="sport_schaatsen_OS_2018.html">2018</a>. </li>
   <li> EK en WK voetbal van
    <a href="sport_voetbal_EK_1996.html">1996</a> t/m
    $last_ekwk. </li>
   <li> <a href="sport_voetbal_WKD2019.html">WK vrouwen 2019</a>.
   <li> Nederlandse clubs in het Europacup voetbal van
$voetbal_ec_list
   </li>
   <li> Betaald voetbal in Nederland van
$voetbal_nl_list
   </li>
  </ul>
</ul>
EOF
];

 my $url_stats = (get_host_id eq 'werk' ? 'https://www.epsig.nl/stats.html' : 'stats.html');

 my $deze_site = [
'Deze site',
<< "EOF"
<ul>
 <li> <a href="reactie.html">reageer</a> </li>
 <li> hoe zo, <a href="epsig.html">epsig?</a> </li>
 <li> en, veel <a href="$url_stats">hits?</a> </li>
 <li>
  <form action=/cgi-bin/search.cgi method=get>
   <input type="hidden" name="html_url" value="/search.html">
   <input type=text name=keywords size=8>
   <input type=submit value="Zoek op deze site!">
  </form> </li>
</ul>
EOF
];

 my $actueel = [
'Actueel',
"<ul>\n" . get_actueel('hopa') . "</ul>"
];

 my $links = [
'Links',
<< 'EOF'
<ul>
 <li> <a href="bookmarks_sport.html">Sport</a>
 <li> <a href="bookmarks_treinen.html">Treinen</a>
 <li> <a href="bookmarks_computers.html">Computers</a>
 <li> <a href="https://www.gewoonbij10.nl/">Kadotips voor het hele jaar</a>
</ul>
EOF
];

 my $pout = [$deze_site, $actueel, $sport, $links];
 my $title ='Welkom op epsig.nl!';
 return maintxt2htmlpage($pout, $title, 'std', 20060825, {type1 => 'no_menu'});
}

sub get_epsig
{# (c) Edwin Spee
 # versie 1.0 20-mar-2006 initiele versie

 my $out = << 'EOF';
epsig = eps + sig (zonder dubbele s)
<br> eps = epsilon = Griekse e; e = eerste letter van Edwin
<br> sig = sigma = Griekse s; s = eerste letter van Spee
<p>
Het was in 2005 &eacute;&eacute;n van de weinige vrije domeinnamen met weinig letters
en nog uit te spreken ook.
<p>
Verder worden epsilon en sigma veel gebruikt in <a href="cv.html">mijn vakgebied</a>.
<p>
Geinig, toch?
<p>
Edwin Spee
<br>webmaster www.epsig.nl.
<p> &nbsp;
EOF

 my $title = 'Hoezo, epsig?';
 my $pout = [[$title, $out]];
 return maintxt2htmlpage($pout, $title, 'std', 20060520, {type1 => 'std_menu'});
}

sub get_std_search_page()
{# (c) Edwin Spee
 # versie 1.0  21-may-2006 initiele versie

 my $title = 'Zoeken binnen www.epsig.nl';
 my $pout = [
$title,
# <input type="hidden" name="user" value="www.epsig.nl">
<< 'EOF'
<form action="/cgi-bin/search.cgi" method="get">
<input type="hidden" name="html_url" value="/search.html">
Zoektermen: <input type="text" name="keywords" size="50"><br>
<p>
<input type="checkbox" name="exact_match">
Zoeken op geheel woord.
<br>
<input type="submit" value="Zoek!">
<input type="reset" value="wis">
</form>
EOF
];

 return maintxt2htmlpage([$pout], $title, 'std', 20060521, {type1 => 'std_menu'});
}

sub get_overzicht
{# (c) Edwin Spee

my $extra_ascii = $local_version ? qq( en <a href="tmp_ascii_codes.html">ascii codes</a>\n) : '';

my $index_politiek = ($local_version ?
qq(<li><a href="$www_xs4all_nl_spee/p-b/index.html">Politiek, meningen, opinies</a>) :
'<li>Politiek, meningen, opinies');

my $link_web_versie = ($local_version ?
qq(,\n <a href="https://www.epsig.nl/overzicht.html">Web-versie van dit overzicht.</a>):'');

my $hopa  = ($web_index eq '' ? $www_epsig_nl : "$www_epsig_nl/$web_index");

my $list_nl = get_voetbal_list('overzicht', 'NL');
my $list_ec = get_voetbal_list('overzicht', 'EC');

my $out = << "EOF";
<ol>
 <li>Algemeen: <a href="$hopa">Home page</a>$link_web_versie
 <ol>
  <li><a href="klaverjas_faq.html">een JavaScript-spel: klaverjassen</a>
  <li><a href="anybrowser.html">speciale characters in html</a> $extra_ascii
  <li><a href="cv.html">mijn CV</a>
  <li><a href="samenvatting_proefschrift.html">samenvatting van mijn proefschrift</a>
  <li><a href="reactie.html">verzoek om reacties, opmerkingen op deze site</a>
  <li>technische documentatie: <a href="tech_doc_kj.html">klaverjassen</a>,
   <a href="tech_doc_shob.html">shob</a> en
   <a href="tech_doc_adressen.html">adressen</a>.
 </ol>
$index_politiek
 <ol>
  <li><a href="$www_xs4all_nl_spee/opinion/kwaliteitssprong_OV.html">kwaliteitssprong OV</a>
  <li><a href="$www_xs4all_nl_spee/p-b/staatsschuld.html">ontwikkeling staatsschuld</a>
  <li><a href="$www_xs4all_nl_spee/p-b/demissionair.html">demissionaire periodes</a>
  <li><a href="$www_xs4all_nl_spee/p-b/verkiezingsuitslagen.html">verkiezingsuitslagen 1994-heden</a>
 </ol>
 <li><a href="sport.html">Sport</a>
 <ol>
  <li><a href="sport_voetbal_nl_stats.html">statistieken eredivisie</a>
  <li>Nederlands betaald voetbal, seizoenen:<br>
$list_nl
  <li>Europacup voetbal, seizoenen:<br>
$list_ec
  <li>schaatsuitslagen Olympische Winterspelen:<br>
   <a href="sport_schaatsen_OS_2018.html">PyeongChang (2018)</a>,
   <a href="sport_schaatsen_OS_2014.html">Sochi (2014)</a>,
   <a href="sport_schaatsen_OS_2010.html">Vancouver (2010)</a>,
   <a href="sport_schaatsen_OS_2006.html">Turijn (2006)</a>,
   <a href="sport_schaatsen_OS_2002.html">Salt Lake City (2002)</a>,
   <a href="sport_schaatsen_OS_1998.html">Nagano (1998)</a> en
   <a href="sport_schaatsen_OS_1994.html">Lillehammer (1994)</a>
  <li>Europees en Wereldkampioenschappen voetbal:
   <br>
     <a href="sport_voetbal_EK_2020_voorronde.html">EK 2021</a>
   | <a href="sport_voetbal_WKD2019.html">WK 2019 (D)</a>
   | <a href="sport_voetbal_WK_2018.html">WK 2018</a>
   | <a href="sport_voetbal_EK_2016.html">EK 2016</a>
   | <a href="sport_voetbal_WK_2014.html">WK 2014</a>
   | <a href="sport_voetbal_EK_2012.html">EK 2012</a>
   | <a href="sport_voetbal_WK_2010.html">WK 2010</a>
   | <a href="sport_voetbal_EK_2008.html">EK 2008</a>
   | <a href="sport_voetbal_WK_2006.html">WK 2006</a>
   | <a href="sport_voetbal_EK_2004.html">EK 2004</a>
   | <a href="sport_voetbal_WK_2002.html">WK 2002</a>
   | <a href="sport_voetbal_EK_2000.html">EK 2000</a>
   | <a href="sport_voetbal_WK_1998.html">WK 1998</a>
   | <a href="sport_voetbal_EK_1996.html">EK 1996</a>
 </ol>
 <li><a href="bookmarks.html">Bookmarks</a>
 <ol>
  <li><a href="bookmarks_sport.html">sport</a>,
      <a href="bookmarks_treinen.html">treinen</a>,
      <a href="bookmarks_media.html">media</a>,
      <a href="tmp_bookmarks_milieu.html">weer, klimaat en milieu</a>,
      <a href="tmp_bookmarks_geld.html">geld</a>,
      <a href="tmp_bookmarks_overheid.html">overheid</a>,
      <a href="tmp_bookmarks_science.html">wetenschap</a> en
      <a href="bookmarks_computers.html">computers en internet</a>.
 </ol>
</ol>
EOF
return maintxt2htmlpage(
 bespaar_bandbreedte($out),
 'Overzicht van de website van Edwin Spee',
 'title2h1', 20200712, {type1 => 'std_menu'});
}

sub get_reactie
{# (c) Edwin Spee

my $out = << 'EOF';
<form method="POST" action="/cgi-bin/mail-a-form">
<input type="hidden" name="to" value="info@epsig.nl">
<input type="hidden" name="subject" value="reactie op web-site">
<input type="hidden" name="nextpage" value="/dank_u_wel.html">
EOF
$out .= << "EOF";
Put your comments on my pages here:
<p>
Je opmerkingen kun je hier kwijt.
<br>
Jouw opmerkingen mogen vari&euml;ren van nieuwe of verhuisde links, typefouten.
Ook als je het niet (helemaal) eens bent met de inhoud, hoor ik dat graag.
<p>
Of misschien wil je iets kwijt over mijn klaverjas-spel.
<br>
Lees in dat geval a.u.b. eerst de <a href="klaverjas_faq.html">Klaverjas FAQ</a>
(FAQ = Frequently Asked Questions = Veel gestelde vragen).
<p>
Ik kan helaas niet garanderen dat ik alle quiz- of triviantvragen beantwoord.
<br>
<textarea name="info" rows="8" cols="60">
</textarea>
<p>
Je E-mail adres: <input type="text" name="from" size="30">
<input type="submit" value="verstuur/send">
</form>
<p>
Alvast bedankt voor de moeite !
<p>
Edwin Spee.
<hr>
Je kunt me natuurlijk ook een <a href="mailto:info\@epsig.nl">e-mailtje</a> sturen.
<hr>
EOF

 my $t = 'Reacties op website www.epsig.nl';
 my $pout = [[$t, $out]];
 return maintxt2htmlpage($pout, $t, 'std', 20180521, {type1 => 'std_menu', skip1 => 0});
}

sub get_dank()
{# (c) Edwin Spee

 my $out = << 'EOF';
Dank u wel voor uw reactie.
<br>
Ik zal proberen binnen een week te reageren.
<p>
met vriendelijke groet,
<br>
Edwin Spee.
<p>
EOF

 return maintxt2htmlpage($out, 'Dank u wel voor uw reactie!',
  'title2h1', 20050616, {type1 => 'std_menu'});
}

sub get_samenvatting_proefschrift()
{# (c) Edwin Spee

 my $out = << 'EOF';
<h2>Numerieke methoden in globale transport-chemie modellen</h2>
Het onderwerp van dit proefschrift betreft de numerieke wiskunde
in globale transport-chemie modellen.
Met deze modellen wordt onderzoek verricht
naar de chemische samenstelling van de atmosfeer,
in het bijzonder in relatie tot luchtverontreiniging op globale schaal.
Met globale modellen wordt derhalve onderzoek verricht
naar globale milieuproblemen,
zoals het ozongat boven de Zuidpool
en het antropogeen (door menselijke activiteiten)
versterkte broeikaseffect, dat mogelijk resulteert in globale opwarming.
Een gerelateerd onderzoeksgebied is smogvoorspelling.
Met dit verschil dat smogvorming voornamelijk plaats vindt
op een veel kleinere schaal,
bijvoorbeeld in de omgeving van stedelijke gebieden.
<p>
Het in dit proefschrift beschreven onderzoek is uitgevoerd
in het kader van het CIRK-project.
Het CIRK-project is ontstaan uit contacten tussen
CWI, IMAU, RIVM en KNMI
met als doel de verbetering van globale 3D modellering
van de troposfeer,
waarin chemie, emissies, deposities en
troposfeer-stratosfeer uitwisseling zijn opgenomen.
Dit proefschrift beschrijft numerieke algoritmen
die in deze modellen voorkomen.
Op het IMAU wordt parallel aan dit onderzoek
gewerkt aan vertikaal transport en processen op sub-grid schaal.
Voor het onderzoek in dit proefschrift is het contact
met wetenschappers van IMAU, RIVM en KNMI zeer belangrijk geweest.
<p>
We beschouwen transport-chemie modellen
die zijn gebaseerd op balansvergelijkingen.
De chemische stoffen in deze modellen hebben zeer verschillende tijdschalen:
van minder dan een seconde voor radicalen
tot jaren voor bijvoorbeeld methaan.
De vergelijkingen worden opgelost op een Euleriaans
lengtegraad-breedtegraad rooster.
Het product van het aantal roosterpunten en het aantal chemische componenten
ligt tussen de honderdduizend en &eacute;&eacute;n miljard.
De combinatie van het grote aantal onbekenden en de verschillende tijdschalen
maakt het oplossen van deze vergelijkingen zeer rekenintensief.
Er worden dan ook hele hoge eisen gesteld aan zowel de computers als
aan de numerieke algoritmen.
<p>
Vanwege de grootte van modelfouten,
bijvoorbeeld in de emissies en de chemische reactiesnelheden,
volstaat in deze modellen een lage nauwkeurigheid.
Het model kan daarom worden opgelost met operator splitting.
Dit heeft tot gevolg dat voor processen als advectie en chemie
verschillende numerieke technieken gebruikt kunnen worden.
In dit proefschrift ligt de nadruk op numerieke technieken
voor advectie en chemie en alternatieven voor
de veelgebruikte operator splitting.
<p>
Bij de ontwikkeling van advectieschema's hebben we ons gericht
op massa behoudende schema's die geen nieuwe minima
of maxima introduceren, zogenaamde monotone schema's.
Massabehoud wordt afgedwongen door advectie te beschrijven
met in- en uitgaande fluxen.
Monotoniciteit wordt verkregen door het gebruik van flux-limiters.
<p>
Op de bol geeft het gebruikte rooster aanleiding tot
een singulariteit aan de beide polen.
Er zijn twee mogelijkheden onderzocht om de bezwaren
van deze singulariteit te onderdrukken:
het zogenaamde gereduceerde rooster waar aan de polen minder cellen
worden gebruikt, en een onvoorwaardelijk stabiel schema.
Goede resultaten werden verkregen met het schema Split-rg.
Dit schema maakt gebruik van dimensie-splitting
op een gereduceerd rooster.
In vergelijking tot bestaande schema's is Split-rg nauwkeurig,
geheugen-effici&euml;nt en gebruikt het weinig cpu-tijd.
Het schema Mol-rg geeft ook bevredigende resultaten.
Mol-rg is een Methode der Lijnen schema op een gereduceerd rooster,
dat gebruik maakt van derde orde upwind fluxen met flux-limiters en
de expliciete trapeziumregel voor tijdsintegratie.
<p>
Het meest rekenintensieve deel in deze modellen is
het oplossen van de chemie.
Een reductie van de cpu-tijd kan worden bereikt
door grote tijdstappen te nemen.
Dit is echter alleen mogelijk als
de chemie solver goede stabiliteitseigenschappen bezit.
Het tweede orde Rosenbrock schema ROS2
lijkt heel geschikt als chemie solver.
Met ROS2 kunnen we een complexe chemie integreren
met een tijdstap van 20 minuten,
zonder gebruik te maken van enige voorkennis van de gebruikte chemie.
<p>
De veel toegepaste techniek operator splitting heeft een aantal grote voordelen.
De verschillende processen kunnen met verschillende technieken
worden opgelost.
De advectie kan expliciet en de chemie impliciet worden opgelost.
Tevens kan de chemie per roosterpunt in tijdstap vari&euml;ren.
Verder is de computercode modulair van opzet en geheugen-effici&euml;nt.
Helaas ontstaat bij operator splitting een splitfout.
We hebben geconcludeerd dat in globale modellen de splitfout
binnen de gewenste nauwkeurigheid blijft.
Hier is echter meer onderzoek nodig.
Als alternatief voor operator splitting hebben we
twee methoden bestudeerd
om chemie en vertikale diffusie gekoppeld op te lossen:
Twostep, een tweede orde BDF methode (Backward differentiation formula) met een
speciale Gauss-Seidel iteratie
en de gefactoriseerde ROS2.
ROS2 met factorisatie is een goed alternatief voor operator splitting,
maar met Twostep kan helaas natte chemie niet worden opgelost.
<p>
De ontwikkelde technieken zijn uitgebreid getest.
Daarvoor zijn standaard testen gebruikt
zoals de Molenkamp test op een bol
en state-of-the-art chemie boxmodellen.
Ook zijn deze boxmodellen gecombineerd met de Molenkamp test
om zo voor een complete advectie-chemie-diffusie stap
de nauwkeurigheid tegen de cpu-tijd af te zetten.
<p>
EOF
 return maintxt2htmlpage($out, 'Samenvatting proefschrift Edwin Spee',
 'title2h1', 20050530, {type1 => 'small_menu'});
}

sub get_letters()
{# (c) Edwin Spee

 my @begin_letters =
  ('A','a','E','e','I','i','N','n','O','o','U','u','Y','y');
 my @tekens =
  ('acute','circ','grave','tilde','uml','slash');
 my $masker = {
  A => [1,1,1,1,1,1],
  E => [1,1,1,0,1,0],
  I => [1,1,1,0,1,0],
  N => [0,0,0,1,0,0],
  O => [1,1,1,1,1,1],
  U => [1,1,1,0,1,0],
  Y => [1,0,0,0,1,0] };

 my $txt = '';
 foreach my $l (@begin_letters)
 {
  my $row = '';
  for (my $j=0; $j < scalar @tekens; $j++)
  {
   my $m = $masker->{uc($l)}[$j];
   my $t = $tekens[$j];
   if ($l =~ m/a/iso and $t eq 'slash') {$t = 'ring';}
   my $lt = $l . $t;
   if ($m)
   {
    $row .= ftdl(" &amp;$lt; = &$lt; ");
   }
   else
   {
    $row .= ftdl('&nbsp;');
   }
  }
  $txt .= ftr($row);
 }

 my $out = << "EOF";
<p align="left">
<a href="http://www.anybrowser.org/campaign/">
<img src="include/anybrowser_coffee.gif" width="157" height="44"
alt="This site is best viewed from a comfortable chair with a cup of (Java) coffee" border="0">
</a></p>
Om de pagina's van mijn website te kunnen bekijken,
is alleen nodig dat je browser met tabellen en heel elementair JavaScript overweg kan
(mijn klaverjas-programma kan echt niet zonder).
<br> HTML is dan ook uitgevonden om Internet pagina's leesbaar te houden
op diverse computersystemen (Windows, Linux en Mac/Apple).
<br> Helaas lukt dat steeds minder.
<br> Bekijk daarom je website eens met een andere browser, of vraag een bekende dat te doen.
<p>
De tekens op deze pagina zijn probleemloos te gebruiken.
Let er verder op dat de symbolen &amp;, &gt;, &lt; en &quot; een aparte betekenis hebben binnen HTML.
<table border cellspacing=0>
<tr><td colspan=2> &amp;amp;    = &amp;  </td>
    <td colspan=2> &amp;euro;   = &euro;  </td>
    <td colspan=2> &amp;micro;  = &micro;  </td> </tr>
<tr><td colspan=2> &amp;gt;     = &gt;   </td>
    <td colspan=2> &amp;pound;  = &pound;  </td>
    <td colspan=2> &amp;para;   = &para;  </td> </tr>
<tr><td colspan=2> &amp;lt;     = &lt;   </td>
    <td colspan=2> &amp;yen;    = &yen;  </td>
    <td colspan=2> &amp;sect;   = &sect;  </td> </tr>
<tr><td colspan=2> &amp;quot;   = &quot; </td>
    <td colspan=2> &amp;curren; = &curren; </td>
    <!-- <td> &amp;fnof; = &fnof; </td> -->
    <td colspan=2> &amp;deg;    = &deg;  </td> </tr>
<tr><td colspan=2> &amp;pi;     = &pi; </td>
    <td colspan=2> &amp;cent;   = &cent; </td>
    <td colspan=2> &amp;plusmn; = &plusmn;  </td> </tr>
<tr><td colspan=6> &nbsp; </td> </tr>
<tr><td colspan=6> &amp;nbsp;   = &nbsp; (non braking space) </td> </tr>
<tr><td colspan=2> &amp;copy;   = &copy;   </td>
    <td colspan=2> &amp;reg;    = &reg;    </td>
    <td colspan=2> &lt;sup&gt;TM&lt;/sup&gt; = <sup>TM</sup> </td> </tr>
<tr><td colspan=3> O(&lt;sup&gt;1&lt;/sup&gt;D) = O(<sup>1</sup>D) </td>
    <td colspan=3> CH&lt;sub&gt;2&lt;/sub&gt;O = CH<sub>2</sub>O </td> </tr>
<tr><td colspan=2> &amp;szlig;  = &szlig;  </td>
    <td colspan=2> &amp;aelig;  = &aelig;  </td>
    <td colspan=2> &amp;ccedil; = &ccedil; </td> </tr>
<tr><td colspan=6> &nbsp; </td> </tr>
$txt
</table>
EOF
 return maintxt2htmlpage(bespaar_bandbreedte($out), 'Te bekijken met elke browser',
  'title2h1', 20060520, {type1 => 'std_menu'});
}

sub get_ascii_codes
{# (c) Edwin Spee

 my $out = '';
 for (my $i=3;$i<26;$i++)
 {
  my $tmp_out = '';
  for (my $j=0;$j<10;$j++)
  {
   my $x = 10*$i+$j;
   my $t = (($x <= 32 or $x > 255 ) ? '&nbsp;':"&#$x;");
   $tmp_out .= ftd($x . ': ' . $t);
  }
  $out .= ftr($tmp_out);
 }
 $out = ftable('border', fth({cols => 10}, 'escape codes') . $out);

 return maintxt2htmlpage($out, 'Ascii codes in HTML', 'title2h1',
  20030813, {type1 => 'std_menu'});
}

sub get_tech_doc_kj
{
 my $filenm = File::Spec->catfile('doc', 'tech_doc_kj.html');
 my $main = file2str($filenm);
 my $dd = (stat $filenm)[9];

 return maintxt2htmlpage($main, 'Technische documentatie Klaverjassen', 'title2h1',
  time2idate($dd), {type1 => 'std_menu'});
}

sub get_tech_doc_shob
{
 my $filenm = File::Spec->catfile('doc', 'tech_doc_shob.html');
 my $main = file2str($filenm);
 my $dd = (stat $filenm)[9];

 return maintxt2htmlpage($main, 'Technische documentatie Shob', 'title2h1',
  time2idate($dd), {type1 => 'std_menu'});
}

sub get_tech_doc_adressen
{
 my $filenm = File::Spec->catfile('doc', 'tech_doc_adressen.html');
 my $main = file2str($filenm);
 my $dd = (stat $filenm)[9];

 return maintxt2htmlpage($main, 'Technische documentatie Adressen', 'title2h1',
  time2idate($dd), {type1 => 'std_menu'});
}

return 1;
