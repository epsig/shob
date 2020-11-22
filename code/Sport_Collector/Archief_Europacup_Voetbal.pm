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
#
$u_ec->{'1995-1996'} = {
extra => {
dd => 20090614,
summary => << 'EOF'},
Ajax staat opnieuw in de finale van de Champions League,
maar moet na strafschoppen de beker aan Juventus laten.
<p>In de EC-II bereikt Feyenoord de halve finale,
en is dan in Wenen kansloos tegen Rapid Wien.
<p>In de UEFA-cup heeft PSV in de kwartfinale veel pech tegen Barcelona.
Roda JC komt niet verder dan de tweede ronde.
EOF

CL => {
groupD => [ ['', [1, 3, 'Champions League: 1-D', 1]],
['NLajx','ESrmd',[19950913,1,0]],
['CHgrs','HUfrv',[19950913,0,3]],
['HUfrv','NLajx',[19950927,1,5]],
['ESrmd','CHgrs',[19950927,2,0]],
['NLajx','CHgrs',[19951018,3,0]],
['ESrmd','HUfrv',[19951018,6,1]],
['CHgrs','NLajx',[19951101,0,0]],
['HUfrv','ESrmd',[19951101,1,1]],
['ESrmd','NLajx',[19951122,0,2]],
['HUfrv','CHgrs',[19951122,3,3]],
['NLajx','HUfrv',[19951206,4,0]],
['CHgrs','ESrmd',[19951206,0,2]] ],
#Eerste ronde: poule A
#Panathinaikos * (Gri);6;3;2;1;11;7-3
#FC Nantes * (Fra);6;2;3;1;9;8-6
#FC Porto (Por);6;1;4;1;7;6-5
#Aalborg (Den) ;6;1;1;4;4;5-12
#<td colspan=7> 21-23 sep 95
#Dinamo Kiev is schuldig bevonden aan omkoping van de scheidsrechter.<br>
#Straf: uitsluiting + 3 jaar schorsing. Het Deense Aalberg wordt de vervanger.
#Eerste ronde: poule B
#Spartak Moskou * (Rus);6;6;0;0;18;15-4
#Legia Warschau * (Pol);6;2;1;3;7;5-8
#Rosenborg Trondheim (Noo);6;2;0;4;6;11-16
#Blackburn Rovers (Eng);6;1;1;4;4;5-8
#Eerste ronde: poule C
#Juventus * (Ita);6;4;1;1;13;15-4
#Borussia Dortmund * (Dui);6;2;3;1;9;8-8
#Steaua Boekarest (Roe);6;1;3;2;6;2-5
#Glasgow Rangers (Sch);6;0;3;3;3;6-14
quarterfinal => [ [''],
['FRnnt','RUsmk',[19960306,2,0],[19960320,2,2],1],
['ESrmd','ITjuv',[19960306,1,0],[19960320,2,0],2],
['PLlgw','GRpnt',[19960306,0,0],[19960320,3,0],2],
['DEbdm','NLajx',[19960306,0,2],[19960320,1,0],2] ],
semifinal => [ [''],
['ITjuv','FRnnt',[19960403,2,0],[19960416,3,2],1],
['NLajx','GRpnt',[19960403,0,1],[19960416,0,3],1] ],
final => [ [''],
['ITjuv','NLajx',[19960522,1,1],5,'Rome'] ]},

CWC => {
round1 => [ ['Eerste ronde EC-II'],
['LVdlp','NLfyn',[19950914,0,7],[19950928,6,0],2] ],
round2 => [ ['Tweede ronde EC-II'],
['G1evr','NLfyn',[19951019,0,0],[19951102,1,0],2] ],
quarterfinal => [ [''],
['ITprm','FRpsg',[19960307,1,0],[19960321,3,1],2],
['ESdlc','ESrzg',[19960307,1,0],[19960321,1,1],1],
['RUdmk','ATrwn',[19960307,0,1],[19960321,3,0],2],
['DEbmg','NLfyn',[19960307,2,2],[19960321,1,0],2] ],
semifinal => [ [''],
['ESdlc','FRpsg',[19960404,0,1],[19960416,1,0],2],
['NLfyn','ATrwn',[19960404,1,1],[19960416,3,0],2] ],
final => [ [''],
['FRpsg','ATrwn',[19960508,1,0],1,'Brussel'] ]},

UEFAcup => {
#Intertoto: de laatste zestien ; Achtste finales:
#29/30 jul 95 SC Heerenveen * - Farul Constanta (Roe) <td> 4-0
#29/30 jul 95 1. FC K&ouml;ln * (Dui) - Tirol Innsbruck (Oos) <td> 1-3
#29/30 jul 95 Bordeaux * (Fra) - Eintracht Frankfurt (Dui) <td> 3-0
#29/30 jul 95 Bayer Leverkusen * (Dui) - Odense BK (Den) <td> 5-2
#29/30 jul 95 Bursaspor * (Tur) - OFI Kreta (???) <td> 2-1
#29/30 jul 95 FC Aarau (Zwi) - Karlsruher SC * (Dui) <td> 1-2 (n.v.)
#29/30 jul 95 Piatra Neamt (???) - FC Metz * (Fra) <td> 0-2
#29/30 jul 95 RC Strasbourg * (Fra) - Vorw&auml;rts Steyr (Oos) <td> 4-0
#Kwart finales
#2 aug 95 Bordeaux * - SC Heerenveen <td> 2-0
#2 aug 95 Bursaspor - Karlsruher SC * <td> 3-3 Karlsruher w.n.s.
#2 aug 95 Tirol Innsbruck * - Bayer Leverkusen <td> 2-2 Innsbruck w.n.s.
#2 aug 95 FC Metz - RC Strasbourg * <td> 0-2
itoto => [ ['Intertoto: laatste zestien'],
['NLhrv','ROfrc',["29/30 jul '95",4,0],1] ],
intertoto => [ ['Intertoto: laatste acht (winnaars naar UEFA-cup)'],
['FRgbr','NLhrv',[19950802,2,0],1] ],
round1 => [ ['Eerste ronde UEFA-cup'],
['FImyp','NLpsv',[19950912,1,1],[19950926,7,1],2],
['NLrdj','SIolj',[19950912,5,0],[19950926,2,0],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['PTbnf','NLrdj',[19951017,1,0],[19951031,2,2],1],
['G1lds','NLpsv',[19951017,3,5],[19951031,3,0],2] ],
round3 => [ ['Derde ronde UEFA-cup'],
['NLpsv','DEwbr',[19951121,2,1],[19951205,0,0],1] ],
quarterfinal => [ [''],
['ITmln','FRgbr',[19960305,2,0],[19960319,3,0],2],
['CZslp','ITasr',[19960305,2,0],[19960319,3,1],1],
['ESbcl','NLpsv',[19960305,2,2],[19960319,2,3],1],
['DEbmn','G1ntf',[19960305,2,1],[19960319,1,5],1] ],
semifinal => [ [''],
['CZslp','FRgbr',[19960402,0,1],[19960416,1,0],2],
['DEbmn','ESbcl',[19960402,2,2],[19960416,1,2],1] ],
final => [ [''],
['DEbmn','FRgbr',[19960501,2,0],[19960515,1,3],1] ]}};
#
$u_ec->{'1996-1997'} = {
extra => {
dd => 20090614,
summary => << 'EOF'},
In de Champions League is Juventus opnieuw te sterk voor Ajax.
Dit seizoen ontmoeten zij elkaar al in de halve finale,
en in de return in Turijn wordt Ajax overklast.
In de finale legt Juventus het dan af tegen Borussia Dortmund.
<p>In de EC-II blameert PSV zich in de tweede ronde tegen het Noorse Brann Bergen.
<p>In de UEFA-cup bereikt Feyenoord de derde ronde, en wordt Roda JC
al in de eerste ronde uitgeschakeld.
EOF

CL => {
groupA => [ ['', [1, 3, 'Champions League: 1-A', 1]],
['FRaux','NLajx',[19960911,0,1]],
['CHgrs','G2glr',[19960911,3,0]],
['NLajx','CHgrs',[19960925,0,1]],
['G2glr','FRaux',[19960925,1,2]],
['NLajx','G2glr',[19961016,4,1]],
['FRaux','CHgrs',[19961016,1,0]],
['G2glr','NLajx',[19961030,0,1]],
['CHgrs','FRaux',[19961030,3,1]],
['NLajx','FRaux',[19961120,1,2]],
['G2glr','CHgrs',[19961120,2,1]],
['CHgrs','NLajx',[19961204,0,1]],
['FRaux','G2glr',[19961204,2,1]] ],
#Eerste ronde: poule B
#Atletico Madrid * (Spa);6;4;1;1;13;12-4
#Borussia Dortmund * (Dui);6;4;1;1;13;14-8
#Widzew Lodz (Pol);6;1;1;4;4;6-10
#Steaua Boekarest (Roe);6;1;1;4;4;5-15
#Eerste ronde: poule C
#Juventus * (Ita);6;5;1;0;16;11-1
#Manchester United * (Eng);6;3;0;3;9;6-3
#Fenerbahce (Tur);6;2;1;3;7;3-6
#SK Rapid Wien (Oos);6;0;2;4;2;2-12
#Eerste ronde: poule D
#FC Porto * (Por);6;5;1;0;16;12-4
#Rosenborg Trondheim * (Noo);6;3;0;3;9;7-11
#AC Milan (Ita);6;2;1;3;7;13-11
#IFK G&ouml;teborg (Zwe);6;1;0;5;3;7-13
quarterfinal => [ [''],
['NOros','ITjuv',[19970305,1,1],[19970319,2,0],2],
['NLajx','ESamd',[19970305,1,1],[19970319,2,3],3],
['G1mnu','PTpor',[19970305,4,0],[19970319,0,0],1],
['DEbdm','FRaux',[19970305,2,1],[19970319,0,1],1] ],
semifinal => [ [''],
['NLajx','ITjuv',[19970409,1,2],[19970423,4,1],2],
['DEbdm','G1mnu',[19970409,1,0],[19970423,0,1],1] ],
final => [ [''], ['ITjuv','DEbdm',[19970528,1,3],2,'M&uuml;nchen (Olympiapark)'] ]},

CWC => {
round1 => [ ['Eerste ronde EC-II'],
['GEdbt','NLpsv',[19960912,1,1],[19960926,3,0],2] ],
round2 => [ ['Tweede ronde EC-II'],
['NObbr','NLpsv',[19961017,2,1],[19961031,2,2],1] ],
quarterfinal => [ [''],
['PTbnf','ITfrt',[19970306,0,2],[19970320,0,0],2],
['ESbcl','SEaik',[19970306,3,1],[19970320,1,1],1],
['NObbr','G1lvp',[19970306,1,1],[19970320,3,0],2],
['FRpsg','GRaek',[19970306,0,0],[19970320,0,3],1] ],
semifinal => [ [''],
['ESbcl','ITfrt',[19970410,1,1],[19970424,0,2],1],
['FRpsg','G1lvp',[19970410,3,0],[19970424,2,0],1] ],
final => [ [''], ['ESbcl','FRpsg',[19970512,1,0],1,'Rotterdam (de Kuip)'] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['RUcmk','NLfyn',[19960910,0,1],[19960924,1,1],2],
['DEs04','NLrdj',[19960910,3,0],[19960924,2,2],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['ESesp','NLfyn',[19961015,0,3],[19961029,0,1],2] ],
round3 => [ ['Derde ronde UEFA-cup'],
['EStnr','NLfyn',[19961119,0,0],[19961203,2,4],1] ],
quarterfinal => [ [''],
['G1nwc','FRmnc',[19970304,0,1],[19970318,3,0],2],
['BEand','ITiml',[19970304,1,1],[19970318,2,1],2],
['DEs04','ESval',[19970304,2,0],[19970318,1,1],1],
['EStnr','DKbrn',[19970304,0,1],[19970318,0,2],1] ],
semifinal => [ [''],
['ITiml','FRmnc',[19970408,3,1],[19970422,1,0],1],
['EStnr','DEs04',[19970408,1,0],[19970422,2,0],4] ],
final => [ [''],
['DEs04','ITiml',[19970507,1,0],[19970521,1,0],5] ]}};
#
$u_ec->{'1997-1998'} = {
extra => {
dd => 20090614,
summary => << 'EOF'},
Voor het eerst mogen twee Nederlandse team meedoen aan de Champions League.
Zowel PSV als Feyenoord stranden in de eerste ronde.
Real Madrid wint de finale van Juventus.
<p>In de EC-II bereikt Roda JC de kwartfinale, maar wordt dan zowel in
Kerkrade als in Itali&euml; afgedroogd door Vicenza.
<p>In de UEFA-cup stelt Vitesse opnieuw teleur door in de eerste ronde van
SC Braga te verliezen. Twente haalt dit seizoen de derde ronde.
Na drie mooie seizoenen in de Champions League,
komt Ajax nu niet verder dan de kwartfinale,
waar het kansloos is tegen Spartak Moskou.
EOF

CL => {
qfr_3 => [ ['2e voorronde'],
['NLfyn','FIjzz',[19970813,6,2],[19970827,1,2],1] ],
groupB => [ ['', [1, 3, 'Champions League: 1-B', 1]],
['SKksc','G1mnu',[19970917,0,3]],
['ITjuv','NLfyn',[19970917,5,1]],
['NLfyn','SKksc',[19971001,2,0]],
['G1mnu','ITjuv',[19971001,3,2]],
['G1mnu','NLfyn',[19971022,2,1]],
['SKksc','ITjuv',[19971022,0,1]],
['NLfyn','G1mnu',[19971105,1,3]],
['ITjuv','SKksc',[19971105,3,2]],
['NLfyn','ITjuv',[19971126,2,0]],
['G1mnu','SKksc',[19971127,3,0]],
['SKksc','NLfyn',[19971210,0,1]],
['ITjuv','G1mnu',[19971210,1,0]] ],
groupC => [ ['', [1, 3, 'Champions League: 1-C', 3]],
['NLpsv','UAdkv',[19970917,1,3]],
['G1nwc','ESbcl',[19970917,3,2]],
['ESbcl','NLpsv',[19971001,2,2]],
['UAdkv','G1nwc',[19971001,2,2]],
['NLpsv','G1nwc',[19971022,1,0]],
['UAdkv','ESbcl',[19971022,3,0]],
['G1nwc','NLpsv',[19971105,0,2]],
['ESbcl','UAdkv',[19971105,0,4]],
['ESbcl','G1nwc',[19971126,1,0]],
['UAdkv','NLpsv',[19971127,1,1]],
['NLpsv','ESbcl',[19971210,2,2]],
['G1nwc','UAdkv',[19971210,2,0]] ],
#Eerste ronde: poule A
#Borussia Dortmund * (Dui);6;5;0;1;15;14-3
#AS Parma (Ita);6;2;3;1;9;6-5
#Spartak Praag (Tsj);6;1;2;3;5;6-11
#Galatasaray (Tur);6;1;1;4;4;4-11
#Eerste ronde: poule D
#Real Madrid * (Spa);6;4;1;1;13;15-4
#Rosenborg BK (Noo);6;3;2;1;11;13-8
#Olympiakos (Gri);6;1;2;3;5;6-14
#FC Porto (Por);6;1;1;4;4;3-11
#Eerste ronde: poule E
#Bayern M&uuml;nchen * (Dui);6;4;0;2;12;13-6
#Paris Saint Germain (Fra);6;4;0;2;12;11-10
#Besiktas (Tur);6;2;0;4;6;6-9
#IFK G&ouml;teborg (Zwe);6;2;0;4;6;4-9
#Eerste ronde: poule F
#AS Monaco * (Mon-Fra);6;4;1;1;13;15-8
#Bayer Leverkusen * (Dui);6;4;1;1;13;11-7
#Sporting Portugal (Por);6;2;1;3;7;9-11
#Lierse SK (Bel);6;0;1;5;1;3-12
quarterfinal => [ [''],
['DEbmn','DEbdm',[19980304,0,0],[19980318,1,0],4],
['DElvk','ESrmd',[19980304,1,1],[19980318,3,0],2],
['FRmnc','G1mnu',[19980304,0,0],[19980318,1,1],1],
['ITjuv','UAdkv',[19980304,1,1],[19980318,1,4],1] ],
semifinal => [ [''],
['ESrmd','DEbdm',[19980401,2,0],[19980415,0,0],1],
['ITjuv','FRmnc',[19980401,4,1],[19980415,3,2],1] ],
final => [ [''],
['ESrmd','ITjuv',[19980520,1,0, {stadion => 'Amsterdam (de Arena)',
opm =>
 "De finale komt even in gevaar omdat Schiphol te weinig\n".
 "<br>start- en landingsrechten heeft om de bezoekers van de finale te verwerken.\n".
 "<br>De halve finale wedstrijd Real Madrid - Borussia Dortmund begint\n".
 "<br>75 minuten te laat door een omgetrokken doel.\n"}],1]]},

CWC => {
round1 => [ ['Eerste ronde EC-II'],
['ILhbs','NLrdj',[19970918,1,4],[19971002,10,0],2] ],
round2 => [ ['Tweede ronde EC-II'],
['SIprm','NLrdj',[19971023,0,2],[19971106,4,0],2] ],
quarterfinal => [ [''],
['ESbsv','G1cls',[19980305,1,2],[19980319,3,1],2],
['NLrdj','ITvcn',[19980305,1,4],[19980319,5,0],2],
['GRaek','RUlkm',[19980305,0,0],[19980319,2,1],2],
['CZslp','DEvfs',[19980305,1,1],[19980319,2,0],2] ],
semifinal => [ [''],
['ITvcn','G1cls',[19980402,1,0],[19980416,3,1],2],
['DEvfs','RUlkm',[19980402,2,1],[19980416,0,1],1] ],
final => [ [''], ['G1cls','DEvfs',[19980513,1,0,
{stadion => 'Stockholm',
 opm => 'In de finale scoort Zola 20s nadat hij als invaller in het veld kwam.'}], 1] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['SImrb','NLajx',[19970916,1,1],[19970930,9,1],2],
['NLvit','PTbrg',[19970916,2,1],[19970930,2,0],2],
['NLtwn','NOlll',[19970916,0,1],[19970930,1,2],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['NLajx','ITudn',[19971021,1,0],[19971104,2,1],1],
['DKarh','NLtwn',[19971021,1,1],[19971104,0,0],2] ],
round3 => [ ['Derde ronde UEFA-cup'],
['NLtwn','FRaux',[19971125,0,1],[19971209,2,0],2],
['NLajx','DEbcm',[19971125,4,2],[19971211,2,2],1] ],
quarterfinal => [ [''],
['NLajx','RUsmk',[19980303,1,3],[19980317,1,0],2],
['ITiml','DEs04',[19980303,1,0],[19980317,1,1],4],
['ITlzr','FRaux',[19980303,1,0],[19980317,2,2],1],
['ESamd','G1avl',[19980303,1,0],[19980317,2,1],1] ],
semifinal => [ [''],
['ITiml','RUsmk',[19980331,2,1],[19980414,1,2],1],
['ESamd','ITlzr',[19980331,0,1],[19980414,0,0],2] ],
final => [ [''],
['ITiml','ITlzr',[19980506,3,0, {stadion => 'Parijs (Parc des Princes)'}],1,] ]}};
#
$u_ec->{'1998-1999'} = {
extra => {
dd => 20090614,
summary => << 'EOF'},
In de Champions League komen Ajax en PSV niet verder dan de eerste ronde.
In de finale verslaat Manchester United Bayern M&uuml;nchen op z'n Duits.
<p>In de EC-II verliest Heerenveen in de tweede ronde op een
onbegrijpelijke manier van het Kroatische Varteks Varazdin.
<p>In de UEFA-cup lijkt Feyenoord na de eerste wedstrijd tegen Vfb Stuttgart
op rozen te zitten, maar de Duitsers winnen de return in Rotterdam met 0-3.
Willem II en Vitesse komen niet verder dan de tweede ronde.
EOF

CL => {
qfr_3 => [['Voorronde'], ['SImrb','NLpsv',[19980812,2,1],[19980826,4,1],4] ],
groupA => [ ['', [1, 3, 'Champions League: 1-A', 3]],
['PTpor','GRolp',[19980916,2,2]],
['HRczg','NLajx',[19980916,0,0]],
['GRolp','HRczg',[19980930,2,0]],
['NLajx','PTpor',[19980930,2,1]],
['GRolp','NLajx',[19981021,1,0]],
['PTpor','HRczg',[19981021,3,0]],
['NLajx','GRolp',[19981104,2,0]],
['HRczg','PTpor',[19981104,3,1]],
['GRolp','PTpor',[19981125,2,1]],
['NLajx','HRczg',[19981125,0,1]],
['PTpor','NLajx',[19981209,3,0]],
['HRczg','GRolp',[19981209,1,1]] ],
groupF => [ ['', [1, 3, 'Champions League: 1-F', 3]],
['NLpsv','FIhjk',[19980916,2,1]],
['DEksl','PTbnf',[19980916,1,0]],
['PTbnf','NLpsv',[19980930,2,1]],
['FIhjk','DEksl',[19980930,0,0]],
['FIhjk','PTbnf',[19981021,2,0]],
['NLpsv','DEksl',[19981021,1,2]],
['PTbnf','FIhjk',[19981104,2,2]],
['DEksl','NLpsv',[19981104,3,1]],
['FIhjk','NLpsv',[19981125,1,3]],
['PTbnf','DEksl',[19981125,2,1]],
['NLpsv','PTbnf',[19981209,2,2]],
['DEksl','FIhjk',[19981209,5,2]] ],
# Poule B
# Juventus (Ita) +     6,1,5,0, 8, 7- 5
# Galatasaray (Tur) -  6,2,2,2, 8, 8- 8
# Rosenborg BK (Noo) - 6,2,2,2, 8, 7- 8
# Athl. Bilbao (Spa) - 6,1,3,2, 6, 5- 6
# Poule C
# Internazionale (Ita)+6,4,1,1,13, 9- 5
# Real Madrid (Spa) +  6,4,0,2,12,17- 8
# Spartak Moskou (Rus)-6,2,2,2, 8, 7- 6
# Sturm Graz (Oos) -   6,0,1,5, 1, 2-16
# Poule D
# Bayern Munchen (Dui)+6,3,2,1,11, 9- 6
# Manchester Utd (Eng)+6,2,4,0,10,20-11
# FC Barcelona (Spa) - 6,2,2,2, 8,11- 9
# Br&ouml;ndby (Den) - 6,1,0,5, 3, 4-18
# Poule E
# Dynamo Kiev (Oek) +  6,3,2,1,11,11- 7
# Arsenal (Eng) -      6,2,2,2, 8, 8- 8
# RC Lens (Fra) -      6,2,2,2, 8, 5- 6
# Panathinaikos (Gri) -6,2,0,4, 6, 6- 9
quarterfinal => [ [''],
['ITjuv','GRolp',[19990303,2,1],[19990317,1,1],1],
['G1mnu','ITiml',[19990303,2,0],[19990317,1,1],1],
['DEbmn','DEksl',[19990303,2,0],[19990317,0,4],1],
['ESrmd','UAdkv',[19990303,1,1],[19990317,2,0],2] ],
semifinal => [ [''],
['G1mnu','ITjuv',[19990407,1,1],[19990421,2,3],1],
['UAdkv','DEbmn',[19990407,3,3],[19990421,1,0],2] ],
final => [ [''],
['G1mnu','DEbmn',[19990526,2,1,
{stadion => 'Barcelona (Nou Camp)',
 opm => 'In de finale scoort Manchester United beide goals in de blessuretijd.'}], 1]]},

CWC => {
round1 => [ ['Eerste ronde EC-II'],
['NLhrv','PLawr',[19980917,3,1],[19981001,0,1],1] ],
round2 => [ ['Tweede ronde EC-II'],
['NLhrv','HRvrv',[19981022,2,1],[19981105,4,2],4] ],
quarterfinal => [ [''],
['GRpan','ITlzr',[19990304,4,4],[19990318,3,0],2], # 0-4 ??
['RUlkm','ILmhf',[19990304,3,0],[19990318,0,1],1],
['HRvrv','ESmlr',[19990304,0,0],[19990318,3,1],2],
['G1cls','NOvli',[19990304,3,0],[19990318,2,3],1] ],
semifinal => [ [''],
['RUlkm','ITlzr',[19990408,1,1],[19990422,0,0],2],
['G1cls','ESmlr',[19990408,1,1],[19990422,1,0],2] ],
final => [ [''],
['ITlzr','ESmlr',[19990519,2,1, {opm =>
 "Lazio Roma is de laatste winnaar van de Europacup II.<br>\n".
'Vanaf volgend seizoen zijn meeste bekerwinnaars in de UEFA cup terug te vinden.'}],1,
'Birmingham (Villa Park)'] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['DEvfs','NLfyn',[19980915,1,3],[19980929,0,3],1], # !!!
['NLwl2','GEdtb',[19980915,3,0],[19980929,0,3],1],
['NLvit','GRaek',[19980915,3,0],[19980929,3,3],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['NLwl2','ESbsv',[19981020,1,1],[19981103,3,0],2],
['NLvit','FRgbr',[19981020,0,1],[19981103,2,1],2] ],
quarterfinal => [ [''],
['FRgbr','ITprm',[19990302,2,1],[19990316,6,0],2],
['ESamd','ITasr',[19990302,2,1],[19990316,1,2],1],
['ITblg','FRoly',[19990302,3,0],[19990316,2,0],1],
['FRomr','EScdv',[19990302,2,1],[19990316,0,0],1] ],
semifinal => [ [''],
['ESamd','ITprm',[19990406,1,3],[19990420,2,1],2],
['FRomr','ITblg',[19990406,0,0],[19990420,1,1],1] ],
final => [ [''], ['ITprm','FRomr',[19990512,3,0],1,'Moskou (Luzhniki Stadium)'] ]}};
#
$u_ec->{'1999-2000'} = {
extra => {
dd => 20090612,
summary => << 'EOF'},
Real Madrid wint voor de achtste keer het belangrijkste Europacuptournooi.
PSV en Willem II verlaten na de eerste ronde roemloos het tournooi.
Feyenoord bereikt de tweede ronde, en gaat halverwege aan de leiding,
maar weet zich uiteindelijk niet voor de kwartfinale te plaatsen.
<p>In de UEFA-cup halen Vitesse en Roda JC de tweede ronde.
Ajax komt zelfs een ronde verder, maar verliest wel de laatste drie
Europacupwedstrijden van de 20-ste eeuw op rij.
EOF

CL => {
qfr_3 => [['Voorronde'], ['MDzmc','NLpsv',[19990811,0,0],[19990825,2,0],2] ],
groupC => [ ['', [1, 3, 'Champions League: 1-C', 2]],
['NLfyn','DEbdm',[19990914,1,1]],
['PTboa','NOros',[19990914,0,3]],
['NOros','NLfyn',[19990922,2,2]],
['DEbdm','PTboa',[19990922,3,1]],
['PTboa','NLfyn',[19990929,1,1]],
['NOros','DEbdm',[19990929,2,2]],
['NLfyn','PTboa',[19991019,1,1]],
['DEbdm','NOros',[19991019,0,3]],
['DEbdm','NLfyn',[19991027,1,1]],
['NOros','PTboa',[19991027,2,0]],
['NLfyn','NOros',[19991102,1,0]],
['PTboa','DEbdm',[19991102,1,0]] ],
groupF => [ ['', [1, 3, 'Champions League: 1-F', 2]],
['DEbmn','NLpsv',[19990915,2,1]],
['ESval','G2glr',[19990915,2,0]],
['NLpsv','ESval',[19990921,1,1]],
['G2glr','DEbmn',[19990921,1,1]],
['NLpsv','G2glr',[19990928,0,1]],
['DEbmn','ESval',[19990928,1,1]],
['G2glr','NLpsv',[19991020,4,1]],
['ESval','DEbmn',[19991020,1,1]],
['NLpsv','DEbmn',[19991026,2,1]],
['G2glr','ESval',[19991026,1,2]],
['ESval','NLpsv',[19991103,1,0]],
['DEbmn','G2glr',[19991103,1,0]] ],
groupG => [ ['', [1, 3, 'Champions League: 1-G', 2]],
['NLwl2','RUsmk',[19990915,1,3]],
['CZspr','FRgbr',[19990915,0,0]],
['FRgbr','NLwl2',[19990921,3,2]],
['RUsmk','CZspr',[19990921,1,1]],
['CZspr','NLwl2',[19990928,4,0]],
['FRgbr','RUsmk',[19990928,2,1]],
['NLwl2','CZspr',[19991020,3,4]],
['RUsmk','FRgbr',[19991020,1,2]],
['RUsmk','NLwl2',[19991026,1,1]],
['FRgbr','CZspr',[19991026,0,0]],
['NLwl2','FRgbr',[19991103,0,0]],
['CZspr','RUsmk',[19991103,5,2]] ],
#Eerste ronde: poule A
#Lazio Roma * (Ita),6,4,2,0,14,13-3
#Dinamo Kiev * (Oek),6,2,1,3,7,8-8
#Bayer Leverkusen + (Dui),6,1,4,1,7,7-7
#NK Maribor - (Slv),6,1,1,4,4,2-12
#Eerste ronde: poule B
#FC Barcelona * (Spa),6,4,2,0,14,19-9
#Fiorentina * (Ita),6,2,3,1,9,9-7
#Arsenal + (Eng),6,2,2,2,8,9-9
#AIK Solna - (Zwe),6,0,1,5,1,4-16
#Eerste ronde: poule D
#Manchester Utd * (Eng),6,4,1,1,13,9-4
#Olympique Marseille * (Fra),6,3,1,2,10,10-8
#Sturm Graz + (Oos),6,2,0,4,6,5-12
#Croatia Zagreb - (Kro),6,1,2,3,5,7-7
#Eerste ronde: poule E
#Real Madrid * (Spa),6,4,1,1,13,15-7
#FC Porto * (Por),6,4,0,2,12,9-6
#Olympiakos Piraeus + (Gri),6,2,1,3,7,9-12
#Molde FK - (Noo),6,1,0,5,3,6-14
#Eerste ronde: poule H
#Chelsea * (Eng),6,3,2,1,11,10-3
#Hertha BSC * (Dui),6,2,2,2,8,7-10
#Galatasaray + (Tur),6,2,1,3,7,10-13
#AC Milan - (Ita),6,1,3,2,6,6-7
group2D => [ ['', [1, 3, 'Champions League: 2-D', 1]],
['G1cls','NLfyn',[19991124,3,1]],
['FRomr','ITlzr',[19991124,0,2]],
['NLfyn','FRomr',[19991207,3,0]],
['ITlzr','G1cls',[19991207,0,0]],
['ITlzr','NLfyn',[20000229,1,2]],
['FRomr','G1cls',[20000229,1,0]],
['NLfyn','ITlzr',[20000308,0,0]],
['G1cls','FRomr',[20000308,1,0]],
['NLfyn','G1cls',[20000314,1,3]],
['ITlzr','FRomr',[20000314,5,1]],
['FRomr','NLfyn',[20000322,0,0]],
['G1cls','ITlzr',[20000322,1,2]] ],
#Tweede ronde: Poule A
#FC Barcelona * (Spa) ,6,5,1,0,16,17-5
#FC Porto * (Por) ,6,3,1,2,10, 8-8
#Sparta Praag (Tsj) ,6,1,2,3, 5, 5-12
#Hertha BSC (Dui) ,6,0,2,4, 2, 3-8
#Tweede ronde: Poule B
#Manchester United * (Eng) ,6,4,1,1,13,10-4
#Valencia * (Spa) ,6,3,1,1,10, 9-5
#Fiorentina (Ita) ,6,2,2,2, 8, 7-8
#Girondins de Bordeaux (Fra) ,6,0,2,4, 2, 5-14
#Tweede ronde: Poule C
#Bayern M&uuml;nchen * (Dui) ,6,4,1,1,13, 13- 8
#Real Madrid * (Spa) ,6,3,1,2,10, 11-12
#Dynamo Kiev (Oek) ,6,3,1,2,10, 10- 8
#Rosenborg Trondheim (Noo) ,6,0,1,5, 1, 5-11
#Real Madrid naar volgende ronde op basis van onderling
#resultaat met Dynamo Kiev. In Kiev: 1-2, in Madrid: 2-2
quarterfinal => [ [''],
['PTpor','DEbmn',[20000404,1,1],[20000419,2,1],2],
['ESrmd','G1mnu',[20000404,0,0],[20000419,2,3],1],
['G1cls','ESbcl',[20000405,3,1],[20000418,5,1],4],
['ESval','ITlzr',[20000405,5,2],[20000418,1,0],1] ],
semifinal => [ [''],
['ESrmd','DEbmn',[20000503,2,0],[20000509,2,1],1],
['ESval','ESbcl',[20000502,4,1],[20000510,2,2],1] ],
final => [ [''],
['ESrmd','ESval',[20000524,3,0],1,'Parijs St. Denis (Stade de France)'] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['NLajx','SKdbb',[19990916,6,1],[19990930,1,3],1],
['PTbmr','NLvit',[19990916,1,2],[19990930,0,0],2],
['NLrdj','UAsdk',[19990916,2,0],[19990930,1,3],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['ILhhf','NLajx',[19991021,0,3],[19991104,0,1],2],
['NLrdj','DEvwl',[19991021,0,0],[19991102,1,0],2],
['FRrcl','NLvit',[19991028,4,1],[19991104,1,1],1] ],
round3 => [ ['Derde ronde UEFA-cup'],
['NLajx','ESmlr',[19991125,0,1],[19991209,2,0],2] ],
quarterfinal => [ [''],
['G1lds','CZslp',[20000316,3,0],[20000323,2,1],1],
['ESmlr','TRglt',[20000316,1,4],[20000323,2,1],2],
['EScdv','FRrcl',[20000316,0,0],[20000323,2,1],2],
['G1ars','DEwbr',[20000316,2,0],[20000323,2,4],1] ],
semifinal => [ [''],
['TRglt','G1lds',[20000406,2,0],[20000420,2,2],1],
['G1ars','FRrcl',[20000406,1,0],[20000420,1,2],1] ],
final => [ [''],
['TRglt','G1ars',[20000517,0,0,
 {opm => 'De wedstrijd Galatasaray-Leeds United wordt voorafgegaan'.
         '<br>door ernstige rellen waarbij twee Engelsen omkomen.',
 stadion =>'Kopenhagen'}], 5] ]}};
#
$u_ec->{'2000-2001'} = {
extra => {
dd => 20090612,
summary => << 'EOF'},
In de Champions League haalt PSV in de eerste ronde 9 punten.
Meestal is dat genoeg voor de volgende ronde, maar nu niet.
Heerenveen eindigt als laatste in de poule.
Bayern M&uuml;nchen wint de finale van Valencia (na strafschoppen),
na eerst Real Madrid en Manchester United te hebben uitgeschakeld.
<p>In de UEFA-cup bereiken Ajax, Feyenoord en Vitesse eenvoudig de tweede ronde.
In die ronde is Inter Milaan net te sterk voor Vitesse,
en laat Ajax zich verrassen door het Zwitserse Lausanne Sport.
<p>In de derde ronde doet nu ook PSV mee, en schakelt PAOK Saloniki uit.
Feyenoord weet niet van Vfb Stuttgart te winnen.
Na de winterstop schakelt PSV Parma uit, en bereiken de Eindhovenaren de laatste acht.
Daarin speelt PSV tegen het Duitse Kaiserslautern.
PSV verliest twee keer met 1-0. In de return (thuis) breken supporters door het hek.
Dit wordt door de UEFA bestraft met het spelen van de volgende
thuiswedstrijd op minstens 100 km van Eindhoven.
EOF

CL => {
qfr_3 => [ ['Voorronde'], ['ATstg','NLfyn',[20000808,2,1],[20000823,1,1],1] ],
groupC => [ ['', [1, 3, 'Eerste ronde, Poule C', 2]],
['FRoly','NLhrv',[20000912,3,1]],
['ESval','GRolp',[20000912,2,1]],
['NLhrv','ESval',[20000920,0,1]],
['GRolp','FRoly',[20000920,2,1]],
['GRolp','NLhrv',[20000927,2,0]],
['ESval','FRoly',[20000927,1,0]],
['NLhrv','GRolp',[20001017,1,0]],
['FRoly','ESval',[20001017,1,2]],
['NLhrv','FRoly',[20001025,0,2]],
['GRolp','ESval',[20001025,1,0]],
['FRoly','GRolp',[20001107,1,0]],
['ESval','NLhrv',[20001107,1,1]] ],
groupG => [ ['', [1, 3, 'Eerste ronde, Poule G', 2]],
['NLpsv','UAdkv',[20000913,2,1]],
['G1mnu','BEand',[20000913,5,1]],
['BEand','NLpsv',[20000919,1,0]],
['UAdkv','G1mnu',[20000919,0,0]],
['NLpsv','G1mnu',[20000926,3,1]],
['UAdkv','BEand',[20000926,4,0]],
['G1mnu','NLpsv',[20001018,3,1]],
['BEand','UAdkv',[20001018,4,2]],
['UAdkv','NLpsv',[20001024,0,1]],
['BEand','G1mnu',[20001024,2,1]],
['G1mnu','UAdkv',[20001108,1,0]],
['NLpsv','BEand',[20001108,2,3]] ],
quarterfinal => [ [''],
['G1lds','ESdlc',[20010404,3,0],[20010417,2,0],1],
['G1ars','ESval',[20010404,2,1],[20010417,1,0],2],
['TRglt','ESrmd',[20010403,3,2],[20010418,3,0],2],
['G1mnu','DEbmn',[20010403,0,1],[20010418,2,1],2]],
semifinal => [ [''],
['G1lds','ESval',[20010502,0,0],[20010508,3,0],2],
['ESrmd','DEbmn',[20010501,0,1],[20010509,2,1],2]],
final => [ [''],
['DEbmn','ESval',[20010523,0,0],5,'Milaan']]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['BEaag','NLajx',[20000912,0,6],[20000928,3,0],2],
['NLrdj','SKibr',[20000914,0,2],[20000926,2,1],2],
['NLvit','ILmhf',[20000914,3,0],[20000928,2,1],1],
['HUdnf','NLfyn',[20000914,0,1],[20000928,3,1],2]],
round2 => [ ['Tweede ronde UEFA-cup'],
['ITiml','NLvit',[20001026,0,0],[20001109,1,1],1],
['CHlsp','NLajx',[20001026,1,0],[20001109,2,2],1],
['CHbsl','NLfyn',[20001026,1,2],[20001109,1,0],2]],
round3 => [ ['Derde ronde UEFA-cup'],
['NLfyn','DEvfs',[20001123,2,2],[20001205,2,1],2],
['NLpsv','GRpks',[20001123,3,0],[20001207,0,1],1]],
round_of_16 => [ ['Achtste finale UEFA-cup'],
['NLpsv','ITprm',[20010215,2,1],[20010222,3,2],1]],
quarterfinal => [ [''],
['ESbcl','EScdv',[20010308,2,1],[20010315,3,2],1],
['PTpor','G1lvp',[20010308,0,0],[20010315,2,0],2],
['ESalv','ESrvl',[20010308,3,0],[20010315,2,1],1],
['DEksl','NLpsv',[20010308,1,0],[20010315,0,1],1]],
semifinal => [ [''],
['ESbcl','G1lvp',[20010405,0,0],[20010419,1,0],2],
['ESalv','DEksl',[20010405,5,1],[20010419,1,4],1]],
final => [ [''],
['G1lvp','ESalv',[20010516,5,4,
 {stadion => 'Dortmund', opm => 'Liverpool wint na Golden Goal'}],3]]}};
#
$u_ec->{'2001-2002'} = {
extra => {
dd => 20090612,
summary => << 'EOF'},
Het europacupseizoen begon met een discussie over het
al dan niet doorlaten gaan van de wedstrijden i.v.m.
de aanslagen in de VS van 11 september. Op de dag
van de aanslagen zelf is nog wel gespeeld, maar de wedstrijden
van 12 en 13 september werden uitgesteld.
Een vergelijkbare discussie ontstaat rond de UEFA-cup finale
tussen Feyenoord en Borussia Dortmund te Rotterdam
na de moord op de Rotterdamse politicus Pim Fortuijn.
<p>De Champions League was voor alle Nederlandse clubs een omweg
richting de UEFA-cup. De belangrijkste EC-finale werd
voor de negende keer door Real Madrid gewonnen.
<p>Feyenoord wint, vooral door de vrije trappen van Pierre van Hooijdonk, de UEFA-cup!
In UEFA-cup stonden in de kwartfinale voor het eerst in
de geschiedenis van het Europacupvoetbal twee Nederlandse
clubs tegenover elkaar: PSV en Feyenoord. Feyenoord wint
op strafschoppen, bereikt de finale in de eigen Kuip,
en wint die met 3-2 van Borussia Dortmund.
Eerder in het tournooi verliest Ajax roemloos van Kopenhagen,
en zorgt Roda JC bijna voor een stunt door in Milaan
van AC Milan te winnen, maar verliest het de strafschoppenserie.
Utrecht en Twente komen niet verder dan de 2e ronde.
EOF

CL => {
qfr_3 => [ ['Voorronde'],
['NLajx','G2clt',[20010808,1,3],[20010822,0,1],2] ],
groupD => [ ['', [1, 3, 'Eerste ronde, Poule D', 2]],
['FRnnt','NLpsv',[20010911,4,1]],
['TRglt','ITlzr',[20010911,1,0]],
['NLpsv','TRglt',[20010919,3,1]],
['ITlzr','FRnnt',[20010919,1,3]],
['NLpsv','ITlzr',[20010926,1,0]],
['FRnnt','TRglt',[20010926,0,1]],
['ITlzr','NLpsv',[20011016,2,1]],
['TRglt','FRnnt',[20011016,0,0]],
['NLpsv','FRnnt',[20011024,0,0]],
['ITlzr','TRglt',[20011024,1,0]],
['TRglt','NLpsv',[20011030,2,0]],
['FRnnt','ITlzr',[20011030,1,0]] ],
groupH => [ ['', [1, 3, 'Eerste ronde, Poule H', 2]],
['RUsmk','NLfyn',[20010918,2,2]],
['DEbmn','CZspr',[20010918,0,0]],
['CZspr','NLfyn',[20010925,4,0]],
['RUsmk','DEbmn',[20010925,1,3]],
['NLfyn','DEbmn',[20011010,2,2]],
['CZspr','RUsmk',[20011010,2,0]],
['NLfyn','CZspr',[20011017,0,2]],
['DEbmn','RUsmk',[20011017,5,1]],
['DEbmn','NLfyn',[20011023,3,1]],
['RUsmk','CZspr',[20011023,2,2]],
['NLfyn','RUsmk',[20011031,2,1]],
['CZspr','DEbmn',[20011031,0,1]] ],
quarterfinal => [ [''],
['DEbmn','ESrmd',[20020402,2,1],[20020410,2,0],2],
['GRpnt','ESbcl',[20020403,1,0],[20020409,3,1],2],
['ESdlc','G1mnu',[20020402,1,2],[20020410,3,2],2],
['G1lvp','DElvk',[20020403,1,0],[20020409,4,2],2]],
semifinal => [ [''],
['ESbcl','ESrmd',[20020423,0,2],[20020501,1,1],2],
['G1mnu','DElvk',[20020424,2,2],[20020430,1,1],2]],
final => [ ['finale'],
['ESrmd','DElvk',[20020515,2,1],1,'Glasgow (Hampden Park)']]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['NLrdj','ISfyl',[20010911,3,0],[20010925,1,3],1],
['NLutr','ATgrz',[20010920,3,0],[20010927,3,3],1],
['NLajx','CYapp',[20010920,2,0],[20010927,0,3],1],
['PLplw','NLtwn',[20010920,1,2],[20010927,2,0],2] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['NLrdj','ILmta',[20011016,4,1],[20011101,2,1],1],
['DKfkp','NLajx',[20011018,0,0],[20011101,0,1],1],
['NLutr','ITprm',[20011018,1,3],[20011101,0,0],2],
['CHgrs','NLtwn',[20011018,4,1],[20011101,4,2],1] ],
round3 => [ ['Derde ronde UEFA-cup'],
['GRpks','NLpsv',[20011122,3,2],[20011206,4,1],2],
['NLfyn','DEfrb',[20011122,1,0],[20011206,2,2],1],
['FRgbr','NLrdj',[20011120,1,0],[20011204,2,0],2] ],
round_of_16 => [ ['Vierde ronde UEFA-cup'],
['NLrdj','ITmln',[20020219,0,1],[20020228,0,1],6],
['NLpsv','G1lds',[20020221,0,0],[20020228,0,1],1],
['G2glr','NLfyn',[20020221,1,1],[20020228,3,2],2] ],
quarterfinal => [ [''],
['ITiml','ESval',[20020314,1,1],[20020321,0,1],1],
['NLpsv','NLfyn',[20020314,1,1],[20020321,1,1],6],
['ILhta','ITmln',[20020314,1,0,
 {opm => 'Eerste wedstrijd op Cyprus (Nicosia)'}],
 [20020321,2,0],2],
['CZsll','DEbdm',[20020314,0,0],[20020321,4,0],2] ],
semifinal => [ [''],
['ITiml','NLfyn',[20020404,0,1],[20020411,2,2],2],
['DEbdm','ITmln',[20020404,4,0],[20020411,3,1],1] ],
final => [ [''],
['NLfyn','DEbdm',[20020508,3,2],1,'Rotterdam (De Kuip)']]}};
#
$u_ec->{'2002-2003'} = {
extra => {
dd => 20090612,
summary => << 'EOF',
Na een doelpuntloze finale tussen twee Italiaanse teams
wint AC Milan na strafschoppen de Champions League. Clarence Seedorf
heeft nu als eerste speler met drie verschillende clubs (Ajax, Real Madrid en AC Milan)
de Champions League gewonnen. Verder valt hij op door weer eens een strafschop te missen.
<p>Eerder in het seizoen bereikt Ajax de kwartfinale van het belangrijkste Europacuptournooi
en dat was sinds het seizoen 1996/1997 geen enkele Nederlandse club gelukt.
Een doelpunt in blessuretijd van AC Milan houdt Ajax uit de halve finale.
<p>PSV en Feyenoord worden in de eerste ronde vierde,
en hun Europees avontuur is dus snel voorbij.
Na de winst vorig seizoen van de UEFA-cup is dit voor Feyenoord teleurstellend;
PSV heeft sinds de invoering van het poule-systeem nog nooit de tweede ronde bereikt.
<p>In de UEFA-cup bereikt Vitesse knap de derde ronde, en komt tegen Liverpool net tekort.
FC Utrecht en Heerenveen houden in de eerste wedstrijd achterin open huis,
waardoor voor beide clubs de return een formaliteit is.
EOF
supercup => [['Supercup'], ['ESrmd','NLfyn',[20020829,3,1,{stadion => 'Monaco'}],1] ]},

CL => {
qfr_3 => [['Voorronde'], ['NLfyn','TRfen',[20020813,1,0],[20020827,0,2],1] ],
groupA => [ ['', [1, 3, 'Champions League: 1-A', 2]],
['FRaux','NLpsv',[20020917,0,0]],
['G1ars','DEbdm',[20020917,2,0]],
['DEbdm','FRaux',[20020925,2,1]],
['NLpsv','G1ars',[20020925,0,4]],
['NLpsv','DEbdm',[20021002,1,3]],
['FRaux','G1ars',[20021002,0,1]],
['DEbdm','NLpsv',[20021022,1,1]],
['G1ars','FRaux',[20021022,1,2]],
['NLpsv','FRaux',[20021030,3,0]],
['DEbdm','G1ars',[20021030,2,1]],
['FRaux','DEbdm',[20021112,1,0]],
['G1ars','NLpsv',[20021112,0,0]] ],
groupD => [ ['', [1, 3, 'Eerste ronde, Poule D', 2]],
['NOros','ITiml',[20020917,2,2]],
['NLajx','FRoly',[20020917,2,1]],
['FRoly','NOros',[20020925,5,0]],
['ITiml','NLajx',[20020925,1,0]],
['ITiml','FRoly',[20021002,1,2]],
['NOros','NLajx',[20021002,0,0]],
['FRoly','ITiml',[20021022,3,3]],
['NLajx','NOros',[20021022,1,1]],
['ITiml','NOros',[20021030,3,0]],
['FRoly','NLajx',[20021030,0,2]],
['NOros','FRoly',[20021112,1,1]],
['NLajx','ITiml',[20021112,1,2]] ],
groupE => [ ['', [1, 3, 'Eerste ronde, Poule E', 2]],
['NLfyn','ITjuv',[20020918,1,1]],
['UAdkv','G1nwc',[20020918,2,0]],
['G1nwc','NLfyn',[20020924,0,1]],
['ITjuv','UAdkv',[20020924,5,0]],
['ITjuv','G1nwc',[20021001,2,0]],
['NLfyn','UAdkv',[20021001,0,0]],
['G1nwc','ITjuv',[20021023,1,0]],
['UAdkv','NLfyn',[20021023,2,0]],
['ITjuv','NLfyn',[20021029,2,0]],
['G1nwc','UAdkv',[20021029,2,1]],
['NLfyn','G1nwc',[20021113,2,3]],
['UAdkv','ITjuv',[20021113,1,2]] ],
group2B => [ ['', [1, 3, 'Tweede ronde, Poule B', 1]],
['ESval','NLajx',[20021127,1,1]],
['ITasr','G1ars',[20021127,1,3]],
['NLajx','ITasr',[20021210,2,1]],
['G1ars','ESval',[20021210,0,0]],
['G1ars','NLajx',[20030218,1,1]],
['ITasr','ESval',[20030218,0,1]],
['NLajx','G1ars',[20030226,0,0]],
['ESval','ITasr',[20030226,0,3]],
['NLajx','ESval',[20030311,1,1]],
['G1ars','ITasr',[20030311,1,1]],
['ITasr','NLajx',[20030319,1,1]],
['ESval','G1ars',[20030319,2,1]] ],
quarterfinal => [[''],
['ESrmd','G1mnu',[20030408,3,1],[20030423,4,3],1],
['ITjuv','ESbcl',[20030409,1,1],[20030422,1,2],3],
['NLajx','ITmln',[20030408,0,0],[20030423,3,2],2],
['ITiml','ESval',[20030409,1,0],[20030422,2,1],1] ],
semifinal => [[''],
['ESrmd','ITjuv',[20030506,2,1],[20030514,3,1],2],
['ITmln','ITiml',[20030507,0,0],[20030513,1,1],1] ],
final => [['finale'],
['ITmln','ITjuv',[20030528,0,0],5,'Manchester (Old Trafford)']]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup'],
['PLlgw','NLutr',[20020919,4,1],[20021003,1,3],1],
['ROntb','NLhrv',[20020919,3,0],[20021003,2,0],1],
['NLvit','ROrpb',[20020917,1,1],[20021003,0,1],1]],
round2 => [ ['Tweede ronde UEFA-cup'],
['NLvit','DEwbr',[20021031,2,1],[20021114,3,3],1]],
round3 => [ ['Derde ronde UEFA-cup'],
['NLvit','G1lvp',[20021128,0,1],[20021212,1,0],2]],
quarterfinal => [ [''],
['PTpor','GRpnt',[20030313,0,1],[20030320,0,2],3],
['ITlzr','TRbsk',[20030313,1,0],[20030320,1,2],1],
['G2clt','G1lvp',[20030313,1,1],[20030320,0,2],1],
['ESmal','PTboa',[20030313,1,0],[20030320,1,0],6]],
semifinal => [ [''],
['PTpor','ITlzr',[20030410,4,1],[20030424,0,0],1],
['G2clt','PTboa',[20030410,1,1],[20030424,0,1],1]],
final => [ [''],
['PTpor','G2clt',[20030521,3,2],3,'Sevilla']]}};
#
$u_ec->{'2003-2004'} = {
extra => {
dd => 20090612,
supercup => [['Europese Supercup'],['PTpor','ESval',[20040827,1,2],2, 'Monaco']],
summary => << 'EOF'},
In de Champions League bereiken Ajax en PSV niet de tweede ronde.
Ajax gaat halverwege aan de leiding, maar verliest alle returns en wordt vierde.
PSV doet het ongeveer omgekeerd, en komt net te kort om tweede in de poule te worden.
<br>
In de kwartfinale worden verrassend Real Madrid, AC Milan en Arsenal uitgeschakeld,
waardoor later Porto en Monaco zich kunnen plaatsen voor de finale, die Porto dan wint.
<p>
In de Intertoto wordt Heerenveen uitgeschakeld door Villareal,
dat later de halve finale haalt van de UEFA-cup.
<br>
In de UEFA-cup worden NEC en NAC weggespeeld, maar bereiken Utrecht en Feyenoord nog de tweede ronde.
PSV bereikt de kwartfinale, maar komt te kort tegen Newcastle Utd.
<br>
Uiteindelijk wint Valencia de finale van Marseille.
EOF

CL => {
qfr_3 => [['Voorronde'], ['ATgrz','NLajx',[20030812,1,1],[20030827,2,1],4] ],
groupC => [ ['', [1, 3, 'Eerste ronde, Poule C', 2]],
['NLpsv','FRmnc',[20030917,1,2]],
['GRaek','ESdlc',[20030917,1,1]],
['ESdlc','NLpsv',[20030930,2,0]],
['FRmnc','GRaek',[20030930,4,0]],
['GRaek','NLpsv',[20031021,0,1]],
['ESdlc','FRmnc',[20031021,1,0]],
['NLpsv','GRaek',[20031105,2,0]],
['FRmnc','ESdlc',[20031105,8,3]],
['ESdlc','GRaek',[20031125,3,0]],
['FRmnc','NLpsv',[20031125,1,1]],
['NLpsv','ESdlc',[20031210,3,2]],
['GRaek','FRmnc',[20031210,0,0]] ],
groupH => [ ['', [1, 3, 'Eerste ronde, Poule H', 2]],
['ITmln','NLajx',[20030916,1,0]],
['BEcbr','EScdv',[20030916,1,1]],
['NLajx','BEcbr',[20031001,2,0]],
['EScdv','ITmln',[20031001,0,0]],
['NLajx','EScdv',[20031022,1,0]],
['ITmln','BEcbr',[20031022,0,1]],
['EScdv','NLajx',[20031104,3,2]],
['BEcbr','ITmln',[20031104,0,1]],
['NLajx','ITmln',[20031126,0,1]],
['EScdv','BEcbr',[20031126,1,1]],
['BEcbr','NLajx',[20031209,2,1]],
['ITmln','EScdv',[20031209,1,2]] ],
quarterfinal => [ ['Kwartfinale C-L'],
['PTpor','FRoly',[20040323,2,0],[20040407,2,2],1],
['ITmln','ESdlc',[20040323,4,1],[20040407,4,0],2],
['ESrmd','FRmnc',[20040324,4,2],[20040406,3,1],2],
['G1cls','G1ars',[20040324,1,1],[20040406,1,2],1] ],
semifinal => [ ['Halvefinale C-L'],
['PTpor','ESdlc',[20040421,0,0],[20040504,0,1],1],
['FRmnc','G1cls',[20040420,3,1],[20040505,2,2],1] ],
final => [ ['Finale C-L'],
['PTpor','FRmnc',[20040526,3,0],1,'Gelsenkirchen'] ]},

UEFAcup => {
intertoto => [ ['Finale Intertoto (winnaars naar UEFA-cup)'],
['NLhrv','ESvlr',[20030812,1,2],[20030826,0,0],2],
['ATpsc','DEs04',[20030812,0,2],[20030826,0,0],2],
['ITprg','DEvwl',[20030812,1,0],[20030826,0,2],1] ],
round1 => [ ['Eerste ronde UEFA-cup'],
['G1nwc','NLnac',[20030924,5,0],[20031015,0,1],1],
['NLutr','SKzln',[20030924,2,0],[20031015,0,4],1],
['PLwkr','NLnec',[20030925,2,1],[20031015,1,2],1],
['NLfyn','ATkrt',[20030925,2,1],[20031015,0,1],1] ],
round2 => [ ['Tweede ronde UEFA-cup'],
['NLutr','FRaux',[20031106,0,0],[20031127,4,0],2],
['NLfyn','CZtpl',[20031106,0,2],[20031127,1,1],2] ],
round3 => [ ['Derde ronde UEFA-cup'],
['ITprg','NLpsv',[20040225,0,0],[20040303,3,1],2] ],
round_of_16 => [ ['Vierde ronde; 8-ste finale UEFA-cup'],
['FRaux','NLpsv',[20040311,1,1],[20040325,3,0],2] ],
quarterfinal => [ [''],
['NLpsv','G1nwc',[20040408,1,1],[20040414,2,1],2],
['FRomr','ITiml',[20040408,1,0],[20040414,0,1],1],
['G2clt','ESvlr',[20040408,1,1],[20040414,2,0],2],
['FRgbr','ESval',[20040408,1,2],[20040414,2,1],2] ],
semifinal => [ [''],
['G1nwc','FRomr',[20040422,0,0],[20040506,2,0],2],
['ESvlr','ESval',[20040422,0,0],[20040506,1,0],2] ],
final => [ [''],
['ESval','FRomr',[20040519,2,0],1,'Gothenburg'] ]}};

sub get_u_ec($)
{
  my $szn = shift;

  if (not defined($u_ec->{$szn}))
  {
    my $csv = "europacup_$szn.csv";
    $csv =~ s/-/_/;
    $u_ec->{$szn} = read_ec_csv($csv, $szn);
    $u_ec->{$szn}->{extra}->{dd} =
      max(laatste_speeldatum_ec($szn), $u_ec->{$szn}->{extra}->{dd});
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
