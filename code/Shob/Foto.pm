package Shob::Foto;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
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
 '&get_index_okt01',
 '&get_index_mrt03',
 '&get_index_jun01',
 '&get_index_feb02',
 '&get_index_bruiloft',
 '&get_foto_carlijn_jan_04',
 '&get_foto_sep_04',
 '&get_foto_feb_05',
 '&get_foto_mei_06',
 '&get_foto_sep_06',
 '&get_foto_zwemles',
 '&get_index_wilma40',
 #========================================================================
);

sub menu_bottum_fotos
{# (c) Edwin Spee

 my $zonder_link = $_[0];
 my $out = "<hr>Andere foto's van Johanneke en Carlijn:<br>\n";
 $out .= ($zonder_link eq 'zwemles' ?
'oct 2006':'<a href="index_oct06.html">oct 2006</a>').",\n";
 $out .= ($zonder_link eq 'sep_06' ?
'sep 2006':'<a href="index_sep06.html">sep 2006</a>').",\n";
 $out .= ($zonder_link eq 'mei_06' ?
'mei 2006':'<a href="index_mei06.html">mei 2006</a>').",\n";
 $out .= ($zonder_link eq 'feb_05' ?
'feb 2005':'<a href="index_feb05.html">feb 2005</a>').",\n";
 $out .= ($zonder_link eq 'sep_04' ?
'sep 2004':'<a href="index_sep04.html">sep 2004</a>').",\n";
 $out .= ($zonder_link eq 'jan_04' ?
'jan 2004':'<a href="index_jan04.html">jan 2004</a>').",\n";
 $out .= ($zonder_link eq 'mrt_03' ?
'maart 2003':'<a href="index_mrt03.html">maart 2003</a>').",\n";
 $out .= ($zonder_link eq 'feb_02' ?
'feb 2002':'<a href="index_feb02.html">feb 2002</a>').",\n";
 $out .= ($zonder_link eq 'okt_01' ?
'okt 2001':'<a href="index_okt01.html">okt 2001</a>').",\n";
 $out .= "en\n";
 $out .= ($zonder_link eq 'jun_01' ?
'juni 2001':'<a href="index_jun01.html">juni 2001</a>').".\n";
 $out .= "<br>\nFoto's van ";
 $out .= $zonder_link eq 'bruiloft' ?
q(onze bruiloft.):
q(<a href="index_bruiloft.html">onze bruiloft</a>.);
 return $out;
}

sub get_index_wilma40
{# (c) Edwin Spee
 # versie 1.0 25-apr-2006 initiele versie

 my @imgs;

 $imgs[0] = img_velden("IMG_37.jpg", "Foto nr. 37", 328, 480, 0.4, 2);
 for (my $i=39; $i<=72; $i++)
 {
  $imgs[$i-38] = img_velden("IMG_$i.jpg", "Foto nr. $i", 328, 480, 0.4, 2);
 }
 for (my $i=74; $i<=76; $i++)
 {
  $imgs[$i-39] = img_velden("IMG_$i.jpg", "Foto nr. $i", 328, 480, 0.4, 2);
 }
 for (my $i=78; $i<=82; $i++)
 {
  $imgs[$i-40] = img_velden("IMG_$i.jpg", "Foto nr. $i", 328, 480, 0.4, 2);
 }
 for (my $i=84; $i<100; $i++)
 {
  $imgs[$i-41] = img_velden("IMG_$i.jpg", "Foto nr. $i", 328, 480, 0.4, 2);
 }
 $imgs[100-41] = img_velden("IMG_100.jpg", "Foto nr. 100", 480, 328, 0.4, 2);

 my $out = make_table('border', 4, @imgs);

 $out .= << 'EOF';
<form method="POST" action="/cgi-bin/mail-a-form">
<input type="hidden" name="to" value="kuijters@tiscali.nl">
<input type="hidden" name="subject" value="bestelling foto's">
<input type="hidden" name="nextpage" value="ok.html">
<p>
Geef hier de nummers van de foto's die je wilt hebben,
en je naam als dat niet gelijk uit het e-mailadres is op te maken.
<textarea name="info" rows="8" cols="80">
</textarea>
<p>
Je E-mail adres: <input type="text" name="from" size="30">
<input type="submit" value="verstuur/send">
</form>
EOF

 return maintxt2htmlpage($out, q(Foto's van de surprise-party voor de 40-jarige Wilma), 'title2h1',
  -1, {type1 => 'no_menu_no_kookie'});
}

sub get_foto_zwemles
{# (c) Edwin Spee

 my @imgs = (
  img_velden(
'2006_sep_zwemles1.jpg',
'Tegen de rand even wachten',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_zwemles2.jpg',
'Goed opletten wat de badmeester doet',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_zwemles3.jpg',
'Groepsfoto',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_zwemles4.jpg',
'Met hulp blijf ik al drijven',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_zwemles5.jpg',
'Onder de douche',
480, 640, 0.5, 1),
 );

 my $out = make_table('border', 2, @imgs);
 return maintxt2htmlpage($out, q(Eerste zwemles van Johanneke.), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('zwemles')});
}

sub get_foto_sep_06
{# (c) Edwin Spee

 my @imgs = (
  img_velden(
'2006_sep_Carlijn.jpg',
'Close-up Carlijn',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_Johanneke.jpg',
'Close-up Johanneke',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_straatfeest.jpg',
'Gesminkt op het straatfeest',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_met_tante_Wilma.jpg',
'met tante Wilma',
480, 640, 0.5, 1),
  img_velden(
'2006_sep_bij_Gerda_Marloes.jpg',
'bij Gerda en Marloes',
480, 640, 0.5, 1),
 );

 my $out = make_table('border', 2, @imgs);
 return maintxt2htmlpage($out, q(Eerste foto's met nieuwe camera.), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('sep_06')});
}

sub get_foto_mei_06
{# (c) Edwin Spee
 # versie 1.0 08-mei-2006 initiele versie

 my @imgs = (
  img_velden(
'2005_kerst.jpg',
'Kerst bij Opa en Oma',
435, 640, 0.5, 1),
  img_velden(
'2005_dec_Blijdorp_Carlijn_Niko1.jpg',
'In Blijdorp',
435, 640, 0.5, 1),
  img_velden(
'2005_dec_Blijdorp_Carlijn_Niko2.jpg',
'In Blijdorp',
435, 640, 0.5, 1),
  img_velden(
'2005_dec_Blijdorp_Johanneke_Evert.jpg',
'In Blijdorp',
435, 640, 0.5, 1),
  img_velden(
'2006_mrt_Blijdorp_Johanneke_pinguin.jpg',
'In Blijdorp',
640, 435, 0.5, 1),
  img_velden(
'2006_mrt_Blijdorp_opa_oma_Johanneke_edwin.jpg',
'In Blijdorp',
640, 435, 0.5, 1),
  img_velden(
'2006_stoepkrijten_winter.jpg',
'Altijd kleuren of stoepkrijten...',
435, 640, 0.5, 1),
  img_velden(
'2006_Carlijn_bank.jpg',
'Zieke Carlijn op de bank',
435, 640, 0.5, 1),
  img_velden(
'2006_apr_Johanneke.jpg',
'Eerste schoolfoto',
480, 340, 0.5, 1),
 );

 my $out = make_table('border', 2, @imgs);
 return maintxt2htmlpage($out, q(Nieuwe foto's van Johanneke en Carlijn!), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('mei_06')});
}

sub get_foto_feb_05
{# (c) Edwin Spee
 # versie 1.0 27-feb-2005 initiele versie

 my @imgs = (
  img_velden(
'2005_feb_Carlijn_jarig_creche.jpg',
'Verjaardagsfeest Carlijn op de creche.',
480, 328, 0.5, 1),
  img_velden(
'2005_feb_Carlijn_jarig_kinderstoel.jpg',
'Carlijn 1 jaar!',
438, 640, 0.5, 1),
  img_velden(
'2005_feb_Johanneke_prinses.jpg',
'Johanneke in haar prinsesse-jurk.',
480, 360, 0.5, 1),
  '&nbsp;',
  img_velden(
'2005_feb_voorlezen.jpg',
'Papa leest voor',
465, 640, 0.5, 1),
  img_velden(
'2005_feb_zusjes_poehtrui1.jpg',
'De zusjes in hun Winnie-de-Poeh-trui',
439, 640, 0.5, 1),
  img_velden(
'2005_feb_zusjes_voor_de_sneeuw.jpg',
'Carlijn en Johanneke voor de besneeuwde tuin',
480, 328, 0.5, 1),
  img_velden(
'2005_feb_zusjes_poehtrui2.jpg',
'Opnieuw: de zusjes in hun Winnie-de-Poeh-trui',
435, 640, 0.5, 1),
 );

 my $out = make_table('border', 3, @imgs);
 return maintxt2htmlpage($out, q(Foto's van Johanneke en Carlijn uit 2005), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('feb_05')});
}

sub get_foto_sep_04
{# (c) Edwin Spee
 # versie 1.1 25-sep-2004 foto beide oma's vervangen
 # versie 1.0 19-sep-2004 initiele versie

 my @imgs = (
  img_velden(
'2004_zomer_johanneke_carlijn_bank.jpg',
'Johanneke en Carlijn samen op de bank',
 786, 1162, 0.2, 1),
  img_velden(
'2004_zomer_3dames.jpg',
'Anne-Marie met beide dochters',
 786, 1152, 0.2, 1),
  img_velden(
'2004_zomer_achtertuin.jpg',
'Edwin met zijn dochters in de achtertuin',
 781, 1157, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_jaap_connie.jpg',
'Carlijn bij ome Jaap op schoot',
 792, 1162, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_leonie.jpg',
'Carlijn bij haar nichtje Leonie op schoot',
 736, 1162, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_martine.jpg',
'Carlijn bij tante Martine op schoot',
 781, 1157, 0.2, 1),
  img_velden(
'2004_zomer_creche.jpg',
'foto van Johanneke en Carlijn door de schoolfotograaf',
 984,  682, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_connie.jpg',
'Carlijn bij tante Connie op schoot',
1162,  792, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_wilma.jpg',
'Carlijn bij tante Wilma op schoot',
1170,  725, 0.2, 1),
  img_velden(
'2004_zomer_carlijn_ingrid.jpg',
'Carlijn bij tante Ingrid',
1162,  786, 0.2, 1),
  img_velden(
'2004_zomer_twee_omas.jpg',
q(Johanneke met beide oma's),
 396,  528, 0.4, 1),
);

 my $out = make_table('border', 3, @imgs);
 return maintxt2htmlpage($out, q(Meer foto's van Johanneke en Carlijn.), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('sep_04')});
}

sub get_foto_carlijn_jan_04
{# (c) Edwin Spee
 # versie 1.0 30-jan-2004 initiele versie

my $out = << 'EOF';
<table border cellspacing=0>
<tr> <td valign="top">
<a href="anne-marie_en_carlijn.jpg">
<img src="anne-marie_en_carlijn.jpg"
alt="Anne-Marie en Carlijn" width="230" border="0"></a>
</td>
<td valign="top">
<a href="met_zijn_vieren.jpg">
<img src="met_zijn_vieren.jpg"
alt="met zijn vieren" width="230" border="0"></a>
</td>
<td valign="top" rowspan="2">
<a href="edwin_en_carlijn.jpg">
<img src="edwin_en_carlijn.jpg"
alt="Edwin en Carlijn" width="180" border="0"></a>
</td>
</tr>
<tr>
<td valign="top">
<a href="tante_ingrid_met_twee_nichtjes.jpg">
<img src="tante_ingrid_met_twee_nichtjes.jpg"
alt="Tante Ingrid met twee nichtjes" width="230" border="0"></a>
</td>
<td valign="top">
<a href="carlijn_in_box.jpg">
<img src="carlijn_in_box.jpg"
alt="Carlijn in box" width="230" border="0"></a>
<hr>
<a href="johanneke_tracteert.jpg">
<img src="johanneke_tracteert.jpg"
alt="Johanneke tracteert" width="230" border="0"></a>
</td></tr>
</table>
EOF
 return maintxt2htmlpage($out, q(Eerste foto's Carlijn!), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('jan_04')});
}

sub get_index_bruiloft
{# (c) Edwin Spee
 # versie 1.0 11-aug-2003 initiele versie

my $out = << 'EOF';
<P ALIGN="LEFT">
<IMG SRC="voor_onze_flat.jpg" WIDTH="568" HEIGHT="382"
ALT="Voor onze flat" BORDER="0">
</P>

<P ALIGN="LEFT">
<IMG SRC="anne-marie_in_trouwauto.jpg" WIDTH="579" HEIGHT="392"
ALT="Anne-Marie in trouwauto" BORDER="0">
</P>

<P ALIGN="LEFT">
<IMG SRC="voor_stadhuis.jpg" WIDTH="391" HEIGHT="580"
ALT="Voor het stadhuis" BORDER="0">
</P>

<P ALIGN="LEFT">
<IMG SRC="trouwauto.jpg" WIDTH="571" HEIGHT="388"
ALT="De trouwauto" BORDER="0">
</P>
EOF
 return maintxt2htmlpage($out, q(Trouwfoto's van Edwin en Anne-Marie), 'title2h1',
  -1, {mymenu => menu_bottum_fotos('bruiloft')});
}

sub get_index_feb02
{# (c) Edwin Spee
 # versie 1.0 11-aug-2003 initiele versie

 my $achter_pc = img_velden(
'bij_papa_achter_pc.jpg',
'bij papa achter pc.',
 480, 329, 0.42, 1);
 my $kinderstoel2 = img_velden(
'in_kinderstoel2.jpg',
'in kinderstoel.',
 480, 327, 0.42, 1);
 my $tegen_mama = img_velden(
'tegen_mama.jpg',
'tegen mama.',
 480, 329, 0.42, 1);
 my $kinderstoel1 = img_velden(
'in_kinderstoel.jpg',
'in kinderstoel.',
 438, 640, 0.33, 1);
 my $kerst_opa = img_velden(
'met_kerst_bij_opa.jpg',
'met kerst bij opa.',
 445, 640, 0.33, 1);
my $out = << "EOF";
<h2> Klik op de foto voor een vergroting </h2>
<table>
<tr> <td valign="top">
$achter_pc
<td valign="top">
$kinderstoel2
<td valign="top">
$tegen_mama
</table>
<table>
<tr>
<td valign="top">
$kinderstoel1
<td valign="top">
$kerst_opa
 </td> </tr>
</table>
EOF
 return maintxt2htmlpage($out, "Foto's van Johanneke en haar papa en mama.", 'title2h1',
  -1, {mymenu => menu_bottum_fotos('feb_02')});
}

sub get_index_jun01
{# (c) Edwin Spee
 # versie 2.0 01-feb-2005 zonder naam.html
 # versie 1.0 11-aug-2003 initiele versie

my $out = << 'EOF';
<table width="360">
<tr> <td>
<a href="johanneke_in_bed.jpg"> <img src="johanneke_in_bed.jpg"
alt="Johanneke in bed." width="200" border="0"> </a>
 <br>
<a href="anne-marie_geeft_johanneke_melk.jpg">
<img src="anne-marie_geeft_johanneke_melk.jpg"
 alt="Anne-Marie geeft Johanneke de fles." width="200" border="0"> </a>
 </td>
<td valign="top">
<a href="edwin_geeft_johanneke_melk.jpg">
<img src="edwin_geeft_johanneke_melk.jpg"
 alt="Edwin geeft Johanneke eerste flesje." width="150" border="0"> </a>
 </td> </tr>
</table>
EOF
 return maintxt2htmlpage($out, "De eerste foto's van Johanneke en haar trotse ouders.", 'title2h1',
  -1, {mymenu => menu_bottum_fotos('jun_01')});
}

sub get_index_mrt03
{# (c) Edwin Spee
 # versie 1.0 11-aug-2003 initiele versie

my $out = << 'EOF';
<table border cellspacing=0>
<tr> <td valign="top">
<img src="johanneke_loopt.jpg"
alt="ik kan lopen." width="700" border="0">
</table>
EOF
 return maintxt2htmlpage($out, 'Johanneke: ik kan lopen !', 'title2h1',
  -1, {mymenu => menu_bottum_fotos('mrt_03')});
}

sub get_index_okt01
{# (c) Edwin Spee
 # versie 2.0 01-feb-2005 zonder naam_klein.jpg en naam.html
 # versie 1.0 11-aug-2003 initiele versie

my $out = << 'EOF';
<table width="360">
<tr> <td valign="top">
<a href="portret1.jpg">
 <img src="portret1.jpg"
alt="Johanneke, een beetje eigenwijs." width="200" border="0"> </a>
<td valign="top">
<a href="portret2.jpg">
<img src="portret2.jpg"
 alt="Johanneke, in een bruin kistje." width="200" border="0"> </a>
<td valign="top">
<a href="portret3.jpg">
<img src="portret3.jpg"
 alt="Johanneke, zwart-wit portret." width="150" border="0"> </a>
 </td> </tr>
</table>
EOF
 return maintxt2htmlpage($out, 'Johanneke, ons fotomodel', 'title2h1',
  -1, {mymenu => menu_bottum_fotos('okt_01')});
}

return 1;
