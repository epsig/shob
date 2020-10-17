package Sport_Functions::BekerReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Overig;
use Sport_Functions::EcReaders;
use Sport_Functions::Readers;
use File::Spec;
use XML::Parser;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&read_beker_csv',
 '$csv_dir',
 #========================================================================
);

# (c) Edwin Spee

sub read_beker_csv($$$)
{
  my $filein = shift;
  my $subdir = shift;
  my $year   = shift;

  open ($IN, "< $csv_dir/$subdir/$filein") or die "can't open $filein: $!";

  my $sc = read_ec_part('supercup','',"Johan Cruijff schaal $year");
  my $r2 = read_ec_part('r2', '', 'Tweede ronde');
  my $f8 = read_ec_part('8f', '', 'achtste-finales KNVB-beker');
  my $f4 = read_ec_part('4f', '', 'kwart-finale KNVB-beker');
  my $f2 = read_ec_part('2f', '', 'halve finale KNVB-beker');
  my $f = read_ec_part('f', '', 'finale KNVB-beker');
  my $opm = read_beker_opm();
 
  close($IN);

  my $beker = {
    extra => { supercup => $sc },
    beker => {
      round2 => $r2,
      round_of_16 => $f8,
      quarterfinal => $f4,
      semifinal => $f2,
      final => $f,
      beker_opm => $opm
    }
  };

  return $beker;
}

sub read_beker_opm()
{
  seek($IN, 0, 0);
  my $opm = '';
  while (my $line = <$IN>)
  {
    my @parts = split /,/, $line,2;
    if ($parts[0] eq 'beker_opm')
    {
      $opm .= $parts[1];
    }
  }
  return $opm;
}

return 1;
