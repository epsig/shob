package Sport_Collector::Archief_Europacup_Voetbal;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Idate;
use Sport_Functions::Formats;
use Sport_Functions::Overig;
use Sport_Functions::Filters;
use Sport_Functions::Get_Result_Standing;
use Sport_Functions::Results2Standing;
use Sport_Functions::EcReaders;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
  '&laatste_speeldatum_ec',
  '&set_laatste_speeldatum_ec',
  '&get_ec_webpage',
  '&init_ec',
  '&get_u_ec',
 #========================================================================
);

our $u_ec;

sub get_u_ec($)
{
  my $szn = shift;

  if (not defined($u_ec->{$szn}))
  {
    my $csv = "europacup_$szn.csv";
    $csv =~ s/-/_/;
    $u_ec->{$szn} = read_ec_csv($csv, $szn);

    my $ddExtra = $u_ec->{$szn}->{extra}->{dd};
    my $yr2 = substr($szn, 5, 4);
    if ($yr2 > $ddExtra * 1E-4 - 1)
    { # TODO: can it be removed ?
      $u_ec->{$szn}->{extra}->{dd} = max(laatste_speeldatum_ec($szn), $ddExtra);
    }
  }
  return $u_ec->{$szn};
}

sub get_ec_webpage($)
{# (c) Edwin Spee

 my $szn = shift;
 my $u   = get_u_ec($szn);
 return format_europacup($szn, $u);
}

sub laatste_speeldatum_ec($)
{# (c) Edwin Spee

 my ($szn) = @_;

 my $dd = 20120723;

 my $u = get_u_ec($szn);
 while (my ($key1, $value1) = each %{$u})
 {
  while (my ($key2, $value2) = each %{$u->{$key1}})
  {
   if (ref $value2 eq 'ARRAY')
   {
    $dd = max($dd, laatste_speeldatum($value2));
 }}}

 return $dd;
}

sub init_ec
{ #(c) Edwin Spee
  use File::Glob;

  my @files = <Sport_Data/europacup/europacup_????_????.csv>;
  my $lastYr = -999;
  my $lastSzn;
  foreach my $file (@files)
  {
    if ($file =~ m/(\d{4})_(\d{4})/)
    {
      my ($yr1, $yr2) = ($1, $2);
      if ($yr1 > $lastYr)
      {
        $lastYr = $yr1;
        $lastSzn = "$yr1-$yr2";
      }
    }
  }
  $u_ec->{lastyear} = $lastSzn;
}

sub set_laatste_speeldatum_ec
{# (c) Edwin Spee

 my $szn = $u_ec->{lastyear};
 my $dd = max(laatste_speeldatum_ec($szn));

 my $u = get_u_ec($szn);

 if (defined($u->{extra}))
 {
  $dd = max($dd, $u->{extra}{dd});
 }
 $u->{extra}{dd} = $dd;
 set_datum_fixed($dd);
}

return 1;
