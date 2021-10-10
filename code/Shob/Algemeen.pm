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
 my @ekwkPages       = get_first_and_last_page('ekwk');
 my @OSpages         = get_first_and_last_page('OS');
 my $sport = [
'Sport en spel',
<< "EOF"
<ul>
 <li> Een <a href="klaverjas_faq.html">klaverjasspel</a> </li>
 <li> Een <a href="sport.html">sport-archief</a> met onder andere: </li>
  <ul>
   <li> Schaatsen op de Olympische Spelen in:
    ${OSpages[0]} t/m
    ${OSpages[1]}. </li>
   <li> EK en WK voetbal van
    ${ekwkPages[0]} t/m
    ${ekwkPages[1]}. </li>
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

 my $url_stats = 'stats.html';

 my $deze_site = [
'Deze site',
<< "EOF"
<ul>
 <li> <a href="reactie.html">reageer</a> </li>
 <li> hoe zo, <a href="epsig.html">epsig?</a> </li>
 <li> en, veel <a href="$url_stats">hits?</a> </li>
 <li>
<form action="https://www.google.com/search" class="searchform" method="get" name="searchform" target="_blank">
<input name="sitesearch" type="hidden" value="epsig.nl">
<input autocomplete="on" class="form-control search" name="q" placeholder="Search in epsig.nl" required="required"  type="text">
<button class="button" type="submit">Search</button>
</form>
 </li>
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
<form action="https://www.google.com/search" class="searchform" method="get" name="searchform" target="_blank">
<input name="sitesearch" type="hidden" value="epsig.nl">
<input autocomplete="on" class="form-control search" name="q" placeholder="Search in epsig.nl" required="required"  type="text">
<button class="button" type="submit">Search</button>
</form>
EOF
];

 return maintxt2htmlpage([$pout], $title, 'std', 20060521, {type1 => 'std_menu'});
}

sub get_overzicht
{# (c) Edwin Spee

my $extra_ascii = $local_version ? qq( en <a href="tmp_ascii_codes.html">ascii codes</a>\n) : '';

my $link_web_versie = ($local_version ?
qq(,\n <a href="https://www.epsig.nl/overzicht.html">Web-versie van dit overzicht.</a>):'');

my $hopa  = ($web_index eq '' ? $www_epsig_nl : "$www_epsig_nl/$web_index");

my $list_nl = get_voetbal_list('overzicht', 'NL');
my $list_ec = get_voetbal_list('overzicht', 'EC');
my $list_OS = OSlistWithCity();
my $list_EKWK_DH = EKWK_DH_List();

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
 <li><a href="sport.html">Sport</a>
 <ol>
  <li><a href="sport_voetbal_nl_stats.html">statistieken eredivisie</a>
  en <a href="sport_voetbal_nl_stats_more.html">nog meer stats</a>
  <li>Nederlands betaald voetbal, seizoenen:<br>
$list_nl
  <li>Europacup voetbal, seizoenen:<br>
$list_ec
  <li>schaatsuitslagen Olympische Winterspelen:<br>
$list_OS
  <li>Europees en Wereldkampioenschappen voetbal:
   <br>
$list_EKWK_DH
 </ol>
 <li>Bookmarks
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
 my $datum_fixed = get_datum_fixed();
return maintxt2htmlpage(
 bespaar_bandbreedte($out),
 'Overzicht van de website van Edwin Spee',
 'title2h1', $datum_fixed, {type1 => 'std_menu'});
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

 my $out = file2str(File::Spec->catfile('include', 'samenvatting_phd.html'));

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
