package Shob::Stats_Website;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Shob_Tools::Html_Head_Bottum;
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
 '&get_stats',
 '&set_laatste_datum_statfiles',
 #========================================================================
);

sub collect_stats_files($$)
{# (c) Edwin Spee

 my ($start_yr, $stop_yr) = @_;

 my $regexp1 = '(http\S*)\s+(\d+)\s*\((\d+.\d)Kb\)';

 my $statsdir = 'Data_stats_website';

 my $out = '';
 my $datum = -1;
 for (my $yr = $start_yr; $yr <= $stop_yr; $yr++)
 {foreach my $month ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
  {
   my $flnm_new = File::Spec->catfile($statsdir, $yr, "stats_epsig_$month$yr.txt");
   my $flnm_nw2 = File::Spec->catfile($statsdir, $yr, "stats_$month$yr.txt");
   my $filename = File::Spec->catfile($statsdir, "stats_epsig_$month$yr.txt");
   my $flnm_old = File::Spec->catfile($statsdir, "stats_$month$yr.txt");
   open (IN, $flnm_new) or open (IN, $flnm_nw2) or open (IN, $filename) or open (IN, $flnm_old) or next; 
   my ($days, $traffic, $hits, $pageviews, $pv_kj, $pv_sport) = (0) x 6;
   while (my $line = <IN>)
   {
    if ($line =~ m/^ *(\d+ ... \d{4})/iso)
    {$datum = $1; $days++;}
    elsif ($line =~ m/traffickb = (\d+\.\d);/iso)
    {$traffic = $1 / (1024*1024);}
    elsif ($line =~ m#$regexp1#iso)
    {my ($url, $h, $t) = ($1, $2, $3);
     $hits += $h;
     if ($url !~ m/(include|jpg|gif|ico|robots)/iso)
     {$pageviews += $h;
      if ($url =~ m/sport/iso) {$pv_sport += $h;}
     }
     if ($url =~ m/kj_code/iso) {$pv_kj += $h;}
   }}
   close(IN);

   $hits *= 1E-6;
   if ($days < 20)
   {
    $traffic *= 30/$days;
    $hits    *= 30/$days;
    foreach my $x ($pageviews, $pv_kj, $pv_sport)
    {
     $x = '<i>' . int(0.5 + $x * 30/$days) . '</i>';
   }}

   my $out_line = ftd("$month $yr");
   $out_line .= ftd(sprintf '%.2f Gb', $traffic);
   $out_line .= ftd(sprintf '%.2f', $hits) . ftd($pageviews) . ftd($pv_kj) . ftd($pv_sport);
   $out = ftr($out_line) . $out;
 }}

 my $itdate = ($datum ne '-1' ? str2itdate($datum) : -1);

 if (wantarray)
 {
  my $title = ftr(fth('periode') . fth('traffic') . fth('M hits') .
   fth('pageviews total') . fth('pageviews klaverjassen') . fth('pageviews sport'));
  return (ftable('border', $title . $out), $itdate);
 }
 else
 {
  return $itdate;
 }
}

sub set_laatste_datum_statfiles
{# (c) Edwin Spee
 my $ddfixed = get_datum_fixed();
 my $dd = collect_stats_files(int($ddfixed*1e-4)-1,int($ddfixed*1e-4)+1);
 if ($dd > $ddfixed) {set_datum_fixed($dd)};
}

sub get_stats
{# (c) Edwin Spee

 my $out = << 'EOF';
De website www.epsig.nl <sup>*</sup>
haalt de volgende hoeveelheid hits (dat is inclusief plaatjes) en pageviews:
<p>&nbsp;
EOF

 my ($body, $datum) = collect_stats_files(2003, int(get_datum_fixed() / 1E4));
 $out .= $body;
 $out .= "*: en voorganger www.xs4all.nl/~spee t/m mei 2005.\n";
 $out .= "<p>italic: cijfers aangepast vanwege ontbrekende dagen.\n";

 return maintxt2htmlpage([['stats www.epsig.nl', $out]], 'stats www.epsig.nl', 'std',
  $datum, {type1 => 'std_menu'});
}

return 1;
