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
 #========================================================================
);

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

  my $distances;
  $distances->{H} = ['500m', '1000m', '1500m', '5km', '10km'];
  $distances->{D} = ['500m', '1000m', '1500m', '3km', '5km'];
  my @extras      = ('teampursuit', 'massaStart');

  my @games = ();
  foreach my $DH ('H', 'D')
  {
    foreach my $distance (@{$distances->{$DH}})
    {
      push @games, get_one_distance($DH, $distance, $allResults);
    }
  }
 
  foreach my $distance (@extras)
  {
    foreach my $DH ('H', 'D')
    {
      my $extra = get_one_distance($DH, $distance, $allResults);
      if (scalar @$extra)
      {
        push @games, $extra;
      }
    }
  }

  return \@games;
}

sub get_OS1994()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_1994.csv');
  my $OS1994 = get_all_distances($cvsFile);

  my $out = format_os($OS1994);

  my $title = 'Schaatsen OS 1994 Lillehammer; Vikingskip, Hamar';

  return maintxt2htmlpage(OSTopMenu(1994) . $out, $title, 'title2h1',
    20050319, {type1 => 'std_menu'});
}

sub get_OS1998()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_1998.csv');
  my $OS1998 = get_all_distances($cvsFile);

  my $out = format_os($OS1998);

  my $title = 'Schaatsen OS 1998 Nagano';
  return maintxt2htmlpage(OSTopMenu(1998) . $out, $title, 'title2h1',
    20050319, {type1 => 'std_menu'});
}

sub get_OS2002()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2002.csv');
  my $OS2002 = get_all_distances($cvsFile);

  my $out = format_os($OS2002);

  my $title = 'Schaatsen OS 2002 Salt Lake City';

  return maintxt2htmlpage(OSTopMenu(2002) . $out, $title, 'title2h1',
    20201212, {type1 => 'std_menu'});
}

sub get_OS2006()
{# (c) Edwin Spee

  my $cvsFile = File::Spec->catdir($csv_dir, 'schaatsen', 'OS_2006.csv');
  my $OS2006 = get_all_distances($cvsFile);

  my $out = format_os($OS2006);

  my $title = 'Schaatsen OS 2006 Turijn';

  return maintxt2htmlpage(OSTopMenu(2006) . $out, $title, 'title2h1',
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
