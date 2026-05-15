package Sport_Collector::Archief_Voetbal_NL;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use File::Spec;
use Shob_Tools::General;
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Sport_Functions::Readers;
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Functions::Overig;
use Sport_Functions::Seasons;
use Sport_Functions::Formats;
use Sport_Functions::Filters;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Range_Available_Seasons;
use Sport_Functions::AddMatch;
use Sport_Collector::Archief_Voetbal_Beker;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Archief_Voetbal_NL_Standen;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.0';
# (c) Edwin Spee.

@EXPORT =
(#========================================================================
 '&set_laatste_speeldatum_u_nl',
 #========================================================================
);

my $subdir = 'nc_po';

sub set_laatste_speeldatum_u_nl
{
  my $ranges = get_sport_range();
  my $last_beker_szn = $ranges->{beker}[1];

  my $dd = laatste_speeldatum($u_nl->{lastyear});
  $u_nl->{laatste_speeldatum} = $dd;
  my $dd2 = laatste_speeldatum_beker($last_beker_szn);
  my $fixed_dd = max($dd, $dd2);

  set_datum_fixed($fixed_dd);
}

return 1;
