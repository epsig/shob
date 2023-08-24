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
use Sport_Functions::Readers qw($csv_dir);
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
  '&get_ekwk_voorr_gen',
 #========================================================================
);

my $ekwkDir = 'ekwk';
my $ekwkQfDir = 'ekwk_qf';
my $xmlDir = File::Spec->catfile($csv_dir, $ekwkDir);

sub get_ekwk_gen($;$)
{ # (c) Edwin Spee

  my $id      = shift;
  my $outtype = shift;

  my $year = $id;
     $year =~ s/[ew]kD?//;

  my $ekwk = substr($id, 0, length($id)-4);

  my $dd                 = $all_remarks->{ekwk}->get($id, 'dd');
  my $organising_country = $all_remarks->{ekwk}->get($id, 'organising_country');
  my $sort_rule          = $all_remarks->{ekwk}->get($id, 'sort_rule', 5);
  my $title              = $all_remarks->{ekwk}->get($id, 'title', uc($ekwk) . '-' . $year);
  my $summary            = $all_remarks->{ekwk}->get_ml($id, 'summary_NL', 1);

  my $csv_file = File::Spec->catfile($ekwkDir, "$id.csv");
  my $xml_file = File::Spec->catfile($xmlDir, uc($ekwk) . "_$year.xml");

  my $all_results = read_ekwk($id, $csv_file, $xml_file, $sort_rule);

  my $topscorers = get_topscorers_competitie($id, 'ekwk', $title);

  my $all = combine_puus(@{$all_results->{grp}});
  my @expect = ('u16', 'uk', 'uh', 'uf', 'u34');
  foreach my $val (@expect)
  {
    if (defined $all_results->{$val})
    {
      $all = combine_puus($all, $all_results->{$val});
    }
  }
  $all_results->{all} = $all;
  my $ddu = laatste_speeldatum($all);
  $dd = (defined $dd ? max($dd, $ddu) : $ddu);

  if ($summary ne '') {$all_results->{summary} = $summary;}

  if (defined $outtype && $outtype eq 'dd')
  {
    return $dd;
  }

  my $html = format_ekwk($year, $organising_country, $all_results, $topscorers, $dd);
  return $html;
}

my $all_ekwk_qf = {};

sub get_ekwk_voorr_data($)
{
  my $id      = shift;
  if (defined $all_ekwk_qf->{$id})
  {
    return $all_ekwk_qf->{$id};
  }

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

  my $ekwk_qf = {organising_country => $organising_country};
  my $u_nl = read_voorronde($csvfile_u, $gNL, 'u', $id);
  if (defined $u_nl)
  {
    if (scalar @{$u_nl} > 1)
    {
      $ekwk_qf->{u_nl} = $u_nl;
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
        my $star_grp_euro = $u_nl->[0][1][3];
        $star_grp_euro = $all_remarks->{ekwk_qf}->get($id, 'star_grp_euro', $star_grp_euro);
        $ekwk_qf->{grp_euro}->[$grpNr] = u2s($u_nl, 1, 3, "Groep $grp", $star_grp_euro);
      }
    }
  }

  $ekwk_qf->{geplaatst} = read_voorronde($csvfile_q, 'qf', 'qf', $id);

  $ekwk_qf->{play_offs} = read_voorronde($csvfile_u, 'po', 'po', $id);

  my $dd1kzb = 1e4 * ($year - 2) + 810; # 810: aug, 10
  my $dd2kzb = 1e4 *  $year      + 630; # 630: june, 30
     $dd1kzb = $all_remarks->{ekwk_qf}->get($id, 'dd1kzb', $dd1kzb);
     $dd2kzb = $all_remarks->{ekwk_qf}->get($id, 'dd2kzb', $dd2kzb);
  my $kzb = get_oefenduels($dd1kzb, $dd2kzb);
  if (scalar @$kzb > 1)
  {
    $ekwk_qf->{kzb} = $kzb;
  }

  $ekwk_qf->{extra} = read_voorronde($csvfile_v, 'extra', 'extra', $id);

  my $beslissend = $all_remarks->{ekwk_qf}->get($id, 'beslissend');
  if (defined $beslissend)
  {
    my @countries = split(/;/, $beslissend);
    $ekwk_qf->{beslissend} = \@countries;
  }

  my $uNatLFile = $all_remarks->{ekwk_qf}->get($id, 'NatLeagueGroup');
  if (defined $uNatLFile)
  {
    my $NatLster = 3;
    $NatLster = $all_remarks->{ekwk_qf}->get($id, 'NatLeagueGroupSter', $NatLster);
    $ekwk_qf->{NatL} = ReadNatLeague($uNatLFile, $NatLster);
  }
  my $uNatLFinalsFile = $all_remarks->{ekwk_qf}->get($id, 'NatLeagueFinals');
  if (defined $uNatLFinalsFile)
  {
    $ekwk_qf->{NatLFinals} = ReadNatLeagueFinals($uNatLFinalsFile);
  }

  if ($dd eq 'auto')
  {
    $dd = 0;
    my @comps = ($ekwk_qf->{kzb}, $u_nl, $ekwk_qf->{NatL});
    foreach my $comp (@comps)
    {
      if (defined $comp)
      {
        $dd = max($dd, laatste_speeldatum($comp));
      }
    }
  }
  $ekwk_qf->{dd} = $dd;

  $all_ekwk_qf->{$id} = $ekwk_qf;

  return $ekwk_qf;
}

sub get_ekwk_voorr_gen($;$)
{ # (c) Edwin Spee

  my $id      = shift;
  my $outtype = shift;

  my $ekwk_qf = get_ekwk_voorr_data($id);

  if (defined $outtype && $outtype eq 'dd')
  {
    return $ekwk_qf->{dd};
  }

  my $year = $id;
     $year =~ s/[ew]kD?//;

  $ekwk_qf->{yearTitle} = $all_remarks->{ekwk_qf}->get($id, 'year', $year);

  my $html = format_voorronde_ekwk($year, $ekwk_qf);
}

sub set_laatste_speeldatum_ekwk
{
  my $dd = 0;

  my @subs = (\&get_ekwk_voorr_gen, \&get_ekwk_gen);
  my @names = ('ekwk_qf', 'ekwk');

  for(my $i = 0; $i < 2; $i++)
  {
    my $comps = $all_remarks->{$names[$i]}->get('all', 'dd');
    if (defined $comps)
    {
      my @comps = split(/;/, $comps);
      foreach my $comp (@comps)
      {
        $dd = max($dd, $subs[$i]($comp, 'dd'));
      }
    }
  }

  set_datum_fixed($dd);
}

return 1;
