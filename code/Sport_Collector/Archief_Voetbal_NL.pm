package Sport_Collector::Archief_Voetbal_NL;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use File::Spec;
use Shob_Tools::General;
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Sport_Functions::Readers;
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Functions::Overig;
use Sport_Functions::Seasons;
use Sport_Functions::Formats;
use Sport_Functions::Filters;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Range_Available_Seasons;
use Sport_Functions::AddMatch;
use Sport_Collector::Archief_Voetbal_Beker;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Archief_Voetbal_NL_Standen;
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

my $subdir = 'nc_po';

sub get_nc($)
{
  my ($year) = @_;

  my $nc;

  my $file_pd = "pd_s_$year.csv";
  my $fullname = File::Spec->catfile($csv_dir, $subdir, $file_pd);

  my $file_pd_u = "pd_u_$year.csv";
  my $fullname_u = File::Spec->catfile($csv_dir, $subdir, $file_pd_u);

  my $title = $all_remarks->{nc_po}->get($year, 'title', 'groep');
  my $opm   = $all_remarks->{nc_po}->get_ml($year, 'opm_nc', 1);

  if (-f $fullname)
  {
    my @s = ();
    foreach my $g ('A', 'B')
    {
      my $s = read_stand($fullname, "$title $g", "nc$g");
      push @s, get_stand($s, 2, 0, [1]);
    }
    my $out = get2tables($s[0], $s[1]);
    $nc = $out . $opm;
  }
  elsif (-f $fullname_u)
  {
    my $gamesFromFile = read_csv_with_header($fullname_u);
    my $rounds = $all_remarks->{nc_po}->get($year, 'rounds');
    my @rounds  = split(/;/, $rounds);
    my $out = '';
    foreach my $round (@rounds)
    {
      my $u = get_selection($gamesFromFile, 'pd', $round);
      my $titleRound = $title;
      $titleRound .= " ronde $round" if (scalar @rounds > 1);
      $out .= get_uitslag($u, {ptitel=>[2, $titleRound]});
    }
    if ($opm ne '')
    {
      $out .= ftr(ftd({cols => 2}, $opm));
    }
    $nc = ftable('border', $out);
  }
  elsif ($opm ne '')
  {
    chomp($opm);
    $nc = ftable('border', ftr(ftd($opm)));
  }
  else
  {
    $nc = '';
  }
  return $nc;
}

sub bekerwinnaar($$)
{
  my ($szn, $kampioen) = @_;

  my $beker = knvb_beker($szn);
  if (defined $beker)
  {
    my $final = $beker->{beker}{final};
    if (defined $final)
    {
      my $ster = $final->[1][3];
      my $index = ($ster % 2 == 0 ? 1 : 0);
      my $winnaar = $final->[1][$index];
      my $finalist = $final->[1][1-$index];
      return ($winnaar, $finalist) if ($winnaar eq $kampioen);
      return ($winnaar);
    }
  }
  return ('');
}

sub auto_europa_in($)
{
  my $szn = shift;

  my @lookfor = ('CL', 'vCL', 'EC2', 'UEFA', 'vEL', 'vCF');
  my @name1 = ('CL', 'vCL', 'CWC', 'UEFAcup', 'EuropaL', 'CL');
  my @name2 = ('Champions League', 'Voorronde Champions League', 'Europacup II', 'UEFA cup',
               'Europa League', 'Conference League');
  my $pster = read_u2s($szn);

  my $next = next_szn($szn);
     $next =~ s/-/_/;

  my $ranges = get_sport_range();
  my $last_szn_ec = $ranges->{europacup}[1];

  my $out = '';

  my $stand = standen_eredivisie($szn);
  my $kampioen = $stand->[1][0];
  my @beker_finalists = bekerwinnaar($szn, $kampioen);
  my $cupwinner = $beker_finalists[0];
  my $runner_up = (scalar @beker_finalists == 2 ? $beker_finalists[1]: '');

  for (my $t=0; $t < scalar @lookfor; $t++)
  {
    my $tournement = $lookfor[$t];
    my @clubs = ();
    for (my $i=0; $i < scalar @$pster; $i+=2)
    {
      my $clubs = $pster->[$i];
      my $ster  = $pster->[$i+1];
      if ($ster =~ m/\b$tournement\b/)
      {
        my @parts = split(/,/, $clubs);
        push @clubs, @parts;
      }
    }
    if (scalar @clubs)
    {
      my $txt = '';
      for (my $j=0; $j < scalar @clubs; $j++)
      {
        my $club = $clubs[$j];
        $txt .= expand($club, 0);
        $txt .= ' (bekerwinnaar)' if ($club eq $cupwinner && $tournement eq 'UEFA');
        $txt .= ' (beker finalist)' if ($club eq $runner_up && $tournement eq 'UEFA');
        $txt .= ', ' if ($j < scalar @clubs - 2);
        $txt .= ' en '  if ($j == scalar @clubs - 2);
      }
      my $br = ($lookfor[$t] eq 'UEFA' ? '' : '<br>');
      if ($szn eq $last_szn_ec)
      {
        $out .= qq($name2[$t]: $txt $br\n);
      }
      else
      {
        $out .= qq(<a href="sport_voetbal_europacup_$next.html#$name1[$t]">$name2[$t]</a>: $txt $br\n);
      }
    }
  }
  return $out;
}

sub get_selection($$$)
{
    my $gamesFromFile = shift;
    my $tournement = shift;
    my $round =shift;

    my @games = (['']);
    foreach my $game (@$gamesFromFile)
    {
      if ($game->{tournement} eq $tournement && $game->{round} eq $round)
      {
        add_one_line(\@games, $game, 1);
      }
    }
    return \@games;
}

sub auto_europa_po($$)
{
  my ($gamesFromFile, $all) = @_;

  my @tournements = ('CL', 'EL', 'UEFA', 'Intertoto', 'CF');
  my @rounds      = (1, 2, 3, 'finale');

  my %fullName = ('CL' => 'voorronde Champions League',
                  'EL' => 'de Europa League',
                  'CF' => 'de Conference League',
                  'UEFA' => 'UEFA Cup',
                  'Intertoto' => 'Intertoto Cup');

  my $europa_po = '';
  foreach my $tournement (@tournements)
  {
    my $uTournement = [];
    foreach my $round (@rounds)
    {
      my $u = get_selection($gamesFromFile, $tournement, $round);
      if (scalar @$u > 1)
      {
        if (scalar @$uTournement == 0 || ($tournement ne 'CL' && $all == 0))
        {
          $uTournement = $u;
        }
        else
        {
          $uTournement = combine_puus($uTournement, $u);
        }
      }
    }
    if (scalar @$uTournement > 0)
    {
      my $title = "play-offs voor $fullName{$tournement}";
      $europa_po .= get_uitslag($uTournement, {ptitel=>[2, $title]});
    }
  }

  return $europa_po;
}

sub get_betaald_voetbal_nl($)
{# (c) Edwin Spee

 my $yr = shift;
 my $szn = yr2szn($yr);
 
 my $opm_ered = $all_remarks->{eredivisie}->get_ml($szn, 'opm', 1);

 my $europa_in = '';
 my $dd = $all_remarks->{eredivisie}->get($szn, 'dd', 20090722);

 my $yr_p1 = $yr + 1;

 my $file_nc_po = "po_ec_$yr_p1.csv";
 my $fullname = File::Spec->catfile($csv_dir, $subdir, $file_nc_po);

 my $ranges = get_sport_range();
 my $szn1 = $ranges->{topscorers_eredivisie}[1];
 my $szn2 = $ranges->{voetbal_nl}[1];

 if (-f $fullname)
 {
  my $gamesFromFile = read_csv_with_header($fullname);
  my $all = ($yr == 2006 || $yr >= 2020);
  $europa_in = auto_europa_in($szn) . auto_europa_po($gamesFromFile, $all);
 }
 elsif ($szn eq $szn2 && $szn1 ne $szn2)
 {
  $dd = laatste_speeldatum($u_nl->{lastyear});

  my $last_beker_szn = $ranges->{beker}[1];
  my $dd2 = laatste_speeldatum_beker($last_beker_szn);

  $dd = max($dd, $dd2);
 }
 else
 {
  $europa_in = auto_europa_in($szn);
 }

 my $nc = get_nc($yr_p1);
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
