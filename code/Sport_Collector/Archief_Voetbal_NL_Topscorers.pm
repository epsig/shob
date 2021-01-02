package Sport_Collector::Archief_Voetbal_NL_Topscorers;
use strict; use warnings;
use Sport_Functions::Readers qw($csv_dir &read_csv_with_header);
use File::Spec;
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
$VERSION = '21.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_topscorers_competitie',
 #========================================================================
);

my $contentAllFiles = {};

sub get_topscorers_competitie($$$)
{
  my $seizoen      = shift;
  my $divisie_key = shift;
  my $divisie_name = shift;

  my $found_season = 0;

  if (not defined $contentAllFiles->{$divisie_key})
  {
    my $fullname = File::Spec->catdir($csv_dir, $divisie_key, "topscorers_$divisie_key.csv");
    $contentAllFiles->{$divisie_key} = read_csv_with_header($fullname);
  }

  my $content = $contentAllFiles->{$divisie_key};

  my @tp_list = (['Topscorers ' . $divisie_name ]);

  foreach my $line (@$content)
  {
    if ($line->{season} eq $seizoen)
    {
      push @tp_list, [$line->{rank}, $line->{name}, $line->{club}, $line->{total}];
      $found_season = 1;
    }
  }

  return (\@tp_list) if $found_season;
  return ([]);
}

return 1;
