package Sport_Functions::Readers;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::XML;
use Sport_Functions::Overig;
use File::Spec;
use XML::Parser;
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
 '&read_csv_file',
 '&read_csv_file_szn',
 '&read_csv',
 '$csv_dir',
 '&result2aabb',
 #========================================================================
);

# (c) Edwin Spee

our $csv_dir = 'Sport_Data';

# reads a csv file and returns it as a list of lists
# comments (everything after a #) and newlines are removed
sub read_csv_file($)
{
 my $fullname = shift;
 my @content;

 open(IN, "<$fullname") or die "can't open file $fullname for reading: $!";
 while(my $line = <IN>)
 {
  chomp($line);
  $line =~ s/ *#.*//;
  if ($line eq '') {next;}
  $line =~ s/^ +//;
  my @parts = split(' *, *', $line);
  push @content, \@parts;
 }
 close(IN);
 return \@content;
}

# converts a string like '3-2' into [3,2]
# and '-' into [-1,-1]
sub result2aabb($)
{
  my $result = shift;

  my @results;
  if ($result eq '-')
  {
    @results = (-1,-1);
  }
  else
  {
    @results = split('-', $result);
  }
  return @results;
}

sub read_csv_file_szn($$)
{
 my $fullname = shift;
 my $seizoen = shift;

 my $content = read_csv_file($fullname);
 my $active = 0;
 my @content_szn;
 while(my $line = shift(@$content))
 {
  my @parts = @$line;
  if ($parts[0] =~ m/:$/)
  {
   $active = ($parts[0] =~ m/$seizoen/ ? 1 : 0);
  }
  elsif ($active)
  {
   push @content_szn, $line;
  }
 }
 return (\@content_szn);
}

sub read_csv($)
{
 my $filein = shift;
 my $fullname = File::Spec->catdir($csv_dir, $filein);

 my $aabb = 1;
 my @games;
 $games[0] = [''];
 my $content = read_csv_file($fullname);

 my $header = $content->[0];
 if ($header->[2] eq 'dd')
 {
  if ($header->[3] =~ m/result/)
  {
   $aabb = 0;
  }
  shift(@$content);
 }

 while(my $line = shift(@$content))
 {
  my @values = @$line;
  my $a  = $values[0];
  my $b  = $values[1];
  my $dd = $values[2];
  my ($aa, $bb, $sp, $opm);
  if ($aabb)
  {
    $aa = $values[3];
    $bb = $values[4];
    $sp = $values[5];
    $opm = $values[6];
  }
  else
  {
    my $result = $values[3];
    my @results = result2aabb($result);
    $aa = $results[0];
    $bb = $results[1];
    $sp = $values[4];
    $opm = $values[5];
  }
  my $stadion;
  if (scalar(@values) > 5+$aabb)
  {
   for (my $i=5+$aabb; $i<scalar(@values); $i++)
   {
    if ($values[$i] eq 'dekuip')
    {$stadion = 'Rotterdam, de Kuip';}
    elsif ($values[$i] eq 'arena')
    {$stadion = 'Amsterdam, Arena';}
    if ($i == 5+$aabb and defined($stadion))
    {undef($opm);}
  }}
  my $game;
  if (scalar(@values) >=6+$aabb)
  {
   if (not defined($opm))
   {
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, stadion=>$stadion}]];
   }
   elsif ($opm eq 'afgelast')
   {
    $game = [$a, $b, [$dd, $aa, $bb, {afgelast => 1}]];
   }
   elsif ($opm =~ m/^wns=/)
   {
    my @parts = split /=/, $opm,2;
    my $wns = $parts[1];
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp}], $wns];
   }
   elsif ($opm =~ m/^stadion=/)
   {
    my @parts = split /=/, $opm,2;
    $stadion = $parts[1];
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, stadion=>$stadion}]];
   }
   else
   {
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, opm=>$opm, stadion=>$stadion}]];
   }
  }
  elsif (scalar(@values) >=5+$aabb)
  {
    if ($sp >= 0)
    {
      $game = [$a, $b, [$dd, $aa, $bb, $sp]];
    }
    else
    {
      $game = [$a, $b, [$dd, $aa, $bb]];
    }
  }
  elsif (scalar(@values) == 4+$aabb)
  {
   $game = [$a, $b, [$dd, $aa, $bb]];
  }
  elsif (scalar(@values) == 3+$aabb and $b eq 'straf')
  {
   $game = [$a, $b, $dd, $aa];
  }
  elsif (scalar(@values) == 2+$aabb)
  {
   $game = [$a, $b, [$dd]];
  }
  else
  {
   warn "unexpected line: $line.\n";
  }
  push @games, $game;
 }
 return \@games;
}

return 1;
