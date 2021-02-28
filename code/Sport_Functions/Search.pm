package Sport_Functions::Search;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Html_Stuff;
use Shob_Tools::General;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Seasons;
use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
use Sport_Collector::Teams;
use Sport_Functions::Range_Available_Seasons;
use Sport_Functions::Seasons;
use Exporter;
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
 '&sport_search_results',
 #========================================================================
);

sub sport_search_results($$$$$)
{# (c) Edwin Spee

 my ($c1, $c2, $dd1, $dd2, $both) = @_;

 my $ranges = get_sport_range();
 my $first_yr = szn2yr($ranges->{eredivisie}[0]);
 my $last_yr  = szn2yr($ranges->{eredivisie}[1]);
 my $max_seasons = 5 + $last_yr - $first_yr;

 my @c1 = find_club($c1);
 my @c2 = find_club($c2);

 my $out = "\n";
 if (scalar @c1 * scalar @c2 > 10)
 {
  $out .= ftr(ftdl('Too many clubs, please, be more specific.'));
 }
 elsif (scalar @c1 * scalar @c2 == 0)
 {
  $out .= ftr(ftdl('Sorry, unknown club(s), please, try again.'));
 }
 elsif ($c1 eq $c2)
 {
  $out .= ftr(ftdl('Please, give two different clubs.'));
 }
 else
 {
  my $dd = $u_nl->{laatste_speeldatum};
  my ($yr1, $mnd1, $day1, $yr2, $mnd2, $day2);
  if ($dd1 =~ m/(\d{4})(\d{2})(\d{2})/iso)
  {
   ($yr1, $mnd1, $day1) = ($1, $2, $3);
  }
  else
  {
   ($yr1, $dd1) = ($first_yr, 1E4*$first_yr + 101);
   $out .= ftr(ftdl("ongeldige datum $yr1: format = yyyymmdd. Using $dd1.\n"));
  }
  if ($dd2 =~ m/(\d{4})(\d{2})(\d{2})/iso)
  {
   ($yr2, $mnd2, $day2) = ($1, $2, $3);
  }
  else
  {
   $out .= ftr(ftdl("ongeldige datum $yr2: format = yyyymmdd. Using $dd.\n"));
   ($yr2, $dd2) = (int($dd*1E-4), $dd);
  }

  if (scalar @c1 * scalar @c2 * (1 + $yr2 - $yr1) > $max_seasons)
  {
   $out .= ftr(ftdl('Too many clubs or seasons, please, be more specific.'));
  }
  else
  {
   for (my $year=max($yr1-1, $first_yr); $year <= $yr2; $year++)
   {
    my $seizoen = yr2szn($year);
    my $u_szn = $u_nl->{$seizoen};
    if (defined $u_szn)
    {
     foreach my $t1 (@c1)
     {
      foreach my $t2 (@c2)
      {
       if ($t1 ne $t2)
       {
        my $uc1c2 = filter_team([$t1, $t2], 2, $u_szn, $both);
        if (scalar @{$uc1c2} > 1)
        {
         if ($year <= $yr1 or $year >= $yr2-1)
         {
          $uc1c2 = filter_datum($dd1, $dd2, $uc1c2);
         }
         $out .= get_uitslag($uc1c2, {ptitel => [0]});
    }}}}}
    else
    {
     last;
 }}}}

 return ftable('border', $out);
}

return 1;
