package Sport_Collector::Archief_Voetbal_NL;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::General;
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Sport_Functions::Readers;
use Sport_Functions::Overig;
use Sport_Functions::Formats;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Collector::Archief_Voetbal_Beker;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Archief_Voetbal_NL_Standen;
use Sport_Collector::Archief_Voetbal_NL_Beslissingen;
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
 '&get_betaald_voetbal_nl',
 '&set_laatste_speeldatum_u_nl',
 '&get_extremen_aantal_toeschouwers',
 #========================================================================
);

my $toeschouwers_eredivisie_per_club_per_seizoen = [
['adh', 1, '2003-2004',  7208],
['adh', 1, '2004-2005',  6338],

['ajx', 1, '1995-1996', 21992],
['ajx', 1, '1996-1997', 48069],
['ajx', 1, '1997-1998', 48423],
['ajx', 1, '1998-1999', 41275],
['ajx', 1, '1999-2000', 40873],
['ajx', 1, '2000-2001', 36339],
['ajx', 1, '2001-2002', 35809],
['ajx', 1, '2002-2003', 47571],
['ajx', 1, '2003-2004', 48996],
['ajx', 1, '2004-2005', 49595],

['az1', 1, '1996-1997',  7440],
['az1', 1, '1998-1999',  7884],
['az1', 1, '1999-2000',  6940],
['az1', 1, '2000-2001',  7154],
['az1', 1, '2001-2002',  7085],
['az1', 1, '2002-2003',  7179],
['az1', 1, '2003-2004',  7644],
['az1', 1, '2004-2005',  8182],

['cmb', 1, '1998-1999',  8418],
['cmb', 1, '1999-2000',  8132],

['dbs', 1, '1999-2000',  4240],
['dbs', 1, '2001-2002',  5190],
['dbs', 1, '2004-2005',  5790],

['exc', 1, '2002-2003',  3065],

['fst', 1, '1995-1996',  6318],
['fst', 1, '1996-1997',  4606],
['fst', 1, '1997-1998',  5859],
['fst', 1, '1998-1999',  6206],
['fst', 1, '1999-2000',  8112],
['fst', 1, '2000-2001',  8370],
['fst', 1, '2001-2002',  6672],

['fyn', 1, '1995-1996', 26376],
['fyn', 1, '1996-1997', 26931],
['fyn', 1, '1997-1998', 25042],
['fyn', 1, '1998-1999', 31231],
['fyn', 1, '1999-2000', 32855],
['fyn', 1, '2000-2001', 37609],
['fyn', 1, '2001-2002', 39902],
['fyn', 1, '2002-2003', 43123],
['fyn', 1, '2003-2004', 41411],
['fyn', 1, '2004-2005', 37988],

['gae', 1, '1995-1996',  6591],

['grf', 1, '1995-1996',  7102],
['grf', 1, '1996-1997',  8440],
['grf', 1, '1997-1998',  8100],
['grf', 1, '1998-1999',  7959],
['grf', 1, '1999-2000',  9223],
['grf', 1, '2000-2001', 10191],
['grf', 1, '2001-2002', 10890],
['grf', 1, '2002-2003', 10870],
['grf', 1, '2004-2005', 11105],

['grn', 1, '1995-1996', 12056],
['grn', 1, '1996-1997', 12941],
['grn', 1, '1997-1998', 13100],
['grn', 1, '2000-2001', 11162],
['grn', 1, '2001-2002', 11687],
['grn', 1, '2002-2003', 12001],
['grn', 1, '2003-2004', 12189],
['grn', 1, '2004-2005', 11901],

['hrv', 1, '1995-1996', 13724],
['hrv', 1, '1996-1997', 13279],
['hrv', 1, '1997-1998', 13608],
['hrv', 1, '1998-1999', 13768],
['hrv', 1, '1999-2000', 13813],
['hrv', 1, '2000-2001', 14188],
['hrv', 1, '2001-2002', 14235],
['hrv', 1, '2002-2003', 14258],
['hrv', 1, '2003-2004', 14678],
['hrv', 1, '2004-2005', 18448],

['mvv', 1, '1997-1998',  6038],
['mvv', 1, '1998-1999',  6165],
['mvv', 1, '1999-2000',  6530],

['nac', 1, '1995-1996',  9618],
['nac', 1, '1996-1997', 12165],
['nac', 1, '1997-1998', 12564],
['nac', 1, '1998-1999', 10775],
['nac', 1, '2000-2001', 12758],
['nac', 1, '2001-2002', 13268],
['nac', 1, '2002-2003', 13730],
['nac', 1, '2003-2004', 12643],
['nac', 1, '2004-2005', 12493],

['nec', 1, '1995-1996',  5203],
['nec', 1, '1996-1997',  4701],
['nec', 1, '1997-1998',  4914],
['nec', 1, '1998-1999',  6368],
['nec', 1, '1999-2000',  8335],
['nec', 1, '2000-2001', 10088],
['nec', 1, '2001-2002', 10429],
['nec', 1, '2002-2003', 11032],
['nec', 1, '2003-2004', 12220],
['nec', 1, '2004-2005', 11797],

['psv', 1, '1995-1996', 25862],
['psv', 1, '1996-1997', 25174],
['psv', 1, '1997-1998', 27865],
['psv', 1, '1998-1999', 25556],
['psv', 1, '1999-2000', 28441],
['psv', 1, '2000-2001', 31294],
['psv', 1, '2001-2002', 31494],
['psv', 1, '2002-2003', 33105],
['psv', 1, '2003-2004', 32852],
['psv', 1, '2004-2005', 31688],

['rbc', 1, '2000-2001',  5081],
['rbc', 1, '2002-2003',  4970],
['rbc', 1, '2003-2004',  4981],
['rbc', 1, '2004-2005',  4841],

['rkc', 1, '1995-1996',  3518],
['rkc', 1, '1996-1997',  4535],
['rkc', 1, '1997-1998',  4464],
['rkc', 1, '1998-1999',  5271],
['rkc', 1, '1999-2000',  5576],
['rkc', 1, '2000-2001',  5457],
['rkc', 1, '2001-2002',  6302],
['rkc', 1, '2002-2003',  6508],
['rkc', 1, '2003-2004',  5900],
['rkc', 1, '2004-2005',  5806],

['rdj', 1, '1995-1996',  8500],
['rdj', 1, '1996-1997',  7612],
['rdj', 1, '1997-1998',  7521],
['rdj', 1, '1998-1999',  6809],
['rdj', 1, '1999-2000',  7664],
['rdj', 1, '2000-2001', 13300],
['rdj', 1, '2001-2002', 14517],
['rdj', 1, '2002-2003', 13697],
['rdj', 1, '2003-2004', 13023],
['rdj', 1, '2004-2005', 12709],

['spr', 1, '1995-1996',  4962],
['spr', 1, '1996-1997',  4882],
['spr', 1, '1997-1998',  5607],
['spr', 1, '1998-1999',  4526],
['spr', 1, '1999-2000',  7213],
['spr', 1, '2000-2001',  7755],
['spr', 1, '2001-2002',  7660],

['twn', 1, '1995-1996',  6876],
['twn', 1, '1996-1997',  7653],
['twn', 1, '1997-1998',  8447],
['twn', 1, '1998-1999', 12156],
['twn', 1, '1999-2000', 12782],
['twn', 1, '2000-2001', 13211],
['twn', 1, '2001-2002', 13205],
['twn', 1, '2002-2003', 13233],
['twn', 1, '2003-2004', 13053],
['twn', 1, '2004-2005', 13088],

['utr', 1, '1995-1996',  7559],
['utr', 1, '1996-1997', 10731],
['utr', 1, '1997-1998', 11971],
['utr', 1, '1998-1999', 13065],
['utr', 1, '1999-2000', 13211],
['utr', 1, '2000-2001', 13594],
['utr', 1, '2001-2002', 13076],
['utr', 1, '2002-2003', 16198],
['utr', 1, '2003-2004', 17400],
['utr', 1, '2004-2005', 19718],

['vit', 1, '1995-1996',  7001],
['vit', 1, '1996-1997',  7287],
['vit', 1, '1997-1998', 13789],
['vit', 1, '1998-1999', 23080],
['vit', 1, '1999-2000', 25097],
['vit', 1, '2000-2001', 26007],
['vit', 1, '2001-2002', 24756],
['vit', 1, '2002-2003', 22959],
['vit', 1, '2003-2004', 18973],
['vit', 1, '2004-2005', 18770],

['vol', 1, '1995-1996',  3988],
['vol', 1, '1996-1997',  4418],
['vol', 1, '1997-1998',  4021],
['vol', 1, '2003-2004',  5036],

['wl2', 1, '1995-1996',  8614],
['wl2', 1, '1996-1997',  8376],
['wl2', 1, '1997-1998', 10017],
['wl2', 1, '1998-1999', 12049],
['wl2', 1, '1999-2000', 14191],
['wl2', 1, '2000-2001', 13726],
['wl2', 1, '2001-2002', 13652],
['wl2', 1, '2002-2003', 13466],
['wl2', 1, '2003-2004', 12753],
['wl2', 1, '2004-2005', 12470],

['zwl', 1, '2002-2003',  5931],
['zwl', 1, '2003-2004',  6250],
];

sub get_extremen_aantal_toeschouwers($$$)
{# (c) Edwin Spee

 my ($seizoen, $divisie, $min_max) = @_;

 my ($h, $hc, $l, $lc) = (-1e33, -1, +1e33, -1);

# TODO : werkt niet bij 2 dezelfde min/max
 foreach my $row (@$toeschouwers_eredivisie_per_club_per_seizoen)
 {
  if ($row->[2] eq $seizoen and $row->[1] == $divisie)
  {
   if ($row->[3] > $h)
   {
    $h = $row->[3];
    $hc = $row->[0];
   }
   if ($row->[3] < $l)
   {
    $l = $row->[3];
    $lc = $row->[0];
   }
  }
 }
 return ($min_max eq 'max' ? [$h, expand($hc, 3)] : [$l, expand($lc, 3)]);
}

sub get_nc($)
{# (c) Edwin Spee

 my ($year) = @_;
 my $nc;
 my $pd = $nc_po->{$year}{PD};
 if ($year < 2006 and defined($pd))
 {
  my $opm = '';
  if (defined $pd->{opm_nc}) {$opm = $pd->{opm_nc};}
  $nc = [$opm, $pd->{ncA}, $pd->{ncB}];
 }
 elsif ($year == 2006 or $year == 2007)
 {
  $nc = [ftable('border', get_uitslag($pd->{finale}, {})), [], []];
 }
 elsif ($year == 2008)
 {
  $nc = [ftable('border', get_uitslag($pd->{3}, {})), [], []];
 }
 elsif ($year == 2009)
 {
  $nc = [ftable('border',
   get_uitslag($nc_po->{2009}{PD}{2}, {}) .
   get_uitslag($nc_po->{2009}{PD}{3}, {}))];
 }
 elsif ($year == 2010)
 {
  $nc = [ftable('border',
   get_uitslag($nc_po->{2010}{PD}{3}, {}) .
   ftr(ftd({cols => 2},
   "Kampioen en rechtstreekse promotie: De Graafschap.<br>\n" .
   "Excelsior promoveert na winst in de nacompetitie op stadgenoot Sparta.<br>\n" .
   "Haarlem wegens faillisement uit de competitie genomen.<br>\n" .
   "TOP Oss degradeert naar (nieuwe) Topklasse<br>\n" )))];
 }
 elsif ($year == 2011)
 {
  $nc = [ftable('border', ftr(ftd(
   "Periodekampioenen: FC Zwolle, Volendam, MVV en RKC.\n" .
   '<br> Excelsior en VVV behouden eredivisieschap na nacompetitie.')))];
 }
 elsif ($year == 2012)
 {
  $nc = [ftable('border', ftr(ftd(
   'Periodekampioenen: FC Zwolle, FC Den Bosch en Sparta.')))];
 }
 else
 {
  $nc = [];
 }
 return $nc;
}

sub get_betaald_voetbal_nl($)
{# (c) Edwin Spee

 my $yr = shift;
 my $szn = yr2szn($yr);
 
 my $opm_ered = ReadOpm($szn, 'opm', 'NL', 1);

 my $europa_in = '';
 my $dd = 20090722;

 if ($yr == 1993)
 {$dd = 20090803;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1994_1995.html#CL">Champions League:</a> Ajax <br>
<a href="sport_voetbal_europacup_1994_1995.html#CWC">Europacup II</a>: Feyenoord<br>
<a href="sport_voetbal_europacup_1994_1995.html#UEFAcup">UEFA cup</a>: PSV, Vitesse en FC Twente.
EOF
 }
 elsif ($yr == 1994)
 {$dd = 20080216;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1995_1996.html#CL">Champions League:</a> Ajax <br>
<a href="sport_voetbal_europacup_1995_1996.html#CWC">Europacup II</a>: Feyenoord<br>
<a href="sport_voetbal_europacup_1995_1996.html#UEFAcup">UEFA cup</a>: Roda JC en PSV
EOF
 }
 elsif ($yr == 1995)
 {$dd = 20080216;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1996_1997.html#CL">Champions League:</a> Ajax <br>
<a href="sport_voetbal_europacup_1996_1997.html#CWC">Europacup II</a>: PSV<br>
<a href="sport_voetbal_europacup_1996_1997.html#UEFAcup">UEFA cup</a>: Feyenoord en Roda JC
EOF
 }
 elsif ($yr == 1996)
 {$dd = 20080211;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1997_1998.html#CL">Champions League:</a> PSV en Feyenoord<br>
<a href="sport_voetbal_europacup_1997_1998.html#CWC">Europacup II</a>: Roda JC<br>
<a href="sport_voetbal_europacup_1997_1998.html#UEFAcup">UEFA cup</a>: Twente, Ajax en Vitesse
EOF
 }
 elsif ($yr == 1997)
 {$dd = 20201030;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1998_1999.html#CL">Champions League:</a> Ajax<br>
<a href="sport_voetbal_europacup_1998_1999.html#vCL">Voorronde Champions League:</a> PSV<br>
<a href="sport_voetbal_europacup_1998_1999.html#CWC">Europacup II:</a> Heerenveen<br>
<a href="sport_voetbal_europacup_1998_1999.html#UEFAcup">UEFA cup:</a> Vitesse, Feyenoord en Willem II<br>
EOF
 }
 elsif ($yr == 1998)
 {$dd = 20080209;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_1999_2000.html#CL">Champions League:</a> Feyenoord en Willem II<br>
<a href="sport_voetbal_europacup_1999_2000.html#vCL">Voorronde Champions League:</a> PSV<br>
<a href="sport_voetbal_europacup_1999_2000.html#UEFAcup">UEFA cup:</a> Ajax (bekerwinnaar), Vitesse en Roda JC<br>
EOF
 }
 elsif ($yr == 1999)
 {$dd = 20080209;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2000_2001.html#CL">Champions League:</a> PSV en Heerenveen <br>
<a href="sport_voetbal_europacup_2000_2001.html#vCL">Voorronde Champions League:</a> Feyenoord <br>
<a href="sport_voetbal_europacup_2000_2001.html#UEFAcup">UEFA cup:</a> de bekerwinnaar Roda JC en Vitesse en Ajax <br>
EOF
 }
 elsif ($yr == 2000)
 {$dd = 20030807;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2001_2002.html#CL">Champions League:</a> PSV en Feyenoord <br>
<a href="sport_voetbal_europacup_2001_2002.html#vCL">Voorronde Champions League:</a> Ajax <br>
<a href="sport_voetbal_europacup_2001_2002.html#UEFAcup">UEFA cup:</a> de bekerwinnaar FC Twente, Roda JC en FC Utrecht <br>
EOF
 }
 elsif ($yr == 2001)
 {$dd = 20030807;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2002_2003.html#CL">Champions League:</a> Ajax en PSV; <br>
<a href="sport_voetbal_europacup_2002_2003.html#vCL">voorronde Champions League:</a> Feyenoord; <br>
<a href="sport_voetbal_europacup_2002_2003.html#UEFAcup">UEFA-cup:</a> Heerenveen, Vitesse en FC Utrecht <br>
EOF
 }
 elsif ($yr == 2002)
 {$dd = 20030811;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2003_2004.html#CL">Champions League:</a> PSV.
<br> <a href="sport_voetbal_europacup_2003_2004.html#vCL">Voorronde Champions League:</a> Ajax.
<br> <a href="sport_voetbal_europacup_2003_2004.html#UEFAcup">UEFA-cup:</a> bekerwinnaar FC Utrecht, Feyenoord, NAC en NEC.
EOF
 }
 elsif ($yr == 2003)
 {$dd = 20040810;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2004_2005.html#CL">Champions League:</a> Ajax.
<br> <a href="sport_voetbal_europacup_2004_2005.html#vCL">Voorronde Champions League:</a> PSV.
<br> <a href="sport_voetbal_europacup_2004_2005.html#UEFAcup">UEFA-cup:</a> bekerwinnaar FC Utrecht, Feyenoord, Heerenveen en AZ.
EOF
 }
 elsif ($yr == 2004)
 {$dd = 20050809;
  $europa_in = << 'EOF';
<a href="sport_voetbal_europacup_2005_2006.html#CL">Champions League:</a> PSV.
<br> <a href="sport_voetbal_europacup_2005_2006.html#vCL">Voorronde Champions League:</a> Ajax.
<br> <a href="sport_voetbal_europacup_2005_2006.html#UEFAcup">UEFA-cup:</a>
bekerfinalist Willem II, AZ, Feyenoord en Heerenveen.
EOF
 }
 elsif ($yr == 2005)
 {$dd = 20070512;
  $europa_in =
"PSV als kampioen rechtstreeks naar de " .
qq(<a href="sport_voetbal_europacup_2006_2007.html#CL">Champions League</a>.\n) .
"<p>Overige plekken voor het eerst via Play Offs:\n" .
qq(<br>Ajax naar <a href="sport_voetbal_europacup_2006_2007.html#vCL">voorronde Champions League</a> en\n) .
"<br>Groningen, Feyenoord, AZ en Heerenveen naar de " .
qq(<a href="sport_voetbal_europacup_2006_2007.html#UEFAcup">UEFA-cup.\n) .
"<br>Twente naar de Intertoto.\n" .
get_uitslag(combine_puus($nc_po->{2006}{CL}{1}, $nc_po->{2006}{CL}{finale}), {}) .
get_uitslag($nc_po->{2006}{UEFA}{finale}, {}) .
get_uitslag($nc_po->{2006}{Intertoto}{finale}, {});}
 elsif ($yr == 2006)
 {$dd = 20080523;
  $europa_in =
"PSV als kampioen rechtstreeks naar de " .
qq(<a href="sport_europacup_2007_2008.html#CL">Champions League</a>.\n) .
"<p>Overige plekken via Play Offs:\n" .
qq(<br>Ajax naar <a href="sport_europacup_2007_2008.html#vCL">voorronde Champions League</a> en\n) .
"<br>AZ, Heerenveen, Twente en Groningen naar de " .
qq(<a href="sport_europacup_2007_2008.html#UEFAcup">UEFA-cup.</a>\n) .
"<br>Utrecht naar de Intertoto.\n" .
get_uitslag(combine_puus($nc_po->{2007}{CL}{1}, $nc_po->{2007}{CL}{finale}), {}) .
get_uitslag(combine_puus($nc_po->{2007}{UEFA}{1}, $nc_po->{2007}{UEFA}{finale}), {}) .
get_uitslag(combine_puus($nc_po->{2007}{Intertoto}{1}, $nc_po->{2007}{Intertoto}{2},
 $nc_po->{2007}{Intertoto}{finale}), {});}
 elsif ($yr == 2007)
 {$dd = 20090220;
  $europa_in =
'PSV als kampioen rechtstreeks naar de '.
qq(<a href="sport_voetbal_europacup_2008_2009.html#CL">Champions League</a>.\n) .
'<p>FC Twente via Plays Offs naar ' .
qq(<a href="sport_voetbal_europacup_2008_2009.html#vCL">voorronde Champions League</a>.\n) .
'<p>Feyenoord als bekerwinnaar naar de ' .
qq(<a href="sport_voetbal_europacup_2008_2009.html#UEFAcup">UEFA-cup</a>.\n) .
"<p>Ajax, Heerenveen en NEC via Play Offs na de UEFA-cup.\n" .
"<p>NAC na de Play Offs in de Intertoto.<p>\n" .
 get_uitslag(
  combine_puus(
   $nc_po->{2008}{CL}{1},
   $nc_po->{2008}{CL}{finale}), {}) .
 get_uitslag(
  combine_puus(
#  $nc_po->{2008}{UEFA}{2},
   $nc_po->{2008}{UEFA}{3}), {});}
 elsif ($yr == 2008)
 {$europa_in =
qq(AZ als kampioen rechtstreek naar de <a href="sport_voetbal_europacup_2009_2010.html#CL">Champions League</a>.\n).
'<p>FC Twente (zonder nationale play-offs) naar de ' .
qq(<a href="sport_voetbal_europacup_2009_2010.html#vCL">voorronde Champions League</a>.\n) .
'<p>Ajax, PSV en Heerenveen (zonder nationale play-offs),' .
"<br> en NAC als winnaar van de play-offs\n" .
qq(<br> naar de <a href="sport_voetbal_europacup_2009_2010.html#EuropaL">voorronde Europa League (opvolger UEFA-cup)</a>.\n) .
#get_uitslag($nc_po->{2009}{UEFA}{1}, {}) .
 get_uitslag($nc_po->{2009}{UEFA}{2}, {});
  $dd = 20100508;
 }
 elsif ($yr == 2009)
 {
  $europa_in =
qq(FC Twente als kampioen naar de Champions League.\n) .
qq(<p>Ajax naar de voorronde Champions League.\n) .
qq(<p>PSV, Feyenoord en AZ direct naar (een voorronde van) de Europa League.\n) .
qq(<p>FC Utrecht wint in de play-offs het laatste ticket voor de Europa League,\n) .
qq(<br>en mag vlak na de WK-finale al weer aan de slag.\n) .
#get_uitslag($nc_po->{2010}{UEFA}{1}, {}) .
 get_uitslag($nc_po->{2010}{UEFA}{2}, {});
  $dd = 20101128;
 }
 elsif ($yr == 2010)
 {
  $dd = 20110515;
 }
 elsif ($yr == 2011)
 {
  $dd = 20120527;
 }
 elsif ($yr == 2012)
 {
  $dd = 20130804;
 }
 elsif ($yr == 2013)
 {
  $dd = 20140810;
 }
 elsif ($yr == 2014)
 {
  $dd = 20150517;
 }
 elsif ($yr == 2015)
 {
  $dd = 20160617;
 }
 elsif ($yr == 2017)
 {
  $dd = 20180520;
 }
 elsif ($yr == 2019)
 {
  $dd = 20200426;
 }
 else
 {
  $dd = laatste_speeldatum($u_nl->{lastyear});
  my $dd2 = laatste_speeldatum_beker('2020-2021');
  $dd = max($dd, $dd2);
  $dd = max(20200913, $dd);
 }
 my $nc = get_nc($yr+1);
 return format_eindstanden($yr, $opm_ered, $europa_in, $nc, $dd);
}

sub set_laatste_speeldatum_u_nl
{# (c) Edwin Spee

 my $dd = laatste_speeldatum($u_nl->{lastyear});
 $dd = max(20200913, $dd);
 $u_nl->{laatste_speeldatum} = $dd;
 my $dd2 = laatste_speeldatum_beker('2019-2020');
 my $fixed_dd = max($dd, $dd2);
 #$fixed_dd = max(laatste_speeldatum_nc_po(2010), $fixed_dd);
 set_datum_fixed($fixed_dd);
}

return 1;
