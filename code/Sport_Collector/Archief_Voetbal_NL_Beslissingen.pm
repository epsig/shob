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

$nc_po->{2003}{PD} = {
ncA => [ ['Eindstand poule A'],
['zwl',6,[4,2,0],14,[12, 5],['NB']],
['hlm',6,[3,1,2],10,[ 9,10]],
['dbs',6,[2,1,3], 7,[ 7,10]],
['gae',6,[1,0,5], 3,[ 9,12]] ],
ncB => [ ['Eindstand poule B'],
['vol',6,[4,0,2],12,[12, 7],['NP']],
['emm',6,[3,0,3], 9,[ 6, 6]],
['exc',6,[3,0,3], 9,[ 8, 9],['ND']],
['hrc',6,[2,0,4], 6,[ 6,10]] ]};

$nc_po->{2004}{PD} = {
ncA => [ ['groep A'],
['vit',6,[4,2,0],14,[14, 4],['NB']],
['vvv',6,[2,2,2], 8,[11,10]],
['spr',6,[1,3,2], 6,[ 8,10]],
['hlm',6,[0,3,3], 3,[ 7,16]] ],
ncB => [ ['groep B'],
['grf',6,[4,1,1],13,[10, 4],['NP']],
['hrc',6,[3,2,1],11,[11, 6]],
['exc',6,[2,2,2], 8,[ 8, 8]],
['vol',6,[0,1,5], 1,[ 4,15],['ND']] ]};

$nc_po->{2005}{PD} = {
#'Periode Kampioenen: VVV-Venlo, Sparta, Heracles en Volendam',
ncA => [ ['Eindstand poule A'],
['rbc',6,[3,2,1],11,[ 9, 3],['NB']],
['vol',6,[2,3,1], 9,[11, 9]],
['tls',6,[2,2,2], 8,[ 9,10]],
['vvv',6,[1,1,4], 4,[ 6,13]] ],
ncB => [ ['Eindstand poule B'],
['spr',6,[5,0,1],15,[13, 5],['NP']],
['hlm',6,[2,3,1], 9,[11, 6]],
['grf',6,[2,2,2], 8,[11,10],['ND']],
['zwl',6,[0,1,5], 1,[ 6,20]] ]};

#my $play_offs_D = combine_puus($nc_po->{2006}{PD}{1},$nc_po->{2006}{PD}{2},$nc_po->{2006}{PD}{finale});
#my $nc = ['Periodekampioenen: Volendam, FC Zwolle, TOP Oss, Excelsior, Haarlem en AGOVV.', [], []];
$nc_po->{2006}{PD}{1} = [ [$tPD3],
['zwl','hrl',[20060411,1,1, 2975],[20060414,1,3, 2950],1],
['top','ago',[20060411,3,0, 3185],[20060414,0,2, 2780],1] ];

$nc_po->{2006}{PD}{2} = [ [$tPD3],
['zwl','wl2',[20060421,2,4, 5110],[20060424,6,2,11000],2],
['grf','vvv',[20060421,1,1,10150],[20060424,2,4, 6000],1],
['hlm','vol',[20060421,0,1, 3200],[20060424,2,3, 3900]],
['top','nac',[20060421,0,0, 4375],[20060424,2,2,14820]],
['hlm','vol',[20060428,1,2, 3486],4],
['top','nac',[20060428,3,1, 4375],3] ];

$nc_po->{2006}{PD}{finale} = [ [$tPD3],
['grf','wl2',[20060505,0,1,11000],[20060509,2,1,13800],2],
['vol','nac',[20060505,1,2, 5404],[20060508,0,0,17000],2] ];

$nc_po->{2007}{PD}{1} = [ [$tPD],
['zwl','drd',[20070501,0,1],[20070505,1,1],1],
['vnd','gae',[20070501,5,1],[20070505,2,0],2] ];

$nc_po->{2007}{PD}{2} = [ [$tPD3],
['dbs','vvv',[20070509,1,2],[20070512,0,1]],
['vol','rbc',[20070509,3,5],[20070512,1,0],2],
['vnd','exc',[20070509,0,1],[20070512,3,0],2],
['drd','rkc',[20070509,2,0],[20070513,2,0]],
['vvv','dbs',[20070517,1,0],1],
['drd','rkc',[20070517,0,3],2] ];

$nc_po->{2007}{PD}{finale} = [ [$tPD3],
['rbc','exc',[20070520,1,1],[20070524,1,0],2],
['vvv','rkc',[20070520,2,0],[20070524,1,0]],
['vvv','rkc',[20070527,3,0],1] ];

#my $nc = ['Periodekampioenen: FC Den Bosch, RKC, Go Ahead Eagles, Volendam en Zwolle'];
$nc_po->{2008}{PD}{1} = [ [$tPD],
['gae','adh',[20080422,1,1],[20080426,3,0],2],
['top','hlm',[20080422,2,2],[20080426,3,0],2] ];

$nc_po->{2008}{PD}{2} = [ [$tPD3],
['adh','vvv',[20080501,1,0],[20080504,1,0]],
['mvv','rkc',[20080501,1,0],[20080504,2,0]],
['zwl','dbs',[20080501,0,1],[20080504,1,2]],
['hlm','grf',[20080501,2,3],[20080504,3,1],2],
['adh','vvv',[20080507,2,0],1],
['rkc','mvv',[20080507,4,0],1],
['zwl','dbs',[20080507,1,0],1] ];

$nc_po->{2008}{PD}{3} = [ [$tPD3],
['adh','rkc',[20080511,1,1],[20080515,2,2]],
['zwl','grf',[20080511,1,3],[20080515,0,0],2],
['adh','rkc',[20080518,2,1],1] ];

$nc_po->{2009} = {
PD => {
1 => [ [$tPD],
['tlr','mvv',[20090512,0,0],[20090515,1,0],2],
['top','drd',[20090512,0,2],[20090515,1,0],2] ],

2 => [ [$tPD3],
['drd','rdj',[20090519,1,1],[20090522,1,0],2],
['zwl','cmb',[20090519,2,1],[20090522,3,1]],
['exc','rkc',[20090519,1,2],[20090522,1,1],1],
['mvv','grf',[20090519,2,3],[20090522,2,2],2],
['cmb','zwl',[20090524,2,0],1] ],

3 => [ [$tPD3],
['cmb','rdj',[20090528,0,0],[20090531,1,1],-1],
['rkc','grf',[20090528,2,0],[20090531,2,1],-1],
['cmb','rdj',[20090603,2,2],6],
['rkc','grf',[20090603,1,0],1] ]}};

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
