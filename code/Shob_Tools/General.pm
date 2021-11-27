package Shob_Tools::General;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Time::HiRes qw(gettimeofday);
use Shob_Tools::Error_Handling;
use Shob_Tools::Settings;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use File::Find;
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
 '&min', '&max', '&round', '&equal_digits',
 '&get_js_function', '&file2str', '&url2txt', '&img_velden',
 '&lees_regel',
 '&get_waiting_time',
 '&lees_stdin',
 '&lees_stdin_noecho',
 '&verhuisbericht',
 '&zoek_term',
 #========================================================================
);

my $waiting_time = 0;
my $gterm;

sub min
{# (c) Edwin Spee
 # versie 2.0 10-sep-2004 zoekt maximum over heel array i.p.v. alleen eerste twee argumenten
 # versie 1.0 02-sep-2003 initiele versie

 my $val = shift;
 foreach my $i (@_)
 {
  if ($i < $val)
  {
   $val = $i;
  }
 }
 return $val;
}

sub max
{# (c) Edwin Spee
 # versie 2.0 10-sep-2004 zoekt maximum over heel array i.p.v. alleen eerste twee argumenten
 # versie 1.0 02-sep-2003 initiele versie

 my $val = shift;
 foreach my $i (@_)
 {
  if ($i > $val)
  {
   $val = $i;
  }
 }
 return $val;
}

sub round($)
{# (c) Edwin Spee
 # versie 1.0 25-jun-2004 initiele versie

 return (int($_[0] + 0.5));
}

sub equal_digits($$)
{
  my ($a,$b) = @_;

  if (defined $a and defined $b)
  {
    return (length($a) == length($b));
  }
  return 0;
}

sub img_velden($$$$$$)
{# (c) Edwin Spee
 # versie 1.3 25-apr-2006 option==2 voor alt_tekst onder foto
 # versie 1.2 26-okt-2004 nieuw argument option
 # versie 1.1 24-sep-2004 gebruik van round
 # versie 1.0 19-sep-2004 initiele versie

 my ($filename, $alt_tekst, $h, $b, $scale, $option) = @_;

 my $hh = round($h * $scale);
 my $bb = round($b * $scale);

 my $ret_val =
  qq(<img src="$filename" alt="$alt_tekst" width="$bb" height="$hh" border="0">);
 if ($option == 1)
 {
  $ret_val = qq(<a href="$filename">$ret_val</a>);
 }
 if ($option == 2)
 {
  $ret_val = qq(<a href="$filename">$ret_val</a> <br> $alt_tekst);
 }

 return $ret_val;
}

sub url2txt($$$)
{# (c) Edwin Spee
 # versie 1.0 23-oct-2004 initiele versie

 my ($url, $tekst, $with_links) = @_;

 my $ret_val = ($with_links ? qq(<a href="$url">$tekst</a>) : $tekst);

 return $ret_val;
}

sub get_js_function($$)
{# (c) Edwin Spee
 # versie 1.0 15-jul-2005 initiele versie

 my ($file_name, $function_name) = @_;
 my $out = '';
 my $found = 0;
 open (IN, $file_name) or shob_error('open_read', [$file_name]);
 while (my $line = <IN>)
 {
  if ($line =~ m/end function $function_name/is)
  {
   last;
  }
  elsif ($line =~ m/function $function_name/is)
  {
   $found = 1;
  }
  if ($found)
  {
   $out .= $line;
  }
 }
 close IN or shob_error('close_read', [$file_name]);
 return $out;
}

sub file2str($)
{# (c) Edwin Spee
 # versie 1.1 18-okt-2004 gebruik shob_error
 # versie 1.0 15-jan-2004 initiele versie

 my $file_name = $_[0];
 my $out = '';
 open (IN, $file_name) or shob_error('open_read', [$file_name]);
 while (<IN>)
 {
  $out .= $_;
 }
 close IN or shob_error('close_read', [$file_name]);
 return $out;
}

sub get_waiting_time()
{# (c) Edwin Spee
 # versie 1.0 23-mrt-2005 initiele versie

 return $waiting_time;
}

sub lees_stdin
{# (c) Edwin Spee
 # versie 1.0 27-mrt-2005 initiele versie

 my $start_wt = gettimeofday;
 my $in = <STDIN>;
 my $stop_wt = gettimeofday;
 $waiting_time += ($stop_wt - $start_wt);

 return $in;
}

sub lees_stdin_noecho
{# (c) Edwin Spee

 my $start_wt = gettimeofday;
 my $in;
 if ($^O =~ m/win32/iso)
 {
  eval
  {# Term::ReadKey is niet overal geinstalleerd.
   # daarom geen use, maar require en ook maar try/catch
   require Term::ReadKey;
   Term::ReadKey::ReadMode('noecho');
   $in = Term::ReadKey::ReadLine(0);
   Term::ReadKey::ReadMode('normal');
  };
  if ($@)
  {$in = <STDIN>;}
 }
 else
 {
  system 'stty -echo';
  $in = <STDIN>;
  system 'stty echo';
 }
 my $stop_wt = gettimeofday;
 print "\n";
 $waiting_time += ($stop_wt - $start_wt);

 return $in;
}

sub lees_regel
{# (c) Edwin Spee
 # versie 1.2 30-mrt-2005 zonder argumenten; die -> shob_error
 # versie 1.1 27-mrt-2005 + timing <STDIN>
 # versie 1.0 23-mrt-2005 initiele versie

 my $stop_at_eof = 1;
 my $line;
 my $ret_val = 0;
 for (;;)
 {
  if (not ($line = lees_stdin))
  {
   if ($stop_at_eof)
   {
    shob_error('oef', ['']);
   }
   else
   {
    $ret_val = 1;
   }
  }
  last if $line !~ m/^$/iso;
 }
 chomp($line);
 return $stop_at_eof ? $line : ($line, $ret_val);
}

sub verhuisbericht($$$)
{
 my ($titel, $url_new, $idate) = @_;
 my $datum   = getidate($idate, 0);
 my $hopa  = ($web_index eq '' ? $www_epsig_nl : "$www_epsig_nl/$web_index");

 my $out = << "EOF";
<html lang="NL">
<head>
<meta name="robots" content="noindex,follow">
<title>$titel</title>
<meta http-equiv="Refresh" content="20;url=$url_new">
</head>
<body>
<hr> <hr>
<h2>$titel</h2>
Deze pagina is verhuisd naar:
<br><a href="$url_new">$url_new</a>.
<br>
<script language="JavaScript">
document.write("U wordt na 15 seconde doorgeschakeld naar het nieuwe adres.");
window.setTimeout('location.replace("$url_new");', 15000);
</script>
<noscript>
U wordt normaal gesproken na 20 seconde doorgeschakeld naar
<a href="$url_new">het nieuwe adres</a>.
</noscript>
<p>
Pas, indien van toepassing, s.v.p uw links aan.
<p>
Bijvoorbaat dank,
<p>
Edwin Spee, webmaster epsig.nl
<hr><hr>

<table border>
<tr><td>
&nbsp;<a href="$www_epsig_nl/reactie.html">mail-me</a>
</td><td>
&nbsp;<a href="$hopa">homepage</a>
</td><td>
&nbsp;<a href="$www_epsig_nl/sport.html">sport</a>
</td><td>
&nbsp;d.d. $datum
</td></tr>
</table>

</body>
</html>
EOF

 return $out;
}

sub zoek_term
{# (c) Edwin Spee

 my ($term, $path, $verbose) = @_;

 opendir (DIR, '.') or shob_error('open_dir', [$path]);
 my @files = readdir(DIR);
 closedir DIR or shob_error('close_dir', [$path]);

 foreach my $file (@files)
 {
  if ($file eq '.' or $file eq '..') {;} # doe niets
  elsif (-d $file)
  {
   # recursief gebruik van zoek_term (daarom geen prototyping (geeft warning)):
   chdir($file);
   zoek_term($term, File::Spec->catfile($path, $file), $verbose);
   chdir(File::Spec->updir);
  }
  elsif ($file !~ m/\.(swp|doc|jpg|db|gif|xls)$/iso)
  {
   open (IN, $file) or shob_error('open_read', [$file]);
   while (<IN>)
   {
    chomp;
    if (m/$term/is)
    {
     my $f = File::Spec->catfile($path, $file);
     print "$f : $_\n";
    }
   }
   close IN;
  }
  else
  {
   print "skipping $file\n" if ($verbose > 1);
  }
 }
}

return 1;

