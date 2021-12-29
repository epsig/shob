package Sport_Functions::Results2Standing;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::Error_Handling;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Filters;
use Exporter;
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
 '&u2s',
 '&koppel_u_s',
 #========================================================================
);

my $CntSame = 6;
my $NrGamesSame = 7;
my $PointsSame = 8;
my $GoalsSame = 9;
my $AwayGoalsSame = 10;

my $winst;
sub calc_onderling_resultaat($$)
{# (c) Edwin Spee

 my ($s, $u) = @_;
 my $l = scalar @$s;

# extra veld $s->[i][CntSame] al of niet doorlopen en extra lus
 for (my $i=0; $i<$l; $i++)
 {
  my $rij = $s->[$i];
  if (scalar @$rij < 6)
  {
   $rij->[5][0] = '';
  }
  $rij->[$CntSame] = 0;
 }

 for (my $i=0; $i<$l; $i++)
 {
  if ($s->[$i][$CntSame] == 0)
  {
    my $a = $s->[$i];
# zoek teams met evenveel punten en wedstrijden als a
    my @teams_id = ();
    my @teams_nr = ();
    my $found = 0;
    for (my $k=0; $k < scalar @$s; $k++)
    {
     if (($s->[$k][1] == $a->[1]) and ($s->[$k][3] == $a->[3]))
     {
      push @teams_id, $s->[$k][0];
      push @teams_nr, $k;
      $found++;
    }}

# extra nullen in stand voor deze teams en markeer alvast als afgehandeld
    for my $i (@teams_nr)
    {
     my $rij = $s->[$i];
     $rij->[$CntSame] = $found;
     $rij->[$NrGamesSame] = 0;
     $rij->[$PointsSame] = 0;
     $rij->[$GoalsSame] = [0, 0];
     $rij->[$AwayGoalsSame] = 0;
    }

    if ($found > 1)
    {
# filter niet tellende wedstrijden eruit:
     inc_counter('sort_filter');
     my $uf = filter_team(\@teams_id, 2, $u);

# sommeer uitslagen:
     for (my $k=1; $k < scalar @$uf; $k++)
     {
      my $rij = $uf->[$k];
      if (scalar @{$rij->[2]} > 2)
      {
       my $uA = $rij->[2][1];
       my $uB = $rij->[2][2];
       if ($uA >= 0)
       {
        add_u(0, $rij->[0], $uA, $uB, $s, 1, 0);
        add_u(0, $rij->[1], $uB, $uA, $s, 1, 1);
}}}}}}}

sub add_u($$$$$$$)
{# (c) Edwin Spee

my ($only_init, $c, $u1, $u2, $s, $special, $reversed) = @_;
my $l = scalar @$s;
my $found = -1;
for (my $i=0; $i<$l; $i++)
{if ($c eq $s->[$i][0])
 {$found = $i;
  last;
}}
if ($found == -1 and $special == 1)
{shob_error('strange_else', ['unexpected situation.']);
}
elsif ($found == -1)
{
 push (@$s , [$c, 0, [0,0,0],0,[0,0]]);
 $found = $l;
}

if (not $only_init)
{
 my $rij = $s->[$found];
 if ($special == 2)
 {
  if (lc($u1) eq 'pnt')
  {
   $rij->[3] -= $u2;
  }
  else
  {shob_error('strange_else', ["straf $u1 not implemented"]);}
 }
 else
 {
  my $w = $u1  > $u2 ? 1:0;
  my $g = $u1 == $u2 ? 1:0;
  my $pnt = $winst * $w + $g;
  if ($special == 1)
  {
   $rij->[$NrGamesSame]++;
   $rij->[$PointsSame] += $pnt;
   $rij->[$GoalsSame][0] += $u1;
   $rij->[$GoalsSame][1] += $u2;
   $rij->[$AwayGoalsSame] += ($reversed ? $u1 : 0);
  }
  else
  {
   $rij->[1]++;
   $rij->[2][0] += $w;
   $rij->[2][1] += $g;
   $rij->[2][2] += 1 - $w - $g;
   $rij->[3] += $pnt;
   $rij->[4][0] += $u1;
   $rij->[4][1] += $u2;
}}}}

sub alphabetical($$)
{# (c) Edwin Spee

 my ($a, $b) = @_;

 my $str_cmp = (uc(expand($a->[0], 0)) cmp uc(expand($b->[0], 0)) );
 if ($verbose > 1)
 {
  print uc(expand($a->[0], 0)) . ' - ' . uc(expand($b->[0], 0));
  print " : $str_cmp\n";
 }
 return $str_cmp;
}

sub srtGoalDiff($$)
{
  my ($aa, $bb) = @_;
  my $result = (($bb->[0]-$bb->[1]) <=> ($aa->[0]-$aa->[1]));
  return $result;
}

sub srtfie1
{# (c) Edwin Spee

 my $num_result = (
  ($b->[3] <=> $a->[3]) or
  ($a->[1] <=> $b->[1]) or
  srtGoalDiff($a->[4], $b->[4]) or
  ($b->[4][0] <=> $a->[4][0]) );

 if ($num_result)
 {
  return $num_result;
 }
 else
 {
  return alphabetical($a, $b);
 }
}

sub srtfie2
{# (c) Edwin Spee

 my $num_result = (
  ($b->[3] <=> $a->[3]) or
  ($a->[1] <=> $b->[1]) or
  srtGoalDiff($a->[4], $b->[4]));

 if ($num_result)
 {
  return $num_result;
 }
 else
 {
  return alphabetical($a, $b);
 }
}

sub cmp_onderling($$$)
{# (c) Edwin Spee

 my ($a, $b, $type) = @_;

 my $ret_val = (
   ($b->[$PointsSame] <=> $a->[$PointsSame]) or
   ($a->[$NrGamesSame] <=> $b->[$NrGamesSame]) or
    srtGoalDiff($a->[$GoalsSame], $b->[$GoalsSame]) or
   ($type * ($b->[$AwayGoalsSame] <=> $a->[$AwayGoalsSame])) or
   ($b->[$GoalsSame][0] <=> $a->[$GoalsSame][0]) or
    srtGoalDiff($a->[4], $b->[4]) or
   ($b->[4][0] <=> $a->[4][0]) );
 return $ret_val;
}

sub srtfie3
{# (c) Edwin Spee

 my $pnt_wedstr = ( ($b->[3] <=> $a->[3]) or ($a->[1] <=> $b->[1]) );

 if ($pnt_wedstr)
 {
  return $pnt_wedstr;
 }
 else
 {
  my $onderl = cmp_onderling($a, $b, 1);
  if ($onderl)
  {
   return $onderl;
  }
  else
  {
   return alphabetical($a, $b);
  }
 }
}

sub srtfie4
{# (c) Edwin Spee

 my $pnt_wedstr = ( ($b->[3] <=> $a->[3]) or ($a->[1] <=> $b->[1]) );

 if ($pnt_wedstr)
 {
  return $pnt_wedstr;
 }
 else
 {
  my $onderl = cmp_onderling($a, $b, 0);
  if ($onderl)
  {
   return $onderl;
  }
  else
  {
   return alphabetical($a, $b);
  }
 }
}

sub srtfie5
{# (c) Edwin Spee

 my $num_result = (
  ($b->[3] <=> $a->[3]) or
  ($a->[1] <=> $b->[1]) or
   srtGoalDiff($a->[4], $b->[4]) or
  ($b->[4][0] <=> $a->[4][0]) );

 if ($num_result)
 {
  return $num_result;
 }
 else
 {
  my $onderl = cmp_onderling($a, $b, 0);
  if ($onderl)
  {
   return $onderl;
  }
  else
  {
   return alphabetical($a, $b);
  }
 }
}

sub add_ster($$$)
{# (c) Edwin Spee

 my ($stand, $ster, $type) = @_;

 if ($type == 1)
 {for (my $i = 0; $i < scalar @$ster; $i++)
  {$stand->[1+$i][5][0] = $ster->[$i];
  }
 }
 else
 {for (my $i = 0; $i < scalar @$ster; $i+=2)
  {my $zk = $ster->[$i];
   my $lkfr = 1 + ($zk =~ tr/,//);
   my $found = 0;
   for (my $j = 1; $j < scalar @$stand ; $j++)
   {# print "$zk,$lkfr,$found,$i,$j,$ster->[$i],$stand->[$j][0]\n";
    # my $tmp = <STDIN>;
    if ((index $ster->[$i], $stand->[$j][0]) >= 0)
    {$stand->[$j][5][0] = $ster->[$i+1];
     $found++;
     last if $found == $lkfr;
}}}}}

sub koppel_u_s($$)
{# (c) Edwin Spee

 my ($u, $s) = @_;

 $u->[0][2] = $s;
}

sub u2s
{# (c) Edwin Spee

 my ($u, $pnt_telling, $srt_rule, $t, $ster, $pster) = @_;
# pnt_telling = 1: w,g,v = 3,1,0;
# pnt_telling = 2: w,g,v = 2,1,0; TODO rest niet geimplementeerd
# pnt_telling = 101, 102: alleen thuiswedstrijden
# pnt_telling = 201, 202: alleen uitwedstrijden

# srt_rule = sorteer methode volgens reglementen
# srt = 1: pnt; wedstr; doelsaldo; gescoord.
# srt = 2: pnt; wedstr; doelsaldo.
# srt = 3: pnt; wedstr; onderling resultaat; uitgescoord.
# srt = 4: pnt; wedstr; onderling resultaat.
# srt = 5: pnt; wedstr; doelsaldo; gescoord; onderling resultaat
 $winst = ($pnt_telling % 100 == 1 ? 3 : 2);
 my $do_home = ($pnt_telling < 200 ? 1 : 0);
 my $do_away = (abs($pnt_telling - 100) < 10 ? 0 : 1);

 my $s = [];
 for (my $i = 1; $i < scalar @$u; $i++)
 {
  my $rij = $u->[$i];
  if ($rij->[1] eq 'straf')
  {
   if ($pnt_telling < 101)
   {
    add_u(0, $rij->[0], $rij->[2], $rij->[3], $s, 2, 0);
   }
  }
  else
  {
   my $uA = -1; my $uB = -1;
   if (scalar @{$rij->[2]} > 2)
   {
    $uA = $rij->[2][1];
    $uB = $rij->[2][2];
   }
   if ($uA >= 0 and $do_home)
   {
    add_u(0, $rij->[0], $uA, $uB, $s, 0, 0);
   }
   else
   {
    add_u(1, $rij->[0], 0, 0, $s, 0, 0);
   }

   if ($uA >= 0 and $do_away)
   {
    add_u(0, $rij->[1], $uB, $uA, $s, 0, 1);
   }
   else
   {
    add_u(1, $rij->[1], 0, 0, $s, 0, 0);
   }
  }
 }

 my @s;
 if ($srt_rule == 1)
 {
  @s = sort srtfie1 @$s;
 }
 elsif ($srt_rule == 2)
 {
  @s = sort srtfie2 @$s;
 }
 elsif ($srt_rule == 3)
 {
  calc_onderling_resultaat($s, $u);
  @s = sort srtfie3 @$s;
 }
 elsif ($srt_rule == 4)
 {
  calc_onderling_resultaat($s, $u);
  @s = sort srtfie4 @$s;
 }
 elsif ($srt_rule == 5)
 {
  calc_onderling_resultaat($s, $u);
  @s = sort srtfie5 @$s;
 }
 else
 {
  shob_error('not_yet_impl', ["sorteer methode = $srt_rule"]);
 }

 unshift @s , [$t];

 if ($ster == 0)
 {
  add_ster(\@s, $pster, 2);
 }
 elsif ($ster == 1)
 {
  add_ster(\@s, ['+','+'], 1);
 }
 elsif ($ster == 2)
 {
  add_ster(\@s, ['+','+','*'], 1);
 }
 elsif ($ster == 3)
 {
  add_ster(\@s, ['+'], 1);
 }
 elsif ($ster == 4)
 {
  add_ster(\@s, ['+','*'], 1);
 }
 elsif ($ster == 5)
 {
  add_ster(\@s, ['+','+','+'], 1);
 }
 elsif ($ster == 6)
 {
  add_ster(\@s, ['*','**','***'], 1);
 }
 return \@s;
}

return 1;

