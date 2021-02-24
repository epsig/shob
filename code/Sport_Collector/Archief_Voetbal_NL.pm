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
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Functions::Overig;
use Sport_Functions::Seasons;
use Sport_Functions::Formats;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Range_Available_Seasons;
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
$VERSION = '21.0';
# (c) Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_betaald_voetbal_nl',
 '&set_laatste_speeldatum_u_nl',
 #========================================================================
);

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
 
 my $opm_ered = $all_remarks->{eredivisie}->get_ml($szn, 'opm', 1);

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

  my $ranges = get_sport_range();
  my $last_beker_szn = $ranges->{beker}[1];
  my $dd2 = laatste_speeldatum_beker($last_beker_szn);

  $dd = max($dd, $dd2);
 }
 my $nc = get_nc($yr+1);
 return format_eindstanden($yr, $opm_ered, $europa_in, $nc, $dd);
}

sub set_laatste_speeldatum_u_nl
{
  my $ranges = get_sport_range();
  my $last_beker_szn = $ranges->{beker}[1];

  my $dd = laatste_speeldatum($u_nl->{lastyear});
  $u_nl->{laatste_speeldatum} = $dd;
  my $dd2 = laatste_speeldatum_beker($last_beker_szn);
  my $fixed_dd = max($dd, $dd2);

  set_datum_fixed($fixed_dd);
}

return 1;
