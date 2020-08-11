package Shob_Tools::Idate;
use strict; use warnings;
use Shob_Tools::Error_Handling;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
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
 '&time2idate',
 '&getidate',
 '&str2itdate',
 '&split_idate',
 '&handle_dd',
 '&todaystr',
 '&deref_datum', # niet zo mooi, maar moet even.
 '&monthstr',
 #========================================================================
);

# monthstr gekopieerd vanuit my_scripts/datum_funcs.
my @maanden =
 ('jan', 'feb', 'mrt', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec');
my @months =
 ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
my @maxdays =
 ( 31,    29,    31,    30,    31,    30,    31,    31,    30,    31,    30,    31);

my @dows_nl = ('zo', 'ma', 'di', 'wo', 'do', 'vr', 'za');
my @dows_en = ('su', 'mo', 'tu', 'we', 'th', 'fr', 'sa');

sub monthstr($)
{
 return ($maanden[$_[0]]);
}

sub handle_dd($)
{
 my ($in) = @_;

 if ($in =~ m/^[a-z][a-z]$/iso)
 {
  my $found = -1;
  for (my $i = 0; $i < 7; $i++)
  {
   if ($in eq $dows_nl[$i] or $in eq $dows_en[$i])
   {
    my $df = (localtime)[6] - $i;
    $df = $df + 7 if $df < 0;
    return time2idate(time - 24*3600*$df);
   }
  }
 }
 if ($in eq '') {$in = time2idate(time);}
}

# today en todaystr gekopieerd vanuit my_scripts/datum_funcs.
sub today
{my ($sec,$min,$hour,$mday,$mon,$year,$w,$y,$i) = localtime();
 return ($mday, monthstr($mon), 1900 + $year);
}

sub todaystr()
{my ($mday, $month, $yr) = today();
 return "$mday $month $yr";
}

sub time2idate($)
{
 my ($time) = @_;

 my ($sec,$min,$hour,$mday,$mon,$year,$w,$y,$i) = localtime($time);
 return ($mday + 100*(1+$mon) + 10000 * (1900 + $year));
}

sub split_idate($)
{# (c) Edwin Spee
 # versie 1.0 13-jul-2004 initiele versie (verplaatst uit getidate)

 my $idate = $_[0];

 my $yr = int ($idate / 10000);
 my $imnd = int (($idate - $yr*10000)/100);
 my $day = $idate % 100;
 return ($yr, $imnd, $day);
}

sub deref_datum($)
{# (c) Edwin Spee
 # versie 1.0 17-aug-2004 initiele versie

 my $datum = $_[0];

 if (ref $datum eq 'ARRAY')
 {return $datum->[0];}
 else
 {return $datum;}
}

sub getidate($$)
{# (c) Edwin Spee
 # versie 1.3 17-aug-2004 gebruikt deref_datum
 # versie 1.3 13-jul-2004 gebruikt split_idate
 # versie 1.2 16-dec-2003 datum mag ref naar array zijn (quick-fix)
 # versie 1.1 10-sep-2003 lege string gewoon teruggeven
 # versie 1.0 02-sep-2003 initiele versie

 my ($pdatum, $type) = @_;

 my $datum = deref_datum($pdatum);
 if ($datum =~ m/^$/iso) {return '';}
 elsif ($datum =~ m/[^\d-]/iso) {return $datum;}
 elsif ($datum <= 0)
 {return '';
 }

 my ($yr, $imnd, $day) = split_idate($datum);
 if ($imnd < 1 or $imnd > 12) {return "? ? $yr";}
 my $mnd = monthstr ($imnd - 1);
 if ($day < 1 or $day > 31) {return "$mnd $yr";}

 if ($type == 0)
 {return "$day $mnd $yr";
 }
 elsif ($type == 1)
 {return sprintf ('%02u %s %4u', $day, $mnd, $yr);
 }
 elsif ($type == 2 and $day < 10)
 {return sprintf ("%1u %s '%02u",$day,$mnd,$yr % 100);
 }
 else
 {return sprintf ("%02u %s '%02u",$day,$mnd,$yr % 100);
 }
}

sub str2itdate($)
{# (c) Edwin Spee
 # converts string of format
 # dd mmm yyyy or d mmm yyyy, with mmm one of Jan, Feb etc (dutch or english)
 # into idate format

 my ($cdate) = @_;

 my ($dd, $mmm, $yyyy) = split / /, $cdate;
 if ($dd !~ m/^\d{1,2}$/iso or $yyyy !~ m/^\d{4}/iso) {shob_error('notvaliddate', [$cdate]);}
 my $mon = -1;
 foreach my $m (1 .. 12)
 {
  if (uc($mmm) eq uc($maanden[$m-1]) or uc($mmm) eq uc($months[$m-1]))
  {$mon = $m;
   if ($dd > $maxdays[$m-1]) {shob_error('notvaliddate', [$cdate]);}
   last;
  }
 }
 if ($mon == -1) {shob_error('notvaliddate', [$cdate]);}
 return $dd + 1E2 * $mon + 1E4 * $yyyy;
}

return 1;

