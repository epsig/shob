package Sport_Collector::Archief_Oefenduels;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Filters;
use Sport_Functions::Readers;
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
 '&get_alle_oefenduels',
 '&get_oefenduels',
 '&set_laatste_speeldatum_oefenduels',
 #========================================================================
);

 my $oefenduels = read_csv('oefenduels.csv');
 $oefenduels->[0] = ['Oefenduels Oranje'];

sub get_oefenduels($$)
{# (c) Edwin Spee

 my ($d1, $d2) = @_;
 
 return filter_datum($d1, $d2, $oefenduels);
}

sub set_laatste_speeldatum_oefenduels
{
 use Sport_Functions::Overig;
 use Shob_Tools::Settings;

 my $dd = laatste_speeldatum($oefenduels);
 set_datum_fixed($dd);
}

return 1;
