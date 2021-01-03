package Sport_Functions::BekerReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Overig qw(yr2szn);
use Sport_Functions::AddMatch qw(&add_one_line);
use Sport_Functions::Readers qw(&read_csv_with_header $csv_dir);
use Sport_Functions::ListRemarks qw($all_remarks);
use File::Spec qw(&catfile);
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&read_beker_csv',
 '$csv_dir',
 #========================================================================
);

# (c) Edwin Spee

sub read_beker_part($$$$$)
{
  my $phase     = shift;
  my $isko      = shift;
  my $title     = shift;
  my $sort_rule = shift;
  my $content   = shift;

  my @games = ([$title]);

  foreach my $struct (@$content)
  {
    if ($struct->{phase} eq $phase)
    {
      add_one_line(\@games, $struct, $isko);
    }
  }

  return (scalar @games > 1 ? \@games : undef);
}

sub read_beker_csv($$$)
{
  my $filein = shift;
  my $subdir = shift;
  my $year   = shift;

  my $fileWithPath = File::Spec->catfile($csv_dir, $subdir, $filein);

  my $content = read_csv_with_header($fileWithPath);

  my $sc = read_beker_part('supercup', 1, "Johan Cruijff schaal $year", 5, $content);
  my $r2 = read_beker_part('r2', 1, 'Tweede ronde', 5, $content);
  my $f8 = read_beker_part('8f', 1, 'achtste-finales KNVB-beker', 5, $content);
  my $f4 = read_beker_part('4f', 1, 'kwart-finale KNVB-beker', 5, $content);
  my $f2 = read_beker_part('2f', 1, 'halve finale KNVB-beker', 5, $content);
  my $f = read_beker_part('f', 1, 'finale KNVB-beker', 5, $content);
  my $f34 = read_beker_part('f34', 1, 'troost-finale KNVB-beker', 5, $content);

  my $opm = $all_remarks->{eredivisie}->get_ml(yr2szn($year), 'beker_opm', 1);

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
