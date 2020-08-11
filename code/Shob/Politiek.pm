package Shob::Politiek;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
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
 '&get_kwaliteitssprong_OV',
 '&get_staatsschuld',
 '&get_demissionair',
 '&get_index_politiek',
 '&get_beide_namen',
 '&get_geschiedenis_paars',
 #========================================================================
);

sub get_kwaliteitssprong_OV
{# (c) Edwin Spee

my $out2 = << 'EOF';
Wat is er allemaal nodig om iets te doen aan de huidige situatie bij de NS ?
<br>
<i>(Aan schuin gedrukte projecten wordt al gewerkt</i>
en
<b>vet gedrukte projecten zijn inmiddels klaar.)</b>
<ol>
 <li>
Modernisering NS rails door bovenleidingsspanning en beveiliging op
de Europees niveau te brengen.
 <li>Ontbrekende schakels in het spoorwegnetwerk aanleggen:
   <ol>
      <li> <b> Utrecht - Amsterdam Zuid - Schiphol (Utrechtboog) </b>
      <li> <b> Schiphol - Zaandam/Alkmaar/Hoorn/Den Helder (Hemboog) </b>
      <li> <b> Lelystad - Almere - Hilversum - Utrecht (Flevo-Gooiboog) </b>
      <li> <b> Almere - Lelystad - Kampen - Zwolle (Hanzelijn) </b>
      <li>Amsterdam Zuid - Zaandam/Alkmaar/Hoorn/Den Helder (Hemboog + Zuid-Westboog)
      <li>Almere - Lelystad - Heerenveen - Drachten - Groningen (Zuiderzeespoorlijn)
   </ol>
 <li>Capaciteitsuitbreiding op enkele drukke trajecten, dus (deels) 4-sporig maken:
   <ol>
      <li> <b> Amsterdam - Utrecht </b>
      <li>Rotterdam - Delft (- Den Haag)
      <li>Rotterdam Alexander - Nieuwerkerk a/d IJssel (- Gouda)
      <li>(Alkmaar-) Wormerveer - Koog Bloemwijk (- Amsterdam Sloterdijk)
   </ol>
 <li>Extra perrons/sporen op de stations zodat stoptreinen en intercity's gelijk kunnen binnenkomen:
   <ol>
      <li>Zoetermeer en/of Voorburg
      <li> <b> Amsterdam Zuid </b>
      <li> <b> Driebergen-Zeist </b>
   </ol>
 <li>Een aantal nieuwe metro / sneltram-lijnen:
   <ol>
      <li> <i> (Schiphol -) </i> <b> A'dam Zuid - A'dam CS - A'dam Noord </b> <i> (- Purmerend) </i>
      <li>Zoetermeer - Rotterdam
      <li> <b> Rotterdam Marconiplein - Schiedam - Spijkenisse </b>
      <li> <b> Haarlem - Schiphol </b>
      <li> <b> Utrecht - De Uithof </b>
   </ol>
</ol>
EOF
return maintxt2htmlpage(bespaar_bandbreedte($out2), 'Kwaliteitssprong OV', 'title2h1',
20200712, {type1 => 'std_menu', root => $www_epsig_nl});
}

sub get_staatsschuld
{# (c) Edwin Spee

my $out2 = << 'EOF';
Enkele opmerkingen op persoonlijke titel bij de staatsschuld van ons land.
Daarbij is het handig om onderstaand plaatje te bekijken:
<table width=100%>
<tr> <td>
<img src="../pictures/staatsschuld.jpg" width="480" height="361" alt="schuld, tekort als functie van bnp">
</td> </tr> </table>
Boven staat van links naar rechts het bruto nationaal product (BNP), de schuldschuld,
en het jaarlijkse tekort in miljarden euro's.
Duidelijk is dat de schuld iets boven de 200 miljard euro blijft steken.
Dat lijkt heel erg veel.
Onder staat de schuld en het tekort als percentage van het BNP.
Duidelijk te zien is, dat zowel de schuld als het tekort als het percentage
van het BNP de laatste jaren sterk is afgenomen.
<h2> Is het erg dat er nu weer een tekort dreigt ? </h2>
Nee. De economie zit soms mee, en dan weer tegen. Het gemiddelde
over een periode van 5 &agrave; 10 jaar moet positief zijn.
<h2> Moet de staatsschuld helemaal worden afgelost ? </h2>
Niet per se. Van belang is dat de rente die per jaar betaald moet worden
slechts een klein percentage van de totale overheidsuitgaven zijn.
Dat is overigens nu <u>niet</u> het geval. Daarvoor moet op de lange
termijn de schuld afnemen tot circa 20&nbsp;% van het BNP.
<p><a href="mailto:info@epsig.nl">Edwin Spee</a>.<p>&nbsp;
EOF
return maintxt2htmlpage($out2, 'Ontwikkeling staatsschuld', 'title2h1',
 20070226, {type1 => 'std_menu', root => $www_epsig_nl});
}

sub get_demissionair
{# (c) Edwin Spee

# top 5 gevallen kabinnetten:
# balkenende (cda,lpf,vvd) 87 dgn van 20020722 - 20021016
# zijlstra (kvp,arp)      135 dgn van 19661122 - 1967
my $out2 = << 'EOF';
<table>
<tr> <th> periode </th> <th> reden </th> </tr>
<tr> <td> 23 dec 1960 - 2 jan 1961 </td>
<td> &quot;Jenevercrisis&quot;: woningbouw </td> </tr>
<tr> <td> 1966 </td>
<td> Nacht van Schmelzer </td> </tr>
<tr> <td> 1977 </td>
<td> onteigeningswet </td> </tr>
<tr> <td> 1981 </td>
<td> val v. Agt-I </td> </tr>
<tr> <td> 12 mei 1982 - 29 mei 1982 </td>
<td> val v. Agt-II </td> </tr>
<tr> <td> 1989 </td>
<td> Reiskostenforfait </td> </tr>
<tr> <td> 3 mei 1998 - 22 aug 1994 </td>
<td> verkiezingen, formatie </td> </tr>
<tr> <td> 6 mei 1998 - 3 aug 1998 </td>
<td> verkiezingen, formatie </td> </tr>
<tr> <td> 19 mei 1999 - 3 jul 1999 </td>
<td> Nacht van Wiegel: invoering referendum bij Eerste Kamer </td> </tr>
<tr> <td> 16 apr 2002 - 22 jul 2002 </td> <td> NIOD rapport over de val van Sebrenica </td> </tr>
<tr> <td> 16 okt 2002 - 27 mei 2003 </td> <td> Interne crisis LPF </td> </tr>
<tr> <td> 30 jun 2006 -  7 jul 2006 </td>
<td> Paspoortaffaire Hirsi-Ali (dan tot 22 feb 2007 minderheidskabinet) </td> </tr>
</table>
EOF
return maintxt2htmlpage($out2, 'Demissionaire periodes', 'title2h1',
 20070226, {type1 => 'std_menu', root => $www_epsig_nl});
}

sub get_index_politiek
{# (c) Edwin Spee

#http://home.hetnet.nl/~d66rotterdam/Tegenstroom/inhoud/06.html
my ($pb_opinion) = @_;
my $dir_pb = $pb_opinion ? '':'../p-b/';
my $dir_opinion = $pb_opinion ? '../opinion/':'';
my $out2 = << "EOF";
<ol>
<li><a href="${dir_opinion}kwaliteitssprong_OV.html">kwaliteitssprong_OV.html</a>
<li><a href="${dir_pb}staatsschuld.html">ontwikkeling staatsschuld</a>
<li><a href="${dir_pb}demissionair.html">demissionaire periodes </a>
<li><a href="${dir_pb}verkiezingsuitslagen.html">verkiezingsuitslagen 1994-heden</a>
EOF
$out2 .= << 'EOF';
<li><a href="http://www.d66.nl/">D66</a>
<li><a href="http://www.d66rotterdam.nl/">D66-Rotterdam</a>
<li><a href="http://www.d66rotterdam-alexander.nl/">D66-Rotterdam-Alexander</a>
<li><a href="http://www.prinsalexander.rotterdam.nl/">Deelgemeente Prins-Alexander</a>
</ol>
EOF

return maintxt2htmlpage($out2,
'Overzicht politiek getint deel van de website www.xs4all.nl/~spee.', 'title2h1',
20070802, {type1 => 'std_menu', root => $www_epsig_nl});
}

sub make_tabel
{# (c) Edwin Spee

 my $nwe_kop =
qq(<h2>Verhuisbericht</h2>\nDeze pagina wordt niet meer aangeboden.).
qq( Zie voor vergelijkbare informatie:<ul>\n).
qq(<li><a href="http://www.allesopeenrij.nl/overzichten/politiek.html">Alles op een rij.nl</a>\n).
qq(<li><a href="http://www.parlement.com/">parlement.com</a>\n).
qq(<li><a href="http://www.parlement.nl/">Parlement</a>\n).
qq(<li><a href="http://www.eerstekamer.nl/">Eerste Kamer</a>\n).
qq(<li><a href="http://www.tweede-kamer.nl/">Tweede Kamer</a>\n).
qq(<li><a href="http://www.regering.nl/">Regering.nl</a>\n).
qq(<li><a href="http://www.overheid.nl/">Overheid.nl</a>\n).
qq(<li><a href="http://www.minaz.nl/">Ministerie van Algemene Zaken</a></ul>\n);

 return $nwe_kop;
}

sub get_beide_namen
{# (c) Edwin Spee
 # versie 1.0 11-aug-2003 get_namen en get_namen_meer samengevoegd

my ($lv, $optie) = @_;
return maintxt2htmlpage(make_tabel($lv, $optie), 'Namen van Nederlandse politici', 'title2h1',
 ($all_data ? 20050427 : 20040114), {type1 => 'std_menu', robot => 1, root => $www_epsig_nl});
}

sub get_geschiedenis_paars
{# (c) Edwin Spee

 my ($lv) = @_;

 my $verhuisd =
qq(<h2>Verhuisbericht</h2>\nDeze pagina wordt niet meer aangeboden.).
qq( Zie voor vergelijkbare informatie:<ul>\n).
qq(<li><a href="http://www.histocasa.nl/artikelen/paars.shtml">Histocasa: Kroniek Paars</a>\n).
qq(<li><a href="http://www.geschiedenis.nl/">Geschiedenis.nl</a>\n).
qq(<li><a href="http://www.geschiedenis.net/">Geschiedenis.net</a></ul><hr>\n);

 my $out = << 'EOF';
De herkomst van de term paars is inmiddels wel duidelijk.
<br>Zeer waarschijnlijk is het een combinatie van partijkleuren, immers het
mengen van de kleuren
<font color="red">rood (PvdA)</font> en
<font color="blue">blauw (VVD)</font> levert
<font color="purple">paars</font>
op.
Hoe dan D66 in paars uit de verf komt, is niet duidelijk.
<p>Zeker is dat voor de verkiezingen van
<a href ="verkiezingsuitslagen.html">mei 1994</A>
deze term algemeen ingeburgerd was.
<p>Een voorzet tot een paars kabinet werd gegeven in het
'Des Indes-beraad', waar verschillende politici van
PvdA en VVD zonder pers spraken over samenwerking tussen PvdA en VVD.
<p>Na deze verkiezingen werd paars de eerste serieuze optie.
<p>Paars is bijzonder omdat enerzijds er geen Christelijke partij
meedoet in de coalitie, en anderzijds omdat liberalen (VVD) en
sociaal-democraten (PvdA)
samenwerken in &eacute;&eacute;n coalitie.
<p>Grootste voorstander van paars was en is de D66.
<hr>In de pers (Volkskrant, 4 mei 1994) verscheen een artikel waarin
werd geschreven dat 'paars' 'purper' zou zijn geweest, als de
voorzitter van de Jonge Democraten, Roel van der Poort, het woord
'purper' zou kunnen uitspreken.<br>
Roel van der Poort kon het woord weliswaar uitspreken, maar vond het dermate
lelijk dat hij het niet over zijn lippen kon krijgen in figuurlijke zin.
<p>In het voorjaar van 1992 brachten de JOVD en de jongerenorganisaties van de
PvdA en D66 (JS en JD) een rapport uit met de titel &quot;Het paarse regeeraccoord&quot;.
Dit zou dus eerst &quot;Het purperen regeeracoord&quot; hebben geheten.
Zeer waarschijnlijk stamt de politieke term &quot;paars&quot; dus uit het voorjaar
van 1992.
<hr>Kort overzicht beslissingen en andere feiten paars:
<ul>
 <li>Borsele opengehouden, ondanks kamermotie die aandrong op sluiting.
 <li>Visum verstrekt aan Poncke Princen.
 <li>Geen algemeen pardon voor illegalen die 6 jaar in Nederland werken.
 <li>Schiphol krijgt 5e baan, parallel aan Zwanenburgbaan.
 <li>Snelweg A73 op de Oostoever, nadat 2e kamer Westvariant had weggestemd.
 <li>Begin 1995: Na twee opeenvolgende winters met extreme waterhoogte van Rijn en Maas
komt de <a href="http://www.waterland.net/hdw/deltariv/">Deltawet grote rivieren</a>:
in hoog tempo (door kortere procedures en
de beschikbaarheid van extra geld) worden diverse rivierdijken en kades
verhoogd en/of versterkt.
 <li>Besluit Betuwelijn komt na de Statenverkiezing. De tijdens de formatie
aangekondigde commissie Hermans adviseerde inmiddels om de Betuwelijn
aan te passen, met f 1,2 miljard aan voorzieningen om de geluids-
en milieubelasting te beperken. Kok vind f 0,5 miljard een maximum,
D66 wil aanpassingen voor f 1,2 miljard.
 <li>Op 21 april 1995 wordt besloten om de Betuwelijn aan te leggen.
Er is in vergelijking met het vorige kabinet 820 miljoen gulden
extra beschikbaar om knelpunten op te lossen.
 <li>29 juni 1995 gaat ook de Tweede Kamer akkoord met de aanleg van de
Betuwelijn. Er wordt een motie aangenomen die er voor zorgt dat er
een tunnel onder het Pannerdens Kanaal komt, in plaats van een brug.
 <li>Het einde van 1995 stond in het teken van de <a href="http://www.xs4all.nl/~respub/traa/">IRT enqu&ecirc;te</a>
onder leiding van de heer Van Traa, waar minister Sorgdrager
van <a href="http://www.justitie.nl/">Justitie</a>
in de problemen kwam na het ontslag met gouden handdruk van procoreur-generaal Van Randwijck.
<br>
Op 21 oktober 1997 komt Maarten Van Traa om het leven bij een auto-ongeluk.
 <li>Bosni&euml; heeft in heel 1995 de politiek beheerst.
Minister Voorhoeve van
<a href="http://www.mindef.nl/">Defensie</a> werd meerdere
malen onaangenaam verrast door fouten en blunders van zijn ambtenaren en
militairen na de val van Srebenica.
 <li>In januari 1996 komt Fokker in ernstige problemen. Moederbedrijf
Daimler Benz/DASA (Deutsche Aerospace) steekt geen geld in het
zwaar verlieslijdende Fokker, nadat de Nederlandse overheid niet
ingaat op de eis van Daimler Benz/DASA om anderhalf miljard gulden
in Fokker te steken.<br>
15 maart gaat Fokker failliet. 5664 werknemers krijgen ontslag,
950 kunnen terugkeren bij Fokker Aviation BV, die nieuwe naam
voor Fokker voor de levensvatbare onderdelen, zoals de vestigingen in
Hoogeveen en Woensdrecht.
Daar is werk voor 2500 mensen.
 <li>29 januari 1996 besluit staatssecretaris
Gmelich Meijling dat de groep dienstplichtigen die die
dag is opgekomen, de laatsten zijn. Voor veel dienstplichten
(niet de mariniers in het Cara&iuml;bisch gebied) geldt vanaf 31
augustus 1996 een generaal pardon, zodat vanaf 1 september
1996 Nederland een beroepsleger heeft.
 <li>6 februari 1996 stemt de Eerste Kamer in met de afschaffing van de
Ziektewet. Bedrijven moeten nu zelf 70 % van het loon van zieke
werknemers doorbetalen, maar kunnen zich daartegen particulier
verzekeren.
 <li>In het voorjaar van 1996 speelt de affaire rond de gekke koeien ziekte BSE.
 <li>Maart 1996: Staatssecretaris Linschoten
van <a href="http://www.minszw.nl/">Sociale Zaken</a>
moet zich verantwoorden in verband met diverse problemen bij de
Ctsv (College toezicht sociale verzekeringen). Op 20 maart treedt
het voltallige bestuur (de oud politici Van Leeuwen (voorzitter, VVD),
Van Otterloo (Pvda) en Van Rooijen (CDA)) af.<br>
Verder komt de staatssecretaris in problemen omdat het vermoeden bestond
dat hij de Kamer onjuist heeft ingelicht tijdens het debat rond de afschaffing
van de ziektewet. Hij zou de inhoud van een Ctsv-rapport hebben achtergehouden.
De vertrouwensvraag wordt niet gesteld, mede door een taktische fout van
SP-kamerlid Marijnissen.<br>
Vlak voor het zomerreces komt Staatssecretaris Linschoten opnieuw in de
problemen door de Ctsv kwestie, en in de nacht van 27 op 28 juni 1996 treedt
hij af. Zijn opvolger wordt De Grave.
 <li>Mei 1996: De Hogesnelheidslijn (HSL) Amsterdam-Schiphol-Rotterdam en
verder naar Belgi&euml; en Parijs gaat door het Groene Hart met een
9 kilometer lange geboorde tunnel. Tussen Antwerpen en Rotterdam zal
de HSL de E19 langs Breda volgen. De totale kosten voor het Nederlandse
deel bedragen 7,52 miljard gulden, waarvan 0,9 miljard voor de tunnel
onder het Groene Hart, en 0,535 miljard voor overige knelpunten. Verder
draagt de Nederlandse overheid ongeveer 835 miljoen gulden bij aan het
deel door Belgi&euml;.
 <li>September 1996: een van de weinige opvallende punten in de miljoenennota is
de accijnsverhoging op benzine en tabak. De VVD 2e kamerfractie probeert beide
verhogingen tegen te houden. Verder lijkt ondanks de hoge <a href="staatsschuld.html">
staatsschuld</a> de EMU-norm gehaald te worden.
 <li>1 November 1996: het kabinet besluit de accijnsverhoging op benzine tegen de
wens van de Tweede Kamer uit te voeren; de accijnsverhoging op tabak vervalt (voorlopig).
 <li>December 1996: de Tweede Kamer fracties van de PvdA en D66 willen eigenlijk de
zogenoemde Bos-variant van de <a href="http://www.hslzuid.nl/">HSL-zuid</a> aanleggen.
(Waarom is volstrekt onduidelijk:
er moeten dan meer huizen gesloopt worden, meer geluidshinder in druk bevolkte gebieden,
hogere aanlegkosten, meer reistijd, en extra procedures in vergelijking met het voorkeurstrac&eacute;
van het kabinet dat onder het Groene Hart gaat. Als het Groene Hart zo belangrijk is waarom wordt er
dan wel een snelweg van Leiden naar Alphen aan de Rijn aangelegd ?)
Overleg in het Torentje van premier Kok zorgt ervoor dat PvdA en D66 hun verzet staken.
 <li>Februari 1997: In Noord-Brabant breekt de varkenspest uit. Onlangs transportverboden
en de slachting van vele varkens legt de EG en exportverbod op voor Nederlandse varkens.
 <li>1e helft 1997: Nederland is voorzitter van de Europese Unie.
Doel is de ondertekening van het Verdrag van Amsterdam tijdens de Europese Top in juni.
In dat verdrag moet de besluitvorming binnen de EU geregeld worden, vooral de veranderingen
na de toetreding van nieuwe leden uit het voormalige Oost-Europa.
Echter, de invoering van de Euro vraagt veel aandacht omdat Duitsland zelfs van plan
is om de goudvoorraad te verkopen om aan de EMU-norm te voldoen.
Uiteindelijk is het Verdrag van Amsterdam een vaag compromis.
 <li>8 juli 1997: Ook de NAVO wordt uitgebreid: Hongarije, Polen en Tjechi&euml; mogen als
eerste lid worden. Roemeni&euml; en Sloveni&euml; moeten ondanks sterke steun van
Frankrijk nog even geduld hebben. De VS zijn bang voor te hoge kosten als vijf
landen lid worden.
 <li>aug 1997: Sorgdrager en Van Mierlo komen in de problemen doordat Brazili&euml; niet om uitlevering is gevraagd van Desi Bouterse.
Het is nog komkommertijd dus maakt politiek Den Haag van deze mug een olifant.
<li>
januari 1998:
Na oudjaarsrellen in het Oosterpark te Groningen ontstaat een dubbele crisis.
<br>Burgemeester Ouwerkerk stapt op omdat de gemeenteraad
hem verwijt te laat de ME te hebben ingeschakeld.
Korpschef J. Veenstra ging hem voor, en de positie van
hoofdofficier van Justitie mr R. Daverschot staat
ook ter discussie.
<p>De Noordelijke Procoreur-Generaal (PG) Steenhuis komt in problemen nadat blijkt
dat hij een bijbaan heeft bij het onderzoeksbureau Bakkenist, dat veel onderzoek verricht
voor het Openbaar Ministerie (OM).
Super-PG Docters-van Leeuwen steunt zijn collega,
en zo ontstaat een zware botsing met minister Sorgdrager.
Een botsing tussen twee prominente D66-leden;
Mogelijk profileren D66'ers zich te sterk na slechte opiniepeilingen.
<br>Docters van Leeuwen meldt zich ziek, en wordt vervangen door Ficq.
<li>2 mei 1998 valt de beslissing over de invoering van de Euro.
Wim Duisenberg wordt de eerste voorzitter van de Europese Centrale Bank,
maar Frankrijk regelt dat hij na ongeveer vier jaar wordt vervangen door
een Fransman (Jean-Claude Trichet)
<li>6 mei 1998: Tweede Kamer verkiezingen.<br>
Belangrijkste thema's:
<ul><li>wordt Kok of Bolkestein minister-president
<li>doet D66 mee in paars-2
<li>echte inhoudelijke thema's als uitbreiding Schiphol,
24-uurs economie, Europese eenwording en verborgen armoede spelen nauwelijks een rol.
</ul></ul>
<hr>Een eerste graadmeter voor paars is de uitslag van de Provinciale Staten verkiezing.
Vlak voor de Tweede Kamer <a href="verkiezingsuitslagen.html">verkiezingen</a> van 6 mei 1998,
vonden gemeenteraadsverkiezingen plaats. Grote verliezer: D66.
EOF
 $out = '<h1><font color="purple">Paars</font> als politieke kleur.</h1>' .
  ($lv ? $verhuisd . $out : $verhuisd);
return maintxt2htmlpage($out, 'Geschiedenis Paars-I', 'std',
 20040115, {type1 => 'std_menu', robot => 1, root => $www_epsig_nl});
}

return 1;
