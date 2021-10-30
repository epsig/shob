package Sport_Collector::Stats_Eredivisie;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
use Shob::Functions;
use Sport_Functions::Overig;
use Sport_Functions::Seasons;
use Sport_Functions::Filters;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::Results2Standing; # voor officieus
use Sport_Functions::Get_Result_Standing; # voor officieus
use Sport_Collector::Archief_Voetbal_NL;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Archief_Voetbal_NL_Standen;
use Sport_Collector::Archief_Voetbal_NL_Topscorers qw(&get_topscorers_competitie);
use Sport_Collector::Teams;
use Sport_Functions::ListRemarks qw($all_remarks);
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
 '&get_stats_eredivisie',
 '&officieuze_standen',
 #========================================================================
);

sub get_sort_button($$$$)
{
  my ($tableId, $column, $headers, $sortUpDown) = @_;

  my $arrow = ($sortUpDown == 1 ? '&darr;' : '&uarr;');

  return qq(<button onclick="sortTable('$tableId', $column, $headers, $sortUpDown)"> <b> $arrow </b> </button>);
}

sub get_lijst_topscorers($$)
{ # (c) Edwin Spee

  my ($yrA, $yrB) = @_;
  my @lijst = ();
  for (my $year = $yrA; $year <= $yrB; $year++)
  {
    my $seizoen = yr2szn($year);
    my $tpsc = get_topscorers_competitie($seizoen, 'eredivisie', 'Eredivisie');
    push @lijst, [$seizoen,$tpsc];
  }
  return \@lijst;
}

sub get_lijst_extremen_uit_standen($$)
{# (c) Edwin Spee

# record:
# t/m 1961-2 34 wedstr., 1962-3 t/m 1965-6 30 wedstr., vanaf 1966-7 34 wedstr.
# 1971-2: FC Twente'65 13 tegengoals
# 1958-9: SHS 111 tegengoals
# 1966-7: Ajax 122 goals
# 1971-2: Volendam 16 goals
# 1962-3: de Volewijckers (31 - 102)/30= -71/30 = -2,37
# 1985-6: Heracles (26 - 99)/34 = -73/34 = -2,15
 my ($yrA, $yrB) = @_;
 my @lijst = ();
 for (my $year = $yrA; $year <= $yrB; $year++)
 {my $seizoen = yr2szn($year);
  my $stand = standen_eredivisie($seizoen);
  my @max_g = (0,'');
  my @min_g = (999,'');
  my @max_t = (0,'');
  my @min_t = (999,'');
  my @max_s = (0,'');
  my @min_s = (999,'');
  my $sum = 0;
  for (my $club = 1; $club < scalar @$stand; $club++)
  {my $g = $stand->[$club][4][0] ;
   my $t = $stand->[$club][4][1];
   my $s = $g - $t;
   my $naam = $stand->[$club][0];
   $sum += $g;
   if ($g > $max_g[0]) {@max_g = ($g, $naam);}
   elsif ($g == $max_g[0]) {@max_g = (@max_g, $naam);}
   if ($g < $min_g[0]) {@min_g = ($g, $naam);}
   elsif ($g == $min_g[0]) {@min_g = (@min_g, $naam);}
   if ($t > $max_t[0]) {@max_t = ($t, $naam);}
   elsif ($t == $max_t[0]) {@max_t = (@max_t, $naam);}
   if ($t < $min_t[0]) {@min_t = ($t, $naam);}
   elsif ($t == $min_t[0]) {@min_t = (@min_t, $naam);}
   if ($s > $max_s[0]) {@max_s = ($s, $naam);}
   elsif ($s == $max_s[0]) {@max_s = (@max_s, $naam);}
   if ($s < $min_s[0]) {@min_s = ($s, $naam);}
   elsif ($s == $min_s[0]) {@min_s = (@min_s, $naam);}
  }
# print "$seizoen, @max_g, @max_t, @max_s\n";
# print "@min_g, @min_t, @min_s\n";
  my $clubs = scalar @$stand - 1;
  my $tot = $clubs * ($clubs-1);
  if ($year == 2019) {$tot = 232;}
  my $gem = $sum / $tot;
# print "totaal: $sum ; gem: $gem \n";
  push @lijst, [$seizoen, \@max_g, \@max_t, \@max_s, \@min_g, \@min_t, \@min_s, $sum, $gem];
 }
 return \@lijst;
}

sub get_namen_expand($)
{# (c) Edwin Spee

 my $p = $_[0];
 if (scalar @$p == 2)
 {return expand($p->[1],3);}
 else
 {return expand($p->[1],3) . '<br>' . expand($p->[2],3);}
}

sub extra_spectators_from_remarks($)
{
  my $type = shift;

  my $h = {};
  for (my $yr=1988; $yr<1997; $yr++)
  {
    my $szn = yr2szn($yr);
    my $spectators = $all_remarks->{eredivisie}->get($szn, "${type}_spectators");
    if (defined($spectators))
    {
      if ($type eq 'tot') {
        $h->{$szn} = $spectators;
      } else {
        my @parts = split(/:/, $spectators);
        $h->{$szn} = [$parts[1], $parts[0]];
      }
    }
  }
  return $h;
}

sub get_toeschouwers_tabel($$$)
{# (c) Edwin Spee

 my ($yrA, $yrB, $ABBA) = @_;
 # $yrA = start jaar
 # $yrB = laatste jaar
 # $ABBA = 1: tabel start met $yrA
 # $ABBA = 0: tabel start met $yrB
# zie soccerstats.com

 my $max_toeschouwers = extra_spectators_from_remarks('max');
 my $min_toeschouwers = extra_spectators_from_remarks('min');
 my $tot_toeschouwers = extra_spectators_from_remarks('tot');

 my $skip_last = 0;
 my $schatting_lopend = 0;
 my $lopend_szn;
 for (my $year=1997; $year <= $yrB ; $year++)
 {
  my $seizoen = yr2szn($year);
  my $u_szn = $u_nl->{$seizoen};
  if (defined $u_szn)
  {
   my @extr = extremen_gem_aantal_toeschouwers($u_szn);
   $max_toeschouwers->{$seizoen} = [$extr[1], $extr[0]],
   $min_toeschouwers->{$seizoen} = [$extr[3], $extr[2]],
   my ($sum, $tot) = gem_aantal_toeschouwers($u_szn, 1);
 # print "sum, tot = $sum, $tot.\n";
   {if ($tot == 306 or $year == 2019)
    {$tot_toeschouwers->{$seizoen} = $sum;}
    elsif ($tot < 36)
    {$skip_last = 1;}
    else
    {$schatting_lopend = 1;
     $lopend_szn = $seizoen;
     $tot_toeschouwers->{$seizoen} = 306*gem_aantal_toeschouwers($u_szn, 0)}
   }
  }
  else
  {warn "Ongeldig jaar $year in sub get_toeschouwers_tabel.\n";}
 }
 if ($skip_last) {$yrB--;}

 my $out = '<a name="toesch"></a>';
 if ($schatting_lopend)
 {
  $out .= "Schatting van het totaal aantal toeschouwers voor $lopend_szn: ";
  $out .= sprintf('%.1f', $tot_toeschouwers->{$lopend_szn}/1E6) . " miljoen.\n";
 }

 my $tmp_out = '';
 for (my $i = 0; $i <= $yrB - $yrA; $i++)
 {my $year = ( $ABBA ? $yrA + $i : $yrB - $i);
  my $seizoen = yr2szn($year);
  my $mx_ts = $max_toeschouwers->{$seizoen};
  my $mn_ts = $min_toeschouwers->{$seizoen};
  my $tot_ts = $tot_toeschouwers->{$seizoen};
  my $tot = ($year == 2019 ? 232 : 306);
  if (defined $mx_ts and defined $tot_ts)
  {
    my $minClub = ''; my $minValue = '';
    if (defined $mn_ts)
    {
      $minClub = $mn_ts->[1];
      $minValue = sprintf('%4.1f k', $mn_ts->[0]/1E3);
    }

    $tmp_out .= ftr(ftdl($seizoen)
    . ftdl(sprintf('%4.2f M', $tot_ts/1E6))
    . ftdl(sprintf('%4.1f k', $tot_ts/(1E3 * $tot)))
    . ftdl($mx_ts->[1]) . ftdl(sprintf('%4.1f k', $mx_ts->[0]/1E3))
    . ftdl( $minClub ). ftdl( $minValue ) );
  }
  else
  {warn "Ongeldig jaar $year in sub get_toeschouwers_tabel.\n";} # warn again...
 }

 my @sortBtns = ();
 my @colums = (1, 2, 4, 6);
 foreach my $i (0..7)
 {
   my $hulp = int(($i) / 2);
   my $column = $colums[$hulp];
   my $sortUpDown = 1 + ($i % 2);
   $sortBtns[$i] = get_sort_button('id1', $column, 2, $sortUpDown);
 }

 $out .= ftable('border cellspacing=0 id="id1"',
  ftr(fth('seizoen')
  . fth('totaal aantal toeschouwers') . fth('gemiddelde per wedstrijd')
  . fth({cols => 2}, 'hoogste gemiddelde per club') . fth({cols => 2}, 'laagste gemiddelde per club'))
  . ftr(ftd($nbsp) .
    fth($sortBtns[0] . $sortBtns[1]) . 
    fth($sortBtns[2] . $sortBtns[3]) . 
    fth({cols => 2}, $sortBtns[4] . $sortBtns[5]) . 
    fth({cols => 2}, $sortBtns[6] . $sortBtns[7])    
    )
  . $tmp_out);

 return $out;
}

sub get_tabel_extremen_doelpunten($$$$)
{# (c) Edwin Spee

 my ($lijst_extremen, $yrA, $yrB, $ABBA) = @_;
 my $szns = scalar @$lijst_extremen;
 my $out = '<p> Gebruik pijltje om te sorteren </p>';
 for (my $i = 0; $i < $szns; $i++)
 {my $rij = $lijst_extremen->[ $ABBA ? $i : $szns - 1 - $i ];
  my $szn = $rij->[0];
  if ($szn ge yr2szn($yrA) and $szn le yr2szn($yrB))
  {$out .= ftr(ftdl($szn)
        . ftdl(get_namen_expand($rij->[1]))
        . ftdr( sprintf("%3d", $rij->[1][0]) )
        . ftdl(get_namen_expand($rij->[4]))
        . ftdl($rij->[4][0]) . qq(\n)
        . ftdl(get_namen_expand($rij->[2]))
        . ftdr( sprintf("%3d", $rij->[2][0]) )
        . ftdl(get_namen_expand($rij->[5]))
        . ftdl($rij->[5][0]) . qq(\n)
        . ftdl(get_namen_expand($rij->[3]))
        . ftdl('+' . $rij->[3][0])
        . ftdl(get_namen_expand($rij->[6]))
        . ftdl($rij->[6][0]));
  }
 }

 my @sortBtns = ();
 foreach my $i (0..11)
 {
   my $column = 2 + 2 * int(($i) / 2);
   my $sortUpDown = 1 + ($i % 2);
   $sortBtns[$i] = get_sort_button('id2', $column, 1, $sortUpDown);
 }

 $out = '<a name="extr_goals"></a>'
 . ftable('border cellspacing=0 id="id2"',
    ftr(fth('seizoen')
    . fth({cols => 2}, 'meeste goals <br> ' . $sortBtns[0] . $sortBtns[1])
    . fth({cols => 2}, 'minste goals <br> ' . $sortBtns[2] . $sortBtns[3]) . qq(\n)
    . fth({cols => 2}, 'meeste tegengoals <br> ' . $sortBtns[4] . $sortBtns[5])
    . fth({cols => 2}, 'minste tegengoals <br> ' . $sortBtns[6] . $sortBtns[7]) . qq(\n)
    . fth({cols => 2}, 'hoogste doelsaldo <br> ' . $sortBtns[8] . $sortBtns[9])
    . fth({cols => 2}, 'laagste doelsaldo <br> ' . $sortBtns[10] . $sortBtns[11]))
  . $out);
 if ($yrA > 1970)
 {
  $out .= "seizoen 2019-2020 is over 232 wedstrijden; overige over 306.";
 }
 else
 {
  $out .= "seizoen 2019-2020 is over 232 wedstrijden; " .
          "seizoenen 1962-1963 t/m 1965-1966 over 240 wedstrijden " .
          "en de overige seizoenen over 306 wedstrijden.";
 }
 return $out;
}

sub get_namen_topscorers($)
{ # (c) Edwin Spee

  my $tp = shift;

  my $names = '';
  for my $i (1 .. scalar(@$tp)-1)
  {
    my $line = $tp->[$i];
    if ($line->{rank} == 1)
    {
      $names .= '<br>' if ($names ne '');
      $names .= expand_voetballers($line->{name}, 'std') . ' (' . expand($line->{club}, 0) . ')';
    }
    else
    {
      last;
    }
  }
  return $names;
}

sub get_tabel_doelpunten($$$$$)
{# (c) Edwin Spee

 my ($lijst_extremen, $lijst_tpsc, $yrA, $yrB, $ABBA) = @_;

# record totaal aantal doelpunten: 83-84: 1079, 58-59: 1188
 my $out = '';
 my $szns = scalar @$lijst_extremen;
 for (my $i = 0; $i < $szns; $i++)
 {my $rij_e = $lijst_extremen->[ $ABBA ? $i : $szns - 1 - $i ];
  my $rij_t = $lijst_tpsc->[ $ABBA ? $i : $szns - 1 - $i ][1];
  my $szn = $rij_e->[0];
  if ($szn ge yr2szn($yrA) and $szn le yr2szn($yrB))
  {
   my $tmp_out = ftdl($szn)
         . ftdr(sprintf('%4d', $rij_e->[7]))
         . ftdl(sprintf('%.2f', $rij_e->[8]))
         . ftdl(get_namen_topscorers($rij_t))
         . ftdl($rij_t->[1]{total});
   $out .= ftr($tmp_out);
 }}

 my @sortBtns = ();
 my @colums = (1, 2, 4);
 foreach my $i (0..5)
 {
   my $hulp = int(($i) / 2);
   my $column = $colums[$hulp];
   my $sortUpDown = 1 + ($i % 2);
   $sortBtns[$i] = get_sort_button('id3', $column, 1, $sortUpDown);
 }

 $out = '<a name="tot_goals"></a>'
 . ftable('border cellspacing=0 id="id3"', "\n" .
     ftr(fth('seizoen')
     . fth('doelpunten <br>'   . $sortBtns[0] . $sortBtns[1])
     . fth('gemiddelde <br>'   . $sortBtns[2] . $sortBtns[3])
     . fth('naam topscorer')
     . fth('aantal goals <br>' . $sortBtns[4] . $sortBtns[5])
     )
   . $out);
 return $out;
}

sub get_tabel_ruimste_zege($$$)
{# (c) Edwin Spee

 my ($yrA, $yrB, $ABBA) = @_;
# eruit sinds 28 juni: 1994-1995;Arnold (NAC);4 1995-1996;Arnold (NAC);4
 my $out = '';
 for (my $j = 0; $j <= $yrB - $yrA; $j++)
 {my $year = ( $ABBA ? $yrA + $j : $yrB - $j);
  my $seizoen = yr2szn($year);
  my $pu_all = $u_nl->{$seizoen};
  my $tmp_out = ftdl($seizoen);
  for (my $ii = 1; $ii <= 3; $ii++)
  {my $pu = filter_opvallend($pu_all, $ii);
   my $ctn = scalar @$pu ;
   my $cell = '';
   for (my $i=1; $i<$ctn; $i++)
   {$cell .= expand($pu->[$i][0],3) .'-'.expand($pu->[$i][1],3);
    if ($i < $ctn-1) {$cell .= "<br>\n";}
   }
   $tmp_out .= ftdl($cell) . "\n";
   $cell = '';
   for (my $i=1; $i<$ctn; $i++)
   {$cell .= $pu->[$i][2][1] . '-' . $pu->[$i][2][2];
    if ($i < $ctn-1) {$cell .= "<br>\n";}
   }
   $tmp_out .= ftdr($cell) . "\n";
  }
  $out .= ftr($tmp_out);
 }
 $out = '<a name="extr_uitsl"></a>'
 . ftable('border',
  ftr(fth('seizoen') . fth({cols => 2}, 'ruimste zege') .
  fth({cols => 2}, 'meeste treffers <br> (&eacute;&eacute;n van beide)') .
  fth({cols => 2}, 'hoogste totaal'))
  . $out);
 return $out;
}

sub get_toeschouwers_tabel2($$$)
{# (c) Edwin Spee

# Games with highest attandence:
# 88-89 Ajax - Feijenoord 52.000 [Olympic Stadium Amsterdam, sold out]
# 89-90 Ajax - PSV        52.000
# 90-91 Ajax - PSV        52.000
#       Ajax - Feijenoord 52.000
#       Ajax - Vitesse    52.000
# 91-92 Ajax - Feijenoord 48.000
#       Ajax - PSV        48.000
#       Feijenoord - Ajax 48.000
#       [ Both de Kuip and the Olympic Stadium again were sold out, but
#        because of safety-measures less tickets were made available ]
# 92-93 Feijenoord - Ajax 47.644

 my ($yrA, $yrB, $ABBA) = @_;

 my $out = << "EOF";
<table border cellspacing=0>
<tr><th>seizoen</th><th colspan=2>best bezocht</th><th colspan=2>minst bezocht</th></tr>
EOF

 for (my $j = 0; $j <= $yrB - $yrA; $j++)
 {
  my $year = ( $ABBA ? $yrA + $j : $yrB - $j);
  my $seizoen = yr2szn($year);
  my $u_szn = $u_nl->{$seizoen};
  my $txt = min_max_aantal_toeschouwers($seizoen, $u_szn);
  $out .= $txt if ($txt ne '');
 }
 $out .= qq(</table>\n);

 return $out;
}

sub tpsc_all_seasons($$)
{# (c) Edwin Spee

  my $ltp    = shift;
  my $maxcnt = shift;

  my @ls = sort {$b->[1][1]{total} <=> $a->[1][1]{total}} @{$ltp};

  my $totalMax = $ls[$maxcnt]->[1][1]{total};

  my $out = '';
  for (my $i=0; $i < scalar @ls; $i++)
  {
    my $seizoen = $ls[$i]->[0];
    my $speler  = $ls[$i]->[1][1];
    if ($speler->{total} >= $totalMax)
    {
      my $names_tp = get_namen_topscorers($ls[$i]->[1]);
      $out .= ftr(ftdl($seizoen) . ftdl($names_tp) . ftdl($speler->{total}));
    }
  }

  return ftable('border', $out);
}

sub get_stats_eredivisie($$$)
{# (c) Edwin Spee

 my ($szn1, $szn2, $all_data) = @_;
# $all_data = 0: nieuwe optie voor epsig.nl
# $all_data = 1: optie voor xs4all/~spee: wel met geel/rood
# $all_data = 2: optie voor stats...more

 my $yr1 = szn2yr($szn1);
 my $yr2 = szn2yr($szn2);

 my $yrA = ($all_data == 2 ? first_year() : 1993);

 my $l_extremen  = get_lijst_extremen_uit_standen($yrA, $yr1);
 my $l_tpsc = get_lijst_topscorers($yrA, $yr1);

# TODO Records sinds de invoering van betaald voetbal zijn vetgedrukt.

 my $out = qq(<hr>| <a href="#extr_goals">meeste/minste goals</a>\n) .
   qq(| <a href="#tot_goals">totaal goals/topscorers</a>\n) .
   qq(| <a href="#extr_uitsl">opvallende uitslagen</a>\n);
 if ($all_data)
 {
   $out .= qq(| <a href="#allTimeTpsc">all time topscorers</a>\n);
 }
 $out .= qq(| <a href="#toesch">toeschouwersaantallen</a>\n);
 if ($all_data)
 {
   $out .= qq(| <a href="sport_voetbal_nl_stats.html">samengevat</a>\n);
 }
 else
 {
   $out .= qq(| <a href="sport_voetbal_nl_stats_more.html">meer stats</a>\n);
 }

 $out .= "|<hr>\n";

 $out .= get_tabel_extremen_doelpunten($l_extremen, $yrA, $yr2, 0);
 $out .= "<p>\n";
 $out .= get_tabel_doelpunten($l_extremen, $l_tpsc, $yrA, $yr1, 0);
 $out .= "<p>\n";
 $out .= get_tabel_ruimste_zege(1993, $yr2, 0);
 $out .= "<p>\n";
 $out .= get_toeschouwers_tabel(1988, $yr2, 0);
 $out .= "<p>\n";
 $out .= get_toeschouwers_tabel2(1993, $yr2, 0);
 $out .= "<p>\n";

 if ($all_data > 1)
 {
   $out .= qq(<a name="allTimeTpsc"> <h2> All time Topscorers. </h2>\n);
   $out .= tpsc_all_seasons ( get_lijst_topscorers( first_year(),  $yr1), 20 );
 }

 my $dd =max(20210102, $u_nl->{laatste_speeldatum});

return maintxt2htmlpage($out, 'Statistieken eredivisie', 'title2h1',
 $dd, {type1 => 'std_menu', pjs => [2, '/sort_table.js']});
}


sub officieuze_standen($$)
{
 my ($type, $yr) = @_;

 my $out = '';
 my $sz1 = yr2szn($yr - 1);
 my $sz2 = yr2szn($yr);
 my $datum_fixed = get_datum_fixed();
 my $yearlast = int($datum_fixed / 10000);
 my $dd =max($datum_fixed, $u_nl->{laatste_speeldatum});
 if (not defined $u_nl->{$sz1})
 {
  $out = "Sorry, season $sz1 is not available.\n";
  return maintxt2htmlpage($out, 'Error Message', 'title2h1', $dd, {type1 => 'std_menu'});
 }

 my $skip2 = not defined $u_nl->{$sz2};
 if ($type ne 'uit_thuis')
 {
  my $u = $u_nl->{$sz1};
  $u = combine_puus($u_nl->{$sz1}, $u_nl->{$sz2}) if not $skip2;
# my $title = ($skip2 ? 'tussenstand' : 'eindstand');
# my $s_echt  = u2s($u_nl->{$sz1}, 1, 1, "$title $sz1", -1);
  my $s_total = u2s(filter_datum($yr*1E4, $yr*1E4 + 1300, $u), 1, 1, "kalenderjaar $yr", -1);
  my $s_wintr = u2s(filter_datum(      0, $yr*1E4 + 1300, $u_nl->{$sz2}), 1, 1, "stand 2e helft $yr", -1) if not $skip2;
  my $s_lente = u2s(filter_datum($yr*1E4, $yr*1E4 + 1300, $u_nl->{$sz1}), 1, 1, "stand 1e helft $yr", -1);
# my $txt_echt  = get_stand($s_echt , 4, 0, [1]);
  my $txt_total = ($skip2 ? '' : get_stand($s_total, 4, 0, [1]));
  my $txt_wintr = ($skip2 ? '' : get_stand($s_wintr, 4, 0, [1]));
  my $txt_lente = get_stand($s_lente, 4, 0, [1]);
  $out = ftable('border',
   ftr( ftdx('vtop', ftable('border', $txt_lente)) .
#       ftdx('vtop', ftable('border', $txt_echt )) .
        ($skip2 ? '' : ftdx('vtop', ftable('border', $txt_wintr))) .
        ($skip2 ? '' : ftdx('vtop', ftable('border', $txt_total))) )) . "\n&nbsp;<p>&nbsp;\n" . $out;
 }
 else
 {
  if (scalar @{$u_nl->{$sz2}} < 2*9+1)
  { # if less than 2 rounds are played, fall back on previous season:
    $sz2 = $sz1;
    $yr--;
  }
  my $s_total = u2s($u_nl->{$sz2},   1, 1, "uit + thuis $sz2", -1);
  my $s_home  = u2s($u_nl->{$sz2}, 101, 1, "thuis $sz2", -1);
  my $s_away  = u2s($u_nl->{$sz2}, 201, 1, "uit $sz2", -1);
  my $txt_total = get_stand($s_total, 4, 0, [1]);
  my $txt_home  = get_stand($s_home , 4, 0, [1]);
  my $txt_away  = get_stand($s_away , 4, 0, [1]);
  $out = ftable('border',
   ftr( ftdx('vtop', ftable('border', $txt_home )) .
        ftdx('vtop', ftable('border', $txt_away )) .
        ftdx('vtop', ftable('border', $txt_total)) )) . "\n&nbsp;<p>&nbsp;\n" . $out;
 }

 my $title = ($type ne 'uit_thuis' ? 'Winterkampioen en jaarstanden eredivisie' : 'Uit- en thuis standen eredivisie');
 #
 my $options = '';
 for (my $i = 1993; $i <= $yearlast; $i++)
 {
  if ($i == $yr) {next;}
  my $selected = ($i == $yr -1 ? 'selected ' : '');
  if ($type eq 'uit_thuis')
  {
   my $szn = yr2szn($i);
   my $szn2 = $szn;
      $szn2 =~ s/-/_/;
   $options .= qq(<a href="sport_voetbal_nl_uit_thuis_$szn2.html">$szn</a> | \n);
  }
  else
  {
   $options .= qq(<a href="sport_voetbal_nl_jaarstanden_$i.html">$i</a> | \n);
  }
 }
 my $jaren = ($type eq 'uit_thuis' ? 'seizoenen' : 'jaren');
 $out = << "EOF";
<hr>
Ga naar andere $jaren:
$options
<hr>
$out
EOF

 return maintxt2htmlpage($out, $title, 'title2h1', $dd, {type1 => 'std_menu', root => '/'});
}

return 1;
