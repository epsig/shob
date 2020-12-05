package Sport_Collector::OS_Schaatsen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Html_Head_Bottum;
use Sport_Collector::OS_Funcs;
use Sport_Functions::Overig;
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
 '&get_OS1994',
 '&get_OS1998',
 '&get_OS2002',
 '&get_OS2006',
 '&get_OS2010',
 '&get_OS2014',
 '&get_OS2018',
 '$OS',
 #========================================================================
);

our $OS;

sub get_OS1994()
{# (c) Edwin Spee

 my $H500m_1994 = [ [],
[ 1, 'RUglb', [36.33, 'OR']],
[ 2, 'RUklv', 36.39],
[ 3, 'JPhor', 36.53],
[ 4, 'CNhbl', 36.54],
[ 5, 'JPsm2', 36.60],
[ 6, 'JPino', 36.63],
[ 7, 'NOnjs', 36.66],
[ 8, 'USjns', 36.68],
[ 9, 'JPmyb', 36.72],
[10, 'RUzjl', 36.73],
[21, 'NLvld', 37.45],
[24, 'NLlof', 37.52],
[31, 'NLvls', 37.94],
[37, 'NLsrd', 38.33],
#WR:35'76" OR:36'33" NR:36'76"
#Jansen    Goloebev  Ykema
];

 my $H1000m_1994 = [ [],
[ 1, 'USjns', [72.43, 'WR']],
[ 2, 'RUzjl', 72.72],
[ 3, 'RUklv', 72.85],
[ 4, 'CNhbl', 73.47],
[ 5, 'CAsbc', 73.56],
[ 6, 'CAkll', 73.67],
[ 7, 'NOst2', 73.74],
[ 8, 'JPino', 73.75],
[ 9, 'NLvld', 73.81],
[10, 'CAsct', 73.82],
[15, 'NLvls', 74.29],
[22, 'NLlof', 75.12],
[24, 'NLsrd', 75.19],
#WR:1.12'43" OR:1.12'43" NR:1.13'10"
#Jansen      Jansen      Van Velde
];

 my $H1500m_1994 = [ [],
[ 1, 'NOkss', [60+51.29, 'WR']],
[ 2, 'NLrts', 60+51.99],
[ 3, 'NLznd', 60+52.38],
[ 4, 'NOsnd', 60+53.13],
[ 5, 'RUanf', 60+53.16],
[ 6, 'DEadb', 60+53.50],
[ 7, 'CAmrs', 60+53.56],
[ 8, 'NLhrs', 60+53.59],
[ 9, 'NLstr', 60+53.70],
[10, 'UAsjl', 60+54.28],
#WR:1.51'29" OR:1.51'29" NR:1.51'60"
#Koss        Koss        Ritsma
];

 my $H5km_1994 = [ [],
[ 1, 'NOkss', [6*60+34.96, 'WR']],
[ 2, 'NOstl', 6*60+42.68],
[ 3, 'NLrts', 6*60+43.94],
[ 4, 'NLznd', 6*60+44.58],
[ 5, 'NLbvl', 6*60+49.00],
[ 6, 'JPitk', 6*60+49.36],
[ 7, 'PLrdk', 6*60+50.40],
[ 8, 'DEdtt', 6*60+52.27],
[ 9, 'AThds', 6*60+53.02],
[10, 'ATemn', 6*60+53.18],
[11, 'RUanf', 6*60+53.23],
[12, 'SEsch', 6*60+53.39],
[13, 'JPsat', 6*60+54.83],
[14, 'SEbng', 6*60+57.37],
#WR:6.34'96" OR:6.34'96" NR:6.39'40"
#Koss        Koss        Veldkamp
];

 my $H10km_1994 = [ [],
[ 1, 'NOkss', [13*60+30.55, 'WR']],
[ 2, 'NOstl', 13*60+49.25],
[ 3, 'NLbvl', 13*60+56.73],
[ 4, 'NLznd', 13*60+58.25],
[ 5, 'PLrdk', 14*60+ 3.84],
[ 6, 'DEdtt', 14*60+ 4.33],
[ 7, 'NLrts', 14*60+ 9.28],
[ 8, 'SEsch', 14*60+10.15],
[ 9, 'AThds', 14*60+12.09],
[10, 'ATemn', 14*60+15.14],
#WR: 13.30'55" OR: 13.30'55" NR: 13.46'34"
#Koss          Koss          Veldkamp
];

 my $D500m_1994 = [ [],
[ 1, 'USblr', 39.25],
[ 2, 'CAach', 39.61],
[ 3, 'DEsch', 39.70],
[ 4, 'CNrhx', 39.71],
[ 5, 'KRshy', 39.92],
[ 6, 'DEgbr', 39.95],
[ 7, 'RUbjr', 40.17],
[ 8, 'NOhst', 40.20],
[ 9, 'CNjng', 40.23],
[10, 'JPshm', 40.26],
[11, 'CNyng', 40.37],
[12, 'DEhck', 40.38],
[19, 'NLaft', 41.01],
#WR:39'10"   OR:39'10"   NR:40'34"
#Blair       Blair       Aaftink
];

 my $D1000m_1994 = [ [],
[ 1, 'USblr', 60+18.74],
[ 2, 'DEbar', 60+20.12],
[ 3, 'CNqby', 60+20.22],
[ 4, 'DEsch', 60+20.25],
[ 5, 'DEgbr', 60+20.32],
[ 6, 'JPksn', 60+20.37],
[ 7, 'AThnd', 60+20.42],
[ 8, 'CAach', 60+20.72],
[ 9, 'RUrvl', 60+20.82],
[10, 'RUplt', 60+20.84],
[11, 'RUfdt', 60+20.89],
[12, 'DEhck', 60+20.93],
[14, 'NLthm', [60+20.94, 'NR']],
[20, 'NLaft', 60+22.16],
#WR:1.17'65"  OR:1.17'65"  NR:1.20'94"
#Rothenburger Rothenburger Thomas
];

 my $D1500m_1994 = [ [],
[ 1, 'AThnd', 2*60+2.19],
[ 2, 'RUfdt', 2*60+2.69],
[ 3, 'DEnmn', 2*60+3.41],
[ 4, 'USblr', 2*60+3.44],
[ 5, 'NLthm', 2*60+3.70],
[ 6, 'RUbsj', 2*60+3.99],
[ 7, 'RUplt', 2*60+4.00],
[ 8, 'ROdsc', 2*60+4.02],
[ 9, 'JPhsh', 2*60+4.98],
[10, 'NLtdj', 2*60+5.18],
[11, 'DEbar', 2*60+5.97],
[12, 'ITblc', 2*60+5.99],
[13, 'JPksn', 2*60+6.20],
[14, 'DEudb', 2*60+6.40],
[22, 'NLzls', 2*60+8.49],
#WR:1.59'30" OR:2.00'68" NR:2.00'68"
#Kania       Van Gennip  Van Gennip
];

 my $D3km_1994 = [ [],
[ 1, 'RUbsj', 4*60+17.43],
[ 2, 'AThnd', 4*60+18.14],
[ 3, 'DEpch', 4*60+18.34],
[ 4, 'KZprk', 4*60+19.33],
[ 5, 'NLthm', 4*60+19.82],
[ 6, 'JPhsh', 4*60+21.07],
[ 7, 'JPymm', 4*60+22.37],
[ 8, 'ROdsc', 4*60+22.42],
[ 9, 'NLzls', 4*60+23.42],
[10, 'JPogs', 4*60+25.27],
[11, 'NLtdj', 4*60+25.88],
[12, 'RUtrp', 4*60+27.82],
[13, 'ATant', 4*60+27.91],
#Niemann viel; Belci gediskwalificeerd.
#WR:4.10'80" OR:4.11'94" NR:4.11'94"
#Niemann     Van Gennip  Van Gennip
];

 my $D5km_1994 = [ [],
[ 1, 'DEpch', 7*60+14.37],
[ 2, 'DEnmn', 7*60+14.88],
[ 3, 'JPymm', 7*60+19.68],
[ 7, 'NLzls', 7*60+29.42],
[10, 'NLthm', 7*60+32.39],
[11, 'NLtdj', 7*60+36.07],
];

 my $out = format_os(
  [$H500m_1994, $H1000m_1994, $H1500m_1994, $H5km_1994, $H10km_1994,
   $D500m_1994, $D1000m_1994, $D1500m_1994, $D3km_1994, $D5km_1994]);

 my $title = 'Schaatsen OS 1994 Lillehammer; Vikingskip, Hamar';
 return maintxt2htmlpage(OSTopMenu(1994) . $out, $title, 'title2h1',
  20050319, {type1 => 'std_menu'});
}

sub get_OS1998()
{# (c) Edwin Spee
 # versie 2.0 12-mrt-2005 redesign
 # versie 1.0 31-aug-2003 initiele versie

 my $H500m_1998 = [ [],
[ 1, 'JPsmz', 35.76, [35.59, 'OR']],
[ 2, 'CAwsp', 36.04, 35.80],
[ 3, 'CAovl', 35.78, 36.08],
[ 4, 'CAsbc', 35.90, 36.10],
[ 5, 'CApbc', 35.96, 36.09],
[ 6, 'USfrd', 35.81, 36.39],
[12, 'NLbos', 36.66, 36.11],
[21, 'NLlwg', 36.69, 36.54],
[38, 'NLpst', 78.68, 37.81],
[-1, 'NLwnn', 'gevallen', 'opgave'],
];

 my $H1000m_1998 = [ [],
[ 1, 'NLpst', [70.64, 'OR']],
[ 2, 'NLbos', 70.71],
[ 3, 'JPsmz', 71.00],
[ 4, 'NLlwg', 71.26],
[ 5, 'CAsbc', 71.29],
[ 6, 'CAwsp', 71.39],
[ 7, 'USfrd', 71.64],
[ 8, 'USkcb', 71.75],
[ 9, 'DEadb', 71.90],
[10, 'CAovl', 71.90],
[11, 'JPima', 71.96],
[12, 'NLhrs', 72.00],
# oude OR: Dan Jansen (VS)     1.12'43"
# WR: Jeremy Wotherspoon (Can) 1.10'16"
# NR: Jan Bos                  1.10'48"
];

 my $H1500m_1998 = [ [],
[ 1, 'NOsnd', [60+47.87, 'WR']],
[ 2, 'NLpst', [60+48.13, 'NR']],
[ 3, 'NLrts', 60+48.52],
[ 4, 'NLbos', 60+49.75],
[ 5, 'USkcb', 60+50.04],
[ 6, 'NLhrs', 60+50.31],
[ 7, 'JPnok', 60+50.49],
[ 8, 'JPayn', 60+50.68],
[ 9, 'DEbrr', 60+50.96],
[10, 'RUanf', 60+50.99],
[11, 'BEvld', 60+51.73],
[12, 'ATtkn', 60+51.94],
# oude OR: Johann Olav Koss (Noo) 1.51'29"
# oude WR: Rintje Ritsma          1.48'88"
# oude NR: Rintje Ritsma          1.48'88"
];

 my $H5km_1998 = [ [],
[1, 'NLrmm', [6*60+22.20, 'WR']],
[2, 'NLrts', 6*60+28.24],
[3, 'BEvld', 6*60+28.31],
[4, 'NLdjg', 6*60+31.37],
[5, 'DEdtt', 6*60+32.17],
[6, 'DEtbr', 6*60+35.21],
# oude WR voor OS: Romme, 6.30'63"
];

 my $H10km_1998 = [ [],
[ 1, 'NLrmm', [13*60+15.33, 'WR']],
[ 2, 'NLdjg', 13*60+25.76],
[ 3, 'NLrts', 13*60+28.19],
[ 4, 'BEvld', 13*60+29.69],
[ 5, 'NOstl', 13*60+35.95],
[ 6, 'DEdtt', 13*60+36.58],
[ 7, 'NOstr', 13*60+42.94],
[ 8, 'USkcb', 13*60+44.03],
[ 9, 'ITsgh', 13*60+46.85],
[10, 'DEbmg', 13*60+48.44],
[12, 'ATtkn', 13*60+52.30],
# Oude OR+WR: Johann-Olav Koss 13.30'55"
];

 my $D500m_1998 = [ [],
[ 1, 'CAlmy', 38.39, [38.21, 'OR']],
[ 2, 'CAach', 38.42, 38.51],
[ 3, 'JPokz', 38.55, 38.55],
[ 4, 'DEsch', 38.88, 38.57],
[ 5, 'JPshm', 38.75, 38.93],
[ 6, 'NLtmm', 39.12, [39.03, 'NR']],
[ 7, 'DEvlk', 39.19, 39.00],
[17, 'NLzwl', 39.98, 39.88],
[24, 'NLwsm', 40.22, 40.57],
[37, 'NLnuy', 39.62, 78.32],
];

 my $D1000m_1998 = [ [],
[ 1, 'NLtmm', [60+16.51, 'OR + NR']],
[ 2, 'USwtt', 60+16.79],
[ 3, 'CAlmy', 60+17.37],
[ 4, 'DEvlk', 60+17.54],
[ 5, 'NLthm', 60+17.95],
[ 6, 'USsns', 60+18.23],
[ 7, 'JPokz', 60+18.27],
[ 8, 'JPsnm', 60+18.36],
[ 9, 'USdan', 60+18.38],
[10, 'DEgbr', 60+18.76],
[11, 'JPksn', 60+18.82],
[12, 'RUzjr', 60+19.04],
[15, 'NLzwl', 60+19.29],
[20, 'NLwsm', 60+20.02],
# oude OR: Chr.Rothenburger(Dui) 1.17'65"
# WR: Christine Witty (VS)       1.15'43"
# oude NR: Marianne Timmer       1.17'24"
];

 my $D1500m_1998 = [ [],
[ 1, 'NLtmm', [60+57.58, 'WR']],
[ 2, 'DEnmn', 60+58.66],
[ 3, 'USwtt', 60+58.97],
[ 4, 'AThnd', 60+59.19],
[ 5, 'DEfrs', 60+59.20],
[ 6, 'NLthm', 60+59.29],
[ 7, 'DEpch', 60+59.46],
[ 8, 'USrdr', 2*60+0.97],
[ 9, 'RUbsj', 2*60+1.54],
[10, 'RUplt', 2*60+1.56],
[11, 'KZprk', 2*60+1.65],
[12, 'USsns', 2*60+1.81],
[18, 'NLtdj', 2*60+3.19],
[22, 'NLdlr', 2*60+4.05],
];

 my $D3km_1998 = [ [],
[ 1, 'DEnmn', [4*60+7.29, 'OS']],
[ 2, 'DEpch', 4*60+ 8.47],
[ 3, 'DEfrs', 4*60+ 9.44],
[ 4, 'USrdr', 4*60+11.64],
[ 5, 'AThnd', 4*60+12.01],
[ 6, 'UShlm', 4*60+12.24],
[ 7, 'KZprk', 4*60+14.23],
[ 8, 'NLthm', 4*60+14.38],
[ 9, 'NLzls', 4*60+16.43],
[10, 'RUbsj', 4*60+16.45],
[11, 'ITblc', 4*60+16.62],
[12, 'RUvsk', 4*60+17.70],
[16, 'NLtdj', 4*60+19.54],
# Oude OR: Yvonne van Gennip  4.11'94"
# WR: Claudia Pechstein (Dui) 4.07'13"
# NR: Tonny de Jong           4.10'90"
];

 my $D5km_1998 = [ [],
[ 1, 'DEpch', [6*60+59.61, 'WR']],
[ 2, 'DEnmn', 6*60+59.65],
[ 3, 'KZprk', 7*60+11.14],
[ 4, 'NLdlr', 7*60+11.81],
[ 5, 'NLtdj', 7*60+12.77],
[ 6, 'NLzls', 7*60+12.89],
[ 7, 'UShlm', 7*60+14.20],
[ 8, 'AThnd', 7*60+15.23],
[ 9, 'ITblc', 7*60+15.58],
[10, 'USrdr', 7*60+16.78],
[11, 'JPuhr', 7*60+21.72],
[12, 'RUvsk', 7*60+22.18],
[13, 'NOtns', 7*60+28.39],
[14, 'DEwrn', 7*60+30.83],
[15, 'JPnmt', 7*60+36.77],
# Oude OR: Yvonne van Gennip   7.14'13"
# Oude WR: Gunda Niemann (Dui) 7.03'26"
# NR: Carla Zijlstra           7.07'93"
];

 my $out = format_os(
  [$H500m_1998, $H1000m_1998, $H1500m_1998, $H5km_1998, $H10km_1998,
   $D500m_1998, $D1000m_1998, $D1500m_1998, $D3km_1998, $D5km_1998]);

 my $title = 'Schaatsen OS 1998 Nagano';
 return maintxt2htmlpage(OSTopMenu(1998) . $out, $title, 'title2h1',
  20050319, {type1 => 'std_menu'});
}

sub get_OS2002()
{# (c) Edwin Spee

 my $H500m_2002 = [ [],
[ 1, 'USfrd', [34.42, 'OR'], 34.81],
[ 2, 'JPsmz', 34.61, 34.65],
[ 3, 'UScpt', 34.68, 34.79],
[ 4, 'NLvld', [34.72, 'NR'], 34.77],
[ 5, 'KRkhl', 34.74, 34.85],
[ 6, 'USchk', 34.78, 34.82],
[ 7, 'CAirl', 34.77, 34.83],
[ 8, 'JPtkd', 35.00, 34.81],
[ 9, 'NLbos', 35.14, [34.72, 'NR']],
[10, 'NLwnn', 35.00, 34.89],
[11, 'RUlbk', 35.09, 35.01],
[27, 'NLpst', 36.41, 36.08],
[-1, 'CAwsp', 'gevallen', 34.63],
# Winnaar 1998: Hiroyasu Shimizu OR:35,59
# Wereldrecord: Hiroyas.Shimizu, Jap 34,32
# Neder.record: Jan Bos             34,87
# Baanrecord: Hiroyas.Shimizu, Jap 34,32
];

my $H1000m_2002 = [ [],
[ 1, 'NLvld', [67.18, 'WR']],
[ 2, 'NLbos', 67.53],
[ 3, 'USchk', 67.61],
[ 4, 'UScpt', 67.89],
[ 5, 'NLwnn', 67.95],
[ 6, 'USprs', 67.97],
[ 7, 'USfrd', 68.15],
[ 8, 'KRkhl', 68.37],
[11, 'NOsnd', 68.64],
[13, 'CAwsp', 68.82],
[14, 'CAirl', 68.88],
[17, 'NLpst', 69.15],
# Wereldrecord: J.Wotherspoon, Can 1.07,72
# Neder.record: Erben Wennemars   1.07,88
# Baanrecord: J.Wotherspoon, Can 1.07,72
];

my $H1500m_2002 = [ [],
[ 1, 'USprr', [103.95, 'WR']],
[ 2, 'NLuyt', [104.57, 'NR']],
[ 3, 'NOsnd', 105.26],
[ 4, 'USchk', 105.34],
[ 5, 'NLpst', 105.41],
[ 6, 'USprs', 105.51],
[ 7, 'NLbos', 105.63],
[ 8, 'KRkhl', 105.82],
[ 9, 'NLrts', 105.86],
[10, 'RUllk', 105.97],
[11, 'RUsjp', 105.98],
[12, 'CAmlk', 106.00],
# Wereldrecord: Kyu-hyuk Lee, ZKo 1.45,20
#Neder.record: Jakko J.Leeuwangh 1.45,56
#Baanrecord: Joey Cheek (VS) 1.46,22
];

my $H5km_2002 = [ [],
[ 1, 'NLuyt', [6*60+14.66, 'WR']],
[ 2, 'USprr', 6*60+17.98],
[ 3, 'DEbdn', 6*60+21.73],
[ 4, 'RUsjp', 6*60+21.85],
[ 5, 'USkcb', 6*60+22.97],
[ 6, 'NLvrh', 6*60+24.71],
[ 7, 'ITsgh', 6*60+25.11],
[ 8, 'BEvld', 6*60+25.88],
[ 9, 'DEdtt', 6*60+25.89],
[10, 'NOstr', 6*60+25.92],
[11, 'CAmlk', 6*60+26.29],
[30, 'NLdjg', 6*60+43.97],
# Wereldrecord: Gianni Romme 6.18,72
# Baanrecord: Bob de Jong 6.19,58
];

my $H10km_2002 = [ [],
[ 1, 'NLuyt', [12*60+58.92, 'WR']],
[ 2, 'NLrmm', 13*60+10.03],
[ 3, 'NOstr', 13*60+16.92],
[ 4, 'JPshr', 13*60+20.40],
[ 5, 'DEbdn', 13*60+23.43],
[ 6, 'RUsjp', 13*60+23.83],
[ 7, 'ITsgh', 13*60+26.19],
[ 8, 'NOstl', 13*60+27.24],
[ 9, 'BEvld', 13*60+27.48],
[10, 'DEdtt', 13*60+28.73],
[13, 'USprr', 13*60+33.44],
[14, 'PLzgm', 13*60+35.50],
[15, 'NLdjg', 13*60+48.93],
# Wereldrecord: Gianni Romme 13.03,40
];

my $D500m_2002 = [ [],
[ 1, 'CAlmy', 37.30, 37.45],
[ 2, 'DEgbr', 37.34, 37.60],
[ 3, 'DEvlk', 37.62, 37.57],
[ 4, 'NLnuy', 37.54, 37.83],
[ 5, 'BYktj', 37.73, 37.66],
[ 6, 'JPokz', 37.77, 37.87],
[ 7, 'RUzjr', 37.55, 38.09],
[ 8, 'NLtmm', 38.30, 37.87],
[ 9, 'JPwtn', 37.98, 38.22],
[10, 'RUkkn', 38.05, 38.26],
[11, 'JPsnm', 38.25, 38.12],
[18, 'NLwsm', 38.31, 38.79],
# Wereldrecord: Catriona LeMay, Can 37,22
# Neder.record: Andrea Nuyt 37,54
# Baanrecord: Catriona LeMay, Can 37,30
];

my $D1000m_2002 = [ [],
[ 1, 'USwtt', [73.83, 'WR']],
[ 2, 'DEvlk', 73.96],
[ 3, 'USrdr', 74.24],
[ 4, 'NLtmm', [74.45, 'NR']],
[ 5, 'DEfrs', 74.47],
[ 6, 'DEgbr', 74.60],
[ 7, 'JPtnk', 74.64],
[ 8, 'NLnuy', 74.65],
[ 9, 'CAlmy', 74.72],
[10, 'ITsmn', 74.86],
[15, 'NLthm', 75.20],
[18, 'NLwsm', 76.48],
# Wereldrecord: Sabine V&ouml;lker, Dui 1.14,06
# Neder.record: Marianne Timmer 1.15,36
# Baanrecord: Sabine V&ouml;lker, Dui 1.14,06
];

my $D1500m_2002 = [ [],
[ 1, 'DEfrs', [60+54.02, 'WR']],
[ 2, 'DEvlk', 60+54.97],
[ 3, 'USrdr', 60+55.32],
[ 4, 'CAkls', 60+55.59],
[ 5, 'USwtt', 60+55.71],
[ 6, 'DEpch', 60+55.93],
[ 7, 'NLtdj', 60+56.02],
[ 8, 'USsnn', 60+56.29],
[ 9, 'JPtbt', 60+56.35],
[11, 'NLthm', 60+56.45],
[21, 'NLtmm', 60+59.60],
[-1, 'NLgrn', 'gevallen'],
# Wereldrecord: Anni Friesinger, Dui 1.54,38
# Neder.record: Annamarie Thomas 1.55,50
# Baanrecord: Maki Tabata (Jap) 1.54,76
];

my $D3km_2002 = [ [],
[ 1, 'DEpch', [3*60+57.70, 'WR']],
[ 2, 'NLgrn', [3*60+58.94, 'NR']],
[ 3, 'CAkls', 3*60+58.97],
[ 4, 'DEfrs', 3*60+59.39],
[ 5, 'NLtdj', 4*60+ 0.49],
[ 6, 'JPtbt', 4*60+ 3.63],
[ 7, 'USrdr', 4*60+ 4.99],
[ 8, 'CAgrv', 4*60+ 6.44],
[ 9, 'AThnd', 4*60+ 6.55],
[10, 'CAhgh', 4*60+ 6.57],
[11, 'NLgsm', 4*60+ 7.41],
[12, 'DEans', 4*60+ 7.55],
# Wereldrecord: Claudia Pechstein, Dui 3.59,26
# Neder.record: Barbara de Loor 4.04,56
# Baanrecord: Anni Friesinger, Dui 4.01,98
];

my $D5km_2002 = [ [],
[ 1, 'DEpch', [6*60+46.91, 'WR']],
[ 2, 'NLgsm', [6*60+49.22, 'NR']],
[ 3, 'CAhgh', 6*60+53.53],
[ 4, 'CAkls', 6*60+55.89],
[ 5, 'RUbrs', 6*60+56.97],
[ 6, 'DEfrs', 6*60+58.39],
[ 7, 'NLtdj', 7*60+ 1.17],
[ 8, 'JPtbt', 7*60+ 6.32],
[ 9, 'USrny', 7*60+ 6.89],
[10, 'CAgrv', 7*60+ 7.16],
[11, 'RUjks', 7*60+ 8.42],
[12, 'DEans', 7*60+10.17],
[13, 'NLvis', 7*60+19.08],
# Wereldrecord: Gunda Niemann, Dui 6.52,44
# Neder.record: Gretha Smit 7.03,47
];

my $out = qq(<a href="http://www.slc2002.org/">Offici&euml;le site</a>\n<hr>) .
 format_os(
  [$H500m_2002, $H1000m_2002, $H1500m_2002, $H5km_2002, $H10km_2002,
   $D500m_2002, $D1000m_2002, $D1500m_2002, $D3km_2002, $D5km_2002]);

my $title = 'Schaatsen OS 2002 Salt Lake City';
return maintxt2htmlpage(OSTopMenu(2002) . $out, $title, 'title2h1',
 20050312, {type1 => 'std_menu'});
}

sub get_OS2006()
{# (c) Edwin Spee

 my $H500m_2006 = [ [],
[ 1, 'USchk', [34.82, 'BR'], 34.94],
[ 2, 'RUdrf', 35.24, 35.17],
[ 3, 'KRksl', 35.34, 35.09],
[ 4, 'JPokw', 35.35, 35.21],
[ 5, 'CNfty', 35.39, 35.23],
[ 6, 'JPkat', 70.78 - 35.19, 35.19],
[ 7, 'CAirl', 70.88 - 35.29, 35.29],
# 8. Jae-Bong Choi (ZKo) 71.04
[ 9, 'CAwsp', 35.37, 35.68],
[10, 'FIksk', 35.58, 71.09 - 35.58],
[11, 'NLbos', 35.68, 35.43],
[12, 'USfrd', 35.78, 35.34],
#13. Keiichiro Nagashima (Jap) 71.14
[14, 'RUlbk', 35.55, 71.17 - 35.55],
[16, 'NLwnn', 35.46, 35.84],
[23, 'NLkpr', 36.10, 35.74],
[35, 'NLnnh', 48.84, 35.71],
#[99, 'FIhnn', 35.58],
];
#Wereldrecord: Joji Kato           34,30
#Neder.record: Gerard van Velde    34,59
#Baanrecord  : Fengtong Yu         35,19

 my $H1000m_2006 = [ [],
[ 1, 'USdvs', [60+ 8.89, 'BR']],
[ 2, 'USchk', 60+ 9.16],
[ 3, 'NLwnn', 60+ 9.32],
[ 4, 'KRkhl', 60+ 9.37],
[ 5, 'NLbos', 60+ 9.42],
[ 6, 'UShdr', 60+ 9.45],
[ 7, 'RUllk', 60+ 9.46],
[ 8, 'NLgrt', 60+ 9.57],
[ 9, 'USfrd', 60+ 9.59],
[10, 'RUdrf', 60+ 9.74],
[11, 'CAwsp', 60+ 9.76],
[12, 'NLnnh', 60+ 9.85] ];
#Wereldrecord: Shani Davis       1.07,03
#Neder.record: Gerard van Velde  1.07,18
#Baanrecord  : Simon Kuipers     1.09,92

 my $H1500m_2006 = [ [],
[ 1, 'ITfbr', [60+45.97, 'BR']],
[ 2, 'USdvs', 60+46.13],
[ 3, 'UShdr', 60+46.22],
[ 4, 'NLkpr', 60+46.58],
[ 5, 'NLwnn', 60+46.71],
[ 6, 'RUskb', 60+46.91],
[ 7, 'NOand', 60+47.15],
[ 8, 'NOfll', 60+47.28],
[ 9, 'USchk', 60+47.52],
[10, 'NOwtt', 60+47.78],
[15, 'NLkrm', 60+48.36],
[20, 'NLbos', 60+48.61] ];
# Wereldrecord: Chad Hedrick      1.42,78
# Neder.record: Erben Wennemars   1.43,51
# Baanrecord  : Enrico Fabris     1.46,46

 my $H5km_2006 = [ [],
[ 1, 'UShdr', [6*60+14.68, 'BR']],
[ 2, 'NLkrm', 6*60+16.40],
[ 3, 'ITfbr', 6*60+18.25],
[ 4, 'NLvrh', 6*60+18.84],
[ 5, 'CAdnk', 6*60+21.26],
[ 6, 'NLdjg', 6*60+22.12],
[ 7, 'USdvs', 6*60+23.08],
[ 8, 'NOgrd', 6*60+24.21],
[ 9, 'NOstr', 6*60+25.15],
[10, 'NOerv', 6*60+26.91],
[11, 'RUskb', 6*60+27.02],
[13, 'BEvld', 6*60+32.02],
];

 my $h5km = << 'EOF';
******5.000 m heren, zaterdag:
 Wereldrecord: Sven Kramer       6.08,78
 Neder.record: Sven Kramer       6.08,78
 Baanrecord  : Chad Hedrick      6.20,29
EOF

 my $H10km_2006 = [ [],
[ 1, 'NLdjg', [13*60+ 1.57, 'BR']],
[ 2, 'UShdr', 13*60+ 5.40],
[ 3, 'NLvrh', 13*60+ 8.80],
[ 4, 'NOgrd', 13*60+12.58],
[ 5, 'NOstr', 13*60+12.93],
[ 6, 'RUskb', 13*60+17.54],
[ 7, 'NLkrm', 13*60+18.14],
[ 8, 'ITfbr', 13*60+21.54],
[ 9, 'CAdnk', 13*60+23.55],
[10, 'SErjl', 13*60+29.50],
[11, 'NOerv', 13*60+37.62],
[12, 'ITsnf', 13*60+41.91],
[14, 'BEvld', 13*60+48.12] ];
# Winnaar 2002: Jochem Uytdehaage
# Wereldrecord: Chad Hedrick     12.55,11
# Neder.record: Carl Verheijen   12.57,92

 my $D500m_2006 = [ [],
[ 1, 'RUzjr', [38.23, 'BR'], 38.34],
[ 2, 'CNmwg', 38.31, 38.47],
[ 3, 'CNhrn', 38.60, 38.27],
[ 4, 'JPokz', 38.46, 38.46],
[ 5, 'KRshl', 38.69, 38.35],
[ 6, 'DEwlf', 38.70, 38.55],
[ 7, 'CNbwg', 38.71, 38.56],
[ 8, 'JPosg', 38.74, 38.65],
[ 9, 'JPysh', 38.68, 77.43-38.68],
[10, 'ITsmn', 77.68-38.66, 38.66],
[11, 'USrdr', 77.70-38.73, 38.73],
[12, 'NLagt', 39.12, 38.97],
#13. Aihua Xing (Chi) 78.350
[14, 'NLsta', 39.26, 39.33],
#15. Yukari Watanabe (Jap) 78.590
#16. Shannon Rempel (Can) 78.650
];

# Marianne Timmer gediskwalificeerd in 1e 500m
# Wereldrecord: Catriona LeMay-Doan 37,22
# Neder.record: Andrea Nuyt         37,54
# Baanrecord  : Manli Wang          38,25

 my $D1000m_2006 = [ [],
[ 1, 'NLtmm', [60+16.05, 'BR']],
[ 2, 'CAkls', 60+16.09],
[ 3, 'DEfrs', 60+16.11],
[ 4, 'NLwst', 60+16.39],
[ 5, 'CAgrv', 60+16.54],
[ 6, 'NLdlr', 60+16.73],
[ 7, 'RUzjr', 60+17.13],
[ 8, 'PLwjc', 60+17.28],
[ 9, 'RUabr', 60+17.33],
[10, 'USrdr', 60+17.47],
[13, 'ITsmn', 60+17.53],
[23, 'NLagt', 60+18.33],
[27, 'USwtt', 60+18.70] ];
#Wereldrecord: Chris Witty       1.13,83
#Neder.record: Marianne Timmer   1.14,45
#Baanrecord  : Anni Friesinger   1.16,30

 my $D1500m_2006 = [ [],
[ 1, 'CAkls', [60+55.27, 'BR']],
[ 2, 'CAgrv', 60+56.74],
[ 3, 'NLwst', 60+56.90],
[ 4, 'DEfrs', 60+57.31],
[ 5, 'ITsmn', 60+58.76],
[ 6, 'RUlbs', 60+58.87],
[ 7, 'CAnbt', 60+59.15],
[ 8, 'USrdr', 60+59.30],
[ 9, 'NLgrn', 60+59.33],
[10, 'DEans', 60+59.74],
[13, 'NLdtk', 120.15],
[14, 'NLtmm', 120.45] ];
# Wereldrecord: Cindy Klassen     1.51,79
# Neder.record: Ireen Wust        1.54,93
# Baanrecord  : Anni Friesinger   1.57,32

 my $D3km_2006 = [ [],
[ 1, 'NLwst', 4*60+ 2.43],
[ 2, 'NLgrn', 4*60+ 3.48],
[ 3, 'CAkls', 4*60+ 4.37],
[ 4, 'DEfrs', 4*60+ 4.59],
[ 5, 'DEpch', 4*60+ 5.54],
[ 6, 'DEans', 4*60+ 6.89],
[ 7, 'CZsbl', 4*60+ 8.42],
[ 8, 'CAgrv', 4*60+ 9.03],
[ 9, 'CAhgh', 4*60+ 9.17],
[10, 'PLwjc', 4*60+ 9.61],
[11, 'USrny', 4*60+10.44],
[12, 'CNfwg', 4*60+10.55],
[17, 'NLkln', 4*60+13.81],
];

# 13 Eriko Ishino JAP 4:11.21
# 14 Maki Tabata JAP 4:12.38
# 15 Maren Haugli NOO 4:12.50
# 16 Anna Rokita OOS 4:12.87
# 18 Svetlana Vysokova RUS 4:13.94
# 19 Seon-Yeong Noh ZKO 4:15.68
# 20 Adelia Marra ITA 4:16.27
# 20 Eriko Seo JAP 4:16.27
# 22 Margaret Crowley USA 4:17.37
# 23 Annette Bjelkevik NOO 4:17.57
# 24 Valentina Yakshina RUS 4:19.43
# 25 Jia Ji CHN 4:21.06
# 26 Daniela Oltean ROE 4:23.34
# 27 Kristine Holzer USA 4:26.60
# 28 Natalya Rybakova KAZ 4:38.76

 my $D5km_2006 = [ [],
[ 1, 'CAhgh', [6*60+59.07, 'BR']],
[ 2, 'DEpch', 7*60+ 0.08],
[ 3, 'CAkls', 7*60+ 0.57],
[ 4, 'CZsbl', 7*60+ 1.38],
[ 5, 'DEans', 7*60+ 2.82],
[ 6, 'CAgrv', 7*60+ 3.95],
[ 7, 'USrny', 7*60+ 4.91],
[ 8, 'NOmhg', 7*60+ 6.08],
[ 9, 'NLgrn', 7*60+11.32],
[10, 'NLklb', 7*60+12.18],
[11, 'JPish', 7*60+12.48],
[12, 'ATrkt', 7*60+16.75],
[13, 'JPtbt', 7*60+18.05],
];

# Wereldrecord: Claudia Pechstein 6.46,91
# Neder.record: Gretha Smit       6.49,22

 my $rest = << 'EOF';
medaillespiegel, eindstand, na 84 onderdelen:
                          G   Z   B   T

 1. Duitsland            11  12   6  29
 2. Verenigde Staten      9   9   7  25
 3. Oostenrijk            9   7   7  23
 4. Rusland               8   6   8  22
 5. Canada                7  10   7  24
 6. Zweden                7   2   5  14
 7. Zuid-Korea            6   3   2  11
 8. Zwitserland           5   4   5  14
 9. Italie                5   0   6  11
10. Frankrijk             3   2   4   9
    NEDERLAND             3   2   4   9
12. Estland               3   0   0   3
13. Noorwegen             2   8   9  19
14. China                 2   4   5  11
15. Tsjechie              1   2   1   4
16. Kroatie               1   2   0   3
17. Australie             1   0   1   2
18. Japan                 1   0   0   1
19. Finland               0   6   3   9
20. Polen                 0   1   1   2
21. Bulgarije             0   1   0   1
    Groot-Brittannie      0   1   0   1
    Slowakije             0   1   0   1
    Wit-Rusland           0   1   0   1
25. Oekraine              0   0   2   2
26. Letland               0   0   1   1

Schaatsmedailles:     G   Z   B   T

1. Verenigde Staten   3   3   1   7
2. NEDERLAND          3   2   4   9
3. Canada             2   4   2   8
4. Italie             2   0   1   3
5. Duitsland          1   1   1   3
   Rusland            1   1   1   3
7. China              0   1   1   2
8. Zuid-Korea         0   0   1   1

Schaatsen, achtervolging heren:
1. Italie
2. Canada
3. NEDERLAND

Schaatsen, achtervolging dames:
1. Duitsland
2. Canada
3. Rusland
EOF

 my $out = format_os(
  [$H500m_2006, $H1000m_2006, $H1500m_2006, $H5km_2006, $H10km_2006,
   $D500m_2006, $D1000m_2006, $D1500m_2006, $D3km_2006, $D5km_2006]);

 my $title = 'Schaatsen OS 2006 Turijn';
 return maintxt2htmlpage(OSTopMenu(2006) . $out,$title, 'title2h1',
  20100302, {type1 => 'std_menu'});
}

sub get_OS2010
{
 my $H500m_2010 = [ [],
[ 1, 'KRtbm', 34.92, 34.90],
[ 2, 'JPngs', 35.10, 34.87],
[ 3, 'JPkat', 34.93, 35.07],
[ 4, 'KRksl', 35.05, 34.98],
[ 5, 'FIptl', 34.86, 35.18],
[ 6, 'NLsmk', 35.16, 35.05],
[ 7, 'CNfty', 35.11, 35.12],
[ 8, 'CAgrg', 35.14, 35.12],
[ 9, 'CAwsp', 35.09, 35.18],
[10, 'CNzhg', 35.17, 35.11],
[11, 'NLmld', 35.15, 35.14],
[20, 'NLkpr', 35.66, 35.66],
[29, 'NLbos', 36.14, 36.11] ];

 my $H1000m_2010 = [ [],
[ 1, 'USdvs', [68.94, 'BR']],
[ 2, 'KRtbm',  69.12],
[ 3, 'UShdr',  69.32],
[ 4, 'NLgrt',  69.45],
[ 5, 'NLtrt',  69.48],
[ 6, 'NLkpr',  69.65],
[ 7, 'USprs',  69.79],
[ 8, 'FIptl',  69.85],
[ 9, 'KRkhl',  69.92],
[10, 'USmrs',  70.11],
[11, 'RUllk',  70.14],
[12, 'NLbos',  70.29] ];
#Winnaar 2006: Shani Davis
#Wereldrecord: Shani Davis       1.06,42
#Neder.record: Beorn Nijenhuis   1.07,07
#Baanrecord  : Trevor Marsicano  1.08,96

 my $H1500m_2010 = [ [],
[ 1, 'NLtrt', [60+45.57, 'BR']],
[ 2, 'USdvs',  60+46.10],
[ 3, 'NObok',  60+46.13],
[ 4, 'RUskb',  60+46.42],
[ 5, 'KRtbm',  60+46.47],
[ 6, 'UShdr',  60+46.69],
[ 7, 'NLkpr',  60+46.76],
[ 8, 'NOfll',  60+46.77],
[ 9, 'CAmor',  60+46.93],
[10, 'ITfbr',  60+47.02],
[13, 'NLkrm',  60+47.40],
[16, 'NLgrt',  60+48.03] ];
#Winnaar 2006: Enrico Fabris
#Wereldrecord: Shani Davis       1.41,04
#Neder.record: Erben Wennemars   1.42,32
#Baanrecord  : Shani Davis       1.46,17

 my $H5km_2010 = [ [],
[ 1, 'NLkrm', [6*60+14.60, 'OR']],
[ 2, 'KRlsh', 6*60+16.95],
[ 3, 'RUskb', 6*60+18.05],
[ 4, 'NObok', 6*60+18.80],
[ 5, 'NLdjg', 6*60+19.02],
[ 6, 'FRcnt', 6*60+19.58],
[ 7, 'ITfbr', 6*60+20.53],
[ 8, 'NOchr', 6*60+24.80],
[ 9, 'NLblk', 6*60+26.30],
[10, 'NOhgl', 6*60+27.05],
[11, 'UShdr', 6*60+27.07],
[12, 'USdvs', 6*60+28.44] ];

 my $H10km_2010 = [ [],
[ 1, 'KRlsh', 12*60+58.55],
[ 2, 'RUskb', 13*60+ 2.07],
[ 3, 'NLdjg', 13*60+ 6.73],
[ 4, 'FRcnt', 13*60+12.11],
[ 5, 'NObok', 13*60+14.92],
[ 6, 'NOhgl', 13*60+18.74],
[ 7, 'NOchr', 13*60+25.65],
[ 8, 'USkuc', 13*60+31.78],
[ 9, 'NLkft', 13*60+33.37],
[10, 'DEwbr', 13*60+35.73],
[-1, 'NLkrm', 'gediskwalificeerd na foute wissel, <br> waarschijnlijk op aanwijzing coach Gerard Kemkers'] ];
#Winnaar 2006: Bob de Jong
#Wereldrecord: Sven Kramer      12.41,69
#Neder.record: Sven Kramer      12.41,69
#Baanrecord  : Sven Kramer      12.55,32

 my $Hteampursuit_2010 = [ [],
[ 1, ['CA', 'Giroux, Makowsky, Morrison'], 3*60+41.37],
[ 2, ['US', 'Hansen, Hedrick, Kuck'], 3*60+41.58],
[ 3, ['NL', 'Blokhuijsen, Kramer, Tuitert'], [3*60+39.95, 'OR']],
[ 4, ['NO', 'Bokk&oslash;, Christiansen, Flygind-Larsen'], 3*60+40.50],
[ 5, ['KR', 'Lee Jong-woo, Lee Seung-hoon, Ha Hong-sun'], 3*60+48.60],
[ 6, ['IT', 'Anesi, Fabris, Ioriatti'], 3*60+54.39],
[ 7, ['SE', 'Eriksson, Friberg, R&ouml;jler'], 3*60+46.18],
[ 8, ['JP', 'Dejima, Doi, Hirako'], 3*60+49.11] ];
#Winnaar 2006: Italie
#Wereldrecord: Nederland         3.37,80
#Neder.record: Kramer, Verheijen, Wennemars         3.37,80

 my $D500m_2010 = [ [],
[ 1, 'KRshl', 38.24, 37.85],
[ 2, 'DEwlf', 38.30, 37.83],
[ 3, 'CNbwg', 38.48, 38.14],
[ 4, 'NLbor', 38.51, 38.36],
[ 5, 'JPysh', 38.56, 38.43],
[ 6, 'USrch', 38.69, 38.47],
[ 7, 'CNshg', 38.53, 38.80],
[ 8, 'CNpyu', 38.68, 38.77],
[ 9, 'KPhsk', 38.89, 38.57],
[10, 'CAnbt', 38.88, 38.69],
[11, 'DEang', 38.76, 38.83],
[15, 'NLoen', 38.89, 38.86],
[19, 'NLvrs', 39.30, 38.84],
[-1, 'NLagt', [97.95, 'val'], 38.709] ];
#Winnaar 2006: Svetlana Zjoerova
#Wereldrecord: Jenny Wolf          37,00
#Neder.record: Andrea Nuyt         37,54
#Baanrecord  : Jenny Wolf          37,72

 my $D1000m_2010 = [ [],
[ 1, 'CAnbt', 76.56],
[ 2, 'NLagt', 76.58],
[ 3, 'NLvrs', 76.72],
[ 4, 'CAgrv', 76.78],
[ 5, 'JPkdr', 76.80],
[ 6, 'NLbor', 76.94],
[ 7, 'USrdr', 77.08],
[ 8, 'NLwst', 77.28],
[ 9, 'USrch', 77.37],
[10, 'NObkk', 77.43],
[11, 'RUsjc', 77.46],
[12, 'CZerb', 77.53] ];
#Winnaar 2006: Marianne Timmer
#Wereldrecord: Cindy Klassen     1.13,11
#Neder.record: Ireen W&uuml;st   1.13,83
#Baanrecord  : Christine Nesbitt 1.16,28

 my $D1500m_2010 = [ [],
[ 1, 'NLwst', [60+56.89, 'BR']],
[ 2, 'CAgrv', 60+57.14],
[ 3, 'CZsbl', 60+57.97],
[ 4, 'NLbor', 60+58.10],
[ 5, 'JPkdr', 60+58.20],
[ 6, 'CAnbt', 60+58.33],
[ 7, 'NLagt', 60+58.46],
[ 8, 'RUsjc', 60+58.54],
[ 9, 'DEfrs', 60+58.67],
[10, 'DEans', 60+58.85],
[11, 'RUlbs', 60+59.02],
[18, 'NLvrs', 60+59.79] ];
#Winnaar 2006: Cindy Klassen
#Wereldrecord: Cindy Klassen     1.51,79
#Neder.record: Ireen Wust        1.52,38
#Baanrecord  : Christine Nesbitt 1.56,89

 my $D3km_2010 = [ [],
[ 1, 'CZsbl', [4*60+ 2.53, 'BR']],
[ 2, 'DEbck', 4*60+ 4.62],
[ 3, 'CAgrv', 4*60+ 4.84],
[ 4, 'DEans', 4*60+ 4.90],
[ 5, 'CAhgh', 4*60+ 6.01],
[ 6, 'JPhzm', 4*60+ 7.36],
[ 7, 'NLwst', 4*60+ 8.09],
[ 8, 'NOmhg', 4*60+10.01],
[ 9, 'USswp', 4*60+11.16],
[10, 'NLgrn', 4*60+11.25],
[11, 'NLvlk', 4*60+11.71],
[12, 'USrkr', 4*60+13.05] ];

 my $D5km_2010 = [ [],
[ 1, 'CZsbl', [6*60+50.91, 'BR']],
[ 2, 'DEbck',  6*60+51.39],
[ 3, 'CAhgh',  6*60+55.73],
[ 4, 'DEans',  6*60+58.64],
[ 5, 'NOmhg',  7*60+ 2.19],
[ 6, 'CAgrv',  7*60+ 4.57],
[ 7, 'JPhzm',  7*60+ 4.96],
[ 8, 'USrkr',  7*60+ 7.48],
[ 9, 'JPizw',  7*60+12.23],
[10, 'NLjvr',  7*60+13.27],
[11, 'NLedv',  7*60+16.68] ];
#Winnaar 2006: Clara Hughes
#Wereldrecord: Martina Sablikova 6.45,61
#Neder.record: Gretha Smit       6.49,22
#Baanrecord  : Martina Sablikova 6.57,84

 my $Dteampursuit_2010 = [ [],
[1, ['DE', 'Ansch&uuml;tz, Beckert, Mattscherodt'], 3*60+ 2.81],
[2, ['JP', 'Hozumi, Kodaira, Tabata'],3*60+ 2.84],
[3, ['PL', 'Bachleda, Wozniak, Zlotkowska'], 3*60+ 3.73],
[4, ['US', 'Raney, Rodriguez, Rookard'], 3*60+ 5.30],
[5, ['CA', 'Groves, Nesbitt, Schussler'], [3*60+ 1.41, 'OR']],
[6, ['NL', 'Valkenburg, Voorhuis, W&uuml;st'], 3*60+ 2.04],
[7, ['RU', 'Lobysjeva, Sjabanova, Sjichova'], 3*60+ 6.47],
[8, ['KR', 'Lee Ju-youn, Noh Seon-yeong, Park Do-yeon'], 3*60+ 6.96] ];
#Winnaar 2006: Duitsland
#Wereldrecord: Canada            2.55,79
#Neder.record: Van Deutekom, De Vries, Wust        2.57,36

# Medaille-spiegel:
# 1. Canada           14          7          5         26
# 2. Duitsland        10         13          7         30
# 3. Verenigde Staten  9         15         13         37
# 4. Noorwegen         9          8          6         23
# 5. Zuid-Korea        6          6          2         14
# 6. Zwitserland       6          0          3          9
# 7. China             5          2          4         11
# 8. Zweden            5          2          4         11
# 9. Oostenrijk        4          6          6         16
#10. Nederland         4          1          3          8
#11. Rusland           3          5          7         15
#12. Frankrijk         2          3          6         11
#13. Australie         2          1          0          3
#14. Tsjechie          2          0          4          6
#15. Polen             1          3          2          6
#16. Italie            1          1          3          5
#17. Wit-Rusland       1          1          1          3
#18. Slowakije         1          1          1          3
#19. Groot-Brittannie  1          0          0          1
#20. Japan             0          3          2          5
#21. Kroatie           0          2          1          3
#22. Slovenie          0          2          1          3
#23. Letland           0          2          0          2
#24. Finland           0          1          4          5
#25. Estland           0          1          0          1
#26. Kazachstan        0          1          0          1

 my $out = format_os(
  [$H500m_2010, $H1000m_2010, $H1500m_2010, $H5km_2010, $H10km_2010,
   $D500m_2010, $D1000m_2010, $D1500m_2010, $D3km_2010, $D5km_2010,
   $Hteampursuit_2010, $Dteampursuit_2010]);

 my $title = 'Schaatsen OS 2010 Vancouver';
 return maintxt2htmlpage(OSTopMenu(2010) . $out, $title, 'title2h1',
  20100302, {type1 => 'std_menu'});
}

sub get_one_distance($$$)
{
  my $DH       = shift;
  my $distance = shift;
  my $allData  = shift;

  my @data = ([]);
  foreach my $line (@$allData)
  {
    if ($line->{DH} eq $DH && $line->{distance} eq $distance)
    {
      my $result = $line->{result};
      if ($result =~ m/;/)
      {
        my @parts = split(';', $result);
        push(@data, [$line->{ranking}, $line->{name}, @parts]);
      }
      else
      {
        if (defined($line->{remark}))
        {
          $result = [$result, $line->{remark}];
        }
        my $name = $line->{name};
        if (defined ($line->{team}))
        {
          $line->{team} =~ s/; /, /g;
          $name = [$name, $line->{team}];
        }
        push(@data, [$line->{ranking}, $name, $result]);
      }
    }
  }
  return (scalar @data > 1 ? \@data : []);
}

sub get_all_distances($)
{
  my $cvsFile = shift;

  my $allResults = read_csv_with_header($cvsFile);

  my $H500m = get_one_distance('H', '500m', $allResults);
  my $H1000m = get_one_distance('H', '1000m', $allResults);
  my $H1500m = get_one_distance('H', '1500m', $allResults);
  my $H5km = get_one_distance('H', '5km', $allResults);
  my $H10km = get_one_distance('H', '10km', $allResults);

  my $D500m = get_one_distance('D', '500m', $allResults);
  my $D1000m = get_one_distance('D', '1000m', $allResults);
  my $D1500m = get_one_distance('D', '1500m', $allResults);
  my $D5km = get_one_distance('D', '5km', $allResults);
  my $D3km = get_one_distance('D', '3km', $allResults);

  my $Hteampursuit = get_one_distance('H', 'teampursuit', $allResults);
  my $Dteampursuit = get_one_distance('D', 'teampursuit', $allResults);
  my $HmassaStart = get_one_distance('H', 'massaStart', $allResults);
  my $DmassaStart = get_one_distance('D', 'massaStart', $allResults);
 
  my @games = ($H500m, $H1000m, $H1500m, $H5km, $H10km,
           $D500m, $D1000m, $D1500m, $D3km, $D5km);

  if (scalar @$Hteampursuit) {push @games, $Hteampursuit;}
  if (scalar @$Dteampursuit) {push @games, $Dteampursuit;}
  if (scalar @$HmassaStart) {push @games, $HmassaStart;}
  if (scalar @$DmassaStart) {push @games, $DmassaStart;}

  return \@games;
}

sub get_OS2014
{
  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2014.csv');
  my $OS2014 = get_all_distances($cvsFile);
  my $out = format_os($OS2014);

  my $title = 'Schaatsen OS 2014 Sotsji (Sochi; Rusland)';
  return maintxt2htmlpage(OSTopMenu(2014) . $out, $title, 'title2h1',
    20150912, {type1 => 'std_menu'});
}

sub get_OS2018
{
  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2018.csv');
  my $OS2018 = get_all_distances($cvsFile);
  my $out = format_os($OS2018);

  my $title = 'Schaatsen OS 2018 PyeongChang (Zuid-Korea)';
  return maintxt2htmlpage(OSTopMenu(2018) . $out, $title, 'title2h1',
    20180318, {type1 => 'std_menu'});
}

return 1;

