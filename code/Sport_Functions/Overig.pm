package Sport_Functions::Overig;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Filters;
use Sport_Collector::Teams;
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
 '&get_tpsc',
 '&laatste_speeldatum',
 '&extremen_gem_aantal_toeschouwers',
 '&min_max_aantal_toeschouwers',
 '&gem_aantal_toeschouwers',
 '&more_details',
 #========================================================================
);

sub get_tpsc($$$)
{ # (c) Edwin Spee

  my ($maxnr, $plijst, $style) = @_;

  my $outtxt = ftr(fth({cols => 4, class => ($style ? 'h' : '')}, $plijst->[0][0]));
  for (my $i = 0; $i < scalar @$plijst -1; $i++)
  {
    my $rij = $plijst->[$i+1];

    my $nr        = $rij->{rank};
    last if ($nr > $maxnr);
    my $name      = $rij->{name};
    my $club_land = (defined ($rij->{club}) ? $rij->{club} : $rij->{country});
    my $total     = $rij->{total};
    my @bold = ($nr == 1 ? ('<b>','</b>') : ('',''));
    $outtxt .= ftr(ftdr($i+1==$nr ? $nr : $nbsp) .
      ftdl($bold[0] . expand_voetballers($name, 'std') . $bold[1]) .
      ftdl(expand($club_land, 0)) .
      ftdr($total));
 }
 return $outtxt;
}

sub laatste_speeldatum($)
{# (c) Edwin Spee

my ($pu) = @_;
# pu = pointer naar uitslagen-array

my $rows = scalar @$pu;
my $lookfor = 0;
for (my $i=1; $i<$rows; $i++)
{my $row = $pu->[$i];
 if ($row->[1] eq 'straf') {next;}
 if (scalar @{$row->[2]} > 2 and $row->[2][1] > -1)
 {my $datum = deref_datum($row->[2][0]);
  $lookfor = max($lookfor, $datum);
 }
 if (scalar @{$row} > 3 and ref $row->[3] eq 'ARRAY')
 {
  if (scalar @{$row->[3]} > 2 and $row->[3][1] > -1)
  {my $datum = deref_datum($row->[3][0]);
   $lookfor = max($lookfor, $datum);
  }
 }
}
return $lookfor;
}

sub make_club_array($$)
{# (c) Edwin Spee

 my ($pu, $skipzero) = @_;

 my %club_array;
 for (my $i=1; $i < scalar @$pu; $i++)
 {my $rij = $pu->[$i][2];
  if ($pu->[$i][1] eq 'straf') {next;}
  if (scalar @$rij > 3)
  {my $t = $rij->[3];
   if (ref $t eq 'HASH')
   {
    $t = $t->{publiek};
    if (not defined $t) {next;}
   }
   # voorkom lage schatting gemiddelde bij wedstrijd zonder publiek in het begin van de competitie:
   if ($skipzero and $t == 0) {next;}
   my $tc = $pu->[$i][0]; # thuis spelende club
   if (exists $club_array{$tc})
   {
    $club_array{$tc}->[0] = max($club_array{$tc}->[0], $t);
    $club_array{$tc}->[1] = min($club_array{$tc}->[1], $t);
    $club_array{$tc}->[2] =     $club_array{$tc}->[2]+ $t ;
    $club_array{$tc}->[4]++;
   }
   else
   {
    $club_array{$tc} = [$t, $t, $t, -1, 1];
   }
  }
 }

# bereken gemiddelde:
 while ((my $key, my $value) = each %club_array)
 {$value->[3] = $value->[2] / $value->[4];}

 return \%club_array;
}

sub extremen_gem_aantal_toeschouwers($)
{# (c) Edwin Spee

 my $club_array = make_club_array($_[0], 0);
#if (not scalar %$club_array eq 0) {return ('', -1, '', -1);} 
 my @c_l = ();
 my @c_h = ();
 my ($low, $high) = (1e33, -1e33);
 while ((my $key, my $value) = each %$club_array)
 {
  my $t = $value->[3];
  if ($t == $high)
  {
   $high = $t;
   push (@c_h, $key);
  }
  elsif ($t > $high)
  {
   $high = $t;
   @c_h = ($key);
  }
  if ($t == $low)
  {
   $low = $t;
   push (@c_l, $key);
  }
  elsif ($t < $low)
  {
   $low = $t;
   @c_l = ($key);
  }
 }
 my @ret_val = ('', $high, '', $low);
 foreach my $c (@c_h)
 {
  if ($ret_val[0] ne '') {$ret_val[0] .= ", ";}
  $ret_val[0] .= expand($c, 3);
 }
 foreach my $c (@c_l)
 {
  if ($ret_val[2] ne '') {$ret_val[2] .= ", ";}
  $ret_val[2] .= expand($c, 3);
 }

 return @ret_val;
}

sub min_max_aantal_toeschouwers($$)
{# (c) Edwin Spee

 my ($seizoen, $pu) = @_;

 my @imin = (-1);
 my @imax = (-1);
 my $NoSpectators = 0;
 my ($tmin, $tmax) = (1e34, 0);

 my $ii = 0;
 for (my $i=1; $i < scalar @$pu; $i++)
 {
  my $rij = $pu->[$i][2];
  if ($pu->[$i][1] eq 'straf') {next;}
  if (scalar @$rij > 3)
  {
   $ii++;
   my $t = $rij->[3];
   if (ref $t eq 'HASH')
   {
    $t = $t->{publiek};
    if (not defined $t) {next;}
   }
   if ($t == 0) {$NoSpectators++;}
   if ($t > $tmax)
   {
    $tmax = $t;
    @imax = ($i);
   }
   elsif ($t == $tmax)
   {
    push @imax, ($i);
   }
   if ($t < $tmin)
   {
    $tmin = $t;
    @imin = ($i);
   }
   elsif ($t == $tmin)
   {
    push @imin, ($i);
   }
  }
 }

 if ($ii == 0)
 {
   return '';
 }

 my $str = ftdl($seizoen);
 my $games = '';
 for (my $i = 0; $i < scalar @imax; $i++)
 {
  my $club_t = expand($pu->[$imax[$i] ][0], 3);
  my $club_u = expand($pu->[$imax[$i] ][1], 3);
  if ($i > 0) {$games .= '<br>';}
  $games .= qq($club_t - $club_u);
 }
 $str .= ftdl($games);
 $str .= ftdl(sprintf('%.1f k', $tmax/1E3));
 $games = '';
 if ($NoSpectators > 3)
 {
   $games = "Geen publiek bij $NoSpectators duels.";
 }
 else
 {
  for (my $i = 0; $i < scalar @imin; $i++)
  {
   my $club_t = expand($pu->[$imin[$i] ][0], 3);
   my $club_u = expand($pu->[$imin[$i] ][1], 3);
   if ($i > 0) {$games .= '<br>';}
   $games .= qq($club_t - $club_u);
  }
 }
 $str .= ftdl($games);
 $str .= ftdl(sprintf('%.1f k', $tmin/1E3));

 return ftr($str);
}

sub gem_aantal_toeschouwers($$)
{# (c) Edwin Spee

 my ($pu, $normal_calc) = @_;

 if ($normal_calc)
 {
  my $sum = 0;
  my $ii = 0;
  for (my $i=1; $i < scalar @$pu; $i++)
  {my $rij = $pu->[$i][2];
   if ($pu->[$i][1] eq 'straf') {next;}
   if (scalar @$rij > 3)
   {
    if (ref $rij->[3] eq 'HASH')
    {
     if (defined $rij->[3]->{publiek})
     {
      $sum += $rij->[3]->{publiek};
      $ii++;
    }}
    elsif ($rij->[3] >= 0)
    {
     $sum += $rij->[3];
     $ii++;
    }
   }
  }
  return (wantarray ? ($sum, $ii) : $sum / max(1, $ii));
 }
 else
 {
  my $club_array = make_club_array($pu, 1);
# if (not scalar %$club_array) {return -1;}
  my $sum2 = 0; my $isum2 = 0;
  while ((my $key, my $value) = each %$club_array)
  {#$value->[3] = $value->[2] / $value->[4];
   $sum2 += $value->[3];
   $isum2 ++;
  }
  return (wantarray ? ($sum2, $isum2) : $sum2 / $isum2);
 }
}

sub get_rood($$)
{# (c) Edwin Spee

 my ($rood, $land_code) = @_;
 
 my $out = '';
 if (defined $rood)
 {
  for (my $i = 0; $i < scalar @$rood / 3; $i++)
  {
   my ($speler, $min, $geel2x) = (expand_voetballers($rood->[3*$i], 'std'),
    $rood->[3*$i+1], $rood->[3*$i+2]);
   if (defined $geel2x and $geel2x ne '')
   {
    $out .= "<br>$min' $speler ($land_code; $geel2x)\n";
   }
   else
   {
    $out .= "<br>$min' $speler ($land_code)\n";
   }
 }}
 return $out;
}

sub more_details($)
{# (c) Edwin Spee

 my ($all) = @_;

 my $out = '';
 for (my $i=1; $i<scalar @$all; $i++)
 {
  my $rij = $all->[$i];
  my $u = $rij->[2];
  if (scalar @$u > 3)
  {
   my $details = $u->[3];
   if (ref $details eq 'HASH' and defined $details->{refname})
   {
    my $hu = get_1_uitslag($rij, 1, 0, 1);
    $out .= qq(<hr><a name="$details->{refname}">$hu->{affiche} $hu->{u}</a>\n);
    if (defined $details->{stadion} and defined $details->{publiek})
    {
     $out .= qq(<br>Gespeeld te $details->{stadion} voor $details->{publiek} toeschouwers.\n);
    }
    if (defined $details->{arbiter})
    {
     $out .= qq(<br>Scheidsrechter: $details->{arbiter}.\n);
    }

    for (my $i=0; $i<scalar @{$details->{chronological}}; $i++)
    {
     my $goal =$details->{chronological}[$i];
     if ($goal->[2] =~ m/mist/)
     {
      $out .= "<br>$goal->[0]' ";
      for (my $j=1; $j<4; $j++)
      {$out .= "$goal->[$j] ";}
      $out .= "\n";
     }
     else
     {
      my $speler = expand_voetballers($goal->[3], 'std');
      if ($goal->[1] < 0)
      {$out .= "<br>$goal->[0]' $speler\n";}
      else
      {$out .= "<br>$goal->[0]' $goal->[1]-$goal->[2] $speler\n";}
     }
    }
    if (defined $details->{rood_a} or defined $details->{rood_b})
    {
     $out .= qq(<br><font color="red">rood:</font>\n);
     $out .= get_rood($details->{rood_a}, $details->{a});
     $out .= get_rood($details->{rood_b}, $details->{b});
    }
    if (defined $details->{wnshort})
    {
     my ($a, $b) = @{$details->{wnshort}};
     $out .= "<br>Strafschoppenserie: $a - $b.\n";
    }
    my $wns = $details->{wnslong};
    if (defined $wns)
    {
     for (my $i=2; $i < scalar @{$wns}; $i += 2)
     {
      if ($wns->[$i] == 0)
      {
       my $speler = expand_voetballers($wns->[$i+1], 'std');
       $out .= "<br>$speler mist.\n";
      }
     }
    }
 }}}

 return $out;
}

return 1;
