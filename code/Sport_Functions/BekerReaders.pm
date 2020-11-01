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

  my $sc = read_ec_part('supercup', '', 1, "Johan Cruijff schaal $year", 5, $IN);
  my $r2 = read_ec_part('r2', '', 1, 'Tweede ronde', 5, $IN);
  my $f8 = read_ec_part('8f', '', 1, 'achtste-finales KNVB-beker', 5, $IN);
  my $f4 = read_ec_part('4f', '', 1, 'kwart-finale KNVB-beker', 5, $IN);
  my $f2 = read_ec_part('2f', '', 1, 'halve finale KNVB-beker', 5, $IN);
  my $f = read_ec_part('f', '', 1, 'finale KNVB-beker', 5, $IN);
  my $f34 = read_ec_part('f34', '', 1, 'troost-finale KNVB-beker', 5, $IN);

  my $opm = ReadOpm(yr2szn($year), 'beker_opm', 'NL');
 
  close($IN);

  my $beker = {
    extra => { supercup => $sc },
    beker => {
      round2 => $r2,
      round_of_16 => $f8,
      quarterfinal => $f4,
      semifinal => $f2,
      final => $f,
      u34 => $f34,
      beker_opm => $opm
    }
  };

  return $beker;
}

return 1;
