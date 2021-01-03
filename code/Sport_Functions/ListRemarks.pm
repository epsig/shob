package Sport_Functions::ListRemarks;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::RemarkReaders;
use Sport_Functions::Readers qw($csv_dir);
use File::Spec;
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
  my @remarks = ('eredivisie', 'schaatsen', 'europacup', 'eerste_divisie', 'ekwk');

  foreach my $remark (@remarks)
  {
    my $file = File::Spec->catdir($csv_dir, $remark, "${remark}_remarks.csv");
    $all_remarks->{$remark} = new Sport_Functions::RemarkReaders($file);
  }
}

return 1;
