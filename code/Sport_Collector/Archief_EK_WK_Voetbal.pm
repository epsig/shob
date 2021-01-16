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
use Sport_Functions::ListRemarks qw($all_remarks);
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
  '&get_ekwk_gen',
  '&get_wk2022v',
  '&get_ek2020v',
  '&get_wk2018v',
  '&get_ek2016v',
  '&get_wk2014v',
  '&get_ek2012v',
  '&get_wk2010v',
  '&get_ek2008v',
  '&get_wk2006v',
  '&get_ek2004v',
  '&get_wk2002v',
  '&get_wk1998v',
  '&get_ek2000v',
  '&get_ek1996v',
 #========================================================================
);

my $ekwkDir = 'ekwk';
my $ekwkQfDir = 'ekwk_qf';
my $xmlDir = File::Spec->catfile('..', 'data', 'sport', $ekwkDir);

sub get_ekwk_gen($)
{ # (c) Edwin Spee

  my $id = shift;

  my $year = $id;
     $year =~ s/[ew]kD?//;

  my $ekwk = substr($id, 0, 2);

  my $dd                 = $all_remarks->{ekwk}->get($id, 'dd');
  my $organising_country = $all_remarks->{ekwk}->get($id, 'organising_country');
  my $sort_rule          = $all_remarks->{ekwk}->get($id, 'sort_rule', 5);
  my $title              = $all_remarks->{ekwk}->get($id, 'title', uc($ekwk) . '-' . $year);

  my $csv_file = File::Spec->catfile($ekwkDir, "$id.csv");
  my $xml_file = File::Spec->catfile($xmlDir, uc($ekwk) . "_$year.xml");

  my $all_results = read_ekwk($id, $csv_file, $xml_file, $sort_rule);

  my $topscorers = get_topscorers_competitie($id, 'ekwk', $title);
  my $html = format_ekwk($year, $organising_country, $all_results, $topscorers, $dd);
  return $html;
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

sub get_ek2016v
{
  my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek2016u.csv');
  my $ek2016v_u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

  my $kzb = get_oefenduels(20140701, 20160630);

  my $dd1 = laatste_speeldatum($ek2016v_u_nl);
  my $dd2 = laatste_speeldatum($kzb);
  my $dd = max($dd1, $dd2);
  return format_voorronde_ekwk(2016, 'Frankrijk', {u_nl => $ek2016v_u_nl, kzb => $kzb}, $dd);
}

sub get_wk2018v
{
  my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2018u.csv');
  my $wk2018v_u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

  my $kzb = get_oefenduels(20160701, 20180630);

  my $dd = 20200523;
  return format_voorronde_ekwk(2018, 'Rusland', {u_nl => $wk2018v_u_nl, kzb => $kzb}, $dd);
}

sub get_ek2020v
{
  my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'ek2020u.csv');
  my $ek2020v_u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

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
  my $csvfile_u = File::Spec->catfile($ekwkQfDir, 'wk2022u.csv');
  my $wk2022v_u_nl = read_voorronde($csvfile_u, 'gNL', 'u');

  #my $kzb = get_oefenduels(20200701, 20220630);
  my $dd = max(20210110, laatste_speeldatum($uNatL));
  return format_voorronde_ekwk(2022, 'Qatar', {u_nl => $wk2022v_u_nl,NatL => $uNatL}, $dd);
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
