package Sport_Functions::EcReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Overig;
use Sport_Functions::Readers;
use Shob_Tools::Error_Handling;
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
 '&read_ec_csv',
 '&read_ec_part',
 '$IN',
 #========================================================================
);

# (c) Edwin Spee

our $IN;

sub read_ec_csv($)
{
  my $filein = shift;

  open ($IN, "< $csv_dir/$filein") or die "can't open $filein: $!";

  my $sc = read_ec_part('supercup','','Europese Supercup');
  my $cl_v2 = read_ec_part('CL','v2','2e voorronde Champions League');
  my $cl_v3 = read_ec_part('CL','v3','3e voorronde Champions League');
  my $cl_po = read_ec_part('CL','po','play offs Champions League');

  my $el_v2 = read_ec_part('EL','v2','2e voorronde Europa League');
  my $el_v3 = read_ec_part('EL','v3','3e voorronde Europa League');
  my $el_po = read_ec_part('EL','po','play offs Europa League');

  my $ec = {
    extra => { supercup => $sc },
    CL => {
      qfr_2 => $cl_v2,
      qfr_3 => $cl_v3,
      playoffs => $cl_po,
      round_of_16 => read_ec_part('CL','8f', '8-ste finale C-L'),
      quarterfinal => read_ec_part('CL','4f', 'kwart finale C-L'),
      semifinal => read_ec_part('CL','2f', 'halve finale C-L'),
      final => read_ec_part('CL','f', 'finale C-L'),
    },
    EuropaL => {
      qfr => $el_v2,
      qfr_3 => $el_v3,
      playoffs => $el_po,
      round2 => read_ec_part('EL','16f', '8-ste finale E-L'),
      round_of_16 => read_ec_part('EL','8f', '8-ste finale E-L'),
      quarterfinal => read_ec_part('EL','4f', 'kwart finale E-L'),
      semifinal => read_ec_part('EL','2f', 'halve finale E-L'),
      final => read_ec_part('EL','f', 'finale E-L'),
    }
  };

  my $summary = read_ec_summary('NL');
  if ($summary ne '') {$ec->{extra}->{summary} = $summary;}

  foreach my $l ('A'..'H')
  {
    my $g = read_ec_part('CL',"g$l","Champions League, Groep $l");
    if (defined($g))
    {
      $ec->{CL}{"group$l"} = $g;
    }
  }
 
  foreach my $l ('A'..'L')
  {
    my $g = read_ec_part('EL',"g$l","Europa League, Groep $l");
    if (defined($g))
    {
      $ec->{EuropaL}{"group$l"} = $g;
    }
  }
 
  close($IN);
  return $ec;
}

sub read_ec_part($$$)
{
  my $cupname = shift;
  my $phase   = shift;
  my $title   = shift;

  seek($IN, 0, 0);
  my @games;
  if ($phase =~ m/^g/iso) {
    $games[0] = ['', [1, 5, $title, -1]];
  } else {
    $games[0] = [$title];
  }
  my $aabb = 1;
  my $total = 0;
  my $dimheader;
  while(my $line = <$IN>)
  {
    chomp($line);
    $line =~ s/ *#.*//;
    if ($line eq '') {next;}

    if ($line =~ m/,dd,/)
    {
      if ($line =~ m/,result,/)
      {
        $aabb = 0;
      }
      $dimheader = scalar split(/,/, $line, -1);
    }

    my @parts = split(/,/, $line, -1);
    if (defined $dimheader)
    {
      if (scalar @parts != $dimheader)
      {
        shob_error('strange_else',["# cols wrong in $line"]);
      }
    }
    if ($parts[0] eq $cupname and $parts[1] eq $phase)
    {
      my $a  = $parts[2];
      my $b  = $parts[3];
      my $dd1 = $parts[4];
      my $aa1; my $bb1;
      if ($aabb)
      {
        $aa1 = $parts[5];
        $bb1 = $parts[6];
      }
      else
      {
        my @results = result2aabb($parts[5]);
        $aa1 = $results[0];
        $bb1 = $results[1];
      }
      my $dd2 = $parts[6+$aabb];
      my $aa2 = $parts[7+$aabb];
      my $bb2 = $parts[8+$aabb];
      my $wns = $parts[9+$aabb];
      if ($aa1 >= 0) {$total++;}
      if (defined($wns))
      {
        push @games, [$a,$b,[$dd1,$aa1,$bb1],[$dd2,$aa2,$bb2],$wns];
        if ($aa2 >= 0) {$total++;}
      }
      elsif (defined($aa2))
      {
        chomp($aa2);
        push @games, [$a,$b,[$dd1,$aa1,$bb1],$dd2,$aa2];
      }
      elsif (defined($dd2) && $dd2 ne '')
      {
        push @games, [$a,$b,[$dd1,$aa1,$bb1],$dd2];
      }
      elsif (defined($bb1))
      {
        push @games, [$a,$b,[$dd1,$aa1,$bb1]];
      }
    }
    elsif ($parts[0] eq $cupname and $phase eq '')
    {
      my $a  = $parts[1];
      my $b  = $parts[2];
      my $dd = $parts[3];
      my $aa; my $bb;
      if ($aabb)
      {
        $aa = $parts[4];
        $bb = $parts[5];
      }
      else
      {
        my @results = result2aabb($parts[4]);
        $aa = $results[0];
        $bb = $results[1];
      }
      my $wns = $parts[5+$aabb];
      my $opm = $parts[6+$aabb];
      my $stadium = $parts[7+$aabb];
      if (scalar @parts > 8+$aabb) {
        my $dd2 = $parts[6];
        my $aa2 = $parts[7];
        my $bb2 = $parts[8];
        my $wns = $parts[9];
        chomp($wns);
        push @games, [$a,$b,[$dd,$aa,$bb],[$dd2,$aa2,$bb2],$wns];
      } elsif (defined($stadium)) {
        chomp($stadium);
        push @games, [$a,$b,[$dd,$aa,$bb],$wns,$stadium];
      }
      elsif (defined($opm)) {
        push @games, [$a,$b,[$dd,$aa,$bb,opm=>$opm],$wns];
      } else {
        push @games, [$a,$b,[$dd,$aa,$bb],$wns];
      }
    }
  }

  #print "debug: $cupname $phase ", scalar @games, "\n";
  if ($total == 12)
  {
    if ($cupname eq 'CL')
    {
      $games[0] = ['', [1, 5, $title, 2]];
    }
    else
    {
      $games[0] = ['', [1, 5, $title, 1]];
    }
  }
 
  if (scalar @games > 1)
  {
    return \@games;
  } else {
    return undef;
  }
}

sub read_ec_summary($)
{
  my $lang = shift;

  my $retval = '';

  seek($IN, 0, 0);
  while (my $line = <$IN>)
  {
    $line =~ s/ *#.*//;
    if ($line eq '') {next;}

    my @parts = split /,/, $line;
    if ($parts[0] eq 'summary' and $parts[1] eq $lang)
    {
      $retval .= $parts[2];
    }
  }
  return $retval;
}

return 1;