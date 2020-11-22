package ShobTest;
use strict; use warnings;
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
$VERSION = '20.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&test_something',
 #========================================================================
);

my %shortNames;
my $yr = 1998;
my $withOpm = 0;

sub initTestCode()
{
  $shortNames{'intertoto'} = 'intertoto';
  $shortNames{'qfr_1'} = 'v1';
  $shortNames{'qfr'} = 'v2';
  $shortNames{'qfr_3'} = 'v3';
  $shortNames{'playoffs'} = 'po';
  $shortNames{'round1'} = 'round1';
  $shortNames{'round2'} = '16f';
  $shortNames{'round3'} = 'round3';
  $shortNames{'group2B'} = 'group2B';
  $shortNames{'group2D'} = 'group2D';
  $shortNames{'round_of_16'} = '8f';
  $shortNames{'quarterfinal'} = '4f';
  $shortNames{'semifinal'} = '2f';
  $shortNames{'final'} = 'f';
  $shortNames{'CL'} = 'CL';
  $shortNames{'EuropaL'} = 'EL';
  $shortNames{'UEFAcup'} = 'UEFAcup';
  $shortNames{'CWC'} = 'EC2';
  foreach my $c ('A' .. 'L')
  {
    $shortNames{"group$c"} = "g$c";
  }
  $shortNames{'extra'} = 'supercup';
  $shortNames{'supercup'} = '';
}

sub u2csv($$$)
{
  my $league = shift;
  my $round  = shift;
  my $u      = shift;

  my $shortLeague = $shortNames{$league};
  my $shortRound  = $shortNames{$round};

  my @u = @$u;
  my $a1 = $u[2];
  my @a1 = @$a1;
  my $a2 = $u[3];
  my $wns = $u[4];
  my $stadium1 = $u[5];
  if (not defined $wns) {$wns = '';}
  if (not defined $stadium1) {$stadium1 = '';}
  my $result1 = $a1[1] . '-' . $a1[2];
  if ($a1[1] == -1 && $a1[2] == -1) {$result1 = '-';}

  my $opm1 = '';
  if (defined($a1[3]) && ref $a1[3] eq 'HASH')
  {
    $opm1 = $a1[3]->{opm};
    if (defined $opm1)
    {
      $opm1 =~ s/,/;/g;
      if (not $withOpm)
      {
        warn("Toch met opm.\n");
        $withOpm = 1;
      }
    }
    if (defined $a1[3]->{stadion})
    {
      $stadium1 = $a1[3]->{stadion};
    }
  }

  my $opm2 = '';
  my $stadium2 = '';

  my @base1 = ();
  my @base2 = ();
  if (defined($a2) && ref $a2 eq 'ARRAY')
  {
    @base1 = ($shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, -1);
    my @a2 = @$a2;
    my $result2 = $a2[1] . '-' . $a2[2];
    @base2 = ($shortLeague, $shortRound, $u[1], $u[0], $a2[0], $result2, $wns);

    if (defined($a2[3]) && ref $a2[3] eq 'HASH')
    {
      $opm2 = $a2[3]->{opm};
      if (defined $opm2)
      {
        $opm2 =~ s/,/;/g;
        if (not $withOpm)
        {
          warn("Toch met opm.\n");
          $withOpm = 1;
        }
      }
      if (defined $a2[3]->{stadium})
      {
        $stadium2 = $a2[3]->{stadium};
      }
    }
  }
  elsif (defined($a2))
  {
    $wns = $a2;
    if ($stadium1 eq '')
    {
      $stadium1 = (scalar @u > 4 ? $u[4] : '');
    }
    @base1 = ($shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, $wns);
  }
  else
  {
    @base1 = ($shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, $wns);
  }

  $stadium1 =~ s/,/;/g;
  $stadium2 =~ s/,/;/g;

  push @base1, $stadium1;
  if ($withOpm)
  {
    push @base1, $opm1;
  }
  print OUT join(',', @base1), "\n";

  if (@base2)
  {
    push @base2, $stadium2;
    if ($withOpm)
    {
      push @base2, $opm2;
    }
    print OUT join(',', @base2), "\n";
  }
}

sub test_something()
{ use Sport_Functions::Overig;
  use Sport_Collector::Archief_Europacup_Voetbal;

  # print "place holder for tmp/test function.\n";

  my @Leagues = ('extra', 'CL', 'CWC', 'EuropaL', 'UEFAcup');
  my @rounds = ('supercup', 'intertoto', 'v2', 'qfr_1', 'qfr', 'qfr_3', 'playoffs',
  'round1', ('groupA'..'groupL'), 'group2B', 'group2D', 'round2', 'round3', 'round_of_16',
  'quarterfinal', 'semifinal', 'final');

  initTestCode();

  foreach my $yr ($yr .. $yr)
  {
    my $szn = yr2szn($yr);
    my $outfile  = "Sport_Data/europacup/europacup_$szn.csv";
       $outfile =~ s/-/_/;

    my $uCur = get_u_ec($szn);
    for my $ii (1 .. 2)
    { # with without remarks; 2nd time correct with remarks if necessary
      open (OUT, "> $outfile ") or die "can't open $outfile: $!.\n";
      print OUT "league,round,team1,team2,dd,result,star,stadium";
      if ($withOpm)
      {
        print OUT ",remark";
      }
      print OUT "\n";

      foreach my $league (@Leagues)
      {
        if (defined($uCur->{$league}))
        {
          my $uLeague = $uCur->{$league};
          foreach my $round (@rounds)
          {
            if (defined($uLeague->{$round}))
            {
              print "Found $league $round.\n";
              my $comp = $uLeague->{$round};
              for (my $i=1; $i<scalar @$comp; $i++ )
              {
                my $u = $comp->[$i];
                u2csv($league, $round, $u);
              }
            }
          }
        }
      }
      close(OUT) or die "can't close $outfile: $!.\n";
      if ($withOpm == 0) {last;}
    }

    if (defined $uCur->{extra}{summary})
    {
      print "Found overall summary:\n";
      print $uCur->{extra}{summary};
      print "\n";
    }


  }
}

1;
