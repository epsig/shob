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
use Sport_Functions::AddMatch qw(&result2aabb &add_one_line);
use Shob_Tools::Html_Stuff;
use File::Spec;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.0';
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

  my $NLfile = File::Spec->catfile('..', 'data', 'sport', 'nationsLeague', $csvFile);
  my $NLraw = read_csv_with_header($NLfile);
  my @games = ([['Groep A'], [1, 5, '', $ster]]);
  foreach my $game (@$NLraw)
  {
    add_one_line(\@games, $game, 0);
  }

  return \@games;
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

  my $NLfile = File::Spec->catfile('..', 'data', 'sport', 'nationsLeague', $csvFile);
  my $NLraw = read_csv_with_header($NLfile);
  my @uf = (['final']); my @uh = (['semi final']); my @f34 = (['bronze']);
  foreach my $game (@$NLraw)
  {
    if ($game->{phase} eq '2f')
    {
      add_one_line(\@uh, $game, 1);
    }
    elsif ($game->{phase} eq 'f')
    {
      add_one_line(\@uf, $game, 1);
    }
    elsif ($game->{phase} eq 'f34')
    {
      add_one_line(\@f34, $game, 1);
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

return 1;
