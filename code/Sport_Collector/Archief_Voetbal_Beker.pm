package Sport_Collector::Archief_Voetbal_Beker;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::General;
use Sport_Functions::BekerReaders;
use Sport_Functions::Overig;
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
 '$knvb_beker',
 '&laatste_speeldatum_beker',
 #========================================================================
);

our $knvb_beker;
our $subdir = 'beker';

for (my $yr = 1994; $yr < 99999; $yr++)
{
 my $szn = yr2szn($yr);
 my $csv = "beker_$szn.csv";
 $csv =~ s/-/_/;
 if (-f "$csv_dir/$subdir/$csv")
 {
  $knvb_beker->{$szn} = read_beker_csv($csv, $subdir, $yr);
 }
 else {last;}
}

sub laatste_speeldatum_beker($)
{# (c) Edwin Spee

 my ($year) = @_;

 my $dd = 20140808;

 while (my ($key1, $value1) = each %{$knvb_beker->{$year}})
 {
  while (my ($key2, $value2) = each %{$knvb_beker->{$year}{$key1}})
  {
   if (ref $value2 eq 'ARRAY')
   {
    $dd = max($dd, laatste_speeldatum($value2));
 }}}

 return $dd;
}

return 1;
