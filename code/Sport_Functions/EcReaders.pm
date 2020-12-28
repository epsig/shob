package Sport_Functions::EcReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Overig;
use Sport_Functions::Readers;
use Sport_Functions::ListRemarks qw($ec_remarks);
use Shob_Tools::Error_Handling;
use Shob_Tools::Idate;
use File::Spec;
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
 '&add_one_line',
 #========================================================================
);

# (c) Edwin Spee

my $subdir = 'europacup';

sub leagueIsActive($$)
{
  my $content = shift;
  my $league  = shift;

  foreach my $struct (@$content)
  {
    if ($struct->{league} eq $league)
    {
      return 1;
    }
  }
  return 0;
}

sub read_ec_csv($$)
{
  my $filein = shift;
  my $szn    = shift;

  my $fileWithPath = File::Spec->catfile($csv_dir, $subdir, $filein);

  my $content = read_csv_with_header($fileWithPath);

  my $dateTimeLog = qx/git log -1 --pretty="format:%ci" $fileWithPath/;
  
  my $date;
  if (length($dateTimeLog) > 0)
  {
    $date = substr($dateTimeLog, 0, 10);
    $date =~ s/-//g;
  }
  else
  { # apparently file is not added yet, so very new:
    my $today = todaystr();
    $date = str2itdate($today);
  }

  my $sort_rule = $ec_remarks->get($szn, 'sort_rule');
  if (not $sort_rule) {$sort_rule = 5;} # default value
  my $pnt_telling = ($szn le '1994-1995' ? 2 : 1);
  
  my $wnsCL = $ec_remarks->get($szn, 'wns_CL');

  my $voorr_CL_voorronde = $ec_remarks->get($szn, 'voorr_CL_voorronde');
  
  my $remark_extra = $ec_remarks->get_ml_keyStartsWith($szn, 'remark', 2);
  
  my $sc = read_ec_part('supercup', '', 1, 'Europese Supercup', $sort_rule, $content);

  my $ec = {
    extra => {
       dd => $date,
       supercup => $sc,
       }
    };

  my @leagues     = ('CL', 'EC2', 'EL', 'UEFAcup');
  my %long_names  = ('CL' => 'Champions League', 'EL' => 'Europa League', 'UEFAcup' => 'UEFA cup', 'EC2' => 'EC-II');
  my %short_names = ('CL' => 'C-L', 'EL' => 'E-L', 'UEFAcup' => 'UEFA-cup', 'EC2' => 'EC-II');
  my %keys        = ('CL' => 'CL', 'EL' => 'EuropaL', 'UEFAcup' => 'UEFAcup', 'EC2' => 'CWC');

  foreach my $league (@leagues)
  {
    my $longname  = $long_names{$league};
    my $shortname = $short_names{$league};
    my $key       = $keys{$league};

    if ( ! leagueIsActive($content, $league)) {next;}

    $ec->{$key} = {
        itoto        => read_ec_part($league,  'itoto', 1, "Intertoto: laatste zestien", $sort_rule, $content, $pnt_telling),
        intertoto    => read_ec_part($league,  'intertoto', 1, "Finale Intertoto (winnaars naar UEFA-cup)", $sort_rule, $content, $pnt_telling),
        playoffs     => read_ec_part($league,  'po', 1, "play offs $longname", $sort_rule, $content, $pnt_telling),
        round1       => read_ec_part($league, 'round1', 1, "1e ronde $shortname", $sort_rule, $content, $pnt_telling),
        round2       => read_ec_part($league, '16f', 1, "2e ronde $shortname", $sort_rule, $content, $pnt_telling),
        round3       => read_ec_part($league, 'round3', 1, "3e ronde $shortname", $sort_rule, $content, $pnt_telling),
        group2B      => read_ec_part($league, 'group2B', 0, "Tweede ronde, Poule B", $sort_rule, $content, $pnt_telling),
        group2D      => read_ec_part($league, 'group2D', 0, "Tweede ronde, Poule D", $sort_rule, $content, $pnt_telling),
        round_of_16  => read_ec_part($league,  '8f', 1, "8-ste finale $shortname", $sort_rule, $content, $pnt_telling),
        quarterfinal => read_ec_part($league,  '4f', 1, "kwart finale $shortname", $sort_rule, $content, $pnt_telling),
        semifinal    => read_ec_part($league,  '2f', 1, "halve finale $shortname", $sort_rule, $content, $pnt_telling),
        final        => read_ec_part($league,   'f', 1, "finale $shortname", $sort_rule, $content, $pnt_telling),
      };

    foreach my $l (1 .. 3)
    {
      my $title = "${l}e voorronde $longname";
      $title = $voorr_CL_voorronde if ($voorr_CL_voorronde);
      my $voorr = read_ec_part($league,  "v$l", 1, $title, $sort_rule, $content, $pnt_telling);
      if (defined($voorr))
      {
        $ec->{$key}{"qfr_$l"} = $voorr;
      }
    };

    foreach my $l ('A'..'L')
    {
      my $title = ($league eq 'UEFAcup' ? "Groepsfase UEFA-cup, Poule $l": "$longname, Groep $l");
      my $g = read_ec_part($league, "g$l", 0, $title, $sort_rule, $content, $pnt_telling);

      if (defined($g))
      {
        if ($wnsCL)
        {
          my $pos = index($wnsCL, $l);
          if (length($wnsCL) == 1)
          {
            $g->[0][1][3] = $wnsCL;
          }
          elsif ( $pos >= 0)
          {
            my $wns = substr($wnsCL, 2+$pos, 1);
            $g->[0][1][3] = $wns;
          }
        }
        if (ref $remark_extra eq 'HASH')
        {
          if (defined $remark_extra->{"remark_CL_g$l"})
          {
            $g->[0][1][4] = $remark_extra->{"remark_CL_g$l"};
          }
        }
        $ec->{$key}{"group$l"} = $g;
      }
    }
  }

  my $summaryNL = $ec_remarks->get_ml($szn, 'summary_NL', 1);
  my $summaryUK = $ec_remarks->get_ml($szn, 'summary_UK', 1);

  if ($summaryNL ne '')
  {
    $ec->{extra}->{summary} = $summaryNL;
  }
  if ($summaryUK ne '')
  {
    $ec->{extra}->{summaryUK} = $summaryUK;
  }

  return $ec;
}

sub read_ec_part($$$$$$$)
{
  my $cupname     = shift;
  my $phase       = shift;
  my $isko        = shift;
  my $title       = shift;
  my $sort_rule   = shift;
  my $content     = shift;
  my $pnt_telling = shift;

  my @games = ( $phase =~ m/^g/iso ? ['', [$pnt_telling, $sort_rule, $title, -1]] : [$title] );

  my $total = 0;

  foreach my $struct (@$content)
  {
    if ($struct->{league} eq $cupname && ($phase eq '' || $struct->{round} eq $phase))
    {
      $total += add_one_line(\@games, $struct, $isko);
    }
  }

  if ($total == 12)
  {
    $games[0][1][3] = ($cupname eq 'CL' && $phase !~ m/^group2.$/ ? 2 : 1);
  }
  elsif ($total == 10 && $cupname eq 'UEFAcup' && $phase =~ m/^g/iso)
  {
    $games[0][1][3] = 5;
  }

  return (scalar @games > 1 ? \@games : undef);
}

sub add_one_line($$$)
{
  my $games  = shift;
  my $struct = shift;
  my $isko   = shift;

  if ($struct->{team2} eq 'straf')
  {
    push_or_extend($games, [$struct->{team1}, 'straf', $struct->{dd}, $struct->{result}], $isko);
    return 0;
  }

  my ($aa, $bb)= result2aabb($struct->{result});
  my ($a, $b);
  if (defined($struct->{club1})) {$a = $struct->{club1};}
  if (defined($struct->{club2})) {$b = $struct->{club2};}
  if (defined($struct->{team1})) {$a = $struct->{team1};}
  if (defined($struct->{team2})) {$b = $struct->{team2};}
  my $dd = $struct->{dd};

  my @match_result = ($dd, $aa, $bb);

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
    else
    {
      push @match_result, {opm =>$opm};
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
