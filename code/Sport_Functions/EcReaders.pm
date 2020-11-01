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
 #========================================================================
);

# (c) Edwin Spee

our $IN;
my $subdir = 'europacup';

sub read_ec_csv($$)
{
  my $filein = shift;
  my $szn    = shift;

  my $fileWithPath = File::Spec->catfile($csv_dir, $subdir, $filein);

  my $dateTimeLog = qx/git log -1 --pretty="format:%ci" $fileWithPath/;
  my $date = substr($dateTimeLog, 0, 10);
     $date =~ s/-//g;

  open ($IN, "< $fileWithPath") or die "can't open $$fileWithPath: $!\n";

  my $sc = read_ec_part('supercup', '', 1, 'Europese Supercup', $IN);
  my $cl_v2 = read_ec_part('CL', 'v2', 1, '2e voorronde Champions League', $IN);
  my $cl_v3 = read_ec_part('CL', 'v3', 1, '3e voorronde Champions League', $IN);
  my $cl_po = read_ec_part('CL', 'po', 1, 'play offs Champions League', $IN);

  my $el_v2 = read_ec_part('EL', 'v2', 1, '2e voorronde Europa League', $IN);
  my $el_v3 = read_ec_part('EL', 'v3', 1, '3e voorronde Europa League', $IN);
  my $el_po = read_ec_part('EL', 'po', 1, 'play offs Europa League', $IN);

  my $ec = {
    extra => {
       dd => $date,
       supercup => $sc,
       },
    CL => {
      qfr_2 => $cl_v2,
      qfr_3 => $cl_v3,
      playoffs => $cl_po,
      round_of_16 => read_ec_part('CL', '8f', 1, '8-ste finale C-L', $IN),
      quarterfinal => read_ec_part('CL', '4f', 1, 'kwart finale C-L', $IN),
      semifinal => read_ec_part('CL', '2f', 1, 'halve finale C-L', $IN),
      final => read_ec_part('CL', 'f', 1, 'finale C-L', $IN),
    },
    EuropaL => {
      qfr => $el_v2,
      qfr_3 => $el_v3,
      playoffs => $el_po,
      round2 => read_ec_part('EL', '16f', 1, '8-ste finale E-L', $IN),
      round_of_16 => read_ec_part('EL', '8f', 1, '8-ste finale E-L', $IN),
      quarterfinal => read_ec_part('EL', '4f', 1, 'kwart finale E-L', $IN),
      semifinal => read_ec_part('EL', '2f', 1, 'halve finale E-L', $IN),
      final => read_ec_part('EL', 'f', 1, 'finale E-L', $IN),
    }
  };

  my $summaryNL = ReadOpm($szn, 'summary_NL', 'EC');
  my $summaryUK = ReadOpm($szn, 'summary_UK', 'EC');

  if ($summaryNL ne '' or $summaryUK ne '')
  {
    $ec->{extra}->{summary} = $summaryNL;
    $ec->{extra}->{summaryUK} = $summaryUK;
  }

  foreach my $l ('A'..'H')
  {
    my $g = read_ec_part('CL', "g$l", 0, "Champions League, Groep $l", $IN);
    if (defined($g))
    {
      $ec->{CL}{"group$l"} = $g;
    }
  }
 
  foreach my $l ('A'..'L')
  {
    my $g = read_ec_part('EL', "g$l", 0, "Europa League, Groep $l", $IN);
    if (defined($g))
    {
      $ec->{EuropaL}{"group$l"} = $g;
    }
  }
 
  close($IN);
  return $ec;
}

sub read_ec_part($$$$$)
{
  my $cupname = shift;
  my $phase   = shift;
  my $isko    = shift;
  my $title   = shift;
  my $IN      = shift;

  seek($IN, 0, 0);
  my @games;
  if ($phase =~ m/^g/iso) {
    $games[0] = ['', [1, 5, $title, -1]];
  } else {
    $games[0] = [$title];
  }
  my $total = 0;
  my $dimheader;
  my @hdrParts;

  # check on new style header
  my $header = <$IN>;
  if ($header =~ m/,dd,/)
  {
    chomp($header);
    @hdrParts = split(/,/, $header, -1);
    $dimheader = scalar @hdrParts;
  }
  else
  {
    die("Found old style header: $header\n");
  }

  while(my $line = <$IN>)
  {
    chomp($line);
    $line =~ s/ *#.*//;
    if ($line eq '') {next;}

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
      my @results = result2aabb($parts[5]);
      my $aa1 = $results[0];
      my $bb1 = $results[1];
      my $dd2 = $parts[6];
      my $aa2 = $parts[7];
      if ($aa1 >= 0) {$total++;}
      my $opm = '';
      for (my $i=0; $i<$dimheader;$i++)
      {
        if ($hdrParts[$i] eq 'remark')
        {
          $opm = $parts[$i];
        }
      }
      if (defined($aa2) && $aa2 ne '')
      {
        push_or_extend(\@games, [$a,$b,[$dd1,$aa1,$bb1],$dd2,$aa2], $isko);
      }
      elsif (defined($dd2) && $dd2 ne '')
      {
        push_or_extend(\@games, [$a,$b,[$dd1,$aa1,$bb1],$dd2], $isko);
      }
      elsif (defined($bb1) and $opm ne '')
      {
        push_or_extend(\@games, [$a,$b,[$dd1,$aa1,$bb1,{opm=>$opm}]], $isko);
      }
      elsif (defined($bb1))
      {
        push_or_extend(\@games, [$a,$b,[$dd1,$aa1,$bb1]], $isko);
      }
    }
    elsif ($parts[0] eq $cupname and $phase eq '')
    {
      my $a  = $parts[1];
      my $b  = $parts[2];
      my $dd = $parts[3];
      my ($aa, $bb, $opm, $stadium);
      my @results = result2aabb($parts[4]);
      $aa = $results[0];
      $bb = $results[1];
      if ($dimheader > 7 && $hdrParts[6] eq 'stadium' && $hdrParts[7] eq 'remark')
      {
        $stadium = $parts[6];
        $opm = $parts[7];
      }
      elsif ($dimheader > 6 && $hdrParts[6] eq 'stadium')
      {
        $stadium = $parts[6];
      }
      else
      {
        $opm = $parts[6];
        $stadium = $parts[7];
      }

      if (defined $opm)
      {
        if ($opm =~ /\{.*\}/)
        {
          my $test;
          $opm =~ s/;/,/g ;
          my $cmd = "\$test = $opm;";
          eval($cmd);
          $opm = $test;
        }
        elsif ($opm ne '')
        {
          $opm = {opm => $opm};
        }
        else
        {
          undef $opm;
        }
      }

      my $wns = $parts[5];
      if (defined($opm) and defined($stadium) and $stadium ne '')
      {
        chomp($stadium);
        push_or_extend(\@games, [$a,$b,[$dd,$aa,$bb,$opm],$wns,$stadium], $isko);
      }
      elsif (defined($stadium) and $stadium ne '')
      {
        chomp($stadium);
        push_or_extend(\@games, [$a,$b,[$dd,$aa,$bb],$wns,$stadium], $isko);
      }
      elsif (defined($opm))
      {
        push_or_extend(\@games, [$a,$b,[$dd,$aa,$bb,$opm],$wns], $isko);
      }
      else
      {
        push_or_extend(\@games, [$a,$b,[$dd,$aa,$bb],$wns], $isko);
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

sub push_or_extend($$$)
{
  my $games  = shift;
  my $result = shift;
  my $isko   = shift;

  if ($isko)
  { # check whether or not this is the return of an earlier found game.
    # if so, keep them together and done.
    my $a = $result->[0];
    my $b = $result->[1];
    for(my $i=1; $i < scalar @$games; $i++)
    {
      my $cmp_result = $games->[$i];
      my $aa = $cmp_result->[0];
      my $bb = $cmp_result->[1];
      if ($a eq $bb and $b eq $aa)
      {
        for(my $j=2; $j < scalar @$result; $j++)
        {
          $cmp_result->[$j+1] = $result->[$j];
        }
        return;
      }
    }
  }

  push @$games, $result;
}

return 1;
