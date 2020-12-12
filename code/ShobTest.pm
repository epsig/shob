package ShobTest;
use strict; use warnings;
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
$VERSION = '20.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&test_something',
 #========================================================================
);

my $yr = 2006;

sub dumpOS2csv($)
{
  my $OS = shift;

  my @sxs =  ('H', 'H', 'H', 'H', 'H', 'D', 'D', 'D', 'D', 'D', 'H', 'D', 'H', 'D');

  my @distances = ('500m', '1000m', '1500m', '5km', '10km',
   '500m', '1000m', '1500m', '3km', '5km',
   'teampursuit', 'teampursuit', 'massaStart', 'massaStart');

  open (OUT, ">Sport_Data/schaatsen/OS_$yr.csv") or die "can't open OS_$yr: $!.\n";

  print OUT "DH,distance,ranking,name,team,result,remark\n";

  my @OSarr = @$OS;
  my $ii = -1;
  foreach my $OSpart (@OSarr)
  {
    $ii++;
    my $size = scalar @$OSpart;
    foreach my $result (@$OSpart)
    {
      if (scalar @$result == 0) {next;}
      print OUT $sxs[$ii], ',', $distances[$ii], ',';
      my $jj = -1;
      foreach my $field (@$result)
      {
        $jj++;
        if (ref $field eq 'ARRAY')
        {
          my $kk = -1;
          foreach my $subfield (@$field)
          {
            $kk++;
            if (scalar @$result == 4 && $kk == 1)
            {
              print OUT " ($subfield);";
            }
            else
            {
              if ($kk > 0) {print OUT ',';}
              $subfield =~ s/,/;/g;
              print OUT "$subfield";
              if ($jj == 1) {print OUT ',';}
            }
          }
        }
        else
        {
          my $char = ',';
          $char = ';' if (scalar @$result == 4 && $jj == 2); # 500m: 2x
          print OUT $field,$char;
          if ($jj == 1) {print OUT ',';}
        }
      }
      print OUT "\n";
    }
  }
  close(OUT) or die "can't close: $!.\n";
}

sub test_something()
{
  # print "place holder for tmp/test function.\n";

  use Sport_Collector::OS_Schaatsen;
  use Sport_Collector::OS_Funcs;
  use Sport_Collector::Teams;

  initTeams();
  read_schaatsers();

  my $txt = eval("get_OS$yr()");

  dumpOS2csv($OS);
}

1;
