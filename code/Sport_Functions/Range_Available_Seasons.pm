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
 #========================================================================
);

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

sub get_sport_range()
{
  my %ranges = ();
  #my @list_erediv1 = get_sub_range('eredivisie', 'eindstand_eredivisie_');
  $ranges{eredivisie} = get_sub_range('eredivisie', '^eredivisie_');
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

  return \%ranges;
}

return 1;
