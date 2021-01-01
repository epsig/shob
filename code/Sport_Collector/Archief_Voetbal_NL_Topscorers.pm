package Sport_Collector::Archief_Voetbal_NL_Topscorers;
use strict; use warnings;
use Sport_Functions::Readers;
use Sport_Functions::Overig;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_topscorers_eredivisie',
 '&init_tp_eerste_divisie',
 '$topscorers_eerstedivisie',
 #========================================================================
);

my $contentAllFiles = {};

sub read_topscorers_new($$)
{
  my $seizoen = shift;
  my $divisie = shift;

  my $found_season = 0;

  if (not defined $contentAllFiles->{$divisie})
  {
    my $fullname = File::Spec->catdir($csv_dir, $divisie, "topscorers_$divisie.csv");
    $contentAllFiles->{$divisie} = read_csv_with_header($fullname);
  }

  my $content = $contentAllFiles->{$divisie};

  my @tp_list = (['Topscorers ' . ucfirst($divisie)]);

  foreach my $line (@$content)
  {
    if ($line->{season} eq $seizoen)
    {
      push @tp_list, [$line->{rank}, $line->{name}, $line->{club}, $line->{total}];
      $found_season = 1;
    }
  }

  return (\@tp_list) if $found_season;
  return ([]);
}

sub read_topscorers($$)
{
  my $seizoen = shift;
  my $divisie = shift;

  if (not defined $contentAllFiles->{$divisie})
  {
    my $fullname = File::Spec->catdir($csv_dir, $divisie, "topscorers_$divisie.csv");
    $contentAllFiles->{$divisie} = read_csv_file($fullname);
  }

  my $content = read_csv_file_szn($contentAllFiles->{$divisie}, $seizoen);
  my @tp_list;
  while(my $line = shift(@$content))
  {
    my @parts = @$line;
    if ($parts[0] eq 'title')
    {
      push @tp_list, [$parts[1]];
    }
    else
    {
      push @tp_list, $line;
    }
  }
  return (\@tp_list);
}

sub init_tp_eerste_divisie()
{
  for(my $year=2000; $year<=2019; $year++)
  {
    my $szn = yr2szn($year);
    our $topscorers_eerstedivisie->{$szn} = read_topscorers($szn, 'eerste_divisie');
  };
}

sub get_topscorers_eredivisie($)
{ # (c) Edwin Spee
  # (vrijwel) dezelfde versie als standen_eredivisie

  #Most times top goal scorer:
  #1 Geels              5
  #2 Van Basten         4
  #3 Kindvall           3
  #  Van der Kuijlen    3
  #  Romario            3

  my ($seizoen) = @_;

  return read_topscorers_new($seizoen, 'eredivisie');
}

return 1;
