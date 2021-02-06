package Sport_Collector::Archief_Voetbal_Beker;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::General;
use Sport_Functions::Readers qw($csv_dir);
use Sport_Functions::BekerReaders;
use Sport_Functions::Overig;
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
 '&laatste_speeldatum_beker',
 '&knvb_beker',
 #========================================================================
);

my $knvb_beker;
my $subdir = 'beker';

sub knvb_beker($)
{
  my $szn = shift;

  if (not defined ($knvb_beker->{$szn}))
  {
    my $csv = "beker_$szn.csv";
    $csv =~ s/-/_/;
    if (-f "$csv_dir/$subdir/$csv")
    {
      my @yrs =  split(/-/, $szn);
      my $yr = $yrs[0];
      $knvb_beker->{$szn} = read_beker_csv($csv, $subdir, $yr);
    }
  }

  return $knvb_beker->{$szn};
}

sub laatste_speeldatum_beker($)
{# (c) Edwin Spee

  my ($szn) = @_;

  my $dd = 20140808;

  my $beker = knvb_beker($szn);

  while (my ($key1, $value1) = each %{$beker})
  {
    while (my ($key2, $value2) = each %{$beker->{$key1}})
    {
      if (ref $value2 eq 'ARRAY')
      {
        $dd = max($dd, laatste_speeldatum($value2));
      }
    }
  }

  return $dd;
}

return 1;
