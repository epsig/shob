package Sport_Collector::Archief_Oefenduels;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Filters;
use Sport_Functions::Readers;
use Sport_Functions::AddMatch qw(&add_one_line);
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
 '&get_alle_oefenduels',
 '&get_oefenduels',
 '&set_laatste_speeldatum_oefenduels',
 #========================================================================
);

my $oefenduels;

sub get_oefenduels($$)
{ # (c) Edwin Spee

  my ($d1, $d2) = @_;
 
  return filter_datum($d1, $d2, $oefenduels);
}

sub set_laatste_speeldatum_oefenduels
{
  use Sport_Functions::Overig;
  use Shob_Tools::Settings;

  my $oefenduels_new = read_csv_with_header('oefenduels.csv');

  my @games = (['Oefenduels Oranje']);
  foreach my $game (@$oefenduels_new)
  {
    if (defined $game->{stadium})
    {
      if ($game->{stadium} eq 'dekuip')
      {
        $game->{stadium} = 'Rotterdam, de Kuip';
      }
      elsif ($game->{stadium} eq 'arena')
      {
        $game->{stadium} = 'Amsterdam, Arena';
      }
    }
    add_one_line(\@games, $game, 0);
  }
  $oefenduels = \@games;

  my $dd = laatste_speeldatum($oefenduels);
  set_datum_fixed($dd);
}

return 1;
