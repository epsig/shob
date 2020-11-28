package Sport_Collector::Archief_Europacup_Voetbal;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
use Sport_Functions::Formats;
use Sport_Functions::Overig;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Results2Standing;
use Sport_Functions::EcReaders;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
  '&laatste_speeldatum_ec',
  '&set_laatste_speeldatum_ec',
  '&get_ec_webpage',
  '&init_ec',
  '&get_u_ec',
 #========================================================================
);

our $u_ec;

#
$u_ec->{'1994-1995'} = {
extra => {
dd => 20090614,
summary => << 'EOF'},
Ajax wint de Champions League!
De Amsterdammers verslaan dit seizoen AC Milan liefst driemaal.
<p>In de EC-II bereikt Feyenoord de kwartfinale door een mooie winst op
Werder Bremen, maar moet dan in Real Zaragoza haar meerdere erkennen.
<p>In de UEFA-cup zijn FC Twente, Vitesse en PSV geen van drie&euml;n
in staat de eerste ronde te overleven.
<br>Vitesse loot de latere winnaar Parma, en PSV het sterke Bayern Leverkusen,
maar Twente stelt zwaar teleur tegen het onbekende Kispest Honved.
EOF

CL => {
groupD => [ ['', 0,
#TODO is work-a-round voor ontbreken jury uitspraken
[ ['Champions League: 1-D',
"14 oktober 1994: AC Milan krijgt 2 winstpunten in mindering als straf\n".
"<br>voor het 'flesjes'-incident. In het duel tegen Casino Salzburg moest\n".
"<br>de keeper van de Oostenrijkers het veld verlaten,\n".
"<br>nadat hij geraakt was door een vanaf de tribunes gegooide plastic fles.\n".
"<br>Verder moeten de laatste twee groepswedstrijden buiten Milaan worden gespeeld."],
['NLajx',6,[4,2,0],10,[9,2],['+']],
['ITmln',6,[3,1,2],5,[6,5],['+']],
['ATcsb',6,[1,3,2],5,[4,6]],
['GRaek',6,[0,2,4],2,[3,9]] ]],
['NLajx','ITmln',[19940914,2,0]],
['ATcsb','GRaek',[19940914,0,0]],
['GRaek','NLajx',[19940928,1,2]],
['ITmln','ATcsb',[19940928,3,0]],
['ATcsb','NLajx',[19941019,0,0]],
['GRaek','ITmln',[19941019,0,0]],
['NLajx','ATcsb',[19941102,1,1]],
['ITmln','GRaek',[19941102,2,1],'Triest'],
['ITmln','NLajx',[19941123,0,2],'Triest'],
['GRaek','ATcsb',[19941123,1,3]],
['NLajx','GRaek',[19941207,2,0]],
['ATcsb','ITmln',[19941207,0,1]] ],
#Eerste ronde: poule A
#IFK G&ouml;teborg * (Zwe);6 - 9;10 - 7
#FC Barcelona * (Spa);6 - 6;11 - 8
#Manchester United (Eng);6 - 6;11 - 11
#Galatasaray (Tur);6 - 3;3 - 9
#Eerste ronde: poule B
#Paris Saint Germain * (Fra);6 -12;12 - 3
#Bayern M&uuml;nchen * (Dui);6 - 6;8 - 7
#Spartak Moskou (Rus);6 - 4;8 - 12
#Dinamo Kiev (Oek);6 - 2;5 - 11
#Eerste ronde: poule C
#Benfica * (Por);6 - 9;9 - 5
#Hajduk Split * (Kro);6 - 6;5 - 7
#Steaua Boekarest (Roe);6 - 5;7 - 6
#RSC Anderlecht (Bel);6 - 4;4 - 7
quarterfinal => [ [''],
['HRhds','NLajx',[19950301,0,0],[19950315,3,0],2],
['DEbmn','SEifk',[19950301,0,0],[19950315,2,2],1],
['ITmln','PTbnf',[19950301,0,0],[19950315,0,0],5],
['ESbcl','FRpsg',[19950301,1,1],[19950315,2,1],2] ],
semifinal => [ [''],
['DEbmn','NLajx',[19950405,0,0],[19950419,5,2],2],
['FRpsg','ITmln',[19950405,0,1],[19950419,2,0],2] ],
final => [ [''],
['NLajx','ITmln',[19950524,1,0],1,'Wenen'] ]},

CWC => {
round1 => [ ['Eerste ronde EC-II'],
['LTzvl','NLfyn',[19940915,1,1],[19940929,2,1],2] ],
round2 => [ ['Tweede ronde EC-II'],
['NLfyn','DEwbr',[19941020,1,0],[19941103,3,4],1] ],
quarterfinal => [ [''],
['BEcbr','G1cls',[19950302,1,0],[19950316,2,0],2],
['NLfyn','ESrzg',[19950302,1,0],[19950216,2,0],2],
['ITsdr','PTpor',[19950302,0,1],[19950216,0,1],5], #???
['G1ars','FRaux',[19950302,1,1],[19950216,1,1],5] ],
semifinal => [ [''],
['ESrzg','G1cls',[19950406,3,0],[19950420,3,1],1],
['G1ars','ITsdr',[19950406,3,2],[19950420,3,2],5] ],
final => [ [''],
['ESrzg','G1ars',[19950510,2,1, {opm =>
"Al Hamar Mohammed, bijgenaamd Nayim scoort in de\n".
"slotseconde van de 2e verlenging een absolute wereldgoal.\n".
"<br>Vanaf 40 m lift hij de bal over de verbouwereerde keeper."}],3]]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['NLtwn','HUkhv',[19940913,1,4],[19940927,1,3],2],
['NLvit','ITprm',[19940913,1,0],[19940927,2,0],2],
['DElvk','NLpsv',[19940913,5,4],[19940927,0,0],1] ],
quarterfinal => [ [''],
['ITlzr','DEbdm',[19950228,1,0],[19950314,2,0],2],
['DEefr','ITjuv',[19950228,1,1],[19950314,3,0],2],
['ITprm','DKodn',[19950228,1,0],[19950314,0,0],1],
['DElvk','FRnnt',[19950228,5,1],[19950314,0,0],1] ],
semifinal => [ [''],
['ITjuv','DEbdm',[19950404,2,2],[19950418,1,2],1],
['DElvk','ITprm',[19950404,1,2],[19950418,3,0],2] ],
final => [ [''],
['ITprm','ITjuv',[19950503,1,0],[19950517,1,1],1] ]}};

sub get_u_ec($)
{
  my $szn = shift;

  if (not defined($u_ec->{$szn}))
  {
    my $csv = "europacup_$szn.csv";
    $csv =~ s/-/_/;
    $u_ec->{$szn} = read_ec_csv($csv, $szn);

    my $ddExtra = $u_ec->{$szn}->{extra}->{dd};
    my $yr2 = substr($szn, 5, 4);
    if ($yr2 > $ddExtra * 1E-4 - 1)
    { # TODO: can it be removed ?
      $u_ec->{$szn}->{extra}->{dd} = max(laatste_speeldatum_ec($szn), $ddExtra);
    }
  }
  return $u_ec->{$szn};
}

sub get_ec_webpage($)
{# (c) Edwin Spee

 my $szn = shift;
 my $u   = get_u_ec($szn);
 return format_europacup($szn, $u);
}

sub laatste_speeldatum_ec($)
{# (c) Edwin Spee

 my ($szn) = @_;

 my $dd = 20120723;

 my $u = get_u_ec($szn);
 while (my ($key1, $value1) = each %{$u})
 {
  while (my ($key2, $value2) = each %{$u->{$key1}})
  {
   if (ref $value2 eq 'ARRAY')
   {
    $dd = max($dd, laatste_speeldatum($value2));
 }}}

 return $dd;
}

sub init_ec
{ #(c) Edwin Spee
  use File::Glob;

  my @files = <Sport_Data/europacup/europacup_????_????.csv>;
  my $lastYr = -999;
  my $lastSzn;
  foreach my $file (@files)
  {
    if ($file =~ m/(\d{4})_(\d{4})/)
    {
      my ($yr1, $yr2) = ($1, $2);
      if ($yr1 > $lastYr)
      {
        $lastYr = $yr1;
        $lastSzn = "$yr1-$yr2";
      }
    }
  }
  $u_ec->{lastyear} = $lastSzn;
}

sub set_laatste_speeldatum_ec
{# (c) Edwin Spee

 my $szn = $u_ec->{lastyear};
 my $dd = max(laatste_speeldatum_ec($szn));

 my $u = get_u_ec($szn);

 if (defined($u->{extra}))
 {
  $dd = max($dd, $u->{extra}{dd});
 }
 $u->{extra}{dd} = $dd;
 set_datum_fixed($dd);
}

return 1;
