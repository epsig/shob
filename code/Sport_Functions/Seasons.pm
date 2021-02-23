package Sport_Functions::Seasons;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
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
  '&yr2szn',
  '&max_szn',
  '&previous_szn'
 #========================================================================
);

sub yr2szn($)
{
  my ($year) = @_;

  my $yp1 = $year + 1;

  return qq($year-$yp1);
}

sub max_szn($$)
{
  my ($szn1, $szn2) = @_;

  return ($szn1 gt $szn2 ? $szn1 : $szn2);
}

sub previous_szn($)
{
  my ($szn) = @_;

  my @parts = split /-/, $szn;
  $parts[0]--;
  $parts[1]--;

  return "$parts[0]-$parts[1]";
}

return 1;
