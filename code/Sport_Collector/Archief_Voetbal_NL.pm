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
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Range_Available_Seasons;
use Sport_Functions::AddMatch;
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

my $subdir = 'nc_po';

sub get_nc($)
{# (c) Edwin Spee

 my ($year) = @_;
 my $nc;
 my $pd = $nc_po->{$year}{PD};

 my $file_pd = "pd_s_$year.csv";
 my $fullname = "$csv_dir/$subdir/$file_pd";
 if (-f $fullname)
 {
   my $title = $all_remarks->{nc_po}->get($year, 'title', 'groep');
   $pd->{ncA} = read_stand($fullname, "$title A", 'ncA');
   $pd->{ncB} = read_stand($fullname, "$title B", 'ncB');
 }

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

  my @lookfor = ('CL', 'vCL', 'EC2', 'UEFA');
  my @name1 = ('CL', 'vCL', 'CWC', 'UEFAcup');
  my @name2 = ('Champions League', 'Voorronde Champions League', 'Europacup II', 'UEFA cup');
  my $pster = read_u2s($szn);

  my $next = next_szn($szn);
     $next =~ s/-/_/;

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
      my $br = ($t == scalar @lookfor -1 ? '' : '<br>');
      $out .= qq(<a href="sport_voetbal_europacup_$next.html#$name1[$t]">$name2[$t]</a>: $txt $br\n);
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

  my @tournements = ('CL', 'EL', 'UEFA', 'Intertoto');
  my @rounds      = (1, 2, 3, 'finale');

  my %fullName = ('CL' => 'voorronde Champions League',
                  'EL' => 'de Europa League',
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
 my $dd = 20090722;
 my $yr_p1 = $yr + 1;

 my $file_nc_po = "po_ec_$yr_p1.csv";
 my $fullname = "$csv_dir/$subdir/$file_nc_po";

 if ($yr <= 2004)
 {
  $dd = $all_remarks->{eredivisie}->get($szn, 'dd');
  $europa_in = auto_europa_in($szn);
 }
 elsif (-f $fullname)
 {
  $dd = $all_remarks->{eredivisie}->get($szn, 'dd');
  my $gamesFromFile = read_csv_with_header($fullname);
  my $all = ($yr == 2006);
  $europa_in = auto_europa_in($szn) . auto_europa_po($gamesFromFile, $all);
 }
 elsif ($yr >= 2010 && $yr <= 2019)
 {
  $dd = $all_remarks->{eredivisie}->get($szn, 'dd');
 }
 else
 {
  $dd = laatste_speeldatum($u_nl->{lastyear});

  my $ranges = get_sport_range();
  my $last_beker_szn = $ranges->{beker}[1];
  my $dd2 = laatste_speeldatum_beker($last_beker_szn);

  $dd = max($dd, $dd2);
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
