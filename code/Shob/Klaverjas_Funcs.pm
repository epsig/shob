package Shob::Klaverjas_Funcs;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Error_Handling;
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Html_Stuff;
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
 '&get_klaverjas_faq',
 '&get_kj_code',
 '&versleutel',
 '&get_klaverjas_std_scherm',
 '&get_kj_palmtop',
 #========================================================================
);

 my $style = << 'EOF';
<style type="text/css">
body {background:silver; color:black; font-family:"Verdana","Arial"; font-size:12pt}
th,td {background:white; font-size:12pt; padding-top:2pt; padding-bottom:2pt; padding-left:4pt; padding-right:4pt}
input,option {font-family:"Verdana","Arial"; font-size:12pt}
input.k {font-family:"Courier New","Courier"; font-weight: bold; font-size:14pt}
input.b {font-family:"Courier New","Courier"; font-weight: bold; font-size:12pt}
</style>
EOF

# deze 4 eruit vanwege palmtop-versie:
#f0 ShowKaartL
#f1 ShowKaartR
#f2 ShowKaartM
#f3 ShowKaartS
# en deze voor std/gfx:
#mL TotaleScore
#n4 BSpelNiveau
#mQ HuidigNiv
#mC HelpFunctie
#mO IncSpelNiveau
#f5 KiesTroefTxt
#mP ShowTroefKleur
#f9 HuidigeTroefKiezer
#mR ShowScore
#f6 KiesTroefKleur
#f7 HuidigeScoreU
#f8 HuidigeScoreC
#fA HuidigeRoemU
#fB HuidigeRoemC
#mS ShowRoem
#n5 IndeHand
#nJ NieuwSpel

my %lijst = qw(
c vkleur
o OKaart
h hoogte
p punten
r v_roem
m0 next_check
m1 LoadFinished
m2 found
m3 found1
m4 found2
m5 outstr
m6 geschiedenis
m7 OutSlagStr
m8 vgespeeld
m9 tekst1
mA tekst2
mB status
mD vorige1
mE volgende1
mF volgende2
mG volgende3
mH waarde
mI roem100
mJ roem200
mK TelRoem
mM KomUit
mN SpeelKaart
mT AmsRotStr
mU AmsRotStr2
mV setadm
mW SchudKaarten
mX ALL_READY_USED
mZ FKiesTroef
n0 KRHSpnt
n1 Bekennen
n2 RestMarkeren
n3 OverTroefen
n6 SlagIndex
n7 OnderTroefen
n8 KomSlimUit
n9 j_found
nA vhoogste
nB ALL_READY_USED
nC nr_maat
nD Loaded
nE Kaart4
nF Kaart23
nG gifje
nH NOT_USED
nI speler
nK volgorde
nL InfoHelp
nM ALL_READY_USED
nN Help1
nO Help2
nP Help3
nQ WijZij
nR NwSpel
nS SelectGoTo
nT extra
nU gonow
s1 WelkeKaartenMogen
s2 HoogsteDezeKleurOpTafel
s3 ComputerAanZet_vervolg
s4 UpdateKaartKleur
s5 UpdateIndeHand
s6 NochTroefNochBekennen
s7 TroefTrekkenSlim
s8 IsHoogsteDezeKleur
s9 BerekenScore
s0 count_loaded_img
sA ZoekWinnaarSlag
sB WelkeKaartType1
sC WelkeKaartType2
sD WelkeKaartType34
sE OutputMSG1
sF OutputMSG2
sG setkjkoekkie
sH getkjkoekkie
sI InitMSGLijst
sJ InitScoreLijst
sK SlimsteZet
sL Hand2Tafel
sM WinnerIs
sN ComputerAanZet
sO NietVerzaakt
sP ALL_READY_USED
sQ PreLoadImg
sR PreLoad
g1 kleur_deze_slag
g2 groot_scherm
g3 start_speler
g4 troef_kiezer
g5 troef_offset
g6 totaalU
g7 totaalC
g8 scoreU
g9 scoreC
gA roemU
gB roemC
gC pit_C
v0 g_niveau
v1 DezeKaartenMogen
v2 slimme_zet
v3 KaartOpTafel
v4 found_troef_vrouw
v5 found_troef_heer
v6 LigtOpTafel
v7 nameplayer
v8 volgorde_form
v9 kj_koekkies
vF ID_timeout
vG TroefVolgordeInv
vH VolgordeRestInv
vI TroefPunten
vJ PuntenRest
vK cmp_hoogte
vL KRHSgifje
vM KRHSlong
vN naam_long
vO naam_short
vP kom_niet_met_troef
vQ OutputStr
vR tot_gespeeld
vS filtertype
vT show_preload
vU preloadi
vV SLMR
vW AmsRot
vX slag_nr
vY spel_nr
vZ g_troef
f4 GoToKeus
l0 today
l1 expiry
l6 index
lO endstr
l2 koekkie
l3 kj_koekkie
l7 lwaarde
lP lkleur
l8 tkst
lQ tkst_roemU
lR tkst_roemC
lS tkst_pnt
l4 potjes
l5 PotjeStr
lK ComputerWeerAanZet
lL delay
lM hoeveel_mogen
lA hogetroef
lB winnaar
lC kaartnr
lD cmp_kleur
lE typeslag
lF max_found
lG i_found
lH max_elm
lI gevonden
lJ kaartn
lT temp
sT vorig_overzicht
sU afronden
sV KRHSitalic
sW KRHScolor
sX use_color_italic
sY check_color_italic
sZ logstr
aA Analyseer_spel
aB normeren
aC SlagLigtAan
aD consistent_maken
aE hoogste
aF print_kk
aG kleur_slag
aH verbose
aI mogelijk1
aJ mogelijk2
aK zeker
aL tegen1
aM tegen2
aN nr_tegen1
aO nr_tegen2
aP zelf
aQ troef_tegen
aR max_iter
aS tol
aT kkindex
aU hkrth
aV krt_ij
aW kl_sl_ij
aX logtol
aY krth
aZ ready
bA outer
bB scale
bC vslag
bD from
bE sum
bF optie
bG CTroefVolgordeInv
bH CVolgordeRestInv
bI CTroefPunten
bJ CPuntenRest
bK GetDezeKaartenMogen
bL settings_koekkies
bM volgende_slag
);

sub versleutel($)
{# (c) Edwin Spee

 my ($ptxt) = @_;

 # reset hash iterator:
 my $i = scalar keys %lijst;
 while (my ($key, $val) = each %lijst)
 {
   $$ptxt =~ s/\b$val\b/$key/g;
 }
}

sub get_kj_code($$)
{# (c) Edwin Spee

 my ($gfx_txt, $versie) = @_;

 my @files;

 if ($versie eq 'test')
 {@files = (
   'web_kj_main.js', 'tools.js', 'OTimer.js', 'OHelp.js', 'OSetAnalyse.js',
   'OKaart.js', 'OBasicRules.js', 'OStack.js', 'OStrategy.js', 'OEnvironment.js', 'OScore.js',
   'OSetAdmin.js','OMatchAdmin.js',  'OScreenAdmin.js', 'ODebug.js');}
 else
 {@files = (
   'web_kj_main.js', 'tools.js', 'OTimer.js', 'OHelp.js', 'OSetAnalyse.js',
   'OKaart.js', 'OBasicRules.js', 'OStack.js', 'OStrategy.js', 'OEnvironment.js', 'OScore.js',
   'OSetAdmin.js','OMatchAdmin.js',  'OScreenAdmin.js');}

 if ($gfx_txt eq 'txt') {push @files, 'web_kj_color_italic.js';}
 else {push @files, 'web_kj_preload.js';}

 my $do_versleutel = ($versie eq 'test' ? 0 : 2);

 my $kj_code = js_collect($do_versleutel, $versie, @files);

 $kj_code =~ s/(var versie ?= ?"\d.\d{1,2})(";)/$1-$versie$2/   if ($versie ne 'std');

 return $kj_code;
}

sub js_collect($$@)
{# (c) Edwin Spee

 my ($do_versleutel, $versie, @bron) = @_;
 my $tot_l = 0;
 my $new_l;
 my $no_break = 0;
 my $outtxt = '';

 foreach my $f (@bron)
 {
  my $dir;
  if ($f eq 'tools.js')
  {$dir = 'my_scripts';}
  elsif ($versie eq 'std')
  {$dir = 'Klaverjas';}
  else
  {$dir = "Klaverjas-$versie";}

  my $f2 = File::Spec->catfile($dir, $f);
  open (BRON, $f2) or shob_error('open_read', [$f2]);
  if ($do_versleutel)
  {
   while (<BRON>)
   {
    chomp;
    $no_break = (m/^.\*/iso);
    s/.*debug.*//iso;
    s/.*dbg.*//iso;
    if (not ($no_break))
    {
     if (not m/'/iso )
     {
      s/ *([-+(){}[\]*?=\/;|:><,!&%]) */$1/isog;
     }
     if (not m/http/iso )
     {
      s#([^\/]*)//.*#$1#iso;
     }
     else
     {
      s#^//.*##iso;
     }
     s/^ *//iso;
     s/ *$//iso;
    }
    $new_l = $tot_l + length($_);
    if ($no_break or $versie eq 'beta' or $versie eq 'std')
    {
     $outtxt .= "$_\n";
     $tot_l = 0;
    }
    elsif (m/function/iso or $new_l > 120 )
    {
     $outtxt .= "\n$_";
     $tot_l = length($_);
    }
    else
    {
     $outtxt .= $_;
     $tot_l = $new_l;
    }
   }
  }
  else
  {
   if ($outtxt ne '') {$outtxt .= "\n";}
   $outtxt .= "// from file: $f\n";
   while (<BRON>)
   {
    $outtxt .= $_;
  }}
  close BRON;
 }

 if ($do_versleutel)
 {
  $outtxt .= "\n";
  versleutel(\$outtxt);
 }

 my $hopa  = ($web_index eq '' ? $www_epsig_nl : $web_index);
 $outtxt =~ s#www_epsig_nl#$hopa#imog;

 return $outtxt;
}

sub get_6smaken($)
{# (c) Edwin Spee

 my ($edition) = @_;

 my $title = $edition;
 if ($title eq '') {$title = '&nbsp;';}

 my $outtxt = << "EOF";
<table border cellspacing=0>
 <tr> <th> Amsterdams </th> <th> Rotterdams </th> </tr>
 <tr>
  <td class="c"> <a href="kj_gfx_adam.html"> met plaatjes </a> </td>
  <td class="c"> <a href="kj_gfx_rdam.html"> met plaatjes </a> </td>
 </tr>
 <tr>
  <td class="c"> <a href="kj_txt_adam.html"> text-only </a> </td>
  <td class="c"> <a href="kj_txt_rdam.html"> text-only </a> </td>
 </tr>
 <tr>
  <td class="c"> <a href="kj_klein_rdam.html"> text-only en klein scherm </a> </td>
  <td class="c"> <a href="kj_klein_adam.html"> text-only en klein scherm </a> </td>
 </tr>
</table>
EOF

 return $outtxt;
}

sub get_klaverjas_title
{# (c) Edwin Spee

 my ($versie) = @_;

 if ($versie eq 'std')
 {return 'Klaverjassen';}
 elsif ($versie eq 'beta')
 {return 'Klaverjassen (beta-versie)';}
 else
 {return 'Klaverjassen (test-versie)';}
}

sub get_kj_js_head($$)
{# (c) Edwin Spee

 my ($gfx_txt, $versie) = @_;

 if ($versie eq 'test')
 {
  my $kj_js  = get_kj_code($gfx_txt, $versie);
  return [1, $kj_js];
 }
 elsif ($versie eq 'beta')
 {
  return [2, "include/kj_code_${gfx_txt}_beta.js"];
 }
 else
 {
  return [2, "include/kj_code_$gfx_txt.js"];
 }
}

sub get_klaverjas_std_scherm($$$)
{# (c) Edwin Spee

 my ($gfx_txt, $amsrot, $versie) = @_;

 my $out = kj_tabel($gfx_txt);
 my $type = "$gfx_txt;$amsrot;$versie";
 my $dd   = 20080219;

 return maintxt2htmlpage($out, get_klaverjas_title($versie), 'std',
  $dd, {type1 => $type, pjs => get_kj_js_head($gfx_txt, $versie), style => $style});
}

sub get_settings_form($)
{# (c) Edwin Spee

 my ($is_local) = @_;

 my $dbg_out = << 'EOF';
<hr>
debug:
<input type="button" value="on/off" name="debug_button" onClick="debug_onoff();"/>
verbose:
<input type="button" value=" - " onClick="inc_verb(-1);"/>
<input type="button" value=" 1/2/3/4 " name="verb_button"/>
<input type="button" value=" + " onClick="inc_verb(1);"/>
semi-automaat:
<input type="button" value="on/off" name="autom_button" onClick="autom_onoff();"/>
EOF

 my $stopna4 = qq(4 <input type="radio" value="4" name="stop_radio" onClick="stop_na(4);"/>);

 if (not $is_local) {$dbg_out = ''; $stopna4 = ''}

 my $out = << "EOF";
<tr> <td colspan=2>
<hr> Speciale settings:<p>
<form name="form1">
Score door 10 delen en afronden:
<input type="button" value="on/off" name="round_button" onClick="round_onoff();"/>
<br>
Altijd door blijven spelen:
<input type="radio" value="inf" name="stop_radio" onClick="stop_na('inf');" checked/>
, of stoppen na:
16 <input type="radio" value="16" name="stop_radio" onClick="stop_na(16);"/>
32 <input type="radio" value="32" name="stop_radio" onClick="stop_na(32);"/>
$stopna4
potjes.
<br>
tempo:
<input type="button" value=" - " onClick="inc_tempo(-1);"/>
<input type="button" value=" 1-9 " name="tempo_button"/>
<input type="button" value=" + " onClick="inc_tempo(1);"/>
$dbg_out
</form> </td> </tr>
EOF
}

sub get_klaverjas_faq
{# (c) Edwin Spee

 my $url_beta = 'kj_beta_versies.html';
 if (get_host_id() eq 'werk') {$url_beta = 'https://www.epsig.nl/' . $url_beta;}

 my $out = "<ol> <li> Welke versies zijn er precies? <br> Mijn klaverjas-spel is er in 6 smaken:\n";
 $out .= get_6smaken('');
 $out .= << "EOF";
  <li> Waarom kan ik niet passen?
   <br> Het verplicht spelen was sneller te programmeren.
  <li> Amsterdams is helemaal niet Amsterdams; Rotterdams is helemaal niet Rotterdams!
   <br> Er zijn veel varianten van klaverjassen met een flinke spraakverwarring als gevolg.
   Ik heb de volgende regels toegepast:
   <ol>
    <li> Verplicht troefkiezen, en dan als eerste uitkomen.
    <li> Kleur bekennen indien mogelijk.
    <li> Als troef wordt gevraagd, en je kunt overtroeven, dan moet dat.
    <li> Als je niet kunt bekennen, moet je introeven, behalve als de slag aan je maat ligt.
     <br> Bij Rotterdams moet dat ook als de slag aan je maat ligt.
    <li> Je mag alleen ondertroeven, als je niets anders kunt.
   </ol>
  <li> Na &quot;Reload&quot; doet de tekst-only uitvoering van het programma vreemd.
   <br> Waarom weet ik ook niet, maar ik kan niet vinden waarom.
   Daarom kun je beter &quot;Nieuw Spel&quot; uit het menu op pagina zelf gebruiken.
  <li> Ook op niveau drie speelt mijn maat niet best!
   <br> Er kan inderdaad slimmer gespeeld worden, maar dat vraagt een forse programmeerinspanning.
    Dat ga ik misschien ooit doen, maar die versie komt dan mogelijk niet gratis op Internet.
 </ol>
EOF

 return maintxt2htmlpage([['Klaverjas - FAQ', $out]], 'Klaverjas - FAQ', 'std',
  20180521, {type1 => 'std_menu', skip1 => 2});
}

sub get_kj_palmtop($$$)
{# (c) Edwin Spee

 my ($do_versleutel, $amsrot, $versie) = @_;

 my $dir = 'Klaverjas';
 if ($versie ne 'std') {$dir = "$dir-$versie";}
 my $palmtop_scherm = File::Spec->catfile($dir, 'palmtop_scherm.html');
 my $out = file2str($palmtop_scherm);
 if ($do_versleutel) {versleutel(\$out);}
 bespaar_bandbreedte_ref(\$out);

 my $type = "klein;$amsrot;$versie";

 return maintxt2htmlpage($out, get_klaverjas_title($versie), 'std',
  20080907,
  {type1 => $type, pjs => get_kj_js_head('txt', $versie)}); #, style => $style});
}

sub img_wit($)
{
 my ($x) = @_;
 return '<img border=0 src="include/wit.gif" height=' . $x . ' width=' . $x . '/>';
}

sub show_kaart($$)
{
 my ($gfx, $k) = @_;
 return ftdl(fform("ShowKaart$k", ($gfx? img_wit(50) : finput('text', '', '', 4, 'k', ''))));
}

sub kj_tabel($)
{
 my $gfx = (shift eq 'gfx');

 my $topline = ftdx('vtop', fform('KiesTroefTxt', finput('text', 'vld1', 'kies troef:', 12, '', '')));

 my $formtxt = '';
 if ($gfx)
 {
  for (my $i=0; $i<4; $i++)
  {
   $formtxt .= '<a href="javascript:KiesTroef(' . $i . ')">' . img_wit(40) . '</a>' . $nbsp;
 }}
 else
 {
  for (my $i=0; $i<4; $i++)
  {
   $formtxt .= finput('button', '', ' ? ', 0, 'k', "KiesTroef($i);");
 }}
 $topline .= ftd({cols => 2}, fform('KiesTroefKleur', $formtxt)) .
  ftdx('vtop', 'Score: ') .
  ftdl(fform('ShowScore', finput('text', 'HuidigeScoreU', 0, 4, '', '') .
  finput('text', 'HuidigeScoreC', 0, 4, '', '') ) );

 $formtxt = ''; my $mx_hist = $gfx ? 6 : 7;
 my $input_field = finput('text', '', '', 5, '', '');
 for (my $i=0; $i < $mx_hist; $i++)
 {
  if ($i > 0)
  {
   $formtxt .= '<br>';
  }
  $formtxt .= $input_field . $nbsp . $input_field;
 }

 $topline .= ftd({rows=>($gfx ? 4 : 5)},
  fform('WijZij', finput('text', 'Wij', 'Wij', 5, '', '') .
  finput('text', 'Zij', 'Zij', 5, '', '') .  '<br>') .
  fform('TotaleScore', $formtxt));

 my $OutputStr = ftr($topline) . ftr( ftdx('vtop', 'gekozen door: ') .
  ftd({cols => 2}, fform('ShowTroefKleur',
  finput('text', 'HuidigeTroefKiezer', '???', 10, '', ''))) .
  ftdx('vtop', 'Roem: ') . ftdl(fform('ShowRoem',
  finput('text', 'HuidigeRoemU', 0, 4, '', '') .
  finput('text', 'HuidigeRoemC', 0, 4, '', '')))) .
  ftr(ftd({cols => 2}, fform('BSpelNiveau',
  finput('button', '', "Spelniveau:", -1, 'b', "HelpFunctie(3);") .
  finput('button', '', "-", -1, 'b', "IncSpelNiveau(-1);") .
  finput('button', "HuidigNiv", 1, -1, 'b',  "HelpFunctie(3);") .
  finput('button', '', '+', -1, 'b', "IncSpelNiveau(1);"))) .
  show_kaart($gfx, 'M') .
  ftd({cols=>2, align=>'center', valign=>'center'},
  fform('InfoHelp',
  finput('button', '', ' ? ', -1, 'b', "HelpFunctie(1);") .
  finput('button', '', ' i ', -1, 'b', "HelpFunctie(4);") .
  finput('button', '', ' &copy; ', -1, 'b', "HelpFunctie(2);"))));

 $formtxt = '';
 if ($gfx)
 {
  for (my $i=0; $i<8; $i++)
  {
   $formtxt .= '<a href="javascript:SpeelDeze(' . $i . ')">' . img_wit(50) . '</a>' . $nbsp . "\n";
  }
  $OutputStr .= ftr(tds(1) . show_kaart($gfx, 'L') . show_kaart($gfx, 'S') . show_kaart($gfx, 'R') . tds(1)) .
                ftr(ftd({cols=>6, align=>'center'}, fform('IndeHand', $formtxt)));
 }
 else
 {
  for (my $i=0; $i<8; $i++)
  {
   $formtxt.= finput('button', '', 'WWW', -1, "k", "SpeelDeze($i);");
  }
  $OutputStr .= ftr(tds(1) . show_kaart($gfx, 'L') . tds(1) . show_kaart($gfx, 'R') . tds(1)) .
                ftr(tds(2) . show_kaart($gfx, 'S') . tds(2)) .
                ftr(tds(1) . ftd({cols=>5}, fform('IndeHand', $formtxt)));
 }

 $OutputStr .= ftr(ftd({cols => 6} ,fform('msg',
  finput('text', 'm0', ' ', 43, '', '') .
  finput('text', 'm1', ' ', 43, '', ''))));

 return ftable('border_width100%', $OutputStr);
}

return 1;
