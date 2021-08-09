package Sport_Functions::BekerReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Seasons qw(yr2szn);
use Sport_Functions::AddMatch qw(&add_one_line);
use Sport_Functions::Readers qw(&read_csv_with_header);
use Sport_Functions::ListRemarks qw($all_remarks);
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
 '&read_beker_csv',
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

  my $content = read_csv_with_header($filein, $subdir);

  my $sc = read_beker_part('supercup', 1, "Johan Cruijff schaal $year", 5, $content);

  my %bekerKeys;
  $bekerKeys{'r2'} = ['round2',       'Tweede ronde'];
  $bekerKeys{'8f'} = ['round_of_16',  'achtste-finales KNVB-beker'];
  $bekerKeys{'4f'} = ['quarterfinal', 'kwart-finale KNVB-beker'];
  $bekerKeys{'2f'} = ['semifinal',    'halve finale KNVB-beker'];
  $bekerKeys{'f'}  = ['final',        'finale KNVB-beker'];
  $bekerKeys{'f34'}= ['u34',          'troost-finale KNVB-beker'];

  my $beker;
  foreach my $bkr ('r2', '8f', '4f', '2f', 'f', 'f34')
  {
    my $title = $bekerKeys{$bkr}[1];
    my $key   = $bekerKeys{$bkr}[0];
    my $result = read_beker_part($bkr, 1, $title, 5, $content);
    if (defined $result)
    {
      $beker->{$key} = $result;
    }
  }

  my $opm = $all_remarks->{eredivisie}->get_ml(yr2szn($year), 'beker_opm', 1);
  $beker->{beker_opm} = $opm if ($opm ne '');

  my $out;
  $out->{extra}{supercup} = $sc    if (defined $sc);
  $out->{beker}           = $beker if (defined $beker);

  return $out;
}

return 1;
