package Sport_Collector::Archief_EK_WK_Voetbal;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Sport_Functions::Formats;
use Sport_Functions::Overig;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Results2Standing;
use Sport_Functions::EkWkReaders;
use Sport_Functions::Readers qw($csv_dir);
use Sport_Functions::XML;
use Sport_Functions::NatLeagueReaders;
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Collector::Archief_Oefenduels;
use Sport_Collector::Archief_Voetbal_NL_Topscorers qw(&get_topscorers_competitie);
use Shob_Tools::Idate;
use File::Spec;
use Data::Dumper qw(Dumper);
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
  '&set_laatste_speeldatum_ekwk',
 #========================================================================
);

my $ekwkDir = 'ekwk';
my $ekwkQfDir = 'ekwk_qf';
my $xmlDir = File::Spec->catfile($csv_dir, $ekwkDir);

my $all_ekwk_qf = {};

sub set_laatste_speeldatum_ekwk
{
  my $dd = 0;

  my @subs = (\&get_ekwk_gen);
  my @names = ('ekwk_qf', 'ekwk');

  for(my $i = 0; $i < 2; $i++)
  {
    my $comps = $all_remarks->{$names[$i]}->get('all', 'dd');
    if (defined $comps)
    {
      my @comps = split(/;/, $comps);
      foreach my $comp (@comps)
      {
        $dd = max($dd, $subs[$i]($comp, 'dd'));
      }
    }
  }

  set_datum_fixed($dd);
}

return 1;
