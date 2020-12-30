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
$VERSION = '20.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&init_remarks',
 '$os_remarks',
 '$ec_remarks',
 '$eredivisie_remarks',
 '$eerste_divisie_remarks',
 #========================================================================
);

# (c) Edwin Spee

our $os_remarks;
our $ec_remarks;
our $eredivisie_remarks;
our $eerste_divisie_remarks;

sub init_remarks()
{
  my $file1 = File::Spec->catdir($csv_dir, 'eredivisie', 'eredivisie_remarks.csv');
  $eredivisie_remarks = new Sport_Functions::RemarkReaders($file1);

  my $file2 = File::Spec->catdir($csv_dir, 'schaatsen', 'schaatsen_remarks.csv');
  $os_remarks = new Sport_Functions::RemarkReaders ($file2);

  my $file3 = File::Spec->catdir($csv_dir, 'europacup', 'europacup_remarks.csv');
  $ec_remarks = new Sport_Functions::RemarkReaders ($file3);

  my $file4 = File::Spec->catdir($csv_dir, 'eerste_divisie', 'eerste_divisie_remarks.csv');
  $eerste_divisie_remarks = new Sport_Functions::RemarkReaders($file4);
}

return 1;
