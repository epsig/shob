package Sport_Functions::Get_Result_Standing;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Sport_Functions::Get_Land_Club;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_uitslag',
 '&get_1_uitslag',
 '&get_last16',
 '&get_stand',
 #========================================================================
);

sub get_title($$$)
{# (c) Edwin Spee
 # versie 1.0 15-aug-2003 initiele versie

my ($u_s, $ptitel, $cols) = @_;
my $ret_val = '';

if ($ptitel->[0] != 0)
{# check hier ook of titel wel bestaat!!
 my $t_str = ($ptitel->[0] == 1 ? $u_s->[0][0] : $ptitel->[1]);
 $ret_val = ftr(fth({cols => $cols, class => 'h'}, $t_str));
}
return $ret_val;
}

sub get_stand($$$$)
{# (c) Edwin Spee

 my ($pstand, $output_optie, $expand_optie, $ptitel) = @_;
# $output_optie == 1 : alles
# $output_optie == 2 : wedstrijden; punten; doelsaldo
# $output_optie == [3, offset] : volgnr+offset, wedstrijden; punten; doelsaldo, geen title

 my $offset = 0;
 if (ref $output_optie eq 'ARRAY')
 {$offset = $output_optie->[1];
  $output_optie = 3;
 }

 my $rijen = scalar @$pstand;
 my @tdarr = fill_tdarray_stand($pstand, $output_optie);

 my $out = get_title($pstand, $ptitel, $output_optie == 1 ? 7 : 4);
 if ($output_optie == 3) {$out = '';}

 my $opts = [
['K',   1, ''],
['PDD', 0, ' (NC;degr.)'],
['PDP', 0, ' (NC;prom.)'],
['PD',  0, ' (NC)'],
['RP',  0, ' (prom.)'],
['RD',  0, ' (degr.)'],
['UEFA',0, ' (UEFA)'],
['EL',  0, ' (EL)'],
['vEL', 0, ' (voorr. EL)'],
['CL',  0, ' (CL)'],
['vCL', 0, ' (voorr. CL)'],
['EC2', 0, ' (ECII)'],
['NB',  1, ' (behoud ered.)'],
['NP',  1, ' (prom.)'],
['ND',  0, ' (degr.)'],
];

 for (my $i = 1; $i < $rijen; $i++)
 {
  my $rij = $pstand->[$i];

  my $extra = '';
  my $bold = 0;
  if (scalar @$rij > 5)
  {
   my $option = $rij->[5][0];
   $extra = " $option" if $option ne '';
   foreach my $opt (@$opts)
   {
    my ($code, $b, $str) = @$opt;
    if ($option =~ m/\b$code\b/is)
    {
     $extra = $str;
     $bold  = max($bold, $b);
    }
   }
  }

  my $nr = ($output_optie == 3 ? ftdl($i+$offset) : '');
  my $row = $nr . ftdx ($tdarr[0],
   ($bold?'<b>':''). expand($rij->[0],$expand_optie). ($bold?'</b>':''). $extra);
  my $wedstr   = $rij->[1];
  my $winst    = $rij->[2][0];
  my $gelijk   = $rij->[2][1];
  my $verloren = $rij->[2][2];
  my $punten   = $rij->[3];
  my $voor     = $rij->[4][0];
  my $tegen    = $rij->[4][1];
  my $saldo = $voor - $tegen;
  $saldo = '+' . $saldo if ($saldo > 0);

  $row .= ftdx ($tdarr[1], $wedstr);
  if ($output_optie == 1)
  {
   $row .= ftdx ($tdarr[2], $winst) . ftdx ($tdarr[3], $gelijk) .
           ftdx ($tdarr[4], $verloren) . ftdx ($tdarr[5], $punten) .
           ftdx ($tdarr[6], $voor . '-' . $tegen);
  }
  elsif ($wedstr > 0 and $output_optie != 4)
  {
   $row .= "\n" . ftdx ($tdarr[5],
    qq(<acronym title="$winst x w, $gelijk x g en $verloren x v => $punten pnt">$punten</acronym>));
   $row .= "\n" . ftdr (qq(<acronym title="$voor - $tegen = $saldo">$saldo</acronym>));
  }
  else
  {
   $row .= ftdx ($tdarr[5], $punten) . ftdr ($saldo);
  }
  $out .= ftr($row);
 }
 if (scalar @{$pstand->[0]} > 1)
 {
  $out .= ftr(ftd({cols => 7}, $pstand->[0][1]));
 }
 return $out;
}

sub fill_tdarray_stand($$)
{# (c) Edwin Spee
 # versie 1.1 18-okt-2004 klaarmaken voor output_optie == 2
 # versie 1.0 11-aug-2003 initiele versie

 my ($pstand, $output_optie) = @_;
 my @tdarr_init = ('l', 'r', 'r', 'r', 'r', 'r', 's');
 my @mins = ( 1e33) x 8;
 my @maxs = (-1e33) x 8;

 for (my $i = 1; $i < scalar @$pstand; $i++)
 {
  my @data;
  $data[0] = '';
  $data[1] = $pstand->[$i][1];
  for (my $j=0; $j<3; $j++)
  {
   $data[2+$j] = $pstand->[$i][2][$j];
  }
  $data[5] = $pstand->[$i][3];
  for (my $j=0; $j<2; $j++)
  {
   $data[6+$j] = $pstand->[$i][4][$j];
  }

  for (my $j=1; $j<8; $j++)
  {
   $mins[$j] = min($mins[$j],$data[$j]);
   $maxs[$j] = max($maxs[$j],$data[$j]);
  }
 }
 my @tdarr = @tdarr_init;
 {
  for (my $j=1; $j<6; $j++)
  {
   if (equal_digits($mins[$j],$maxs[$j]))
   {
    $tdarr[$j] = 'l';
   }
  }
 }
 if (equal_digits($mins[6],$maxs[6]) && equal_digits($mins[7],$maxs[7]))
 {
  $tdarr[6] = 'l';
 }
 return @tdarr;
}

sub make_bold
{# (c) Edwin Spee

 my ($is_finale, @ster) = @_;

 my @bold = ('', '', '', '');
 if ($is_finale)
 {
  if ($ster[0] ne '')
  {
   @bold = ('<b>','</b>','','');
  }
  elsif ($ster[1] ne '')
  {
   @bold = ('','','<b>','</b>');
  }
 }
 return @bold;
}

sub make_wns_nv($)
{# (c) Edwin Spee

 my ($code) = @_;

 if ($code<=2)
 {
  return '';
 }
 elsif ($code>=5)
 {
  return $nbsp . 'n.s.';
 }
 else
 {
  return $nbsp . 'n.v.';
 }
}

sub make_ster($)
{# (c) Edwin Spee

 my ($uitslag_code) = @_;

 if ($uitslag_code <= 0)
 {
  return ('', '');
 }
 elsif ($uitslag_code % 2 == 1)
 {
  return ($nbsp . '*', '');
 }
 else
 {
  return ('', $nbsp . '*');
 }
}

sub uitslag_str($)
{# (c) Edwin Spee

 my $u = $_[0];
 if (scalar @$u > 2)
 {my ($a, $b) = ($u->[1], $u->[2]);
  return $a .'-'.$b if ($a > -1 and $b > -1);
 }
 elsif (ref ($u->[0]) eq 'ARRAY')
 {
  my $hour = int ($u->[0][1] / 100);
  my $min  = $u->[0][1] % 100;
  return sprintf ('<i>%2u:%02u</i>', $hour, $min);
 }

 return '.-.';
}

sub get_uitslag($$)
{# (c) Edwin Spee

 # $ptitel = [1] : print titelstring van $pu
 # $ptitel = [0] : print geen titelstring
 # $ptitel = [2,string] : print string als titel string

 my ($pu, $options) = @_;

 if (scalar @$pu == 1) {return '';}

 my $ptitel = [1];
 $ptitel = $options->{ptitel} if defined $options->{ptitel};
 my $cols = 1;
 $cols = $options->{cols} if defined $options->{cols};
 my $opt_expand = 1;
 $opt_expand = $options->{opt_expand} if defined $options->{opt_expand};

 my $out = get_title($pu, $ptitel, $cols+1);

 for (my $i = 1; $i < scalar @$pu; $i++)
 {
  for (my $j = 1; $j <= get_cnt_uitslagen($pu->[$i]); $j++)
  {
   my $hpu = get_1_uitslag($pu->[$i], $j, 0, $opt_expand);
   my $cell1 = $hpu->{dd_acro} . ' ' . $hpu->{affiche_link};
   $cell1 = ($cols == 1 ? ftdl($cell1) : ftd({cols => $cols}, $cell1));
   $out .= ftr($cell1 . ftdc($hpu->{u}));
   if ($hpu->{opm} ne '')
   {$out .= ftr(ftd({cols => 1+$cols}, $hpu->{opm}));}
  }
 }
 return $out;
}

sub get_cnt_empty_uitslagen($)
{# (c) Edwin Spee

 my ($u) = @_;

 my $cnt = 0;
 for (my $i = 2; $i < scalar @$u; $i++)
 {
  if (ref ($u->[$i]) eq 'ARRAY' and scalar @{$u->[$i]} == 0)
  {
   $cnt++;
  }
 }

 return $cnt;
}

sub get_cnt_uitslagen($)
{# (c) Edwin Spee

 my ($u) = @_;

 my $found = -1;
 for (my $i = 2; $i < scalar @$u; $i++)
 {
  if (ref ($u->[$i]) eq 'ARRAY' and scalar @{$u->[$i]} > 0)
  {
   $found = $i - 1;
  }
  else
  {
   last;
 }}

 return $found;
}

sub get_1_uitslag($$$$)
{# (c) Edwin Spee

 my ($u, $i, $is_finale, $opt_expand) = @_;

 my $g = get_cnt_uitslagen($u);
 if ($g < $i) {print "warning: cnt = $g; param = $i.\n";}

 my $e = get_cnt_empty_uitslagen($u);

 my ($a, $b);
 if ($opt_expand == 5)
 {
  $a  = expand($u->[$i-1], 1);
  $b  = expand($u->[2-$i], 0);
 }
 else
 {
  $a  = expand($u->[$i-1], ($i == 1 ? $opt_expand : 0));
  $b  = expand($u->[2-$i], ($i == 1 ? $opt_expand : 0));
 }
 my $dd = getidate($u->[1+$i][0], 1);

 my $stadion = '';
 my $ster_nr = -1;
 for (my $j = 2+$g+$e; $j < scalar @$u; $j++)
 {
  if ($u->[$j] =~ m/[a-z]/iso)
  {
   $stadion = $u->[$j];
  }
  else
  {
   $ster_nr = $u->[$j];
 }}

 my $u_str  = uitslag_str($u->[1+$i]) . ($i == $g ? make_wns_nv($ster_nr) : '');
 my @ster   = ($i == $g ? make_ster($ster_nr) : ('', ''));
 my @bold   = make_bold($is_finale, @ster);

 my $affiche = "$a$ster[0] - $b$ster[1]";
 $affiche = "$a$ster[1] - $b$ster[0]" if ($i == 2 and not $is_finale);
 $affiche = "$bold[0]$a$bold[1] - $bold[2]$b$bold[3]" if $is_finale;
 $affiche = "$bold[2]$a$bold[3] - $bold[0]$b$bold[1]" if ($i == 2 and $is_finale);

 my $affiche_link = $affiche;

 my $opm = '';
 if (scalar @{$u->[1+$i]} > 3)
 {my $details = $u->[1+$i][3];
  if (ref $details eq 'HASH')
  {
   if (defined $details->{refname})
   {$affiche_link = qq(<a href="#$details->{refname}">$affiche</a>);}
   if (defined $details->{opm})
   {$opm = " ($details->{opm})";}
   if (defined $details->{stadion})
   {$stadion = $details->{stadion};}
   if (defined $details->{afgelast})
   {$u_str = 'afgelast';}
  }
 }

 my $dd_acro = ($stadion ne '' ? qq(<acronym title="te: $stadion">$dd</acronym>) : $dd);

 return {
  a  => $a,
  b  => $b,
  dd => $dd,
  u  => $u_str,
  opm     => $opm,
  stadion => $stadion,
  dd_acro => $dd_acro,
  affiche => $affiche,
  affiche_link => $affiche_link,
 };
}

sub get_last16
{# (c) Edwin Spee

 my ($phu) = @_;

 my @lines;
 my $line_nr = {u16 => [-1, 0, 2, 4, 6, 9, 11, 13, 15],
                uk  => [-1, 1, 5, 10, 14],
                uh  => [-1, 3, 12]};
 my $size1 = 2;
 my $size2 = 4;
 my $size3 = 3;

 my $tabs_pre; my $tabs_post;
 if (not defined $phu->{u16})
 {
  $tabs_pre  = {uk => ''    , uh => tds(1), uf71 => '', uf81 => '', uf72 => tds($size2-1), uf82 => tds($size3-1)};
  $tabs_post = {uk => tds(5), uh => tds(4)};
 }
 else
 {
  $tabs_pre  = {u16 => '',     uk => tds(1), uh => tds(2), uf71 => tds(1), uf81 => tds(1), uf72 => tds($size2), uf82 => tds($size3)};
  $tabs_post = {u16 => tds(5), uk => tds(4), uh => tds(3)};
 }

 my $opm = '';
 foreach my $round ('u16', 'uk', 'uh')
 {
  my $phr = $phu->{$round};
  if (defined $phr)
  {
   for (my $i = 1; $i < scalar @$phr ; $i++)
   {
    my $pu = $phr->[$i];
    $lines[$line_nr->{$round}->[$i]] = '';
    my $cnt = get_cnt_uitslagen($pu); # gebruik $cnt als switch for europacup
    for (my $j = 1; $j <= $cnt; $j++)
    {
     my $opt_expand = 0;
     if ($cnt == 2 and $round eq 'uk') {$opt_expand = 5;}

     my $ph1u = get_1_uitslag($pu, $j, 0, $opt_expand);
     $lines[$line_nr->{$round}->[$i]] .= ftr($tabs_pre->{$round} . ftdr($ph1u->{dd_acro}) .
      ftd({cols => $size1}, $ph1u->{affiche_link}) . ftdl($ph1u->{u}) . $tabs_post->{$round});
    }
   }
  }
 }

 my $t34 = '<i>3e/4e plaats:</i>';
 my $tfl = '<b>F I N A L E:</b>';
 if (defined($phu->{uf}[1]) and defined($phu->{u34}[1]))
 {
  my $ph1u1 = get_1_uitslag($phu->{uf}[1], 1, 1, 1);
  my $ph1u2 = get_1_uitslag($phu->{u34}[1], 1, 0, 1);
  $lines[7] = ftr($tabs_pre->{uf71} . ftd({cols => 4}, $t34) . "\n" . ftd({cols => 4}, $tfl) );
  $lines[8] = ftr($tabs_pre->{uf81} .
   ftdr($ph1u2->{dd_acro}) . ftd({cols => 2}, $ph1u2->{affiche_link}) . ftdl($ph1u2->{u}) . "\n" .
   ftdr($ph1u1->{dd_acro}) . ftd({cols => 2}, $ph1u1->{affiche_link}) . ftdl($ph1u1->{u}) );
  if ($ph1u1->{opm} ne '') {$opm .= ftr(ftd({cols => 7}, $ph1u1->{opm}));}
 }
 elsif (defined($phu->{uf}[1]))
 {
  $lines[7] = ftr($tabs_pre->{uf72} . ftd({cols => 4}, $tfl));
  $lines[8] = '';
  for (my $j = 1; $j <= get_cnt_uitslagen($phu->{uf}[1]); $j++)
  {
   my $ph1u1 = get_1_uitslag($phu->{uf}[1], $j, 1, 0);
   $lines[8] .= ftr($tabs_pre->{uf82} .
    ftdr($ph1u1->{dd_acro}) . ftd({cols => 2}, $ph1u1->{affiche_link}) . ftdl($ph1u1->{u}) );
   if ($ph1u1->{opm} ne '') {$opm .= ftr(ftd({cols => 7}, $ph1u1->{opm}));}
  }
 }

 my $out = '';
 for (my $i = 0; $i < scalar @lines ; $i++)
 {
  $out .= $lines[$i] if (defined $lines[$i]);
 }
 $out .= $opm;

 if (defined $phu->{uf}[1] and defined $phu->{u16})
 {
  $out = ftable('width100%', $out);
   if (defined $phu->{title})
  {
   my $hdr = ftr(fth({cols => 4, class => 'h'}, $phu->{title}));
   $out = ftable('border_width100%', $hdr . ftr(ftdl($out)));
  }
 }
 else
 {
  $out = ftable('tabs', $out);
   if (defined $phu->{title})
  {
   my $hdr = ftr(fth({cols => 4, class => 'h'}, $phu->{title}));
   $out = ftable('border', $hdr . ftr(ftdl($out)));
  }
 }
 return $out;
}

return 1;

