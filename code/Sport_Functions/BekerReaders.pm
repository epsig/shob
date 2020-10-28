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

  my $fileWithPath = File::Spec->catfile($csv_dir, $subdir, $filein);

  open (my $IN, "< $fileWithPath") or die "can't open $fileWithPath: $!\n";

  my $sc = read_ec_part('supercup','',"Johan Cruijff schaal $year", $IN);
  my $r2 = read_ec_part('r2', '', 'Tweede ronde', $IN);
  my $f8 = read_ec_part('8f', '', 'achtste-finales KNVB-beker', $IN);
  my $f4 = read_ec_part('4f', '', 'kwart-finale KNVB-beker', $IN);
  my $f2 = read_ec_part('2f', '', 'halve finale KNVB-beker', $IN);
  my $f = read_ec_part('f', '', 'finale KNVB-beker', $IN);
  my $opm = read_beker_opm($IN);
 
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

sub read_beker_opm($)
{
  my $IN = shift;

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
