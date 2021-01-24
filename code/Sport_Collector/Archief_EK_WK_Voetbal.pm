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

sub get_ekwk_voorr_gen($)
{ # (c) Edwin Spee

  my $id = shift;

  my $year = $id;
     $year =~ s/[ew]kD?//;

  my $csvfile_q = File::Spec->catfile($ekwkQfDir, "${id}q.csv");
  my $csvfile_u = File::Spec->catfile($ekwkQfDir, "${id}u.csv");
  my $csvfile_v = File::Spec->catfile($ekwkQfDir, "${id}v.csv");
  my $csvfile_s = File::Spec->catfile($ekwkQfDir, "${id}s.csv");

  my $organising_country = $all_remarks->{ekwk_qf}->get($id, 'organising_country');
  if (not defined $organising_country)
  {
    $organising_country = $all_remarks->{ekwk}->get($id, 'organising_country');
  }
  my $dd                 = $all_remarks->{ekwk_qf}->get($id, 'dd');
  my $gNL                = $all_remarks->{ekwk_qf}->get($id, 'grpNL', 'gNL');

  my $ekwk_qf = {};
  my $u_nl = read_voorronde($csvfile_u, $gNL, 'u');
  if (defined $u_nl)
  {
    if (scalar @{$u_nl} > 1)
    {
      $ekwk_qf = {u_nl => $u_nl};
    }
  }

  my $start = $all_remarks->{ekwk_qf}->get($id, 'start');
  my $cnt = $all_remarks->{ekwk_qf}->get($id, 'cnt');
  my $u = read_voorronde_standen($csvfile_s, $start, $cnt);

  if (defined $u)
  {
    if ($cnt == 1)
    {
      my $nrs2 = $u->[1];
      $nrs2->[0] = ['beste nummers 2'];
      $ekwk_qf->{nrs2} = $nrs2;
    }
    else
    {
      $ekwk_qf->{grp_euro} = $u;
      if ($gNL =~ m/g(.)$/)
      {
        my $grp = $1;
        my $grpNr = $grp;
        if ($start eq 'A') {$grpNr = 1 + ord($grpNr) - ord('A');}
        my $star_grp_euro = -1;
        $star_grp_euro = $all_remarks->{ekwk_qf}->get($id, 'star_grp_euro', $star_grp_euro);
        $ekwk_qf->{grp_euro}->[$grpNr] = u2s($u_nl, 1, 3, "Groep $grp", $star_grp_euro);
      }
    }
  }

  $ekwk_qf->{geplaatst} = read_voorronde($csvfile_q, 'qf', 'qf');

  $ekwk_qf->{play_offs} = read_voorronde($csvfile_u, 'po', 'po_new');

  my $dd1kzb = 1e4 * ($year - 2) + 810; # 810: aug, 10
  my $dd2kzb = 1e4 *  $year      + 630; # 630: june, 30
     $dd1kzb = $all_remarks->{ekwk_qf}->get($id, 'dd1kzb', $dd1kzb);
  $ekwk_qf->{kzb} = get_oefenduels($dd1kzb, $dd2kzb);

  $ekwk_qf->{extra} = read_voorronde($csvfile_v, 'extra', 'extra');

  my $beslissend = $all_remarks->{ekwk_qf}->get($id, 'beslissend');
  if (defined $beslissend)
  {
    my @countries = split(/;/, $beslissend);
    $ekwk_qf->{beslissend} = \@countries;
  }

  if ($dd eq 'auto')
  {
    $dd = laatste_speeldatum($ekwk_qf->{kzb});
    $dd = max($dd, laatste_speeldatum($u_nl));
  }

  my $html = format_voorronde_ekwk($year, $organising_country, $ekwk_qf, $dd);
}

sub get_ek1996v()
{ # (c) Edwin Spee

  return get_ekwk_voorr_gen('ek1996');
}

sub get_ek2000v()
{ # (c) Edwin Spee

  return get_ekwk_voorr_gen('ek2000');
}

sub get_wk1998v()
{# (c) Edwin Spee

  return get_ekwk_voorr_gen('wk1998');
}

sub get_wk2002v()
{# (c) Edwin Spee

  return get_ekwk_voorr_gen('wk2002');
}

sub get_ek2004v()
{ # (c) Edwin Spee

  return get_ekwk_voorr_gen('ek2004');
}

sub get_wk2006v()
{ # (c) Edwin Spee

  return get_ekwk_voorr_gen('wk2006');
}

sub get_ek2008v()
{# (c) Edwin Spee

  return get_ekwk_voorr_gen('ek2008');
}

sub get_wk2010v()
{ # (c) Edwin Spee

  return get_ekwk_voorr_gen('wk2010');
}

sub get_ek2012v
{
  return get_ekwk_voorr_gen('ek2012');
}

sub get_wk2014v
{
  return get_ekwk_voorr_gen('wk2014');
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
