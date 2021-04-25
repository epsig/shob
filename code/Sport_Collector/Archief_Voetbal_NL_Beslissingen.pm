package Sport_Collector::Archief_Voetbal_NL_Beslissingen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Sport_Functions::Overig;
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
 '$nc_po',
 '&laatste_speeldatum_nc_po',
 #========================================================================
);

our $nc_po;

my $tPD   = 'Promotie/degradatie eerste/eredivisie';
my $tPD3  = 'Promotie/degradatie eerste/eredivisie (best of 3)';

$nc_po->{2010} = {
PD => {
1 => [ [$tPD],
['end','ago',[20100426,1,0],[20100501,2,3],1],
['hlm','dbs',[20100426,1,2],[20100429,1,2],5] ],

2 => [ [$tPD],
['end','wl2',[20100506,1,2],[20100509,1,1],2],
['hlm','spr',[20100506,2,1],[20100509,2,0],2],
['gae','cmb',[20100506,2,0],[20100509,1,0],1],
['zwl','exc',[20100506,0,1],[20100509,4,3],2]],

3 => [ [$tPD],
['gae','wl2',[20100513,1,0],[20100516,3,0],4],
['exc','spr',[20100513,0,0],[20100516,1,1],1] ]
}};

sub laatste_speeldatum_nc_po($)
{# (c) Edwin Spee

 my ($year) = @_;

 my $dd = -99999999;

 while (my ($key1, $value1) = each %{$nc_po->{$year}})
 {while (my ($key2, $value2) = each %{$nc_po->{$year}{$key1}})
  {
   $dd = max($dd, laatste_speeldatum($value2));
 }}

 return $dd;
}

return 1;
