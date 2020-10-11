package Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Readers;
use Sport_Functions::Overig;
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
   if (-f "$csv_dir/$subdir/$csv")
   {
    $u_nl->{$szn} = read_csv("$subdir/$csv");
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
