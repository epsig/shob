package Dir::File;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&some_function',
 '$some_scalar',
 '@some_array',
 '%some_hash',
 #========================================================================
);

return 1;

