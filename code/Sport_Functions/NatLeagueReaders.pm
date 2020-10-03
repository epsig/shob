package Sport_Functions::NatLeagueReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Readers;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Results2Standing;
use Shob_Tools::Html_Stuff;
use File::Spec;
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
  '&ReadNatLeague',
  '&NatLeague2Html',
  '&ReadNatLeagueFinals',
  '&NatLeagueFinals2Html',
 #========================================================================
);

# (c) Edwin Spee
sub ReadNatLeague($$)
{
  my $csvFile = shift;
  my $ster    = shift;

  my $NLfile = File::Spec->catfile('Sport_Data', 'nationsLeague', $csvFile);
  my $NLraw = read_csv_file($NLfile);
  $NLraw->[0] = [ ['Groep A'], [1, 5, '', $ster]];
  for(my $i = 1; $i < scalar @$NLraw; $i++)
  {
    my $a = $NLraw->[$i]->[0];
    my $b = $NLraw->[$i]->[1];
    my $dd = $NLraw->[$i]->[2];
    my $result = $NLraw->[$i]->[3];
    my @results = split('-', $result);
    my $u = [$a, $b, [$dd, $results[0], $results[1]]];
    $NLraw->[$i] = $u;
  }

  return $NLraw;
}

sub NatLeague2Html($)
{
  my $NLraw = shift;

  my $td1 = get_uitslag($NLraw, {cols => 1, ptitel => [2, 'Uitslagen groep A']});

  my $args_u2s = $NLraw->[0][1];
  my $s_nl = u2s($NLraw,  @$args_u2s);
  my $td2 = get_stand($s_nl, 2, 0,[2, 'Stand Groep A']);
  
  my $table = get2tables($td1, $td2);
  my $block = qq(<h2>Nations League, groep met Nederland</h2>\n);
  return $block . $table;
}

sub ReadNatLeagueFinals($)
{
  my $csvFile = shift;

  my $NLfile = File::Spec->catfile('Sport_Data', 'nationsLeague', $csvFile);
  my $NLraw = read_csv_file($NLfile);
  my @uf = (['final']); my @uh = (['semi final']); my @f34 = (['bronze']);
  for(my $i = 1; $i < scalar @$NLraw; $i++)
  {
    my $phase = $NLraw->[$i]->[0];
    my $a = $NLraw->[$i]->[1];
    my $b = $NLraw->[$i]->[2];
    my $dd = $NLraw->[$i]->[3];
    my $result = $NLraw->[$i]->[4];
    my $ster = $NLraw->[$i]->[5];
    my @results = split('-', $result);
    my $u = [$a, $b, [$dd, $results[0], $results[1]], $ster];
    if ($phase eq '2f')
    {
      push @uh, $u;
    }
    elsif ($phase eq 'f')
    {
      push @uf, $u;
    }
    elsif ($phase eq 'f34')
    {
      push @f34, $u;
    }
  }

  my $pu   = {uh => \@uh, u34 => \@f34, uf => \@uf};
  return $pu;
}

sub NatLeagueFinals2Html($)
{
  my $pu = shift;  

  my $out  = qq(<h2>Finale Nations League</h2>);
     $out .= get_last16($pu);
  return $out;
}
