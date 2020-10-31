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

sub initTestCode()
{
  $shortNames{'qfr_3'} = 'v3';
  $shortNames{'playoffs'} = 'po';
  $shortNames{'round_of_16'} = '16f';
  $shortNames{'quarterfinal'} = '4f';
  $shortNames{'semifinal'} = '2f';
  $shortNames{'final'} = 'f';  
  $shortNames{'CL'} = 'CL';
  $shortNames{'EuropaL'} = 'EL';
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
  my $stadium = $u[5];
  if (not defined $wns) {$wns = '';}
  if (not defined $stadium) {$stadium = '';}
  my $result1 = $a1[1] . '-' . $a1[2];

  if (defined($a2) && ref $a2 eq 'ARRAY')
  {
    print OUT join(',', $shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, -1, $stadium) , "\n";
    my @a2 = @$a2;
    my $result2 = $a2[1] . '-' . $a2[2];
    print OUT join(',', $shortLeague, $shortRound, $u[1], $u[0], $a2[0], $result2, $wns, $stadium) , "\n";
  }
  elsif (defined($a2))
  {
    $wns = $a2;
    $stadium = $u[4];
    print OUT join(',', $shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, $wns, $stadium) , "\n";
  }
  else
  {
    print OUT join(',', $shortLeague, $shortRound, $u[0], $u[1], $a1[0], $result1, $wns, $stadium) , "\n";
  }
}

sub test_something()
{ use Sport_Functions::Overig;
  use Sport_Collector::Archief_Europacup_Voetbal;

  # print "place holder for tmp/test function.\n";

  my @Leagues = ('extra', 'CL', 'EuropaL');
  my @rounds = ('supercup', 'v2', 'qfr_3', 'playoffs', ('groupA'..'groupL'), 'round_of_16', 'quarterfinal', 'semifinal', 'final');

  initTestCode();

  foreach my $yr (2016 .. 2016)
  {
    my $szn = yr2szn($yr);
    my $outfile  = "Sport_Data/europacup/europacup_$szn.csv";
       $outfile =~ s/-/_/;

    open (OUT, "> $outfile ") or die "can't open $outfile: $!.\n";
    print OUT "league,round,team1,team2,dd,result,star,stadium\n";

    my $uCur = $u_ec->{$szn};
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
  }
}

1;
