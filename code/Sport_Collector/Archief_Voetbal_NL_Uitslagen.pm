package Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Readers;
use Sport_Functions::Overig;
use Sport_Functions::EcReaders qw(add_one_line);
use Exporter;
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
 '$u_nl',
 '&initEredivisieResults',
 #========================================================================
);

# (c) Edwin Spee

our $u_nl;

sub initEredivisieResults()
{
  my $subdir = 'eredivisie';

  my $new = 1;

  my $lastyear;
  for (my $yr = 1992; $yr < 99999; $yr++)
  {
   my $szn = yr2szn($yr);
   my $csv = "eredivisie_$szn.csv";
   $csv =~ s/-/_/;
   if (-f "$csv_dir/$subdir/$csv")
   {
    if ($new)
    { # TODO in a subroutine
      my $gamesFromFile = read_csv_with_header("$csv_dir/$subdir/$csv");
      my @games = (['']);
      foreach my $game (@$gamesFromFile)
      {
        add_one_line(\@games, $game, 0);
      }
      $u_nl->{$szn} = \@games;
    }
    else
    {
      $u_nl->{$szn} = read_csv("$subdir/$csv");
    }
    $lastyear = $szn;
   }
   else
   {
    last;
   }
  }

  $u_nl->{lastyear} = $u_nl->{$lastyear};
}

return 1;
