package Sport_Functions::InitSport;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Collector::Archief_Oefenduels;
use Sport_Collector::Teams;
use Sport_Collector::Archief_Voetbal_NL;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Archief_Europacup_Voetbal;
use Sport_Collector::Archief_EK_WK_Voetbal;
use Sport_Functions::ListRemarks qw(&init_remarks);
use Shob::Stats_Website;
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
 '&sport_init',
 #========================================================================
);

sub sport_init()
{ # (c) Edwin Spee
  # initializations for sport data

  initTeams();
  initEredivisieResults();
  init_ec();

  init_remarks();

  set_laatste_speeldatum_u_nl();
  set_laatste_speeldatum_ec();
  set_laatste_speeldatum_oefenduels();
  set_laatste_speeldatum_ekwk();
  set_laatste_datum_statfiles();
}

return 1;
