package Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Readers;
use Sport_Functions::Seasons;
use Sport_Functions::AddMatch qw(add_one_line);
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

  my $lastyear;
  for (my $yr = 1992; $yr < 99999; $yr++)
  {
   my $szn = yr2szn($yr);
   my $csv = "eredivisie_$szn.csv";
   $csv =~ s/-/_/;
   my $fullname = "$csv_dir/$subdir/$csv";
   if (-f $fullname)
   {
    # TODO in a subroutine
    my $gamesFromFile = read_csv_with_header($fullname);
    my @games = (['']);
    foreach my $game (@$gamesFromFile)
    {
      add_one_line(\@games, $game, 0);
    }
    $u_nl->{$szn} = \@games;
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
