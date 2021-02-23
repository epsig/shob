package Sport_Functions::Range_Available_Seasons;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use File::Spec;
use Sport_Functions::Readers qw($csv_dir);
use Sport_Collector::Archief_Voetbal_NL_Topscorers qw(&get_topscorers_competitie);
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_sport_range',
 '$global_first_year',
 #========================================================================
);

my %ranges = ();

my  $global_first_season = '1993-1994';
our $global_first_year   =  1993;

sub get_sub_range($$;$)
{
  my ($dir, $pattern, $pattern2) = @_;

  $pattern2 = $pattern if not defined $pattern2;

  my $some_dir = File::Spec->catfile($csv_dir, $dir);

  my @list = ();
  opendir(my $dh, $some_dir) || die "Can't opendir $some_dir: $!";
  while (my $filename = readdir $dh)
  {
    if ($filename =~ m/$pattern2/ && $filename =~ m/\d{4}/)
    {
      $filename =~ s/$pattern//;
      $filename =~ s/[a-z]?.csv//;
      $filename =~ s/_/-/;
      push @list, $filename;
    }
  }
  closedir $dh;

  @list = sort @list;
  my $first = $list[0];
  my $last  = $list[-1];
  return [$first, $last];
}

sub max_szn($$)
{
  my ($szn1, $szn2) = @_;

  return ($szn1 gt $szn2 ? $szn1 : $szn2);
}

sub get_sport_range()
{
  if (scalar %ranges)
  {
    return \%ranges;
  }

  $ranges{eredivisie} = get_sub_range('eredivisie', '^eredivisie_');
  $ranges{beker}      = get_sub_range('beker', 'beker_');

  $ranges{voetbal_nl}[0] = $global_first_season;
  $ranges{voetbal_nl}[1] = max_szn($ranges{eredivisie}[1], $ranges{beker}[1]);

  $ranges{europacup}  = get_sub_range('europacup', 'europacup_');
  $ranges{ekwk_qf}    = get_sub_range('ekwk_qf', '[ew]k');
  $ranges{ekwk}       = get_sub_range('ekwk', '[ew]k', '[ew]k\d{4}');
  $ranges{schaatsen}  = get_sub_range('schaatsen', 'OS_');

  my $szn1 = $ranges{eredivisie}[1];
  my $tpsc = get_topscorers_competitie($szn1, 'eredivisie', 'Eredivisie');
  if (not scalar @$tpsc)
  {
    my @parts = split /-/, $szn1;
    $parts[0]--;
    $parts[1]--;
    $szn1 = "$parts[0]-$parts[1]";
  }
  $ranges{topscorers_eredivisie}[1] = $szn1;

  $ranges{global_first_year} = $global_first_year;

  return \%ranges;
}

return 1;
