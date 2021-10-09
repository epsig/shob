package Sport_Functions::Readers;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Shob_Tools::Error_Handling;
use File::Spec;
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
 '&read_csv_with_header',
 '$csv_dir',
 #========================================================================
);

# (c) Edwin Spee

our $csv_dir = File::Spec->catfile(File::Spec->updir(), 'data', 'sport');

sub read_csv_with_header($;$)
{
  my $filename = shift;
  my $subdir   = shift;

  my $fullname = $filename;
  if (not -f $fullname)
  {
    $fullname = File::Spec->catfile($subdir, $filename)  if (defined $subdir);
    $fullname = File::Spec->catfile($csv_dir, $fullname) if ($fullname !~ m/$csv_dir/);
  }

  if ( ! -f $fullname) {return [];}

  open(IN, "<$fullname") or die "can't open file $fullname for reading: $!";
  my $header = <IN>;
  chomp($header);
  my @header_parts = split(',', $header, -1);

  my @content;
  while(my $line = <IN>)
  {
    chomp($line);
    $line =~ s/ *#.*// if ($line !~ m/&/);
    my @parts = split(' *, *', $line, -1);
    my @parts2 = split('"', $line, -1);
    if (scalar @parts2 == 3)
    {
      my @parts3 = split(',', $parts2[1]);
      if (scalar @parts3 > 2)
      { #TODO ugly quick fix
        @parts = ($parts[0], $parts[1], $parts2[1]);
      }
      else
      { #TODO works only for one comma between quotes
        my $str1 = pop @parts;
        my $str2 = pop @parts;
        push @parts, $parts2[1];
      }
    }
    if (scalar @parts != scalar @header_parts)
    {
      shob_error('strange_else',["# cols wrong in $line of file $fullname"]);
    }
    my %struct;
    for (my $i=0; $i < scalar @header_parts; $i++)
    {
      if ($parts[$i] ne '')
      {
        $struct{$header_parts[$i]} = $parts[$i];
      }
    }
    push @content, \%struct;
  }
  close(IN);
  return \@content;
}

return 1;
