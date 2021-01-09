package Sport_Collector::Archief_EK_WK_Voetbal;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Sport_Functions::Formats;
use Sport_Functions::Overig;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Results2Standing;
use Sport_Functions::EkWkReaders;
use Sport_Functions::Readers;
use Sport_Functions::XML;
use Sport_Functions::NatLeagueReaders;
use Sport_Collector::Archief_Oefenduels;
use Sport_Collector::Archief_Voetbal_NL_Topscorers qw(&get_topscorers_competitie);
use Shob_Tools::Idate;
use File::Spec;
use Data::Dumper qw(Dumper);
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
 '&set_laatste_speeldatum_ekwk',
 '&get_wk2022v',
 '&get_ek2020v',
 '&get_wkD2019',
 '&get_wk2018',
 '&get_wk2018v',
 '&get_ek2016',
 '&get_ek2016v',
 '&get_wk2014',
 '&get_wk2014v',
 '&get_ek2012',
 '&get_ek2012v',
 '&get_wk2010',
 '&get_wk2010v',
 '&get_ek2008',
 '&get_ek2008v',
 '&get_wk2006',
 '&get_wk2006v',
 '&get_ek2004',
 '&get_ek2004v',
 '&get_wk2002v',
 '&get_wk2002',
 '&get_wk1998v',
 '&get_wk1998',
 '&get_ek2000v',
 '&get_ek2000',
 '&get_ek1996v',
 '&get_ek1996',
 #========================================================================
);

my $ekwkDir = 'ekwk';
my $ekwkQfDir = 'ekwk_qf';
my $xmlDir = File::Spec->catfile('..', 'data', 'sport', $ekwkDir);

sub get_ek1996()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'ek1996.csv');

 my $ek1996 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_1996.xml'));
 $ek1996->{sort_rule} = 4;
 $ek1996->{u16} = undef; # TODO

 return format_ekwk(1996, 'Engeland', $ek1996, [], 20200725);
}

sub get_ek1996v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'ek1996v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek1996u.csv');

 my $u_nl = read_voorronde($csvfile_u, 'gNL', 'u');
 $u_nl->[0] = ['Groepswedstrijden Nederland', [1, 3, '', 4]];

 my $u = read_voorronde_standen($csvfile, '2', 1);
 my $nrs2 = $u->[1];
 $nrs2->[0] = ['beste nummers 2'];

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 my $po = read_voorronde($csvfile, 'po', 'po');

  return format_voorronde_ekwk(1996, 'Engeland',
  {u_nl => $u_nl, kzb => get_oefenduels(19950000, 19960630),
   play_offs => $po, nrs2 => $nrs2, geplaatst => $list_geplaatst}, 20070114);
}

sub get_ek2000()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'ek2000.csv');

 my $ek2000 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_2000.xml'));
 $ek2000->{sort_rule} = 2;
 $ek2000->{u16} = undef; # TODO

 return format_ekwk(2000, 'Nederland en Belgi&euml;', $ek2000, [], 20200711);
}

sub get_ek2000v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'ek2000v.csv');

 my $po = read_voorronde($csvfile, 'po', 'po');

 my $grp_euro = read_voorronde_standen($csvfile, '1', 9);

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 my $extra = read_voorronde($csvfile, 'extra', 'extra');

 return format_voorronde_ekwk(2000, 'Belgi&euml; en Nederland',
  {kzb => get_oefenduels(19980801,20000630), extra => $extra,
   grp_euro => $grp_euro, play_offs => $po, geplaatst => $list_geplaatst},
  20200712);
}

sub get_wk1998()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'wk1998.csv');

 my $wk1998 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'WK_1998.xml'));
 $wk1998->{sort_rule} = 2;

 my $topscorers = get_topscorers_competitie('wk1998', 'ekwk', 'WK-1998');

 return format_ekwk(1998, 'Frankrijk', $wk1998, $topscorers, 20200715);
}

sub get_wk1998v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'wk1998v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk1998u.csv');

 my $u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

 my $po = read_voorronde($csvfile, 'po', 'po');

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 return format_voorronde_ekwk(1998, 'Frankrijk',
 {u_nl => $u_nl,
  kzb => get_oefenduels(19960901, 19980630),
  play_offs => $po, geplaatst => $list_geplaatst},
 20200718);
}

sub get_wk2002()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'wk2002.csv');

 my $wk2002 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'WK_2002.xml'));
 $wk2002->{sort_rule} = 2;

 return format_ekwk(2002, 'Japan en Zuid-Korea', $wk2002, [], 20070106);
}

sub get_wk2002v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'wk2002v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2002u.csv');

 my $uitslagen_2 = read_voorronde($csvfile_u, 'g2', 'u');

 my $uitslagen_po = read_voorronde($csvfile, 'po', 'po');

 my $grp_euro = read_voorronde_standen($csvfile, '1', 9);
 $grp_euro->[2] = u2s($uitslagen_2, 1, 3, 'Groep 2',-1);

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 return format_voorronde_ekwk(2002, 'Japan/Zuid-Korea',
  {u_nl => $uitslagen_2, beslissend => ['NL','IE','PT'],
   kzb => get_oefenduels(20000801, 20020531),
   grp_euro => $grp_euro, play_offs => $uitslagen_po, geplaatst => $list_geplaatst},
  20200711);
}

sub get_ek2004v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'ek2004v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek2004u.csv');

 my $u3 = read_voorronde($csvfile_u, 'g3', 'u');

 my $grp_euro = read_voorronde_standen($csvfile, '1', 10);
 $grp_euro->[3] = u2s($u3, 1, 3, 'Groep 3',1);

 my $po = read_voorronde($csvfile, 'po', 'po');

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 return format_voorronde_ekwk(2004, 'Portugal',
  {u_nl => $u3, kzb => get_oefenduels(20011101, 20040630),
   grp_euro => $grp_euro, play_offs => $po, geplaatst => $list_geplaatst},
  20200705);
}

sub get_ek2004()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'ek2004.csv');

 my $ek2004 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_2004.xml'));
 $ek2004->{sort_rule} = 2;
 $ek2004->{u16} = undef; # TODO

 my $topscorers = get_topscorers_competitie('ek2004', 'ekwk', 'EK-2004');

 return format_ekwk(2004, 'Portugal', $ek2004, $topscorers, 20070209);
}

sub get_wk2006()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'wk2006.csv');
 my $wk2006 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'WK_2006.xml'));

 # eigenlijk nwe srt_rule: pnt, wedstr, doelsaldo, onderling resultaat
 $wk2006->{sort_rule} = 2;

 my $topscorers = get_topscorers_competitie('wk2006', 'ekwk', 'WK-2006');

 return format_ekwk(2006, 'Duitsland', $wk2006, $topscorers, 20200701);
}

sub get_wk2006v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'wk2006v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2006u.csv');

 my $u_nl = read_voorronde($csvfile_u, 'g1', 'u');

 my $grp_euro = read_voorronde_standen($csvfile, '1', 8);

 my $kzb = get_oefenduels(20040800, 20060630);

 $grp_euro->[1] = u2s($u_nl, 1, 3, 'Groep 1', 1);

 my $po = read_voorronde($csvfile, 'po', 'po');

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 return format_voorronde_ekwk(2006, 'Duitsland',
  {u_nl => $u_nl, kzb => $kzb, grp_euro => $grp_euro, play_offs => $po, geplaatst => $list_geplaatst},
  20070110);
}

sub get_ek2008v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'ek2008v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek2008u.csv');

 my $u_nl = read_voorronde($csvfile_u, 'gG', 'u');

 my $kzb = get_oefenduels(20060800, 20080731);

 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');

 my $grp_euro = read_voorronde_standen($csvfile, 'A', 6);
 $grp_euro->[7] = u2s($u_nl, 1, 3, 'Groep G', 1);

 return format_voorronde_ekwk(2008, 'Oostenrijk/Zwitserland',
 {u_nl => $u_nl, kzb => $kzb, grp_euro => $grp_euro, geplaatst => $list_geplaatst}, 20140622);
}

sub get_ek2008()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkDir, 'ek2008.csv');
 my $ek2008 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_2008.xml'));
 $ek2008->{sort_rule} = 4;
 $ek2008->{u16} = undef; # TODO

 my $topscorers = get_topscorers_competitie('ek2008', 'ekwk', 'EK-2008');

 return format_ekwk(2008, 'Oostenrijk/Zwitserland', $ek2008, $topscorers, 20200623);
}

sub get_wk2010v()
{# (c) Edwin Spee

 my $csvfile = File::Spec->catfile($ekwkQfDir, 'wk2010v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2010u.csv');

 my $u_nl = read_voorronde($csvfile_u, 'g9', 'u');
 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');
 my $po = read_voorronde($csvfile, 'po', 'po');

 my $grp_euro = read_voorronde_standen($csvfile, '1', 8);
 $grp_euro->[9] = u2s($u_nl, 1, 3, 'Groep 9', 3);

 return format_voorronde_ekwk(2010, 'Zuid-Afrika',
 {u_nl => $u_nl, kzb => get_oefenduels(20080800, 20100630),
  play_offs => $po, geplaatst => $list_geplaatst, grp_euro => $grp_euro},
 20100605);
}

sub get_wk2010()
{# (c) Edwin Spee
 my $csvfile = File::Spec->catfile($ekwkDir, 'wk2010.csv');
 my $wk2010 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'WK_2010.xml'));
 $wk2010->{sort_rule} = 5;
 
 my $topscorers = get_topscorers_competitie('wk2010', 'ekwk', 'WK-2010');

 return format_ekwk(2010, 'Zuid-Afrika', $wk2010, $topscorers, 20200620);
}

sub get_ek2012v
{
 my $csvfile = File::Spec->catfile($ekwkQfDir, 'ek2012v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek2012u.csv');

 my $ek2012v_u_nl = read_voorronde($csvfile_u, 'gE', 'u');
 my $list_geplaatst = read_voorronde($csvfile, 'qf', 'qf');
 my $po = read_voorronde($csvfile, 'po', 'po');

 my $kzb = get_oefenduels(20100701,20120630);
 my $dd  = laatste_speeldatum($kzb);

 return format_voorronde_ekwk(2012, 'Polen/Oekra&iuml;ne',
 {u_nl => $ek2012v_u_nl, kzb => $kzb, geplaatst => $list_geplaatst,
  play_offs => $po}, $dd);
}

sub get_ek2012
{
 my $csvfile = File::Spec->catfile($ekwkDir, 'ek2012.csv');
 my $csv2012 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_2012.xml'));

 $csv2012->{sort_rule} = 4;
 $csv2012->{ster} = -1;

 $csv2012->{u16} = undef; # TODO

 my $topscorers = get_topscorers_competitie('ek2012', 'ekwk', 'EK-2012');

 return format_ekwk(2012, 'Polen/Oekra&iuml;ne', $csv2012, $topscorers, 20200615);
}

sub get_wk2014v
{
 my $csvfile = File::Spec->catfile($ekwkQfDir, 'wk2014v.csv');
 my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2014u.csv');

 my $wk2014v_u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

 my $po_wk2014 = read_voorronde($csvfile, 'po', 'po');

 my $kzb = get_oefenduels(20120701, 20140630);

 my $dd = laatste_speeldatum($kzb);

 return format_voorronde_ekwk(2014, 'Brazili&euml;',
 {u_nl => $wk2014v_u_nl, kzb => $kzb, play_offs => $po_wk2014},$dd);
}

sub get_wk2014
{
 my $csvfile = File::Spec->catfile($ekwkDir, 'wk2014.csv');
 my $csv2014 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'WK_2014.xml'));

 $csv2014->{sort_rule} = 5;

 my $topscorers = get_topscorers_competitie('wk2014', 'ekwk', 'WK-2014');

 my $dd = 20140720;
 return format_ekwk(2014, 'Brazili&euml;', $csv2014, $topscorers, $dd);
}

sub get_ek2016v
{
 my $ek2016v_u_nl = read_csv(File::Spec->catfile($ekwkQfDir, 'ek2016u.csv'));
 $ek2016v_u_nl->[0] = [ [''], [1, 3, '', 5]];
 
 my $kzb = get_oefenduels(20140701, 20160630);

 my $dd1 = laatste_speeldatum($ek2016v_u_nl);
 my $dd2 = laatste_speeldatum($kzb);
 my $dd = max($dd1, $dd2);
 return format_voorronde_ekwk(2016, 'Frankrijk',
 {u_nl => $ek2016v_u_nl, kzb => $kzb}, $dd);
}

sub get_ek2016
{
 my $csvfile = File::Spec->catfile($ekwkDir, 'ek2016.csv');
 my $csv2016 = read_wk($csvfile, File::Spec->catfile($xmlDir, 'EK_2016.xml'));
 
 $csv2016->{sort_rule} =  3;
 $csv2016->{ster}      = -1;

 my $topscorers = get_topscorers_competitie('ek2016', 'ekwk', 'EK-2016');

 my $dd = 20200606;
 return format_ekwk(2016, 'Frankrijk', $csv2016, $topscorers, $dd);
}

sub get_wk2018v
{
 my $wk2018v_u_nl = read_csv(File::Spec->catfile($ekwkQfDir, 'wk2018u.csv'));
 $wk2018v_u_nl->[0] = [ ['Groep A'], [1, 2, '', 4]];
 my $kzb = get_oefenduels(20160701, 20180630);

 my $dd = 20200523;
 return format_voorronde_ekwk(2018, 'Rusland',
 {u_nl => $wk2018v_u_nl, kzb => $kzb}, $dd);
}

sub get_wk2018
{
 my $dd = 20180722;
 my $csvFile = File::Spec->catfile($ekwkDir, 'wk2018.csv');
 my $wk2018 = read_wk($csvFile, '');
 my $topscorers = get_topscorers_competitie('wk2018', 'ekwk', 'WK-2018');
 return format_ekwk(2018, 'Rusland', $wk2018, $topscorers, $dd);
}

sub get_wkD2019
{
 my $dd = 20190723;
 my $csvFile = File::Spec->catfile($ekwkDir, 'wkD2019.csv');
 my $wkD2019 = read_wk($csvFile, '');
 my $topscorers = get_topscorers_competitie('wkD2019', 'ekwk', 'WK vrouwen 2019');
 return format_ekwk(2019, 'Frankrijk', $wkD2019, $topscorers, $dd);
}

sub get_ek2020v
{
  my $ek2020v_u_nl = read_csv(File::Spec->catfile($ekwkQfDir, 'ek2020u.csv'));
  $ek2020v_u_nl->[0] = [ ['Groep C'], [1, 5, '', 1]];
  my $kzb = get_oefenduels(20180701, 20210630);
  my $uNatL = ReadNatLeague('NL_2018_grpA.csv', 3);
  my $uNatLFinals = ReadNatLeagueFinals('NL_2019.csv');
  my $dd = laatste_speeldatum($ek2020v_u_nl);
  $dd = max($dd, laatste_speeldatum($kzb));
  $dd = max($dd, 20200922);
  return format_voorronde_ekwk(2021, '12 Europese landen en stadions',
    {u_nl => $ek2020v_u_nl, kzb => $kzb, NatL => $uNatL, NatLFinals => $uNatLFinals}, $dd);
}

my $uNatL = ReadNatLeague('NL_2020_grpA.csv', -1);
sub get_wk2022v
{
  #$ek2020v_u_nl->[0] = [ ['Groep C'], [1, 5, '', 1]];
  #my $kzb = get_oefenduels(20200701, 20220630);
  my $dd = max(20200913, laatste_speeldatum($uNatL));
  return format_voorronde_ekwk(2022, 'Qatar', {NatL => $uNatL}, $dd);
}

sub set_laatste_speeldatum_ekwk
{
 my $dd = 20200913;
 $dd = max($dd, laatste_speeldatum(get_oefenduels(20180701,99999999)));
 $dd = max($dd, laatste_speeldatum($uNatL));
#my $u = $wkD2019->{grp};
#my $all = combine_puus(@{$u});
#my @expect = ('u16', 'uk', 'uh', 'uf', 'u34');
#foreach my $val (@expect)
#{
# if (defined $wkD2019->{$val})
# {
#  $all = combine_puus($all, $wkD2019->{$val});
#}}
# $dd = max($dd, laatste_speeldatum($ek2020v_u_nl));
 set_datum_fixed($dd);
}

return 1;
