package Sport_Functions::AddMatch;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Error_Handling qw(&shob_error);
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
 '&add_one_line',
 '&result2aabb',
 #========================================================================
);

# (c) Edwin Spee

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

sub fill_club_team_land($)
{
  my $struct = shift;

  my ($a, $b);

  if (defined($struct->{club1}))
  {
    if (defined($struct->{club2}))
    {
      $a = $struct->{club1};
      $b = $struct->{club2};
    }
  }
  elsif (defined($struct->{team1}))
  {
    if (defined($struct->{team2})) 
    {
      $a = $struct->{team1};
      $b = $struct->{team2};
    }
  }
  elsif (defined($struct->{land1}))
  {
    if (defined($struct->{land2})) 
    {
      $a = $struct->{land1};
      $b = $struct->{land2};
    }
  }

  if (not defined ($a))
  {
    shob_error('strange_else', ['club/team/land not found']);
  }

  return ($a, $b);
}
sub add_one_line($$$)
{
  my $games  = shift;
  my $struct = shift;
  my $isko   = shift;

  my ($a, $b) = fill_club_team_land($struct);

  my $dd = $struct->{dd};

  if ($b eq 'straf')
  {
    push_or_extend($games, [$a, 'straf', $dd, $struct->{result}], $isko);
    return 0;
  }

  my ($aa, $bb)= result2aabb($struct->{result});

  my @match_result = ($dd, $aa, $bb);

  if (defined $struct->{spectators} && defined($struct->{remark}))
  {
    push @match_result, {opm=>$struct->{remark},publiek=>$struct->{spectators}};
  }
  else
  {
    if (defined $struct->{spectators})
    {
      if ($struct->{spectators} >= 0)
      {
        push @match_result, $struct->{spectators};
      }
    }
    if (defined($struct->{remark}))
    {
      my $opm = $struct->{remark};
      if ($opm =~ /\{.*\}/)
      {
        my $test;
        $opm =~ s/;/,/g ;
        my $cmd = "\$test = $opm;";
        eval($cmd);
        push @match_result, $test;
      }
      elsif ($struct->{remark} eq 'afgelast')
      {
        push @match_result, {afgelast => 1};
      }
      else
      {
        push @match_result, {opm =>$opm};
      }
    }
  }
  my @result = ($a, $b, \@match_result);

  if (defined($struct->{star}))
  {
    push @result, $struct->{star};
    if (defined($struct->{stadium}))
    {
      push @result, $struct->{stadium};
    }
  }
  elsif (defined($struct->{stadium}))
  {
    push @result, (-1, $struct->{stadium});
  }

  push_or_extend($games, \@result, $isko);

  return ( $aa >= 0 ? 1 : 0)
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
      if (ref $cmp_result->[3] eq 'ARRAY')
      { # fix for best-of-three
        next;
      }
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
