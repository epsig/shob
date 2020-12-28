package Sport_Functions::RemarkReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Readers qw(&read_csv_with_header);
use vars qw($VERSION @ISA);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.1';
# by Edwin Spee.

# Constructor for class Sport_Functions::RemarkReaders
# remarks are found in a csv file with 3 colomns:
# year or season, key, value
sub new
{
  my ($class, $fullname) = @_;

  my $content = read_csv_with_header($fullname);

  my $self = bless { content => $content}, $class;

  return $self;
}

# Basic getter for a key in a year/season
sub get
{
  my ($self, $year_season, $key) = @_;

  my $a;

  my $period = ($year_season =~ m/-/ ? 'season' : 'year');

  foreach my $record (@{$self->{content}})
  {
    if ($record->{$period} eq $year_season)
    {
      if ($record->{key} eq $key)
      {
        $a = $record->{value};
        last;
      }
    }
  }

  return $a;
}

sub get_ml
{
  my ($self, $year_season, $key, $multiLine) = @_;

  # $multiLine : 0= no line breaks added; 1= line breaks added; 2= line breaks added, but not after the last

  my $a = '';

  my $period = ($year_season =~ m/-/ ? 'season' : 'year');

  foreach my $record (@{$self->{content}})
  {
    if ($record->{$period} eq $year_season)
    {
      if ($record->{key} eq $key)
      {
        if ($multiLine == 2 && $a ne '') {$a .= "\n";}
        my $line = $record->{value};
        $a .= $line;
        if ($multiLine == 1) {$a .= "\n";}
      }
    }
  }

  return $a;
}

sub get_ml_keyStartsWith
{
  my ($self, $year_season, $key, $multiLine) = @_;

  # $multiLine : 0= no line breaks added; 1= line breaks added; 2= line breaks added, but not after the last

  my $a = '';
  my $keyFound = '';

  my $period = ($year_season =~ m/-/ ? 'season' : 'year');

  foreach my $record (@{$self->{content}})
  {
    if ($record->{$period} eq $year_season)
    {
      if ($record->{key} =~ m/^$key/)
      {
        if ($multiLine == 2 && $a ne '') {$a .= "\n";}
        if ($record->{key} ne $key) {$keyFound = $record->{key};}
        my $line = $record->{value};
        $a .= $line;
        if ($multiLine == 1) {$a .= "\n";}
      }
    }
  }

  return {$keyFound => $a};
}

return 1;
