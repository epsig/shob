package Sport_Functions::Formats;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Error_Handling;
use Shob_Tools::General;
use Shob_Tools::Idate;
use Sport_Collector::Archief_Voetbal_Beker;
use Sport_Collector::Archief_Voetbal_NL_Standen;
use Sport_Collector::Archief_Voetbal_NL_Topscorers qw(&get_topscorers_competitie);
use Sport_Functions::Overig;
use Sport_Functions::Seasons;
use Sport_Functions::List_Available_Pages;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Results2Standing;
use Sport_Functions::Get_Land_Club;
use Sport_Functions::NatLeagueReaders;
use Sport_Functions::Range_Available_Seasons qw($global_first_year);
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
 '&format_ekwk',
 '&format_voorronde_ekwk',
 '&format_europacup',
 '&format_eindstanden',
 #========================================================================
);

sub ko_or_comp($$$)
{# (c) Edwin Spee

 my ($uu, $linkname, $cols) = @_;

 $uu->[0][0][0] = qq(<a name="$linkname">) . $uu->[0][0][0] . '</a>';

 my $found_stand_g = 0;
 if ($cols > 0)
 {
  $found_stand_g = 1;
 }
 else
 {
  foreach my $row (@$uu)
  {
   if (scalar @{$row->[0]} > 1)
   {
    my $type = $row->[0][1];
    if ((scalar @{$row->[0]} > 2) or (ref $type eq 'ARRAY'))
    {
     $found_stand_g = 1;
     last;
    }
   }
  }
 }

 my $out = '';
 my $is_first = 1;
 foreach my $row (@$uu)
 {
  my $found_stand_l = 0;
  if (scalar @{$row->[0]} > 1)
  {
   my $stand;
   my $type = $row->[0][1];
   if (ref $type eq 'ARRAY')
   {
    $found_stand_l = 1;
    $stand = u2s($row, @$type);
    if (scalar @$type > 4)
    {
      # copy extra remark from games to standing
      $stand->[0][1] = $type->[4];
    }
   }
   if (defined $stand)
   {
    if ($is_first)
    {
     $stand->[0][0] = qq(<a name="$linkname">) . $stand->[0][0] . '</a>';
    }
    $out .= get_stand($stand , 2, 2, [1]);
   }
  }
  $out .= get_uitslag(filter_team(['NL'], 1, $row),
   {opt_expand => $found_stand_l ? 0 : 2,
    cols => $found_stand_g ? 3 : 1,
    ptitel => $found_stand_l ? [0] : [1]});
  $is_first = 0;
 }
 return $out;
}

sub ekwk_stats($)
{# (c) Edwin Spee

 my ($all) = @_;

 my $out = '';
 my $found = 0;
 my @titels = ('Grootste winst', 'Veel goals', 'Veel goals (beide)');
 for (my $i = 1; $i <= 3; $i++)
 {
  $out .= ftr(ftd({cols => 2}, $titels[$i-1] .':'));
  my $opv = filter_opvallend($all, $i);
  for (my $i=1; $i<scalar @$opv; $i++)
  {
   my $hu = get_1_uitslag($opv->[$i], 1, 0, 1);
   $out .= ftr(ftdl($hu->{affiche}) . ftdl($hu->{u}));
   $found = 1;
 }}
 $out = ftable('tabs', $out);

 my ($sum_t, $ti) = gem_aantal_toeschouwers($all, 1);
 if ($ti > 4 and $sum_t > 0.0)
 {
  my $tgem = sprintf('%.0f', $sum_t / $ti / 1000);
  my $trnd = sprintf('%.2f', $sum_t / 1E6);
  $out .= "<p>Na $ti wedstrijden $trnd miljoen toeschouwers: gemiddeld $tgem duizend .\n";
  $found = 1;
 }

 if (not $found) {$out = '';}

 return $out;
}

sub format_ekwk($$$$$)
{# (c) Edwin Spee

 my ($year, $organisatie, $phu, $topscorers, $dd) = @_;

 my $has_tp = (scalar @$topscorers > 0);
 my $ko = (defined $phu->{u16} ? 16 : 8);

 my $EK_WK = $year % 4;
 my $EK_WK_str = ($EK_WK >= 2 ? 'WK' : 'EK');

 my $DH = $year % 2;

 my $grp_txt_l = '';
 my $grp_txt_r = '';
 my $grp_txt   = '';
 my $u = $phu->{grp};


 for (my $i=0; $i < scalar @$u / 2; $i++)
 {
  my $ii = 2*$i;
  my $ster = 1;
  if (defined $phu->{ster}) {$ster = $phu->{ster};}
  my $group =$$u[$ii]->[0][0];
  if (defined $$u[$ii]->[0][1])
  {
   $ster  = $$u[$ii]->[0][1][3];
   $group = $$u[$ii]->[0][1][2];
  }

  my $s = u2s($$u[$ii], 1, $phu->{sort_rule}, $group, $ster);
  $grp_txt_l .= get_uitslag($$u[$ii], {cols => 3}) . get_stand($s, 2, 0, [0]);
  $grp_txt .= qq(<div class="row"><div class="column">\n);
  $grp_txt .= ftable('tabs', get_uitslag($$u[$ii], {cols => 3}) . get_stand($s, 2, 0, [0]));
  $grp_txt .= "\n</div>\n";

  $ii = 2*$i + 1;
  $ster = 1;
  if (defined $phu->{ster}) {$ster = $phu->{ster};}
  if (defined $$u[$ii]->[0][1]) {$ster = $$u[$ii]->[0][1][3];}
  if ($ii <= scalar @$u -1)
  {
   $s = u2s($$u[$ii], 1, $phu->{sort_rule}, $$u[$ii]->[0][0], $ster);
   $grp_txt_r .= get_uitslag($$u[$ii], {cols => 3}) . get_stand($s, 2, 0, [0]);
   $grp_txt .= qq(<div class="column">\n);
   $grp_txt .= ftable('tabs', get_uitslag($$u[$ii], {cols => 3}) . get_stand($s, 2, 0, [0]));
   $grp_txt .= "\n</div></div>\n";
  }
 }

 my $all = $phu->{all};
 my $details = more_details($all);
 my $stats   = ekwk_stats($all);

 my $out = << "EOF";
<ul>
EOF
if ($DH == 0)
{
 $out .= << "EOF";
 <li><a href="sport_voetbal_${EK_WK_str}_${year}_voorronde.html">voorronde en oefenduels</a></li>
EOF
}
$out .= << "EOF";
 <li><a href="#r2f">de laatste $ko</a></li>
 <li><a href="#groep_a_h">de groepswedstrijden</a></li>
EOF

 if ($stats ne '')
 {$out .= qq( <li><a href="#opvallend">opvallende uitslagen</a></li>\n);}

 if ($details ne '')
 {$out .= qq( <li><a href="#details">details enkele wedstrijden</a></li>\n);}

 if ($has_tp)
 {$out .= qq( <li><a href="#topscorers">topscorers</a></li>\n);}

 $out .= << "EOF";
</ul>
<hr>
<a name="r2f"><h1>De laatste $ko</h1></a>
EOF

 $out .= get_last16($phu);
 $out .= qq(<hr><a name="groep_a_h"><h1>De groepswedstrijden</h1></a>\n);
 if ($year == 2018)
 {
  $out .= $grp_txt;
 }
 else
 {
  $out .= get2tables($grp_txt_l, $grp_txt_r);
 }

 if ($stats ne '')
 {
  $out .= qq(<hr><h2><a name="opvallend">Opvallende uitslagen</a></h2>\n);
  $out .= $stats;
 }

 if ($details ne '')
 {
  $out .= qq(<hr><h2><a name="details">Details enkele wedstrijden</a></h2>\n);
  $out .= $details;
 }
 $out .= "<hr>\n";


 if ($has_tp)
 {
  $topscorers->[0][0] = qq(<a name="topscorers">$topscorers->[0][0]</a>);
  $out .= ftable('tabs', get_tpsc(10, $topscorers, 0));
 }

 my $dames = ($DH ? '(vrouwen) ' : '');
 my $title = "$EK_WK_str voetbal ${dames}te $organisatie in $year";
 return maintxt2htmlpage(EkWkTopMenu($year) . $out, $title, 'title2h1',
  $dd, {type1 => 'std_menu'});
}

sub format_voorronde_ekwk
{# (c) Edwin Spee

 my ($year, $phu) = @_;

 my $organisatie = $phu->{organising_country};
 my $yearTitle   = $phu->{yearTitle};

 my $EK_WK = $year % 4;
 my $EK_WK_str = ($EK_WK >= 2 ? 'WK' : 'EK');

 my $out = "<ul>\n";
 if ($year > 1995 and $year <= 2018) #TODO eindjaar automatiseren
 {$out .=
qq(<li> <a href="sport_voetbal_${EK_WK_str}_$yearTitle.html">Eindronde $year in $organisatie.</a>\n);}
 if (defined $phu->{u_nl})
 {$out .= qq(<li> <a href="#groepNL"> Stand en uitslagen groep van Nederland</a>\n);}
 my $t = ($EK_WK ? 'Europese' : 'alle');
 if (defined $phu->{grp_euro})
 {$out .= qq(<li> <a href="#standen"> Standen $t poules </a>\n);}
 if (defined $phu->{play_offs})
 {$out .= qq(<li> <a href="#playoff"> Naar de play-offs </a>\n);}
 if (defined $phu->{geplaatst} or defined $phu->{geplaatst_html} or defined $phu->{nrs2})
 {$out .= qq(<li> <a href="#deelnemers"> Overzicht deelnemende landen $EK_WK_str-$year </a>\n);}
 if (defined $phu->{NatL})
 {$out .= qq(<li> <a href="#natleague">Nations League</a>.\n);}
 if (defined $phu->{NatLFinals})
 {$out .= qq(<li> <a href="#natleaguefinals">Nations League Finals</a>.\n);}
 if (defined $phu->{kzb})
 {$out .= qq(<li> <a href="#keizersbaard">Oefenduels</a> van Oranje.\n);}

 $out .= "</ul><hr>\n";

 if (defined $phu->{u_nl})
 {
  my $u_nl = $phu->{u_nl};

  my $args_u2s = $u_nl->[0][1];
  my $s_nl = u2s($u_nl,  @$args_u2s);

  my $recent = '';
  if (defined $phu->{recent})
  {
   my $dd1 = $phu->{recent}->[0];
   my $dd2 = $phu->{recent}->[1];
   $recent = get_uitslag(filter_datum($dd1, $dd2, $u_nl),
    {ptitel => [2, 'Recente uitslagen en programma']});
  }

  my $beslissend = '';
  if (defined $phu->{beslissend})
  {
   $beslissend = get_uitslag(filter_team($phu->{beslissend},2,$u_nl),
    {cols => 3, ptitel => [2, 'beslissende duels:']});
  }

  my $u_nl_nl =    filter_team(['NL'],  1, $u_nl);
  my $u_nl_no_nl = filter_team(['NL'], -1, $u_nl);

  $out .= qq(<a name="groepNL"><h2>Stand en uitslagen groep van Nederland</h2></a>\n);
  my $txt_l = get_stand($s_nl, 2, 0,[2, 'Stand Groep Nederland']) .
   $beslissend .
   get_uitslag($u_nl_nl, {cols => 3, ptitel => [2, 'Uitslagen Nederlands Elftal']});
  my $txt_r = $recent .
   (scalar @$u_nl_no_nl > 1 ? get_uitslag($u_nl_no_nl, {ptitel => [2, 'Overige uitslagen groep Nederland']}) : '');
  if ($txt_r eq '')
  {$out .= ftable('border', $txt_l);}
  else
  {$out .= get2tables($txt_l, $txt_r);}
 }

 if (defined $phu->{grp_euro})
 {
  $out .= qq(<a name="standen"> <h2>Standen $t poules</h2> </a>\n);
  my @s = @{$phu->{grp_euro}};
  my @outA = ('', '', '');
  for (my $j=1; $j <= 3; $j++)
  {for (my $i=$j; $i < scalar @s; $i += 3)
   {$outA[$j-1] .= get_stand($s[$i], 2, 0, [1]);
    # opvullen met lege regels om headings gelijk te krijgen:
    my $start = 1 + 3 * int(($i-1) / 3);
    my $stop  = min(scalar @s - 1, 2 + $start);
    my $max_teams = 0;
    for (my $s=$start; $s <= $stop; $s++)
    {$max_teams = max(scalar @{$s[$s]} , $max_teams);}
    for (my $s=0; $s<($max_teams - scalar @{$s[$i]}); $s++)
    {$outA[$j-1] .= ftr(ftd({cols => 4}, '&nbsp;'));}
   }
  }
  $out .= get3tables($outA[0], $outA[1], $outA[2]);
 }

 if (defined $phu->{play_offs})
 {
  $out .= qq(<a name="playoff"> <h2>Naar de play-offs</h2> </a>\n) .
  ftable('border', get_uitslag($phu->{play_offs}, {ptitel => [0]}));
 }

 if (defined $phu->{geplaatst} or defined $phu->{geplaatst_html} or defined $phu->{nrs2})
 {
  $out .= qq(<a name="deelnemers"> <h2> Overzicht deelnemende landen $EK_WK_str-$year </h2> </a>\n);
 }

 if (defined $phu->{geplaatst_html})
 {
  $out .= << "EOF";
Geplaatst voor de eindronde te $organisatie
<p>
$phu->{geplaatst_html}
EOF
 }
 elsif (defined $phu->{nrs2} and defined $phu->{geplaatst})
 {
  $out .= ftable('tabs',
   expand_list($phu->{geplaatst}, {numbered => 1, opms => 1}) .
    get_stand($phu->{nrs2}, [3, 9], 0, [1]));
 }
 elsif (defined $phu->{geplaatst})
 {
  $out .= ftable('tabs',
   expand_list($phu->{geplaatst}, {numbered => 1, opms => 1}));
 }

 if (defined $phu->{NatL})
 {
  $out .= NatLeague2Html($phu->{NatL});
 }

 if (defined $phu->{NatLFinals})
 {
  $out .= NatLeagueFinals2Html($phu->{NatLFinals});
 }

 if (defined $phu->{extra})
 {
  $out .= $phu->{extra};
 }

 if (defined $phu->{kzb})
 {
  $out .= qq(<a name="keizersbaard"> <h2> Oefenduels Oranje </h2> </a>\n);
  $out .= ftable('border', get_uitslag($phu->{kzb}, {ptitel => [0]}));
 }

 my $title = "Voorronde $EK_WK_str Voetbal $yearTitle te $organisatie";
 return maintxt2htmlpage(EkWkTopMenu($year) . $out, $title, 'title2h1',
  $phu->{dd}, {type1 => 'std_menu'});
}

sub format_one_ec_cup($$)
{# (c) Edwin Spee

 my ($cupname, $u_all) = @_;
 my $u = $u_all->{$cupname};

 my $expect_keys =
 {extra   => ['supercup', 'worldcup'],
  CL      => ['qfr_2', 'qfr_3', 'playoffs', 'groupA' .. 'groupH', 'group2B', 'group2D', 'round_of_16'],
  CWC     => ['round1', 'round2'],
  UEFAcup => ['itoto', 'intertoto', 'qfr', 'qfr_2', 'round1', 'round2', 'groupA' .. 'groupH', 'round3', 'round_of_16'],
  EuropaL => ['qfr_1', 'qfr', 'qfr_2', 'qfr_3', 'playoffs', 'groupA' .. 'groupL', 'round2', 'round_of_16']};

 my $longnames =
 {extra   => 'Supercup/Worldcup',
  CL      => 'Champions League',
  CWC     => 'Europacup-II',
  UEFAcup => 'UEFA-cup',
  EuropaL => 'Europa League',
 };

 my $longname = $longnames->{$cupname};

 my $out = ''; my @listu;

 foreach my $key (@{$expect_keys->{$cupname}})
 {if (defined $u->{$key})
  {push @listu, $u->{$key};
 }}
 $out .= ftable('border', ko_or_comp(\@listu, $cupname, -1)) . '<p>';

 if ($cupname ne 'extra' and (defined $u->{quarterfinal} or defined $u->{semifinal} or defined $u->{final})) {
 my $last16 = get_last16({uk => $u->{quarterfinal}, uh => $u->{semifinal}, uf => $u->{final},
   title => qq($longname: de laatste acht)});
 if ($last16 ne '')
 {
  $out .= qq(<a name="${cupname}_last8"></a><p>\n) . $last16;
 }
 }

 return $out;
}

sub format_europacup($$)
{# (c) Edwin Spee

my ($seizoen, $u) = @_;

my $yr;
if ($seizoen =~ m/(\d{4})-(\d{4})/iso)
{$yr = $1;}
else {die "seizoen fout in format_europacup.\n";}

my $title = "Europacup voetbal seizoen $seizoen";

my $skip = $yr - 1994;

my $menu = get_voetbal_list('menu_format', 'EC');
my $out = '<hr> andere seizoenen: ' . get_menu ('', $skip, 2, -1, @{$menu});

my $out_extra   = (defined $u->{extra}{supercup} ? ftable('border', get_uitslag($u->{extra}{supercup}, {cols => 3})) . '<p>' : '');
my $out_ecI     = (defined $u->{ECI}     ? format_one_ec_cup('EC1',     $u) : '');
my $out_cl      = (defined $u->{CL}      ? format_one_ec_cup('CL',      $u) : '');
my $out_cwc     = (defined $u->{CWC}     ? '<p>' . format_one_ec_cup('CWC',     $u) : '');
my $out_uefacup = (defined $u->{UEFAcup} ? format_one_ec_cup('UEFAcup', $u) : '');
$out_uefacup .= (defined $u->{EuropaL} ? format_one_ec_cup('EuropaL', $u) : '');

$out .= '<hr> ';
if (defined $u->{CL}) {$out .= qq(| <a href="#CL">Champions League</a>\n);}
#if ($cl2txt ne '') {$out .= qq( | <a href="#CL2">Tweede ronde CL</a>\n);}  # voorlopig weg
if ($out_cl =~ m/CL_last8/iso) {$out .= qq( | <a href="#CL_last8">Finale CL</a>\n);}
if (defined $u->{CWC}) {$out .= qq( | <a href="#CWC">EC II</a>\n | <a href="#CWC_last8">Finale EC II</a>\n);}
#if (scalar @$itoto) {$out .= qq( | <a href="#intertoto">Intertoto</a>\n);}
if (defined $u->{UEFAcup}) {$out .= qq( | <a href="#UEFAcup">UEFA-cup</a>\n);}
if (defined $u->{EuropaL}) {$out .= qq( | <a href="#EuropaL">Europa League</a>\n);}
if ($out_uefacup =~ m/UEFAcup_last8/iso) {$out .= qq( | <a href="#UEFAcup_last8">Finale UEFA-cup</a>);}
if ($out_uefacup =~ m/EuropaL_last8/iso) {$out .= qq( | <a href="#EuropaL_last8">Finale Europa League</a>);}
if (defined $u->{CL} or defined $u->{UEFAcup} or defined $u->{EuropaL}) {$out .= " | <hr>\n";}

if (defined $u->{extra}{summary})
{$out .= qq(<h2>Samenvatting Europacup Seizoen $seizoen</h2>\n) . $u->{extra}{summary} . '<hr>';}

my $vCL_link = (defined $u->{CL}{qfr_3} || defined $u->{CL}{qfr_2} ? '<a name="vCL"/>' : '');
$out .= $out_extra . $vCL_link . $out_cl . $out_cwc . '<p>' . $out_uefacup;

return maintxt2htmlpage($out, $title, 'title2h1',
 $u->{extra}{dd}, {type1 => 'std_menu'});
}

sub format_eindstanden($$$$$)
{# (c) Edwin Spee

my ($yr, $opm_ered, $ec, $nc, $datum) = @_;

my $szn = yr2szn($yr);
my $title = "Overzicht betaald voetbal in Nederland, seizoen $szn";
my $ere = standen_eredivisie($szn);
my $div1 = standen_eerstedivisie($szn);
my $tpA = get_topscorers_competitie($szn, 'eredivisie', 'Eredivisie');
my $tpB = get_topscorers_competitie($szn, 'eerste_divisie', 'Eerste Divisie');
my $kls = get_klassiekers($szn);
my $beker_jc = knvb_beker($szn);
my $knvb = $beker_jc->{beker};
my $jc = $beker_jc->{extra}{supercup};

my $some_ered = (scalar @$ere or $opm_ered ne '');
my $some_tpsc = (scalar @$tpA or scalar @$tpB);

my $skip = $yr - $global_first_year;

my $menu = get_voetbal_list('menu_format', 'NL');
my $out = '<hr> andere seizoenen: ' . get_menu ('', $skip, 2, -1, @{$menu});

my $otp = ''; # OnThisPage
if (defined $jc)
{$otp .= qq(<a href="#JC">supercup</a> |\n);
 $jc->[0][0] = '<a name="JC">' . $jc->[0][0] . "</a>";}
if (scalar @$kls > 1)
{$otp .= qq(<a href="#klassiekers">klassiekers</a> |\n);
 $kls->[0][0] = '<a name="klassiekers">' . $kls->[0][0] . "</a>";}
if ($some_ered)
{$otp .= qq(<a href="#ere_div">eredivisie</a> |\n);}
if (defined $knvb)
{$otp .= qq(<a href="#beker">beker-tournooi</a> |\n);}
if ($ec ne '')
{$otp .= qq(<a href="#ec">europa in</a> |\n);}
if (scalar @$div1)
{$otp .= qq(<a href="#1ste_div">eerste divisie</a> |\n);}
if ($some_tpsc)
{$otp .= qq(<a href="#topscorers">topscorers</a> |\n);}
if (scalar @$nc)
{$otp .= qq(<a href="#pd">na-competitie</a> |\n);}
if ($otp ne '') {$out .= '<hr> | ' . $otp;}

$out .= qq(<hr>$link_stats_eredivisie | \n);
$out .=     qq($link_jaarstanden | \n);
$out .=     qq($link_uit_thuis<hr>\n);

if (defined $jc or (scalar @$kls > 1))
{my $tmp_out = '';
 if (defined $jc)  {$tmp_out .= get_uitslag($jc, {opt_expand => 0});}
 if (scalar @$kls > 1) {$tmp_out .= get_uitslag($kls, {opt_expand => 0});}
 $out .= ftable('border', $tmp_out);
}

if ($some_ered)
{$out .= qq(<a name="ere_div"><p></a>\n);
 if (scalar @$ere)
 {$out .= get_table_border(ftable('tabs', get_stand($ere, 2, 0, [1])));}
 if ($opm_ered ne '')
  {
   $out .= "<p> $opm_ered </p> \n";
  }
}

if (defined $knvb)
{$out .= qq(<a name="beker"><p></a>\n);
 if (defined $knvb->{round_of_16} or defined $knvb->{quarterfinal} or defined $knvb->{semifinal})
 {
  my $sponsor;
  if ($yr >= 2007) {$sponsor = '';}
  elsif ($yr >= 2005) {$sponsor = ' (Gatorade cup)';}
  else {$sponsor = ' (Amstel cup)';}

  my $acht_zestien = (defined $knvb->{round_of_16} ? '16' : 'acht');
  my $title = "KNVB Beker$sponsor: de laatste $acht_zestien";
  $out .= get_last16(
  {u16 => $knvb->{round_of_16}, uk => $knvb->{quarterfinal}, uh => $knvb->{semifinal},
   uf => $knvb->{final}, u34 =>$knvb->{u34}, title => $title});
 }
 if ($all_data and defined $knvb->{round2})
 {$out .= '<p>'. ftable('border', get_uitslag($knvb->{round2}, {opt_expand => 0}));
 }
 my $bopm = $knvb->{beker_opm};
 if (defined $bopm) {$out .= $bopm;}
}

if ($ec ne '')
{$out .= qq(<a name="ec"><p></a>\n) .
  get_table_border(
   ftable('tabs', ftr(fth({class => 'h'}, 'Geplaatst voor de europacup')) . ftr(ftdl($ec)) ));
}

if (scalar @$div1)
{$out .= qq(<a name="1ste_div"><p></a>\n);
 $out .= get_table_border(ftable('tabs', get_stand($div1, 2, 0, [1])));}

if ($some_tpsc)
{$out .= qq(<a name="topscorers"><p></a>\n);
 if (scalar @$tpA and scalar @$tpB)
 {$out .= get2tables(get_tpsc(10, $tpA, 1), get_tpsc(10, $tpB, 1));}  # was 9 voor eerste divisie 01/02
 elsif (scalar @$tpA)
 {$out .= get_table_border(ftable('tabs', get_tpsc(10, $tpA, 1)));}
 elsif (scalar @$tpB)
 {$out .= get_table_border(ftable('tabs', get_tpsc(10, $tpB, 1)));}
}

if (scalar @$nc)
{$out .= qq(<a name="pd"><p></a>\n);
 if (scalar @$nc > 2 and scalar @{$nc->[1]} and scalar @{$nc->[2]})
 {$out .= get2tables(
   get_stand($nc->[1], 2, 0, [1]),
   get_stand($nc->[2], 2, 0, [1])
   );
 }
 elsif ($nc->[0] !~ m/table/)
 {$out .= '<h2>Promotie/degradatie</h2>';}
 $out .= "$nc->[0]\n";
}

$out .= "<p>\n";

return maintxt2htmlpage($out, $title, 'title2h1',
 max(20081230, $datum), {type1 => 'std_menu'});
}

return 1;
