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
        foreach my $part (@parts)
        {
          if ($part =~ m/ /)
          {
            my @innerParts = split(' ', $part);
            $part = \@innerParts;
          }
        }
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

sub get_OS2002()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2002.csv');
  my $OS2002 = get_all_distances($cvsFile);

  my $out = qq(<a href="http://www.slc2002.org/">Offici&euml;le site</a>\n<hr>) . format_os($OS2002);

  my $title = 'Schaatsen OS 2002 Salt Lake City';

  return maintxt2htmlpage(OSTopMenu(2002) . $out, $title, 'title2h1',
    20050312, {type1 => 'std_menu'});
}

sub get_OS2006()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2006.csv');
  my $OS2006 = get_all_distances($cvsFile);

  my $out = format_os($OS2006);

  my $title = 'Schaatsen OS 2006 Turijn';
    return maintxt2htmlpage(OSTopMenu(2006) . $out,$title, 'title2h1',
      20100302, {type1 => 'std_menu'});
}

sub get_OS2010
{
  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2010.csv');
  my $OS2010 = get_all_distances($cvsFile);
  my $out = format_os($OS2010);

  my $title = 'Schaatsen OS 2010 Vancouver';
  return maintxt2htmlpage(OSTopMenu(2010) . $out, $title, 'title2h1',
    20201206, {type1 => 'std_menu'});
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

