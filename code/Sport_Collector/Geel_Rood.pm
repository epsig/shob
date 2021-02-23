package Sport_Collector::Geel_Rood;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Html_Stuff;
use Sport_Functions::Seasons;
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
 '&get_gele_rode_kaarten_tabel',
 #========================================================================
);

sub get_namen_expand_geel_rood($)
{# (c) Edwin Spee

 my $p = $_[0];
 return fth({cols => 2}, $nbsp) if not defined $p;
 my ($tot_gr, $club) = ($p->[0] >= 0 ? ($p->[0], $p->[1]) : ($nbsp, $nbsp));
 return ftdl($club) . ftdl($tot_gr);
}

sub show_stats_cgr($)
{# (c) Edwin Spee
 # versie 1.0 23-dec-2003 initiele versie

 my $p = $_[0];
 my $min_g = 999;
 my $max_g =   0;
 my $min_r = 999;
 my $max_r =   0;
 my $tot_g =   0;
 my $tot_r =   0;
 while (my($key, $value) = each %$p)
 {$tot_g += $value->[0];
  $tot_r += $value->[1];
  if ($value->[0] > $max_g) {$max_g = $value->[0];}
  if ($value->[1] > $max_r) {$max_r = $value->[1];}
  if ($value->[0] < $min_g) {$min_g = $value->[0];}
  if ($value->[1] < $min_r) {$min_r = $value->[1];}
 }
 print "Geel: totaal, min, max = $tot_g, $min_g, $max_g.\n";
 print "Rood: totaal, min, max = $tot_r, $min_r, $max_r.\n";
}

sub get_gele_rode_kaarten_tabel($$$)
{# (c) Edwin Spee

 my ($yrA, $yrB, $ABBA) = @_;
# onderstaande cijfers blijken niet overeen te komen met totalen:
# my $club_geel_rood_0203 = {
#'Ajx' => [32, 4], 'AZ1' => [56, 3], 'Exc' => [25, 2], 'Fyn' => [30, 2],
#'Grf' => [48, 3], 'Grn' => [42, 0], 'Hrv' => [48, 1], 'NAC' => [40, 1],
#'NEC' => [52, 3], 'PSV' => [31, 1], 'RBC' => [40, 3], 'RKC' => [51, 6],
#'Rdj' => [44, 1], 'Twn' => [51, 2], 'Utr' => [40, 2], 'Vit' => [46, 3],
#'Wl2' => [44, 4], 'Zwl' => [37, 1]};
#show_stats_cgr($club_geel_rood_0203);
#
# uit sub get_nl0607()
#  Ook het aantal getrokken kaarten steeg.
#  Vorig seizoen vielen er 981 gele en 58
#  rode kaarten en dit seizoen werd 1.050
#  keer geel getoond en 68 keer rood.

 my $tot_geel = {
'1988-1989' => 528,
'1989-1990' => 626,
'1990-1991' => 536,
'1991-1992' => 618,
'1992-1993' => 716,
'1993-1994' => 734,
'1994-1995' => 712,
'1995-1996' => 809,
'1996-1997' => 937,
'1997-1998' => 947,
'1998-1999' => 931,
'1999-2000' => 849,
'2000-2001' => 925,
'2001-2002' => 838,
'2002-2003' => 783,
'2003-2004' => (57+55+55+55+54+51+50+49+47+45+43+42+40+40+40+38+38+26),
'2004-2005' => (60+59+57+56+56+54+51+50+50+49+46+45+43+41+39+37+35+35),
};

my $tot_rood = {
'1988-1989' => 22,
'1989-1990' => 22,
'1990-1991' => 36, # ["professional foul"-rule was introduced]
'1991-1992' => 35,
'1992-1993' => 45, # ["emergency-break"-foul cost you a red card]
'1993-1994' => 40,
'1993-1994' => 40,
'1994-1995' => 54,
'1995-1996' => 56,
'1996-1997' => 63,
'1997-1998' => 79, # max.!
'1998-1999' => 69,
'1999-2000' => 59,
'2000-2001' => 60,
'2001-2002' => 58,
'2002-2003' => 55,
'2003-2004' => (6+2*4+4*3+7*2+4*1),
'2004-2005' =>
(2+3+1+1+2+2+1+1+1+1+2+4+1) + # direct rood
(1+2+1+1+1+2+4+2+1+3+1), # 2x geel
};

my $meeste_geel = {
'1988-1989' => [50,'FC Utrecht'],
'1989-1990' => [53,'FC Utrecht'],
'1990-1991' => [53,'SVV'],
'1991-1992' => [59,'FC Den Haag'],
'1992-1993' => [59,'Cambuur'],
'1993-1994' => [50,'RKC'],
'1994-1995' => [64,'MVV'],
'1995-1996' => [58,'Utrecht <br>Twente'],
'1996-1997' => [80,'Groningen'],
'1997-1998' => [70,'Volendam'],
'1998-1999' => [65,'FC Utrecht'],
'1999-2000' => [62,'MVV; FC Utrecht'],
'2000-2001' => [-1,''],
'2001-2002' => [-1,''],
'2002-2003' => [-1,''],
'2003-2004' => [57,'ADO Den Haag'],
'2004-2005' => [60,'Vitesse'], # Willem II: 59 + 1x 2xgeel=rood
};

my $minste_geel = {
'1988-1989' => [14,'Ajax'],
'1989-1990' => [20,'Ajax'],
'1990-1991' => [14,'Ajax'],
'1991-1992' => [21,'Feijenoord'],
'1992-1993' => [20,'Ajax'],
'1993-1994' => [22,'Roda JC'],
'1994-1995' => [12,'Ajax'],
'1995-1996' => [14,'Ajax'],
'1996-1997' => [27,'Ajax'],
'1997-1998' => [31,'Ajax'],
'1998-1999' => [-1,''],
'1999-2000' => [32,'Willem II'],
'2000-2001' => [-1,''],
'2001-2002' => [-1,''],
'2002-2003' => [-1,''],
'2003-2004' => [26,'Ajax'],
'2004-2005' => [35,'Feyenoord<br>PSV'],};

my $meeste_rood = {
'1993-1994' => [6,'Cambuur'],
'1994-1995' => [5,'G.A. Eagles <br> MVV <br> FC Groningen'],
'1995-1996' => [-1,''],
'1996-1997' => [-1,''],
'1997-1998' => [-1,''],
'1998-1999' => [8,'PSV'],
'1999-2000' => [7,'FC Utrecht'],
'2000-2001' => [-1,''],
'2001-2002' => [-1,''],
'2002-2003' => [-1,''],
'2003-2004' => [6,'Vitesse'],
'2004-2005' => [4,'Willem II<br>NAC<br>Feyenoord'],
};

my $minste_rood = {
'1993-1994' => [0, 'Roda JC'],
'1994-1995' => [1, 'Ajax <br> Vitesse <br> Willem  II'],
'1995-1996' => [-1,''],
'1996-1997' => [-1,''],
'1997-1998' => [-1,''],
'1998-1999' => [-1,''],
'1999-2000' => [1, 'Roda JC; Feyenoord'],
'2000-2001' => [-1,''],
'2001-2002' => [-1,''],
'2002-2003' => [-1,''],
'2003-2004' => [1, 'Heerenveen <br> NAC, RBC <br> Willem II'],
'2004-2005' => [0, 'Ajax'],
};

 my $out = '';
 for (my $i = 0; $i <= $yrB - $yrA; $i++)
 {my $year = ( $ABBA ? $yrA + $i : $yrB - $i);
  my $seizoen = yr2szn($year);
  $out .= ftr(ftdl($seizoen)
   . ftdl($tot_geel->{$seizoen} or $nbsp)
   . get_namen_expand_geel_rood($meeste_geel->{$seizoen})
   . get_namen_expand_geel_rood($minste_geel->{$seizoen})
   . ftdl($tot_rood->{$seizoen} or $nbsp)
   . get_namen_expand_geel_rood($meeste_rood->{$seizoen})
   . get_namen_expand_geel_rood($minste_rood->{$seizoen}))
 }
 $out = '<a name="geel_rood"></a>' .
  ftable('border',
   ftr(fth('seizoen') .
       fth('geel') .
       fth({cols => 2}, 'meeste geel') .
       fth({cols => 2}, 'minste geel') .
       fth('rood') .
       fth({cols => 2}, 'meeste rood') .
       fth({cols => 2}, 'minste rood')) . $out);
 return $out;
}

return 1;
