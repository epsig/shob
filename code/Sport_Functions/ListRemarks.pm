package Sport_Functions::ListRemarks;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::RemarkReaders;
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
 '&init_remarks',
 '$all_remarks',
 #========================================================================
);

# (c) Edwin Spee

our $all_remarks;

sub init_remarks()
{
  my @remarks = ('eredivisie', 'schaatsen', 'europacup', 'eerste_divisie', 'ekwk', 'ekwk_qf');

  foreach my $remark (@remarks)
  {
    $all_remarks->{$remark} = new Sport_Functions::RemarkReaders("${remark}_remarks.csv", $remark);
  }
}

return 1;
