package Sport_Collector::Teams;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Functions::Readers;
use Shob_Tools::Error_Handling;
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
 '%clubs', '%short_land_gb', '%landcodes', '&clubs_short',
 '&expand_voetballers',
 '&land_acronym',
 '&find_club',
 #========================================================================
);

# (c) Edwin Spee

our %clubs;
my %clubs_short;

sub read_clubs($)
{
 my $file = shift;

 my $content = read_csv_file(File::Spec->catdir($csv_dir, $file));
 while (my $line = shift(@$content))
 {
  my @parts = @$line;

  $clubs{$parts[0]} = $parts[1];
  if (scalar @parts > 2)
  {
   $clubs_short{$parts[0]} = $parts[2];
  }
 }
}

read_clubs('clubs.csv');

our %short_land_gb = (
G1 => 'ENG',
G2 => 'SCT',
G3 => 'WLS',
G4 => 'ULS'); # N-Ierl;

our %landcodes;

sub read_landcode($)
{
 my $file = shift;

 open(IN, "<$csv_dir/$file") or die "can't open file $file for reading: $!";
 while (my $line = <IN>)
 {
  chomp($line);
  $line =~ s/ *#.*//;
  my @parts = split(',', $line);

  $landcodes{$parts[0]} = $parts[2];
 }
}

 read_landcode('landcodes.csv');

my %voetballers;

sub read_voetballers($)
{
 my $file = shift;

 open(IN, "<$csv_dir/$file") or die "can't open file $file for reading: $!";
 while (my $line = <IN>)
 {
  chomp($line);
  $line =~ s/ +#.*//;
  my @parts = split(',', $line);

  $voetballers{$parts[0]} = [ $parts[1], $parts[2], $parts[3] ];
 }
}

read_voetballers('voetballers.csv');

sub expand_voetballers($$)
{# (c) Edwin Spee
 # TODO option wordt genegeerd; waardes: 'short', 'std', 'long'.

 my ($speler, $option) = @_;

 if (defined $voetballers{$speler})
 {
  $speler = join(' ', @{$voetballers{$speler}});
  $speler =~ s/  / /iso;
 }
 elsif ($speler =~ m/([a-z]*) .p./iso)
 {if (defined $voetballers{$1})
  {
   $speler = join(' ', @{$voetballers{$1}}, '(p)');
   $speler =~ s/  / /iso;
  }
 }
 return $speler;
}

sub clubs_short($)
{# (c) Edwin Spee

 my ($club_code) = @_;

 my ($long, $short) = ($clubs{$club_code}, $clubs_short{$club_code});

 if (defined($short))
 {
  if ($long =~ m/.. $short/i)
  {return $short;}
  else
  {return qq(<acronym title="$long">$short</acronym>);}
 }
 elsif (defined($long))
 {return $long;}
 else
 {shob_error('strange_else', ["club_code = $club_code"]);}
}

sub land_acronym($)
{# (c) Edwin Spee

 my ($landcode) = @_;

 my $lcode = $landcode;

 # special cases: OAR, G1 - G4:
 if ($lcode eq 'OA')
 {
  $lcode = 'OAR'; # n.a.v. doping gedoe Sotsji
 }
 elsif ($lcode =~ m/G[1-4]/iso)
 {
  $lcode = $short_land_gb{$lcode};
 }

 my $landnaam;
 if (defined $landcodes{$landcode})
 {
  $landnaam = $landcodes{$landcode};
 }
 else
 {
  print "onbekende landcode: $landcode.\n";
 }
 return qq(<acronym title="$landnaam">$lcode</acronym>);
}

sub find_club($)
{
 my $c = shift;
 if (defined $clubs{"NL$c"}) {return ($c);}
 elsif ($c =~ m/^NL(...)$/iso) {return ($1);}

 # reset hash iterator:
 my $i = scalar keys %clubs;
 while (my ($key, $val) = each %clubs)
 {
  if (uc($c) eq uc($val))
  {if ($key =~ m/^NL(...)$/iso) {return ($1);}}
 }
 my @retval = ();
 while (my ($key, $val) = each %clubs)
 {
  if ($val =~ m/$c/is)
  {if ($key =~ m/^NL(...)$/iso) {push @retval, $1;}}
 }
 return @retval;
}

return 1;
