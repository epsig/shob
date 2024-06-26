package Sport_Functions::EcReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Overig;
use Sport_Functions::Readers;
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Functions::AddMatch qw(&add_one_line);
use Shob_Tools::Error_Handling;
use Shob_Tools::Idate;
use File::Spec;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&read_ec_csv',
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

  my $dateTimeLog;
  my $modified;
  if (exists $ENV{SERVER_NAME})
  {
    $dateTimeLog = '';
    $modified    = ''; 
  }
  else
  {
    $dateTimeLog = qx/git log -1 --pretty="format:%ci" $fileWithPath/;
    $modified    = qx/git status -s $fileWithPath/;
  }

  my $date;
  if (length($dateTimeLog) > 0 && $modified !~ /^ ?M/)
  {
    $date = substr($dateTimeLog, 0, 10);
    $date =~ s/-//g;
  }
  else
  { # apparently file is not added yet or modified, so very new:
    my $today = todaystr();
    $date = str2itdate($today);
  }

  my $ec_remarks = $all_remarks->{europacup};

  my $sort_rule = $ec_remarks->get($szn, 'sort_rule');
  if (not $sort_rule) {$sort_rule = 5;} # default value
  my $pnt_telling = ($szn le '1994-1995' ? 2 : 1);
  
  my $wnsCL = $ec_remarks->get($szn, 'wns_CL');

  my $voorr_CL_voorronde = $ec_remarks->get($szn, 'voorr_CL_voorronde');
  
  my $remark_extra = $ec_remarks->get_ml_keyStartsWith($szn, 'remark', 2);

  my $ec = {
    extra => { dd => $date }
    };
  
  my $sc = read_ec_part('supercup', '', 1, 'Europese Supercup', $sort_rule, $content);
  $ec->{extra}{supercup} = $sc if (defined $sc);

  my @leagues     = ('CL', 'EC2', 'EL', 'UEFAcup', 'CF');
  my %long_names  = ('CL' => 'Champions League', 'EL' => 'Europa League', 'UEFAcup' => 'UEFA cup', 'EC2' => 'EC-II', 'CF' => 'Conference League');
  my %short_names = ('CL' => 'C-L', 'EL' => 'E-L', 'UEFAcup' => 'UEFA-cup', 'EC2' => 'EC-II', 'CF' => 'Conf-L');
  my %keys        = ('CL' => 'CL', 'EL' => 'EuropaL', 'UEFAcup' => 'UEFAcup', 'EC2' => 'CWC', 'CF' => 'CF');

  foreach my $league (@leagues)
  {
    my $longname  = $long_names{$league};
    my $shortname = $short_names{$league};
    my $key       = $keys{$league};

    if ( ! leagueIsActive($content, $league)) {next;}

    my %finals;
    $finals{'xr'} = ['xr', "extra round $shortname"];
    $finals{'8f'} = ['round_of_16', "8-ste finale $shortname"];
    $finals{'4f'} = ['quarterfinal', "kwart finale $shortname"];
    $finals{'2f'} = ['semifinal', "halve finale $shortname"];
    $finals{'f'}  = ['final', "finale $shortname"];

    foreach my $l ('xr', '8f', '4f', '2f', 'f')
    {
      my $title = $finals{$l}[1];
      my $k     = $finals{$l}[0];
      my $result = read_ec_part($league, $l, 1, $title, $sort_rule, $content, $pnt_telling);
      if (defined $result)
      {
        $ec->{$key}{$k} = $result;
      }
    }

    my $playoffs = read_ec_part($league,  'po', 1, "play offs $longname", $sort_rule, $content, $pnt_telling);
    $ec->{$key}{playoffs} = $playoffs if defined $playoffs;

    foreach my $l ('itoto', 'intertoto')
    {
      my $title = ($l eq 'itoto' ? "Intertoto: laatste zestien" : "Finale Intertoto (winnaars naar UEFA-cup)");
      my $intertoto = read_ec_part($league, $l, 1, $title, $sort_rule, $content, $pnt_telling);
      if (defined $intertoto)
      {
        $ec->{$key}{$l} = $intertoto;
      }
    }

    foreach my $l ('B', 'D')
    {
      my $group2 = read_ec_part($league, "group2$l", 0, "Tweede ronde, Poule $l", $sort_rule, $content, $pnt_telling);
      if (defined $group2)
      {
        $ec->{$key}{"group2$l"} = $group2;
      }
    }

    foreach my $l (1 .. 3)
    {
      my $roundname = ($l == 2 ? '16f' : "round$l");
      my $round = read_ec_part($league, $roundname, 1, "${l}e ronde $shortname", $sort_rule, $content, $pnt_telling);
      if (defined $round)
      {
        $ec->{$key}{"round$l"} = $round;
      }
    }

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

  if ($total == 12 && not $isko)
  {
    $games[0][1][3] = ($cupname eq 'CL' && $phase !~ m/^group2.$/ ? 2 : 1);
  }
  elsif ($total == 10 && $cupname eq 'UEFAcup' && $phase =~ m/^g/iso)
  {
    $games[0][1][3] = 5;
  }

  return (scalar @games > 1 ? \@games : undef);
}

return 1;
