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
$VERSION = '21.0';
# by Edwin Spee.

# Constructor for class Sport_Functions::RemarkReaders
# remarks are found in a csv file with 3 colomns:
# year or season, key, value
sub new
{
  my ($class, $filename, $subdir) = @_;

  my $content = read_csv_with_header($filename, $subdir);

  my @keys = keys(%{$content->[0]});
  my $period;
  foreach my $key (@keys)
  {
    if ($key ne 'key' && $key ne 'value')
    {
      $period = $key;
    }
  }

  my $self = bless { content => $content, period => $period}, $class;

  return $self;
}

# Basic getter for a key in a year/season
# $retval is optional default value
sub get
{
  my ($self, $year_season, $key, $retval) = @_;

  my $period = $self->{period};

  foreach my $record (@{$self->{content}})
  {
    if ($record->{$period} eq $year_season)
    {
      if ($record->{key} eq $key)
      {
        $retval = $record->{value};
        last;
      }
    }
  }

  return $retval;
}

# Additional getter for a key in a year/season with multiline output
# $multiLine : 0= no line breaks added; 1= line breaks added; 2= line breaks added, but not after the last
sub get_ml
{
  my ($self, $year_season, $key, $multiLine) = @_;

  my $a = '';

  my $period = $self->{period};

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

# Additional getter where only the first part of the key is given, and multiline output may occur
# $multiLine : 0= no line breaks added; 1= line breaks added; 2= line breaks added, but not after the last
sub get_ml_keyStartsWith
{
  my ($self, $year_season, $key, $multiLine) = @_;

  my $a = '';
  my $keyFound = '';

  my $period = $self->{period};

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
