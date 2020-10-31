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
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&laatste_speeldatum_ec',
 '&set_laatste_speeldatum_ec',
 '&get_ec_webpage',
 '&init_ec',
 '$u_ec',
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
#
$u_ec->{'2004-2005'} = {
extra => {
dd => 20090612,
supercup => [['Europese Supercup'],['PTpor','ESval',[20040827,1,2],2, 'Monaco']]},

CL => {
qfr_3 => [['Voorronde'], ['RSrsb','NLpsv',[20040811,3,2],[20040825,5,0],2] ],
groupC => [ ['', [1, 3, 'Eerste ronde, Poule C', 2]],
['NLajx','ITjuv',[20040915,0,1]],
['ILmta','DEbmn',[20040915,0,1]],
['DEbmn','NLajx',[20040928,4,0]],
['ITjuv','ILmta',[20040928,1,0]],
['NLajx','ILmta',[20041019,3,0]],
['ITjuv','DEbmn',[20041019,1,0]],
['ILmta','NLajx',[20041103,2,1]],
['DEbmn','ITjuv',[20041103,0,1]],
['ITjuv','NLajx',[20041123,1,0]],
['DEbmn','ILmta',[20041123,5,1]],
['NLajx','DEbmn',[20041208,2,2]],
['ILmta','ITjuv',[20041208,1,1]] ],
groupE => [ ['', [1, 3, 'Eerste ronde, Poule E', 2]],
['G1ars','NLpsv',[20040914,1,0]],
['GRpnt','NOros',[20040914,2,1]],
['NLpsv','GRpnt',[20040929,1,0]],
['NOros','G1ars',[20040929,1,1]],
['NOros','NLpsv',[20041020,1,2]],
['GRpnt','G1ars',[20041020,2,2]],
['NLpsv','NOros',[20041102,1,0]],
['G1ars','GRpnt',[20041102,1,1]],
['NLpsv','G1ars',[20041124,1,1]],
['NOros','GRpnt',[20041124,2,2]],
['GRpnt','NLpsv',[20041207,4,1]],
['G1ars','NOros',[20041207,5,1]] ],
round_of_16 => [ ['8-ste finale Champions League','k-o'],
['ESrmd','ITjuv',[20050222,1,0],[20050309,2,0],4],
['G1lvp','DElvk',[20050222,3,1],[20050309,1,3],1],
['NLpsv','FRmnc',[20050222,1,0],[20050309,0,2],1],
['DEbmn','G1ars',[20050222,3,1],[20050309,1,0],1],
['ESbcl','G1cls',[20050223,2,1],[20050308,4,2],2],
['G1mnu','ITmln',[20050223,0,1],[20050308,1,0],2],
['DEwbr','FRoly',[20050223,0,3],[20050308,7,2],2],
['PTpor','ITiml',[20050223,1,1],[20050315,3,1],2] ],
quarterfinal => [ [],
['G1cls','DEbmn',[20050406,4,2],[20050412,3,2],1],
['G1lvp','ITjuv',[20050405,2,1],[20050413,0,0],1],
['ITmln','ITiml',[20050406,2,0],[20050412,0,3],1],
# return gestaakt wegens vuurwerp bij 0-1
['FRoly','NLpsv',[20050405,1,1],[20050413,1,1],6] ],
semifinal => [ [],
['G1cls','G1lvp',[20050427,0,0],[20050503,1,0],2], # doelpunt Liverpool amper over de lijn
['ITmln','NLpsv',[20050426,2,0],[20050504,3,1],1] ],
final => [ [''],
['G1lvp','ITmln',[20050525,3,3,{opm => 'ruststand finale: 0-3 voor AC Milan'}],5,'Istanbul'] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup','k-o'],
['NLutr','SEdjg',[20040916,4,0],[20040930,3,0],1],
['NOodg','NLfyn',[20040916,0,1],[20040930,4,1],2],
['GRpks','NLaz1',[20040916,2,3],[20040930,2,1],2],
['NLhrv','ILmpt',[20040930,5,0],1] ],
groupA => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule A', 5]],
['NLfyn','G2hrt',[20041021,3,0]],
['DEs04','CHbsl',[20041021,1,1]],
['HUfrv','NLfyn',[20041104,1,1]],
['G2hrt','DEs04',[20041104,0,1]],
['CHbsl','G2hrt',[20041125,1,2]],
['DEs04','HUfrv',[20041125,2,0]],
['NLfyn','DEs04',[20041201,2,1]],
['HUfrv','CHbsl',[20041201,1,2]],
['G2hrt','HUfrv',[20041216,0,1]],
['CHbsl','NLfyn',[20041216,1,0]] ],
groupC => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule C', 5]],
['ESrzg','NLutr',[20041021,2,0]],
['UAdjn','BEcbr',[20041021,3,2]],
['NLutr','UAdjn',[20041104,1,2]],
['ATawn','ESrzg',[20041104,1,0]],
['BEcbr','NLutr',[20041125,1,0]],
['UAdjn','ATawn',[20041125,1,0]],
['ATawn','BEcbr',[20041201,1,1]],
['ESrzg','UAdjn',[20041201,2,1]],
['BEcbr','ESrzg',[20041216,1,1]],
['NLutr','ATawn',[20041216,1,2]] ],
groupF => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule F', 5]],
['PLawr','G2glr',[20041021,0,5]],
['FRaux','ATgrz',[20041021,0,0]],
['NLaz1','FRaux',[20041104,2,0]],
['ATgrz','PLawr',[20041104,3,1]],
['PLawr','NLaz1',[20041125,1,3]],
['G2glr','ATgrz',[20041125,3,0]],
['NLaz1','G2glr',[20041202,1,0]],
['FRaux','PLawr',[20041202,5,1]],
['G2glr','FRaux',[20041215,0,2]],
['ATgrz','NLaz1',[20041215,2,0]] ],
groupG => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule G', 5]],
['PTbnf','NLhrv',[20041021,4,2]],
['BEbev','DEvfs',[20041021,1,5]],
['DEvfs','PTbnf',[20041104,3,0]],
['HRdzg','BEbev',[20041104,6,1]],
['NLhrv','DEvfs',[20041125,1,0]],
['PTbnf','HRdzg',[20041125,2,0]],
['HRdzg','NLhrv',[20041202,2,2]],
['BEbev','PTbnf',[20041202,0,3]],
['DEvfs','HRdzg',[20041215,2,1]],
['NLhrv','BEbev',[20041215,1,0]] ],
round3 => [ ['Derde ronde UEFA-cup','k-o'],
['PTspp','NLfyn',[20050216,2,1],[20050224,1,2],1],
['NLajx','FRaux',[20050216,1,0],[20050224,3,1],2],
['DEaaa','NLaz1',[20050217,0,0],[20050224,2,1],2],
['NLhrv','G1nwc',[20050217,1,2],[20050224,2,1],2] ],
round_of_16 => [ ['Vierde ronde UEFA-cup','k-o'],
['UAsdk','NLaz1',[20050310,1,3],[20050316,2,1],2] ],
quarterfinal => [ [''],
['ATawn','ITprm',[20050407,1,1],[20050414,0,0],2],
['RUcmk','FRaux',[20050407,4,0],[20050414,2,0],1],
['G1nwc','PTspp',[20050407,1,0],[20050414,4,1],2],
['ESvlr','NLaz1',[20050407,1,2],[20050414,1,1],2] ],
semifinal => [ [],
['ITprm','RUcmk',[20050428,0,0],[20050505,3,0],2],
['PTspp','NLaz1',[20050428,2,1],[20050505,3,2],3] ],
final => [ [''],
['RUcmk','PTspp',[20050518,3,1],1,'Lissabon'] ]}};
#
$u_ec->{'2005-2006'} = {
extra => {
dd => 20090612,
supercup => [['Europese Supercup'],['G1lvp','RUcmk',[20050826,3,1],1]]},

CL => {
qfr_3 => [['Voorronde'],['DKbrn','NLajx',[20050810,2,2],[20050824,3,1],2]],
groupB => [ ['', [1, 3, 'Eerste ronde, Poule B', 2]],
['CZspr','NLajx',[20050914,1,1]],
['G1ars','CHthn',[20050914,2,1]],
['NLajx','G1ars',[20050927,1,2]],
['CHthn','CZspr',[20050927,1,0]],
['NLajx','CHthn',[20051018,2,0]],
['CZspr','G1ars',[20051018,0,2]],
['CHthn','NLajx',[20051102,2,4]],
['G1ars','CZspr',[20051102,3,0]],
['NLajx','CZspr',[20051122,2,1]],
['CHthn','G1ars',[20051122,0,1]],
['G1ars','NLajx',[20051207,0,0]],
['CZspr','CHthn',[20051207,0,0]] ],
groupE => [ ['', [1, 3, 'Eerste ronde, Poule E', 2]],
['NLpsv','DEs04',[20050913,1,0]],
['ITmln','TRfen',[20050913,3,1]],
['TRfen','NLpsv',[20050928,3,0]],
['DEs04','ITmln',[20050928,2,2]],
['ITmln','NLpsv',[20051019,0,0]],
['TRfen','DEs04',[20051019,3,3]],
['NLpsv','ITmln',[20051101,1,0]],
['DEs04','TRfen',[20051101,2,0]],
['DEs04','NLpsv',[20051123,3,0]],
['TRfen','ITmln',[20051123,0,4]],
['NLpsv','TRfen',[20051206,2,0]],
['ITmln','DEs04',[20051206,3,2]] ],
round_of_16 => [ ['8ste finale C-L', 'k-o'],
['NLpsv','FRoly',[20060221,0,1],[20060308,4,0],2],
['DEbmn','ITmln',[20060221,1,1],[20060308,4,1],2],
['PTbnf','G1lvp',[20060221,1,0],[20060308,0,2],1],
['ESrmd','G1ars',[20060221,0,1],[20060308,0,0],2],
['NLajx','ITiml',[20060222,2,2],[20060314,1,0],2],
['G1cls','ESbcl',[20060222,1,2],[20060307,1,1],2],
['DEwbr','ITjuv',[20060222,3,2],[20060307,2,1],2],
['G2glr','ESvlr',[20060222,2,2],[20060307,1,1],2] ],
quarterfinal => [ [],
['G1ars','ITjuv',[20060328,2,0],[20060405,0,0],1],
['ITiml','ESvlr',[20060329,2,1],[20060404,1,0],2],
['FRoly','ITmln',[20060329,0,0],[20060404,3,1],2],
['PTbnf','ESbcl',[20060328,0,0],[20060405,2,0],2] ],
semifinal => [ [],
['G1ars','ESvlr',[20060419,1,0],[20060425,0,0],1],
['ITmln','ESbcl',[20060418,0,1],[20060426,0,0],2] ],
final => [ [''], ['ESbcl','G1ars',[20060517,2,1, {
 a => 'ESbcl', b => 'G1ars',
 chronological => [
[37,0,1, 'Campbell'],
[76,1,1, "Eto'o"],
[80,2,1, 'Belletti'] ],
 arbiter => 'Hauge (NO)',
 publiek => 79500,
 stadion => 'Parijs St. Denis (Stade de France)',
 rood_b  => ['Lehmann', 18],
 trainer_a => 'Frank Rijkaard', # assistent: Henk ten Cate
 opstelling_a => [
'V&iacute;ctor Vald&eacute;s', ['Oleguer', 'Belletti', 71],
'M&aacute;rquez', 'Puyol', 'v. Bronckhorst', 'Deco', ['Edm&iacute;lson', 'Iniesta',46],
['v. Bommel', 'Larsson', 61], 'Giuly', "Eto'o", 'Ronaldinho'],
 trainer_b => 'Wenger',
 opstelling_b => [
'Lehmann', 'Ebou&eacute;', 'K. Tour&eacute;', 'Campbell', 'A. Cole',
['Pires', 'Almunia', 20], 'Silva', 'Ljungberg', ['Fabregas', 'Flamini', 75],
['Hleb', 'Reyes', 85], 'Henry'],
}],1] ]},

UEFAcup => {
round1 => [ ['Eerste ronde UEFA-cup', 'k-o'],
['NLfyn','ROrpb',[20050915,1,1],[20050929,1,0],2],
['CZbos','NLhrv',[20050915,2,0],[20050929,5,0],2],
['RUkrs','NLaz1',[20050915,5,3],[20050929,3,1],2],
['FRmnc','NLwl2',[20050915,2,0],[20050929,1,3],1] ],
groupD => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule D', 5]],
['UAdjn','NLaz1',[20051020,1,2]],
['CHgrs','G1mdd',[20051020,0,1]],
['BGllv','CHgrs',[20051103,2,1]],
['G1mdd','UAdjn',[20051103,3,0]],
['UAdjn','BGllv',[20051124,0,2]],
['NLaz1','G1mdd',[20051124,0,0]],
['CHgrs','UAdjn',[20051130,2,3]],
['BGllv','NLaz1',[20051130,0,2]],
['G1mdd','BGllv',[20051215,2,0]],
['NLaz1','CHgrs',[20051215,1,0]] ],
groupF => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule F', 5]],
['RUcmk','FRomr',[20051020,1,2]],
['ROdnb','NLhrv',[20051020,0,0]],
['BGlsf','ROdnb',[20051103,1,0]],
['NLhrv','RUcmk',[20051103,0,0]],
['RUcmk','BGlsf',[20051124,2,1]],
['FRomr','NLhrv',[20051124,1,0]],
['ROdnb','RUcmk',[20051201,1,0]],
['BGlsf','FRomr',[20051201,1,0]],
['NLhrv','BGlsf',[20051214,2,1]],
['FRomr','ROdnb',[20051214,2,1]] ],
round3 => [ ['3e ronde UEFA-cup', 'k-o'],
['NLhrv','ROstb',[20060215,1,3],[20060223,0,1],2],
['ESbsv','NLaz1',[20060215,2,0],[20060223,2,1],3] ],
quarterfinal => [ [''],
['BGlsf','DEs04',[20060330,1,3],[20060406,1,1],2],
['ESsvl','RUzsp',[20060330,4,1],[20060406,1,1],1],
['ROrpb','ROstb',[20060330,1,1],[20060406,0,0],2],
['CHbsl','G1mdd',[20060330,2,0],[20060406,4,1],2] ],
semifinal => [ [],
['DEs04','ESsvl',[20060420,0,0],[20060427,1,0],4],
['ROstb','G1mdd',[20060420,1,0],[20060427,4,2],2] ],
final => [ [''],
['ESsvl','G1mdd',[20060510,4,0],1,'Eindhoven'] ]}};
#
$u_ec->{'2006-2007'} = {
extra => {
dd => 20090612,
supercup => [['Europese Supercup'], ['ESbcl','ESsvl',[20060825,0,3],2]]},

CL => {
qfr_3 => [['Voorronde C-L'], ['DKfkp','NLajx',[20060809,1,2],[20060823,0,2],1]],
groupC => [ ['', [1, 3, 'Eerste ronde, Poule C', 2]],
['TRglt','FRgbr',[20060912,0,0]],
['NLpsv','G1lvp',[20060912,0,0]],
['G1lvp','TRglt',[20060927,3,2]],
['FRgbr','NLpsv',[20060927,0,1]],
['FRgbr','G1lvp',[20061018,0,1]],
['TRglt','NLpsv',[20061018,1,2]],
['G1lvp','FRgbr',[20061031,3,0]],
['NLpsv','TRglt',[20061031,2,0]],
['FRgbr','TRglt',[20061122,3,1]],
['G1lvp','NLpsv',[20061122,2,0]],
['TRglt','G1lvp',[20061205,3,2]],
['NLpsv','FRgbr',[20061205,1,3]] ],
round_of_16 => [['8-ste finale CL', 'k-o'],
['NLpsv','G1ars',[20070220,1,0],[20070307,1,1],1],
['FRlll','G1mnu',[20070220,1,1],[20070307,1,0],2],
['ESrmd','DEbmn',[20070220,3,2],[20070307,2,1],2],
['G2clt','ITmln',[20070220,0,0],[20070307,1,0],4],
['PTpor','G1cls',[20070221,1,1],[20070306,2,1],2],
['ITasr','FRoly',[20070221,0,0],[20070306,0,2],1],
['ESbcl','G1lvp',[20070221,1,2],[20070306,0,1],2],
['ITiml','ESval',[20070221,2,2],[20070306,0,0],2] ],
quarterfinal => [ ['kwartfinale CL'],
['G1cls','ESval',[20070404,1,1],[20070410,1,2],1],
['NLpsv','G1lvp',[20070403,0,3],[20070411,1,0],2],
['ITasr','G1mnu',[20070404,2,1],[20070410,7,1],2],
['ITmln','DEbmn',[20070403,2,2],[20070411,0,2],1] ],
semifinal => [ ['halve-finales CL'],
['G1cls','G1lvp',[20070425,1,0],[20070501,1,0,{wnshort => [4,1]}],6],
['G1mnu','ITmln',[20070424,3,2],[20070502,3,0],2] ],
final => [ ['F I N A L E'], ['ITmln','G1lvp',[20070523,2,1],1,'Athene'] ]},

UEFAcup => {
qfr => [['Voorronde UEFA-cup'],
['NLtwn','EElvd',[20060810,1,1],[20060824,1,0],2]],
round1 => [['1e ronde UEFA-cup'],
['NLaz1','TRksr',[20060914,3,2],[20060928,1,1],1],
['BGlks','NLfyn',[20060914,2,2],[20060928,0,0],2],
['PTvts','NLhrv',[20060914,0,3],[20060928,0,0],1],
['RSprt','NLgrn',[20060914,4,2],[20060928,1,0],1],
['NOiks','NLajx',[20060914,2,5],[20060928,4,0],2] ],
groupC => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule C', 5]],
['NLaz1','PTbrg',[20061019,3,0]],
['CZsll','ESsvl',[20061019,0,0]],
['CHgrs','NLaz1',[20061102,2,5]],
['PTbrg','CZsll',[20061102,4,0]],
['ESsvl','PTbrg',[20061123,2,0]],
['CZsll','CHgrs',[20061123,4,1]],
['NLaz1','CZsll',[20061129,2,2]],
['CHgrs','ESsvl',[20061129,0,4]],
['ESsvl','NLaz1',[20061214,1,2]],
['PTbrg','CHgrs',[20061214,2,0]] ],
groupD => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule D', 5]],
['DKodn','ITprm',[20061019,1,2]],
['ESoss','NLhrv',[20061019,0,0]],
['NLhrv','DKodn',[20061102,0,2]],
['FRrcl','ESoss',[20061102,3,1]],
['ITprm','NLhrv',[20061123,2,1]],
['DKodn','FRrcl',[20061123,1,1]],
['ESoss','DKodn',[20061129,3,1]],
['FRrcl','ITprm',[20061129,1,2]],
['NLhrv','FRrcl',[20061214,1,0]],
['ITprm','ESoss',[20061214,0,3]] ],
groupE => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule E', 5]],
['PLwkr','G1bbr',[20061019,1,2]],
['CHbsl','NLfyn',[20061019,1,1]],
['G1bbr','CHbsl',[20061102,3,0]],
['FRnnc','PLwkr',[20061102,2,1]],
['NLfyn','G1bbr',[20061123,0,0]],
['CHbsl','FRnnc',[20061123,2,2]],
['FRnnc','NLfyn',[20061130,3,0]],
['PLwkr','CHbsl',[20061130,3,1]],
['NLfyn','PLwkr',[20061213,3,1]],
['G1bbr','FRnnc',[20061213,1,0]] ],
groupF => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule F', 5]],
['ATawn','BEzwr',[20061019,1,4]],
['CZspr','ESesp',[20061019,0,2]],
['NLajx','ATawn',[20061102,3,0]],
['BEzwr','CZspr',[20061102,3,1]],
['CZspr','NLajx',[20061123,0,0]],
['ESesp','BEzwr',[20061123,6,2]],
['NLajx','ESesp',[20061130,0,2]],
['ATawn','CZspr',[20061130,0,1]],
['BEzwr','NLajx',[20061213,0,3]],
['ESesp','ATawn',[20061213,1,0]] ],
round3 => [ ['Derde ronde UEFA-cup', 'k-o'],
['NLfyn','G1ttt',[20070214,-1,-1,{opm =>
 'gaat definitief niet door vanwege straf UEFA n.a.v. supportersrellen in Nancy.'}],-1],
['TRfen','NLaz1',[20070214,3,3],[20070222,2,2],2],
['DEwbr','NLajx',[20070214,3,0],[20070222,3,1],1] ],
round_of_16 => [ ['8-ste finale UEFA-cup', 'k-o'],
['G1nwc','NLaz1',[20070308,4,2],[20070315,2,0],2] ],
quarterfinal => [ ['Kwartfinale UEFA-cup', 'k-o'],
['ESesp','PTbnf',[20070405,3,2],[20070412,0,0],1],
['NLaz1','DEwbr',[20070405,0,0],[20070412,4,1],2],
['DElvk','ESoss',[20070405,0,3],[20070412,1,0],2],
['ESsvl','G1ttt',[20070405,2,1],[20070412,2,2],1] ],
semifinal => [ ['Halve finales UEFA-cup', 'k-o'],
['ESesp','DEwbr',[20070426,3,0],[20070503,1,2],1],
['ESoss','ESsvl',[20070426,1,0],[20070503,2,0],2] ],
final => [ ['F I N A L E UEFA-cup'],
['ESsvl','ESesp',[20070516,2,2,{wnshort => [3,1]}],5,'Glasgow (Hampden Park)'] ]}};
#
$u_ec->{'2007-2008'} = {
extra => {
dd => 20090612,
summary => << 'EOF',
In de voorronde van de Champions League laat Ajax zich voor het tweede
opeenvolgende jaar verrassen door een Europese middelmoter.
Na vorig jaar FC Kopenhagen is nu Slavia Praag te sterk.
Als excuus kan Ajax aanvoeren dat het middenveld gehavend is door
de late verkoop van Wesley Sneijder aan Real Madrid
en de beenbreuk van Edgar Davids.
<p>
In de finale beleeft Edwin van der Sar zijn &quot;Van Breukelen-moment&quot;:
Hij stopt de beslissende strafschop, en wint opnieuw de Champions League
(eerder, in 1995, met Ajax).
<p>
Waar de heenwedstrijden in de eerste ronde van de UEFA-cup
uitzicht gaf op veel Nederlandse clubs in de groepsfase,
gaat het in de returns mis. Uiteindelijk gaat alleen AZ door.
Vooral Ajax stelt weer teleur.
<br>
PSV bereikt netjes de laatste acht.
<p>
De finale wordt gewonnen door Zenit Sint-Petersburg, onder leiding van coach Dick Advocaat.
EOF

supercup => [['Europese Supercup'],
['ITmln','ESsvl',[20070831,3,1],1]]},

CL => {
qfr_3 => [['Voorronde C-L'],
['NLajx','CZslp',[20070815,0,1],[20070829,2,1],2]],
groupG => [ ['', [1, 3, 'Eerste ronde, Poule G', 2]],
['NLpsv','RUcmk',[20070919,2,1]],
['TRfen','ITiml',[20070919,1,0]],
['ITiml','NLpsv',[20071002,2,0]],
['RUcmk','TRfen',[20071002,2,2]],
['NLpsv','TRfen',[20071023,0,0]],
['RUcmk','ITiml',[20071023,1,2]],
['TRfen','NLpsv',[20071107,2,0]],
['ITiml','RUcmk',[20071107,4,2]],
['RUcmk','NLpsv',[20071127,0,1]],
['ITiml','TRfen',[20071127,3,0]],
['NLpsv','ITiml',[20071212,0,1]],
['TRfen','RUcmk',[20071212,3,1]] ],
round_of_16 => [['8-ste finale CL', 'k-o'],
['G1lvp','ITiml',[20080219,2,0],[20080311,0,1],1],
['DEs04','PTpor',[20080219,1,0],[20080305,1,0],5],
['ITasr','ESrmd',[20080219,2,1],[20080305,1,2],1],
['GRolp','G1cls',[20080219,0,0],[20080305,3,0],2],
['G2clt','ESbcl',[20080220,2,3],[20080304,1,0],2],
['FRoly','G1mnu',[20080220,1,1],[20080304,1,0],2],
['G1ars','ITmln',[20080220,0,0],[20080304,0,2],1],
['TRfen','ESsvl',[20080220,3,2],[20080304,3,2],5] ],
quarterfinal => [['Kwartfinales C-L'],
['G1ars','G1lvp',[20080402,1,1],[20080408,4,2],2],
['TRfen','G1cls',[20080402,2,1],[20080408,2,0],2],
['ITasr','G1mnu',[20080401,0,2],[20080409,1,0],2],
['DEs04','ESbcl',[20080401,0,1],[20080409,1,0],2] ],
semifinal => [['Halve finales C-L'],
['G1lvp','G1cls',[20080422,1,1],[20080430,3,2],4],
['ESbcl','G1mnu',[20080423,0,0],[20080429,1,0],2] ],
final => [['Finale C-L'],
['G1mnu','G1cls',[20080521,1,1, {stadion => 'Moskou' }], 5] ]},

UEFAcup => {
round1 => [['1e ronde UEFA-cup'],
['HRdzg','NLajx',[20070920,0,1],[20071004,2,3],3],
['PTpcs','NLaz1',[20070920,0,1],[20071004,0,0],2],
['ESgtf','NLtwn',[20070920,1,0],[20071004,3,2],3],
['NLgrn','ITfrt',[20070920,1,1],[20071004,1,1],6],
['NLhrv','SEhls',[20070920,5,3],[20071004,5,1],2] ],
groupA => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule A', 5]],
['RUzsp','NLaz1',[20071025,1,1]],
['G1evr','GRlar',[20071025,3,1]],
['GRlar','RUzsp',[20071108,2,3]],
['DEnrn','G1evr',[20071108,0,2]],
['NLaz1','GRlar',[20071129,1,0]],
['RUzsp','DEnrn',[20071129,2,2]],
['DEnrn','NLaz1',[20071205,2,1]],
['G1evr','RUzsp',[20071205,1,0]],
['NLaz1','G1evr',[20071220,2,3]],
['GRlar','DEnrn',[20071220,1,3]] ],
round3 => [ ['Derde ronde UEFA-cup', 'k-o'],
['NLpsv','SEhls',[20080213,2,0],[20080221,1,2],1] ],
round_of_16 => [ ['Achtste finale UEFA-cup', 'k-o'],
['G1ttt','NLpsv',[20080306,0,1],[20080312,0,1],6] ],
quarterfinal => [['Kwartfinales UEFA-cup'],
['ITfrt','NLpsv',[20080403,1,1],[20080410,0,2],2],
['G2glr','PTspl',[20080403,0,0],[20080410,0,2],1],
['DElvk','RUzsp',[20080403,1,4],[20080410,0,1],2],
['DEbmn','ESgtf',[20080403,1,1],[20080410,3,3],1] ],
semifinal => [['Halve finales UEFA-cup'],
['G2glr','ITfrt',[20080424,0,0],[20080501,0,0],5],
['DEbmn','RUzsp',[20080424,1,1],[20080501,4,0],2] ],
final => [ [''],
['RUzsp','G2glr',[20080514,2,0,{stadion=>'Manchester'}],1] ]}};
#
$u_ec->{'2008-2009'} = {
extra => {
dd => 20090614,
summary => << 'EOF',
De Nederlandse inbreng in de Champions League was dit seizoen weinig succesvol.
<br>In de voorronde was de loting voor FC Twente heel zwaar: Arsenal.
<br>In de groepsfase kende PSV een opleving in de thuiswedstrijd tegen Olympique Marseille,
en leek de derde plek voor het grijpen, maar in Marseille verloor PSV kansloos.
<p>
De finale van de Champions League wordt gewonnen door Barcelona.
Manchester United is licht favoriet, maar na een vroege 1-0 kantelt de wedstrijd.
<p>
Drie van de vier halve finales in beide toernooien waren binnenlandse onderonsjes:
Manchester&nbsp;Utd-Arsenal, Din.&nbsp;Kiev-Sjakthor Donetsk en Werder&nbsp;Bremen-Hamburg.
<p>
Meer successen waren er in de UEFAcup: alle 5 Nederlandse clubs plaatsten zich
voor de groepsfase.
<br> Na de winterstop nam het aantal Nederlandse clubs helaas snel af.
<p>
De finale van de laatste UEFA-cup (volgend jaar opgevolgd door de Europa League)
wordt gewonnen door Sjakthor Donetsk. Het is de eerste europacup voor een club uit het zelfstandige Oekra&iuml;ne.
EOF
supercup => [['Europese Supercup'],
['G1mnu','RUzsp',[20080829,1,2],2]]},

CL => {
qfr_3 => [ ['3e voorronde C-L'], ['NLtwn','G1ars',[20080813,0,2],[20080827,4,0],2]],
groupD => [ ['', [1, 3, 'Eerste ronde, Poule D', 2]],
['NLpsv','ESamd',[20080916,0,3]],
['FRomr','G1lvp',[20080916,1,2]],
['G1lvp','NLpsv',[20081001,3,1]],
['ESamd','FRomr',[20081001,2,1]],
['NLpsv','FRomr',[20081022,2,0]],
['ESamd','G1lvp',[20081022,1,1]],
['FRomr','NLpsv',[20081104,3,0]],
['G1lvp','ESamd',[20081104,1,1]],
['ESamd','NLpsv',[20081126,2,1]],
['G1lvp','FRomr',[20081126,1,0]],
['NLpsv','G1lvp',[20081209,1,3]],
['FRomr','ESamd',[20081209,0,0]] ],
round_of_16 => [['8-ste finale C-L', 'k-o'],
['ITiml','G1mnu',[20090224,0,0],[20090311,2,0],2],
['G1ars','ITasr',[20090224,1,0],[20090311,1,0],6],
['FRoly','ESbcl',[20090224,1,1],[20090311,5,2],2],
['ESamd','PTpor',[20090224,2,2],[20090311,0,0],2],
['ESrmd','G1lvp',[20090225,0,1],[20090310,4,0],2],
['G1cls','ITjuv',[20090225,1,0],[20090310,2,2],1],
['PTspp','DEbmn',[20090225,0,5],[20090310,7,1],2],
['ESvlr','GRpnt',[20090225,1,1],[20090310,1,2],1] ],
quarterfinal => [['Kwartfinales C-L'],
['G1mnu','PTpor',[20090407,2,2],[20090415,0,1],1],
['ESvlr','G1ars',[20090407,1,1],[20090415,3,0],2],
['ESbcl','DEbmn',[20090408,4,0],[20090414,1,1],1],
['G1lvp','G1cls',[20090408,1,3],[20090414,4,4],2] ],
semifinal => [['Halve finales C-L'],
['G1mnu','G1ars',[20090429,1,0],[20090505,1,3],1],
['ESbcl','G1cls',[20090428,0,0],[20090506,1,1],1] ],
final => [ [''],
['ESbcl','G1mnu',[20090527,2,0,{stadion=>'Rome'}],1] ]},

UEFAcup => {
round1 => [['1e ronde UEFA-cup'],
['RSbrc','NLajx',[20080918,1,4],[20081002,2,0],2],
['NLfyn','SEklm',[20080918,0,1],[20081002,1,2],1],
['NLnec','ROdnb',[20080918,1,0],[20081002,0,0],1],
['FRrnn','NLtwn',[20080918,2,1],[20081002,1,0],2],
['PTvts','NLhrv',[20080918,1,1],[20081002,5,2],2] ],
groupA => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule A', 5]],
['NLtwn','ESrst',[20081023,1,0]],
['DEs04','FRpsg',[20081023,3,1]],
['G1mnc','NLtwn',[20081106,3,2]],
['ESrst','DEs04',[20081106,1,1]],
['FRpsg','ESrst',[20081127,2,2]],
['DEs04','G1mnc',[20081127,0,2]],
['NLtwn','DEs04',[20081203,2,1]],
['G1mnc','FRpsg',[20081203,0,0]],
['FRpsg','NLtwn',[20081218,4,0]],
['ESrst','G1mnc',[20081218,3,1]] ],
groupD => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule D', 5]],
['HRdzg','NLnec',[20081023,3,2]],
['ITudn','G1ttt',[20081023,2,0]],
['G1ttt','HRdzg',[20081106,4,0]],
['RUsmk','ITudn',[20081106,1,2]],
['NLnec','G1ttt',[20081127,0,1]],
['HRdzg','RUsmk',[20081127,0,1]],
['RUsmk','NLnec',[20081203,1,2]],
['ITudn','HRdzg',[20081203,2,1]],
['NLnec','ITudn',[20081218,2,0]],
['G1ttt','RUsmk',[20081218,2,2]] ],
groupE => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule E', 5]],
['NLhrv','ITmln',[20081023,1,3]],
['PTbrg','G1prt',[20081023,3,0]],
['DEvwl','NLhrv',[20081106,5,1]],
['ITmln','PTbrg',[20081106,1,0]],
['G1prt','ITmln',[20081127,2,2]],
['PTbrg','DEvwl',[20081127,2,3]],
['NLhrv','PTbrg',[20081203,1,2]],
['DEvwl','G1prt',[20081203,3,2]],
['G1prt','NLhrv',[20081217,3,0]],
['ITmln','DEvwl',[20081217,2,2]] ],
groupF => [ ['', [1, 1, 'Groepsfase UEFA-cup, Poule F', 5]],
['G1avl','NLajx',[20081023,2,1]],
['SKzln','DEhsv',[20081023,1,2]],
['NLajx','SKzln',[20081106,1,0]],
['CZslp','G1avl',[20081106,0,1]],
['DEhsv','NLajx',[20081127,0,1]],
['SKzln','CZslp',[20081127,0,0]],
['CZslp','DEhsv',[20081204,0,2]],
['G1avl','SKzln',[20081204,1,2]],
['NLajx','CZslp',[20081217,2,2]],
['DEhsv','G1avl',[20081217,3,1]] ],
groupH => [ ['', [1, 2, 'Groepsfase UEFA-cup, Poule H', 5]],
['FRnnc','NLfyn',[20081023,3,0]],
['RUcmk','ESdlc',[20081023,3,0]],
['NLfyn','RUcmk',[20081106,1,3]],
['PLlpz','FRnnc',[20081106,2,2]],
['ESdlc','NLfyn',[20081127,3,0]],
['RUcmk','PLlpz',[20081127,2,1]],
['PLlpz','ESdlc',[20081204,1,1]],
['FRnnc','RUcmk',[20081204,3,4]],
['NLfyn','PLlpz',[20081217,0,1]],
['ESdlc','FRnnc',[20081217,1,0]] ],
round3 => [ ['Derde ronde UEFA-cup', 'k-o'],
['NLnec','DEhsv',[20090218,0,3],[20090226,1,0],2],
['ITfrt','NLajx',[20090219,0,1],[20090226,1,1],2],
['FRomr','NLtwn',[20090219,0,1],[20090226,0,1,{wnshort => [6,7]}],5] ],
round_of_16 => [ ['Achtste finale UEFA-cup', 'k-o'],
['FRomr','NLajx',[20090312,2,1],[20090318,2,2],3] ],
quarterfinal => [['Kwartfinales UEFA-cup'],
['DEwbr','ITudn',[20090409,3,1],[20090416,3,3],1],
['DEhsv','G1mnc',[20090409,3,1],[20090416,2,1],1],
['FRpsg','UAdkv',[20090409,0,0],[20090416,3,0],2],
['UAsdk','FRomr',[20090409,2,0],[20090416,1,2],1] ],
semifinal => [['Halve finales UEFA-cup'],
['DEwbr','DEhsv',[20090430,0,1],[20090507,2,3],1],
['UAdkv','UAsdk',[20090430,1,1],[20090507,2,1],2] ],
final => [ [''], ['UAsdk','DEwbr',[20090520,2,1,{stadion=>'Istanbul'}],3] ]}};

$u_ec->{'2009-2010'} = {
extra => {
dd => 20100522,
supercup => [['Europese Supercup'],['ESbcl','UAsdk',[20090828,1,0],5]],
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['PTspp','NLtwn',[20090729,0,0],[20090804,1,1],1]],
groupH => [ ['', [1, 3, 'Eerste ronde, Poule H', 2]],
['GRolp','NLaz1',[20090916,1,0]],
['BEslk','G1ars',[20090916,2,3]],
['NLaz1','BEslk',[20090929,1,1]],
['G1ars','GRolp',[20090929,2,0]],
['NLaz1','G1ars',[20091020,1,1]],
['GRolp','BEslk',[20091020,2,1]],
['BEslk','GRolp',[20091104,2,0]],
['G1ars','NLaz1',[20091104,4,1]],
['NLaz1','GRolp',[20091124,0,0]],
['G1ars','BEslk',[20091124,2,0]],
['BEslk','NLaz1',[20091209,1,1,
{opm => 'AZ verlengt abonnement op late tegentreffers'}]],
['GRolp','G1ars',[20091209,1,0]] ],
round_of_16 => [['8-ste finale C-L', 'k-o'],
['FRoly','ESrmd',[20100216,1,0],[20100310,1,1],1],
['ITmln','G1mnu',[20100216,2,3],[20100310,4,0],2],
['DEbmn','ITfrt',[20100217,2,1],[20100309,3,2],1],
['PTpor','G1ars',[20100217,2,1],[20100309,5,0],2],
['GRolp','FRgbr',[20100223,0,1],[20100317,2,1],2],
['DEvfs','ESbcl',[20100223,1,1],[20100317,4,0],2],
['RUcmk','ESsvl',[20100224,1,1],[20100316,1,2],1],
['ITiml','G1cls',[20100224,2,1],[20100316,0,1],1] ],
quarterfinal => [[''],
['DEbmn','G1mnu',[20100330,2,1],[20100407,3,2],1],
['FRoly','FRgbr',[20100330,3,1],[20100407,1,0],1],
['ITiml','RUcmk',[20100331,1,0],[20100406,0,1],1],
['G1ars','ESbcl',[20100331,2,2],[20100406,4,1],2] ],
semifinal => [[''],
['DEbmn','FRoly',[20100421,1,0],[20100427,0,3],1],
['ITiml','ESbcl',[20100420,3,1],[20100428,1,0],1] ],
final => [[''],
['ITiml','DEbmn',[20100522,2,0,{stadion=>'Santiago Bernabeu, Madrid',
opm => 'Beide (mooie) goals in de finale van de Argentijn Diego Milito'}],1] ]
},
EuropaL => {
qfr => [['2e voorronde Europa League'],
['NLnac','AMkpn',[20090716,6,0],[20090723,0,2],1]],
qfr_3 => [ ['3e voorronde'],
['NLpsv','BGtmr',[20090730,1,0],[20090806,0,1],1],
['PLplw','NLnac',[20090730,0,1],[20090806,3,1],2]],
playoffs => [ ['Play-offs (4e voorronde)'],
['NLtwn','AZkrb',[20090820,3,1],[20090827,0,0],1],
['NLajx','SKsbr',[20090820,5,0, {opm =>
'4x Luis Suarez, waaronder echte hattrick; zijn 2e binnen 2 weken.'}],
[20090827,1,2],1],
['NLnac','ESvlr',[20090820,1,3],[20090827,6,1],2],
['ILbny','NLpsv',[20090820,0,1],[20090827,1,0],2],
['GRpks','NLhrv',[20090820,1,1],[20090827,0,0],2]],
groupA => [ ['', [1, 3, 'Eerste ronde, Poule A', 1, ]],
['NLajx','ROtms',[20090917,0,0]],
['HRdzg','BEand',[20090917,0,2]],
['BEand','NLajx',[20091001,1,1]],
['ROtms','HRdzg',[20091001,0,3]],
['ROtms','BEand',[20091022,0,0]],
['NLajx','HRdzg',[20091022,2,1]],
['BEand','ROtms',[20091105,3,1]],
['HRdzg','NLajx',[20091105,0,2]],
['ROtms','NLajx',[20091202,1,2]],
['BEand','HRdzg',[20091202,0,1]],
['NLajx','BEand',[20091217,1,3]],
['HRdzg','ROtms',[20091217,1,2]] ],
groupD => [ ['', [1, 3, 'Eerste ronde, Poule D', 1]],
['DEhbc','LVvnt',[20090917,1,1]],
['NLhrv','PTspp',[20090917,2,3]],
['PTspp','DEhbc',[20091001,1,0]],
['LVvnt','NLhrv',[20091001,0,0]],
['LVvnt','PTspp',[20091022,1,2]],
['DEhbc','NLhrv',[20091022,0,1]],
['PTspp','LVvnt',[20091105,1,1]],
['NLhrv','DEhbc',[20091105,2,3]],
['LVvnt','DEhbc',[20091203,0,1]],
['PTspp','NLhrv',[20091203,1,1]],
['DEhbc','PTspp',[20091216,1,0]],
['NLhrv','LVvnt',[20091216,5,0]] ],
groupH => [ ['', [1, 3, 'Eerste ronde, Poule H', 1]],
['ROstb','MDshf',[20090917,0,0]],
['TRfen','NLtwn',[20090917,1,2]],
['NLtwn','ROstb',[20091001,0,0]],
['MDshf','TRfen',[20091001,0,1]],
['MDshf','NLtwn',[20091022,2,0]],
['ROstb','TRfen',[20091022,0,1]],
['NLtwn','MDshf',[20091105,2,1]],
['TRfen','ROstb',[20091105,3,1]],
['MDshf','ROstb',[20091202,1,1]],
['NLtwn','TRfen',[20091202,0,1]],
['ROstb','NLtwn',[20091217,1,1]],
['TRfen','MDshf',[20091217,1,0]] ],
groupK => [ ['', [1, 3, 'Eerste ronde, Poule K', 1]],
['CZspr','NLpsv',[20090917,2,2]],
['ROcfr','DKfkp',[20090917,2,0]],
['DKfkp','CZspr',[20091001,1,0]],
['NLpsv','ROcfr',[20091001,1,0]],
['NLpsv','DKfkp',[20091022,1,0]],
['CZspr','ROcfr',[20091022,2,0]],
['DKfkp','NLpsv',[20091105,1,1]],
['ROcfr','CZspr',[20091105,2,3]],
['NLpsv','CZspr',[20091203,1,0]],
['DKfkp','ROcfr',[20091203,2,0]],
['CZspr','DKfkp',[20091216,0,3]],
['ROcfr','NLpsv',[20091216,0,2]] ],
round2 => [ ['Tweede ronde Europa League', 'k-o'],
['DEhsv','NLpsv',[20100218,1,0],[20100225,3,2],1],
['NLajx','ITjuv',[20100218,1,2],[20100225,0,0],2],
['NLtwn','DEwbr',[20100218,1,0],[20100225,4,1],2]],
quarterfinal => [[''],
['DEhsv','BEslk',[20100401,2,1],[20100408,1,3],1],
['G1flh','DEvwl',[20100401,2,1],[20100408,0,1],1],
['ESval','ESamd',[20100401,2,2],[20100408,0,0],2],
['PTbnf','G1lvp',[20100401,2,1],[20100408,4,1],2] ],
semifinal => [[''],
['DEhsv','G1flh',[20100422,0,0],[20100429,2,1],2],
['ESamd','G1lvp',[20100422,1,0],[20100429,2,1],3] ],
final => [[''],
['ESamd','G1flh',[20100512,2,1,{stadion=>'Arena Hamburg'}],3] ]
}};

$u_ec->{'2010-2011'} = {
extra => {
dd => 20110528,
summary => << 'EOF',
Ajax en Utrecht overleven knap alle voorronde wedstrijden.
Twente debuteert in de Champions League, en weet te overwinteren.
Net als PSV haalt Twente de kwartfinale van de Europa League.
<p>
De halve finales van de Europacup wordt gedomineerd door clubs
van het Iberisch schiereiland. De finale van de Europa League
is zelfs een Portugees onderonsje. De halve finale van de Champions
League is de 3e en 4e ontmoeting in korte tijd tussen
de aartsrivalen Barcelona en Real Madrid.
EOF
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['NLajx','GRpks',[20100728,1,1],[20100804,3,3],1] ],
playoffs => [ ['Play-offs (4e voorronde)'],
['UAdkv','NLajx',[20100817,1,1],[20100825,2,1],2] ],
groupA => [ ['', [1, 3, 'Eerste ronde, Poule A', 2]],
['NLtwn','ITiml',[20100914,2,2,
  {opm=>'Prachtig debuut van FC Twente in de Champions League!'}]],
['DEwbr','G1ttt',[20100914,2,2]],
['G1ttt','NLtwn',[20100929,4,1]],
['ITiml','DEwbr',[20100929,4,0]],
['NLtwn','DEwbr',[20101020,1,1]],
['ITiml','G1ttt',[20101020,4,3]],
['DEwbr','NLtwn',[20101102,0,2]],
['G1ttt','ITiml',[20101102,3,1]],
['ITiml','NLtwn',[20101124,1,0]],
['G1ttt','DEwbr',[20101124,3,0]],
['NLtwn','G1ttt',[20101207,3,3]],
['DEwbr','ITiml',[20101207,3,0]] ],
groupG => [ ['', [1, 3, 'Eerste ronde, Poule G', 2]],
['ESrmd','NLajx',[20100915,2,0]],
['ITmln','FRaux',[20100915,2,0]],
['NLajx','ITmln',[20100928,1,1]],
['FRaux','ESrmd',[20100928,0,1]],
['NLajx','FRaux',[20101019,2,1]],
['ESrmd','ITmln',[20101019,2,0]],
['FRaux','NLajx',[20101103,2,1]],
['ITmln','ESrmd',[20101103,2,2]],
['NLajx','ESrmd',[20101123,0,4]],
['FRaux','ITmln',[20101123,0,2]],
['ITmln','NLajx',[20101208,0,2,
  {opm=>'Debuut Frank de Boer als coach Ajax'}]],
['ESrmd','FRaux',[20101208,4,0]] ],
round_of_16 => [['8-ste finale C-L', 'k-o'],
['ITmln','G1ttt',[20110215,0,1],[20110309,0,0],2],
['ESval','DEs04',[20110215,1,1],[20110309,3,1],2],
['ITasr','UAsdk',[20110216,2,3],[20110308,3,0],2],
['G1ars','ESbcl',[20110216,2,1],[20110308,3,1],2],
['FRoly','ESrmd',[20110222,1,1],[20110316,3,0],2],
['DKfkp','G1cls',[20110222,0,2],[20110316,0,0],2],
['ITiml','DEbmn',[20110223,0,1],[20110315,2,3],1],
['FRomr','G1mnu',[20110223,0,0],[20110315,2,1],2]],
quarterfinal => [ ['', 'k-o'],
['ITiml','DEs04',[20110405,2,5],[20110413,2,1],2],
['G1cls','G1mnu',[20110406,0,1],[20110412,2,1],2],
['ESrmd','G1ttt',[20110405,4,0],[20110413,0,1],1],
['ESbcl','UAsdk',[20110406,5,1],[20110412,0,1],1], ],
semifinal => [ ['', 'k-o'],
['DEs04','G1mnu',[20110426,0,2],[20110504,4,1],2],
['ESrmd','ESbcl',[20110427,0,2],[20110503,1,1],2], ],
final => [ [ '', 'k-o'],
['ESbcl','G1mnu',[20110528,3,1],'Londen, Wembly',1] ]
},
EuropaL => {
qfr => [['2e voorronde Europa League'],
['NLutr','ALtrn',[20100715,4,0],[20100722,1,1],1] ],
qfr_3 => [ ['3e voorronde'],
['NLaz1','SEifk',[20100729,2,0],[20100805,1,0],1],
['NLutr','CHlzr',[20100729,1,0],[20100805,1,3],1] ],
playoffs => [ ['Play-offs (4e voorronde)'],
['RUnvs','NLpsv',[20100819,1,0],[20100826,5,0],2],
['NLfyn','BEaag',[20100819,1,0],[20100826,2,0],2],
['G2clt','NLutr',[20100819,2,0],[20100826,4,0],2],
['NLaz1','KZakt',[20100819,2,0],[20100826,2,1],1] ],
groupE => [ ['', [1, 3, 'Eerste ronde, Poule E', 1]],
['NLaz1','MDshf',[20100916,2,1]],
['UAdkv','BYbtb',[20100916,2,2]],
['BYbtb','NLaz1',[20100930,4,1]],
['MDshf','UAdkv',[20100930,2,0]],
['NLaz1','UAdkv',[20101021,1,2]],
['MDshf','BYbtb',[20101021,0,1]],
['UAdkv','NLaz1',[20101104,2,0]],
['BYbtb','MDshf',[20101104,3,1]],
['MDshf','NLaz1',[20101202,1,1]],
['BYbtb','UAdkv',[20101202,1,4]],
['NLaz1','BYbtb',[20101215,3,0]],
['UAdkv','MDshf',[20101215,0,0]] ],
groupI => [ ['', [1, 3, 'Eerste ronde, Poule I', 1]],
['NLpsv','ITsdr',[20100916,1,1]],
['HUdbr','UAmkh',[20100916,0,5]],
['UAmkh','NLpsv',[20100916,0,2]],
['ITsdr','HUdbr',[20100916,1,0]],
['HUdbr','NLpsv',[20100916,1,2]],
['UAmkh','ITsdr',[20100916,2,1]],
['ITsdr','UAmkh',[20101104,0,0]],
['NLpsv','HUdbr',[20101104,3,0]],
['UAmkh','HUdbr',[20101201,2,1]],
['ITsdr','NLpsv',[20101201,1,2]],
['HUdbr','ITsdr',[20101216,2,0]],
['NLpsv','UAmkh',[20101216,0,0]] ],
groupK => [ ['', [1, 3, 'Eerste ronde, Poule K', 1]],
['ITnpl','NLutr',[20100916,0,0]],
['G1lvp','ROstb',[20100916,4,1]],
['ROstb','ITnpl',[20100930,3,3]],
['NLutr','G1lvp',[20100930,0,0]],
['NLutr','ROstb',[20101021,1,1]],
['ITnpl','G1lvp',[20101021,0,0]],
['ROstb','NLutr',[20101104,3,1]],
['G1lvp','ITnpl',[20101104,3,1]],
['NLutr','ITnpl',[20101202,3,3]],
['ROstb','G1lvp',[20101202,1,1]],
['G1lvp','NLutr',[20101215,0,0]],
['ITnpl','ROstb',[20101215,1,0]] ],
round2 => [ ['Tweede ronde Europa League', 'k-o'],
['RUrkz','NLtwn',[20110217,0,2],[20110224,2,2],2],
['BEand','NLajx',[20110217,0,3],[20110224,2,0],2],
['FRlll','NLpsv',[20110217,2,2],[20110224,3,1],2] ],
round_of_16 => [ ['Achtste finales Europa League', 'k-o'],
['NLtwn','RUzsp',[20110310,3,0],[20110317,2,0],1],
['NLpsv','G2glr',[20110310,0,0],[20110317,0,1],1],
['NLajx','RUsmk',[20110310,0,1],[20110317,3,0],2] ],
quarterfinal => [ ['', 'k-o'],
['UAdkv','PTbrg',[20110407,1,1],[20110414,0,0],2],
['PTbnf','NLpsv',[20110407,4,1],[20110414,2,2],1],
['PTpor','RUsmk',[20110407,5,1],[20110414,2,5],1],
['ESvlr','NLtwn',[20110407,5,1],[20110414,1,3],1], ],
semifinal => [ ['', 'k-o'],
['PTbnf','PTbrg',[20110428,2,1],[20110505,1,0],2],
['PTpor','ESvlr',[20110428,5,1],[20110505,3,2],1], ],
final => [ [ '', 'k-o'],
['PTbrg','PTpor',[20110518,0,1],-1,'Dublin',2] ]
}};

$u_ec->{'2011-2012'} = {
extra => {
dd => 20120519,
supercup => [['Europese Supercup'],['ESbcl','PTpor',[20110826,2,0],1]]},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['NLtwn','ROvsl',[20110726,2,0],[20110803,0,0],1] ], # 1e wedstrijd in Arnhem
playoffs => [ ['Play-offs (4e voorronde) CL'],
['NLtwn','PTbnf',[20110816,2,2],[20110824,3,1],2]],
groupD => [ ['', [1, 3, 'Eerste ronde CL, Poule D', 2]],
['NLajx','FRoly',[20110914,0,0]],
['HRdzg','ESrmd',[20110914,0,1]],
['ESrmd','NLajx',[20110927,3,0]],
['FRoly','HRdzg',[20110927,2,0]],
['HRdzg','NLajx',[20111018,0,2]],
['ESrmd','FRoly',[20111018,4,0]],
['NLajx','HRdzg',[20111102,4,0]],
['FRoly','ESrmd',[20111102,0,2]],
['FRoly','NLajx',[20111122,0,0]],
['ESrmd','HRdzg',[20111122,6,2]],
['NLajx','ESrmd',[20111207,0,3]],
['HRdzg','FRoly',[20111207,1,7]] ],
quarterfinal => [ [''],
['FRomr','DEbmn',[20120328,0,2],[20120403,2,0],2],
['CYapl','ESrmd',[20120327,0,3],[20120404,5,2],2],
['PTbnf','G1cls',[20120327,0,1],[20120404,2,1],2],
['ITmln','ESbcl',[20120328,0,0],[20120403,3,1],2]],
semifinal => [ [''],
['DEbmn','ESrmd',[20120417,2,1],[20120425,2,1],5],
['G1cls','ESbcl',[20120418,1,0],[20120424,2,2],1]],
final => [ [''],
['G1cls','DEbmn',[20120519,1,1],5,'M&uuml;nchen'] ]
},
EuropaL => {
qfr => [['2e voorronde Europa League'],
['LTtrs','NLadh',[20110714,2,3],[20110721,2,0],2] ],
qfr_3 => [ ['3e voorronde EL'],
['CYomm','NLadh',[20110728,3,0],[20110804,1,0],1],
['NLaz1','CZjbl',[20110728,2,0],[20110804,1,1],1] ],
playoffs => [ ['Play-offs (4e voorronde) EL'],
['ATrid','NLpsv',[20110818,0,0],[20110825,5,0],2],
['NOals','NLaz1',[20110818,2,1],[20110825,6,0],2] ],
groupC => [ ['', [1, 3, 'Eerste ronde EL, Poule C', 1]],
['NLpsv','PLlgw',[20110915,1,0]],
['ILhta','ROrpb',[20110915,0,1]],
['PLlgw','ILhta',[20110929,3,2]],
['ROrpb','NLpsv',[20110929,1,3]],
['ROrpb','PLlgw',[20111020,0,1]],
['ILhta','NLpsv',[20111020,0,1]],
['PLlgw','ROrpb',[20111103,3,1]],
['NLpsv','ILhta',[20111103,3,3]],
['ROrpb','ILhta',[20111130,1,3]],
['PLlgw','NLpsv',[20111130,0,3]],
['NLpsv','ROrpb',[20111215,2,1]],
['ILhta','PLlgw',[20111215,2,0]] ],
groupG => [ ['', [1, 3, 'Eerste ronde EL, Poule G', 1]],
['NLaz1','SEmlm',[20110915,4,1]],
['ATawn','UAmkh',[20110915,1,2]],
['UAmkh','NLaz1',[20110929,1,1]],
['SEmlm','ATawn',[20110929,1,2]],
['NLaz1','ATawn',[20111020,2,2]],
['SEmlm','UAmkh',[20111020,1,4]],
['ATawn','NLaz1',[20111103,2,2]],
['UAmkh','SEmlm',[20111103,3,1]],
['UAmkh','ATawn',[20111130,4,1]],
['SEmlm','NLaz1',[20111130,0,0]],
['NLaz1','UAmkh',[20111215,1,1]],
['ATawn','SEmlm',[20111215,2,0]] ],
groupK => [ ['', [1, 3, 'Eerste ronde EL, Poule K', 1]],
['G1flh','NLtwn',[20110915,1,1]],
['PLwkr','DKodn',[20110915,1,3]],
['NLtwn','PLwkr',[20110929,4,1]],
['DKodn','G1flh',[20110929,0,2]],
['DKodn','NLtwn',[20111020,1,4]],
['PLwkr','G1flh',[20111020,1,0]],
['NLtwn','DKodn',[20111103,3,2]],
['G1flh','PLwkr',[20111103,4,1]],
['NLtwn','G1flh',[20111201,1,0]],
['DKodn','PLwkr',[20111201,1,2]],
['PLwkr','NLtwn',[20111214,2,1]],
['G1flh','DKodn',[20111214,2,2]] ],
round2 => [ ['Tweede ronde Europa League', 'k-o'],
['NLajx','G1mnu',[20120216,0,2],[20120223,1,2],2],
['NLaz1','BEand',[20120216,1,0],[20120223,0,1],1],
['TRtrb','NLpsv',[20120216,1,2],[20120223,4,1],2],
['ROstb','NLtwn',[20120216,0,1],[20120223,1,0],2]],
round_of_16 => [ ['Achtste finale Europa League', 'k-o'],
['NLtwn','DEs04',[20120308,1,0],[20120315,4,1,
{opm => "met 3 goals van Klaas-Jan Huntelaar voor Schalke"}],2],
['NLaz1','ITudn',[20120308,2,0],[20120315,2,1],1],
['ESval','NLpsv',[20120308,4,2],[20120315,1,1],1]],
quarterfinal => [ [''],
['ESamd','DEhan',[20120329,2,1],[20120405,1,2],1],
['NLaz1','ESval',[20120329,2,1],[20120405,4,0],2],
['PTspp','UAmkh',[20120329,2,1],[20120405,1,1],1],
['DEs04','ESbil',[20120329,2,4],[20120405,2,2],2]],
semifinal => [ [''],
['ESamd','ESval',[20120419,4,2],[20120426,0,1],1],
['PTspp','ESbil',[20120419,2,1],[20120426,3,1],2]],
final => [ [''],
['ESamd','ESbil',[20120509,3,0],1,'Boekarest'] ]
}};

$u_ec->{'2012-2013'} = {
extra => {
dd => 20130525
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['UAdkv','NLfyn',[20120731,2,1],[20120807,0,1],1]],
groupD => [ ['', [1, 3, 'Eerste ronde CL, Poule D', 2]],
['DEbdm','NLajx',[20120918,1,0]],
['ESrmd','G1mnc',[20120918,3,2]],
['NLajx','ESrmd',[20121003,1,4]],
['G1mnc','DEbdm',[20121003,1,1]],
['NLajx','G1mnc',[20121024,3,1]],
['DEbdm','ESrmd',[20121024,2,1]],
['G1mnc','NLajx',[20121106,2,2]],
['ESrmd','DEbdm',[20121106,2,2]],
['NLajx','DEbdm',[20121121,1,4]],
['G1mnc','ESrmd',[20121121,1,1]],
['DEbdm','G1mnc',[20121204,1,0]],
['ESrmd','NLajx',[20121204,4,1]] ],
quarterfinal => [ [''],
['DEbmn','ITjuv',[20130402,2,0],[20130410,0,2],1],
['FRpsg','ESbcl',[20130402,2,2],[20130410,1,1],2],
['ESmal','DEbdm',[20130403,0,0],[20130409,3,2],2],
['ESrmd','TRglt',[20130403,3,0],[20130409,3,2],1] ],
semifinal => [ [''],
['DEbmn','ESbcl',[20130423,4,0],[20130501,0,3],1],
['DEbdm','ESrmd',[20130424,4,1],[20130430,2,0],1] ],
final => [ [''],
['DEbdm','DEbmn',[20130525,1,2],2,'Londen, Wembly'] ],
},
EuropaL => {
qfr_1 => [['1e voorronde Europa League'],
['NLtwn','ADscl',[20120705,6,0],[20120712,0,3],1]],
qfr => [['2e voorronde Europa League'],
['BGlpl','NLvit',[20120719,4,4],[20120726,3,1],2],
['NLtwn','FIitr',[20120719,1,1],[20120726,0,5],1] ],
qfr_3 => [['3e voorronde Europa League'],
['NLhrv','ROrpb',[20120802,4,0],[20120809,1,0],1],
['RUamk','NLvit',[20120802,2,0],[20120809,0,2],1],
['NLtwn','CZmbl',[20120802,2,0],[20120809,0,2],1] ],
playoffs => [ ['Play-offs (4e voorronde) EL'],
['RUamk','NLaz1',[20120823,1,0],[20120830,0,5],1],
['NOmld','NLhrv',[20120823,2,0],[20120830,1,2],1],
['TRbrs','NLtwn',[20120823,3,1],[20120830,4,1],4],
['NLfyn','CZspr',[20120823,2,2],[20120830,2,0],2],
['MEzet','NLpsv',[20120823,0,5],[20120830,9,0],2] ],
groupF => [ ['', [1, 3, 'Eerste ronde EL, Poule F', 1]],
['UAdjn','NLpsv',[20120920,2,0]],
['ITnpl','SEsln',[20120920,4,0]],
['NLpsv','ITnpl',[20121004,3,0]],
['SEsln','UAdjn',[20121004,2,3]],
['NLpsv','SEsln',[20121025,1,1]],
['UAdjn','ITnpl',[20121025,3,1]],
['SEsln','NLpsv',[20121108,1,0]],
['ITnpl','UAdjn',[20121108,4,2]],
['NLpsv','UAdjn',[20121122,1,2]],
['SEsln','ITnpl',[20121122,1,2]],
['ITnpl','NLpsv',[20121206,1,3]],
['UAdjn','SEsln',[20121206,4,0]], ],
groupL => [ ['', [1, 3, 'Eerste ronde EL, Poule L', 1]],
['NLtwn','DEhan',[20120920,2,2]],
['ESlvn','SEhls',[20120920,1,0]],
['DEhan','ESlvn',[20121004,2,1]],
['SEhls','NLtwn',[20121004,2,2]],
['SEhls','DEhan',[20121025,1,2]],
['ESlvn','NLtwn',[20121025,3,0]],
['NLtwn','ESlvn',[20121108,0,0]],
['DEhan','SEhls',[20121108,3,2]],
['DEhan','NLtwn',[20121122,0,0]],
['SEhls','ESlvn',[20121122,1,3]],
['NLtwn','SEhls',[20121206,1,3]],
['ESlvn','DEhan',[20121206,2,2]], ],
round2 => [ ['Tweede ronde Europa League'],
['NLajx','ROstb',[20130214,2,0],[20130221,2,0],6] ],
quarterfinal => [ [''],
['TRfen','ITlzr',[20130404,2,0],[20130411,1,1],1],
['PTbnf','G1nwc',[20130404,3,1],[20130411,1,1],1],
['G1ttt','CHbsl',[20130404,2,2],[20130411,2,2],6],
['G1cls','RUrkz',[20130404,3,1],[20130411,3,2],1] ],
semifinal => [ [''],
['TRfen','PTbnf',[20130425,1,0],[20130502,3,1],2],
['CHbsl','G1cls',[20130425,1,2],[20130502,3,1],2] ],
final => [ [''],
['PTbnf','G1cls',[20130515,1,2],2,'Amsterdam ArenA'] ],
}};

$u_ec->{'2013-2014'} = {
extra => {
dd => 20130728,
supercup => [['Europese Supercup'],['DEbmn','G1cls',[20130830,1,1],5]]
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['NLpsv','BEzwr',[20130730,2,0],[20130807,0,3],1]],
playoffs => [ ['Play-offs CL'],
['NLpsv','ITmln',[20130820,1,1],[20130828,3,0],2] ],
groupH => [ ['', [1, 3, 'Eerste ronde CL, Poule H', 2]],
['ITmln','G2clt',[20130918,2,0]],
['ESbcl','NLajx',[20130918,4,0]],
['NLajx','ITmln',[20131001,1,1]],
['G2clt','ESbcl',[20131001,0,1]],
['G2clt','NLajx',[20131022,2,1]],
['ITmln','ESbcl',[20131022,1,1]],
['NLajx','G2clt',[20131106,1,0]],
['ESbcl','ITmln',[20131106,3,1]],
['NLajx','ESbcl',[20131126,2,1]],
['G2clt','ITmln',[20131126,0,3]],
['ITmln','NLajx',[20131211,0,0]],
['ESbcl','G2clt',[20131211,6,1]] ],
quarterfinal => [['kwartfinale'],
['ESrmd','DEbdm',[20140402,3,0],[20140408,2,0],1],
['G1mnu','DEbmn',[20140401,1,1],[20140409,3,1],2],
['ESbcl','ESamd',[20140401,1,1],[20140409,1,0],2],
['FRpsg','G1cls',[20140402,3,1],[20140408,2,0],2] ],
semifinal => [[''],
['ESrmd','DEbmn',[20140423,1,0],[20140429,0,4],1],
['ESamd','G1cls',[20140422,0,0],[20140430,1,3],1] ],
final => [[''],
['ESrmd','ESamd',[20140524,4,1],3, 'Lissabon' ] ],
},
EuropaL => {
qfr => [['2e voorronde Europa League'],
['LUdff','NLutr',[20130718,2,1],[20130725,3,3],1]],
qfr_3 => [['3e voorronde Europa League'],
['ROpll','NLvit',[20130801,1,1],[20130808,1,2],1]],
playoffs => [ ['Play-offs (4e voorronde) EL'],
['RUkkr','NLfyn',[20130822,1,0],[20130829,1,2],1],
['GRatr','NLaz1',[20130822,1,3],[20130829,0,2],2] ],
groupB => [ ['', [1, 3, 'Eerste ronde EL, Poule B', 1]],
['NLpsv','BGldg',[20130919,0,2]],
['HRdzg','UAcod',[20130919,1,2]],
['UAcod','NLpsv',[20131003,0,2]],
['BGldg','HRdzg',[20131003,3,0]],
['HRdzg','NLpsv',[20131024,0,0]],
['UAcod','BGldg',[20131024,0,1]],
['NLpsv','HRdzg',[20131107,2,0]],
['BGldg','UAcod',[20131107,1,1]],
['BGldg','NLpsv',[20131128,2,0]],
['UAcod','HRdzg',[20131128,2,1]],
['NLpsv','UAcod',[20131212,0,1]],
['HRdzg','BGldg',[20131212,1,2]],
],
groupL => [ ['', [1, 3, 'Eerste ronde EL, Poule L', 1]],
['ILmhf','NLaz1',[20130919,0,1]],
['GRpks','KZskr',[20130919,2,1]],
['NLaz1','GRpks',[20131003,1,1]],
['KZskr','ILmhf',[20131003,2,2]],
['KZskr','NLaz1',[20131024,1,1]],
['GRpks','ILmhf',[20131024,3,2]],
['NLaz1','KZskr',[20131107,1,0]],
['ILmhf','GRpks',[20131107,0,0]],
['NLaz1','ILmhf',[20131128,2,0]],
['KZskr','GRpks',[20131128,0,2]],
['ILmhf','KZskr',[20131212,2,1]],
['GRpks','NLaz1',[20131212,2,2]] ],
round2 => [ ['Tweede ronde Europa League'],
['NLajx','ATrbs',[20140220,0,3],[20140227,3,1],2],
['CZsll','NLaz1',[20140220,0,1],[20140227,1,1],1] ],
round_of_16 => [ ['Achtste finale UEFA-cup'],
['NLaz1','RUamk',[20140313,1,0],[20140320,0,0],1] ],
quarterfinal => [ [''],
['PTpor','ESsvl',[20140403,1,0],[20140410,4,1],2],
['CHbsl','ESval',[20140403,3,0],[20140410,5,0],2],
['NLaz1','PTbnf',[20140403,0,1],[20140410,2,0],2],
['FRoly','ITjuv',[20140403,0,1],[20140410,2,1],2] ],
semifinal => [ [''],
['ESsvl','ESval',[20140424,2,0],[20140501,3,1],1],
['PTbnf','ITjuv',[20140424,2,1],[20140501,0,0],1] ],
final => [ [''],
['ESsvl','PTbnf',[20140514,0,0],5,'Turijn'] ]
}};

$u_ec->{'2014-2015'} = {
extra => {
dd => 20140812,
supercup => [['Europese Supercup'],['ESrmd','ESsvl',[20140812,2,0],1,'Cardiff']]
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['NLfyn','TRbsk',[20140730,1,2],[20140806,3,1],2]],
groupF => [ ['', [1, 5, 'Eerste ronde CL, Poule F', 2]],
['NLajx','FRpsg',[20140917,1,1]],
['ESbcl','CYapl',[20140917,1,0]],
['CYapl','NLajx',[20140930,1,1]],
['FRpsg','ESbcl',[20140930,3,2]],
['ESbcl','NLajx',[20141021,3,1]],
['CYapl','FRpsg',[20141021,0,1]],
['NLajx','ESbcl',[20141105,0,2]],
['FRpsg','CYapl',[20141105,1,0]],
['FRpsg','NLajx',[20141125,3,1]],
['CYapl','ESbcl',[20141125,0,4]],
['NLajx','CYapl',[20141210,4,0]],
['ESbcl','FRpsg',[20141210,3,1]] ],
round_of_16 => [['8-ste finale C-L', 'k-o'],
['FRpsg','G1cls',[20150217,1,1],[20150311,2,2],1],
['UAsdk','DEbmn',[20150217,0,0],[20150311,7,0],2],
['DEs04','ESrmd',[20150218,0,2],[20150310,3,4],2],
['CHbsl','PTpor',[20150218,1,1],[20150310,4,0],2],
['G1mnu','ESbcl',[20150224,1,2],[20150318,1,0],2],
['ITjuv','DEbdm',[20150224,2,1],[20150318,0,3],1],
['G1ars','FRmnc',[20150225,1,3],[20150317,0,2],2],
['DElvk','ESamd',[20150225,1,0],[20150317,1,0],2] ],
quarterfinal => [['kwartfinale'],
['FRpsg','ESbcl',[20150415,1,3],[20150421,2,0],2],
['PTpor','DEbmn',[20150415,3,1],[20150421,6,1],2],
['ESamd','ESrmd',[20150414,0,0],[20150422,1,0],2],
['ITjuv','FRmnc',[20150414,1,0],[20150422,0,0],1] ],
semifinal => [['halve finale'],
['ESbcl','DEbmn',[20150506,3,0],[20150512,3,2],1],
['ITjuv','ESrmd',[20150505,2,1],[20150513,1,1],1]],
final => [['finale'],
['ITjuv','ESbcl',[20150606,1,3],2,'Berlijn'] ]
},
EuropaL => {
qfr => [ ['2e voorronde Europa League'],
['G2abd','NLgrn',[20140717,0,0],[20140724,1,2],1] ],
qfr_3 => [['3e voorronde Europa League'],
['NLpsv','ATspl',[20140731,1,0],[20140807,2,3],1]],
playoffs => [ ['Play-offs (4e voorronde) EL'],
['AZkrb','NLtwn',[20140821,0,0],[20140828,1,1],1],
['NLpsv','BYslg',[20140821,1,0],[20140828,0,2],1],
['NLpzw','CZspr',[20140821,1,1],[20140828,3,1],2],
['UAzlg','NLfyn',[20140821,1,1],[20140828,4,3],2] ],
groupE => [ ['', [1, 5, 'Eerste ronde EL, Poule E', 1]],
['NLpsv','PTest',[20140918,1,0]],
['GRpnt','RUdmk',[20140918,1,2]],
['RUdmk','NLpsv',[20141002,1,0]],
['PTest','GRpnt',[20141002,2,0]],
['NLpsv','GRpnt',[20141023,1,1]],
['PTest','RUdmk',[20141023,1,2]],
['GRpnt','NLpsv',[20141106,2,3]],
['RUdmk','PTest',[20141106,1,0]],
['RUdmk','GRpnt',[20141127,2,1]],
['PTest','NLpsv',[20141128,3,3,
{opm => '28 nov. gestaakt bij 3-2 wegens regen; 29 nov uitgespeeld.'}]],
['NLpsv','RUdmk',[20141211,0,1]],
['GRpnt','PTest',[20141211,1,1]],
],
groupG => [ ['', [1, 5, 'Eerste ronde EL, Poule G', 1]],
['BEslk','HRhrk',[20140918,2,0]],
['ESsvl','NLfyn',[20140918,2,0]],
['NLfyn','BEslk',[20141002,2,1]],
['HRhrk','ESsvl',[20141002,2,2]],
['HRhrk','NLfyn',[20141023,3,1]],
['BEslk','ESsvl',[20141023,0,0]],
['NLfyn','HRhrk',[20141106,2,0]],
['ESsvl','BEslk',[20141106,3,1]],
['NLfyn','ESsvl',[20141127,2,0]],
['HRhrk','BEslk',[20141127,2,0]],
['BEslk','NLfyn',[20141211,0,3]],
['ESsvl','HRhrk',[20141211,1,0]],
],
round2 => [ ['Tweede ronde Europa League'],
['NLajx','PLlgw',[20150219,1,0],[20150226,0,3],1],
['ITasr','NLfyn',[20150219,1,1],[20150226,1,2],1],
['NLpsv','RUzsp',[20150219,0,1],[20150226,3,0],2] ],
round_of_16 => [ ['Derde ronde UEFA-cup'],
['UAdjn','NLajx',[20150312,1,0],[20150319,2,1],3] ],
quarterfinal => [['kwartfinale'],
['ESsvl','RUzsp',[20150416,2,1],[20150423,2,2],1],
['UAdkv','ITfrt',[20150416,1,1],[20150423,2,0],2],
['DEvwl','ITnpl',[20150416,1,4],[20150423,2,2],2],
['BEcbr','UAdjn',[20150416,0,0],[20150423,1,0],2] ],
semifinal => [['halve finale'],
['ESsvl','ITfrt',[20150507,3,0],[20150514,0,2],1],
['ITnpl','UAdjn',[20150507,1,1],[20150514,1,0],2] ],
final => [['finale'],
['UAdjn','ESsvl',[20150527,2,3],2,'Warschau'] ]
}};

$u_ec->{'2015-2016'} = {
extra => {
dd => 20160814,
supercup => [['Europese Supercup'],['ESbcl','ESsvl',[20150811,5,4],3,'Tbilisi']]
},
CL => {
qfr_3 => [ ['3e voorronde Champions League'],
['ATrwn','NLajx',[20150729,2,2],[20150804,2,3],1]],
groupB => [ ['', [1, 5, 'Groep B Champions League', 2]],
['NLpsv','G1mnu',[20150915,2,1]],
['DEvwl','RUcmk',[20150915,1,0]],
['RUcmk','NLpsv',[20150929,3,2]],
['G1mnu','DEvwl',[20150929,2,1]],
['DEvwl','NLpsv',[20151021,2,0]],
['RUcmk','G1mnu',[20151021,1,1]],
['NLpsv','DEvwl',[20151103,2,0]],
['G1mnu','RUcmk',[20151103,1,0]],
['G1mnu','NLpsv',[20151125,0,0]],
['RUcmk','DEvwl',[20151125,0,2]],
['NLpsv','RUcmk',[20151208,2,1]],
['DEvwl','G1mnu',[20151208,3,2]],
],
round_of_16 => [['8-ste finale C-L', 'k-o'],
['BEaag','DEvwl',[20160217,2,3],[20160308,1,0],2],
['ITasr','ESrmd',[20160217,0,2],[20160308,2,0],2],
['FRpsg','G1cls',[20160216,2,1],[20160309,1,2],1],
['G1ars','ESbcl',[20160223,0,2],[20160316,3,1],2],
['ITjuv','DEbmn',[20160223,2,2],[20160316,4,2],2],
['NLpsv','ESamd',[20160224,0,0],[20160315,0,0],6],
['PTbnf','RUzsp',[20160216,1,0],[20160309,1,2],1],
['UAdkv','G1mnc',[20160224,1,3],[20160315,0,0],2] ],
quarterfinal => [['kwart finale C-L', 'k-o'],
['FRpsg','G1mnc',[20160406,2,2],[20160412,1,0],2],
['DEvwl','ESrmd',[20160406,2,0],[20160412,3,0],2],
['ESbcl','ESamd',[20160405,2,1],[20160413,2,0],2],
['DEbmn','PTbnf',[20160405,1,0],[20160413,2,2],1] ],
semifinal => [['halve final C-L', 'k-o'],
['G1mnc','ESrmd',[20160426,0,0],[20160504,1,0],2],
['ESamd','DEbmn',[20160427,1,0],[20160503,2,1],1] ],
final => [['finale C-L', 'k-o'],
['ESrmd','ESamd',[20160528,1,1],5,'Milaan'] ]
},
EuropaL => {
qfr_3 => [['3e voorronde Europa League'],
['NLaz1','TRbkh',[20150730,2,0],[20150806,1,2],1],
['G1sth','NLvit',[20150730,3,0],[20150806,0,2],1]],
playoffs => [ ['Play-offs (4e voorronde) EL'],
['NLajx','CZjbl',[20150820,1,0],[20150827,0,0],1],
['ROast','NLaz1',[20150820,3,2],[20150827,2,0],2]],
groupA => [ ['', [1, 5, 'Groepsfase EL, groep A', 1]],
['NLajx','G2clt',[20150917,2,2]],
['TRfen','NOmld',[20150917,1,3]],
['NOmld','NLajx',[20151001,1,1]],
['G2clt','TRfen',[20151001,2,2]],
['TRfen','NLajx',[20151022,1,0]],
['NOmld','G2clt',[20151022,3,1]],
['NLajx','TRfen',[20151105,0,0]],
['G2clt','NOmld',[20151105,1,2]],
['G2clt','NLajx',[20151126,1,2]],
['NOmld','TRfen',[20151126,0,2]],
['NLajx','NOmld',[20151210,1,1]],
['TRfen','G2clt',[20151210,1,1]],
],
groupF => [ ['', [1, 5, 'Groepsfase EL, groep F', 1]],
['NLgrn','FRomr',[20150917,0,3]],
['CZsll','PTbrg',[20150917,0,1]],
['PTbrg','NLgrn',[20151001,1,0]],
['FRomr','CZsll',[20151001,0,1]],
['CZsll','NLgrn',[20151022,1,1]],
['PTbrg','FRomr',[20151022,3,2]],
['NLgrn','CZsll',[20151105,0,1]],
['FRomr','PTbrg',[20151105,1,0]],
['FRomr','NLgrn',[20151126,2,1]],
['PTbrg','CZsll',[20151126,2,1]],
['NLgrn','PTbrg',[20151210,0,0]],
['CZsll','FRomr',[20151210,2,4]]
],
groupL => [ ['', [1, 5, 'Groepsfase EL, groep L', 1]],
['ESbil','DEabg',[20150917,3,2]],
['RSpbg','NLaz1',[20150917,3,2]],
['NLaz1','ESbil',[20151001,2,1]],
['DEabg','RSpbg',[20151001,1,3]],
['NLaz1','DEabg',[20151022,0,1]],
['RSpbg','ESbil',[20151022,0,2]],
['ESbil','RSpbg',[20151105,5,1]],
['DEabg','NLaz1',[20151105,4,1]],
['NLaz1','RSpbg',[20151126,1,2]],
['DEabg','ESbil',[20151126,2,3]],
['ESbil','NLaz1',[20151210,2,2]],
['RSpbg','DEabg',[20151210,1,3]] ],
quarterfinal => [['kwart finale E-L', 'k-o'],
['PTbrg','UAsdk',[20160407,1,2],[20160414,4,0],2],
['ESbil','ESsvl',[20160407,1,2],[20160414,1,2],6],
['ESvlr','CZspr',[20160407,2,1],[20160414,2,4],1],
['DEbdm','G1lvp',[20160407,1,1],[20160414,4,3],2] ],
semifinal => [['halve finale E-L', 'k-o'],
['UAsdk','ESsvl',[20160428,2,2],[20160505,3,1],2],
['ESvlr','G1lvp',[20160428,1,0],[20160505,3,0],2] ],
final => [['finale E-L', 'k-o'],
['G1lvp','ESsvl',[20160518,1,3],2,'Basel'] ]
}};

sub get_ec_webpage($)
{# (c) Edwin Spee

 my $szn = shift;
 return format_europacup($szn, $u_ec->{$szn});
}

sub laatste_speeldatum_ec($)
{# (c) Edwin Spee

 my ($year) = @_;

 my $dd = 20120723;

 while (my ($key1, $value1) = each %{$u_ec->{$year}})
 {
  while (my ($key2, $value2) = each %{$u_ec->{$year}{$key1}})
  {
   if (ref $value2 eq 'ARRAY')
   {
    $dd = max($dd, laatste_speeldatum($value2));
 }}}

 return $dd;
}

sub init_ec
{ #(c) Edwin Spee

  for (my $yr = 2016; $yr <= 2020; $yr++)
  {
    my $szn = yr2szn($yr);
    my $csv = "europacup_$szn.csv";
    $csv =~ s/-/_/;
    $u_ec->{$szn} = read_ec_csv($csv, $szn);
    # liever: git log -1 --pretty="format:%ci" <file>
    $u_ec->{$szn}->{extra}->{dd} = laatste_speeldatum_ec($szn);
  }
  $u_ec->{lastyear} = '2020-2021';
}

sub set_laatste_speeldatum_ec
{# (c) Edwin Spee

 my $szn = $u_ec->{lastyear};
 my $dd = max(laatste_speeldatum_ec($szn));
 if (defined($u_ec->{szn}{extra}))
 {
  $dd = max($dd, $u_ec->{$szn}{extra}{dd});
 }
 $u_ec->{$szn}{extra}{dd} = $dd;
 set_datum_fixed($dd);
}

return 1;

