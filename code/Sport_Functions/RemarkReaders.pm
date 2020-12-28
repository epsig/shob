package Sport_Functions::RemarkReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::Readers;
use File::Spec;
use vars qw($VERSION @ISA);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.1';
# by Edwin Spee.

my $allRemarks = {};

sub new
{
  my ($class, $args) = @_;

  my $type = $args->{type};

  my $self = bless { type => $type}, $class;

  if (not defined $allRemarks->{$type})
  {
    my $fullname = File::Spec->catdir($csv_dir, $type, "${type}_remarks.csv");
    $allRemarks->{$type} = read_csv_with_header($fullname);
  }

  $self->{content} = $allRemarks->{$type};

  return $self;
}

sub get
{
  my ($self, $year_season, $key) = @_;

  return $self->get_ml($year_season, $key, 0);
}

sub get_ml
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

  return ($keyFound ne '' ? {$keyFound => $a} : $a);
}

return 1;
