package Sport_Functions::XML;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Data::Dumper;
use Shob_Tools::Html_Stuff;
use Exporter;
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
 '&fill_from_xml',
 '&chronological',
 '&get_xml_val',
 '&search_level2',
 '&search',
 #========================================================================
);

sub search_level2
{
  my ($tree, $key) = @_;

  my $t = $tree;

  foreach my $val (@$tree)
  {
    if (ref $val eq 'ARRAY')
    {
      foreach my $val2 (@$val)
      {
        if (ref $val2 eq 'ARRAY')
        {
          my $found = 0;
          foreach my $val3 (@$val2)
          {
            if ($found) {return $val3;}
            if ($val3 eq $key) {$found = 1;}
          }
        }
      }
    }
  }
  return -1;
}

sub search
{
 my ($tree, @keys) = @_;

 my $t = $tree;
 foreach my $k (@keys)
 {
  my $found = 0;
  foreach my $i (@{$t})
  {
   if ($found)
   {
    $t = $i;
    last;
   }
   elsif ($i eq $k)
   {
    $found = 1;
   }
  }
  if ($found == 0) {return [];}
 }
 return $t;
}

sub chronological
{
 my $t = shift;
 my $out = [];
 my $j = 0;
 foreach my $i (@{$t})
 {
  if (ref $i eq 'ARRAY')
  {
   my $min = $i->[0]{min};
   #$out .= "$min' $i->[2]\n";
   my $data = $i->[2];
   $data =~ s/^ +//;
   $data =~ s/ +$//;
   $data = utf82html($data);
   if ($data =~/mist p\b/)
   {
    $out->[$j] = [$min, -1, -1, $data];
    $j++;
   }
   elsif ($data !~ m/^rood.*:/i)
   {
    $out->[$j] = [$min, split(/[ \-]/, $data, 3)];
#   print Dumper($out->[$j]);
    $j++;
   }
 }}
 return $out;
}

sub chronological_rood
{
 my $t = shift;
 my $ab = shift;

 my @out = ();
 my $j = 0;
 foreach my $i (@{$t})
 {
  if (ref $i eq 'ARRAY')
  {
   my $min = $i->[0]{min};
   my $data = $i->[2];
   $data =~ s/^ +//;
   $data =~ s/ +$//;
   $data = utf82html($data);
   if ($data =~ m/^rood.*2x.*geel.*:/i and $data =~/\($ab\)/)
   {
    $data =~ s/^rood.*2x.*geel.*: *//i;
    $data =~ s/ *\($ab\)//;
    push @out, ($data, $min, '2x geel');
    $j++;
   }
   elsif ($data =~ m/^rood:/i and $data =~/\($ab\)/)
   {
    $data =~ s/^rood: *//i;
    $data =~ s/ *\($ab\)//;
    push @out, ($data, $min, '');
    $j++;
   }
 }}

 if ($j == 0)
 {
  return undef;
 }
 else
 {
  return \@out;
 }
}

sub get_xml_val
{
 my ($t, $key, $default) = @_;

 my $val = search($t, $key);
 $val = $val->[2];
 if (defined $val)
 {
  $val =~ s/^ //;
  $val =~ s/ $//;
  $val = utf82html($val);
 }
 elsif (defined $default)
 {
  $val = $default;
 }
 else
 {
  print Dumper($t);
  print "\n\nkey $key not found.\n\n";
 }
 return $val;
}

sub fill_from_xml
{
 my ($t, $gameId) = @_;

 my $out = {};

 my $stats = search($t, 'stats');

 if ($gameId eq 'finale')
 {
  #my $ta = search($t, 'games', @keys);
  $out->{a} = get_xml_val($t, 'a');
  $out->{b} = get_xml_val($t, 'b');
 }
 else
 {
  $out->{a} = substr($gameId, 0, 2);
  $out->{b} = substr($gameId, 3, 2);
 }
 $out->{refname} = $gameId;
 my $tree = search($stats, 'chronological');
 $out->{chronological} = chronological($tree);
 $out->{rood_a} = chronological_rood($tree, $out->{a});
 $out->{rood_b} = chronological_rood($tree, $out->{b});
 
 my $publiek = get_xml_val($stats, 'spectators', -1);
 if ($publiek != -1) {$out->{publiek} = $publiek;}
 
 my $stadion = get_xml_val($stats, 'stadium', '');
 if ($stadion ne '') {$out->{stadion} = $stadion;}

 my $arbiter = get_xml_val($stats, 'arbiter', '');
 if ($arbiter ne '') {$out->{arbiter} = $arbiter;}

 my $wnshort = search($stats, 'wns_short');
 if (defined $wnshort->[2])
 {
  my $wns_data = $wnshort->[2];
  $wns_data =~ s/^\s+|\s+$//g; # trim left and right
  my @parts = split('-', $wns_data);
  $out->{wnshort} = [$parts[0],$parts[1]];
 }
 my $wns_long = search($stats, 'wns_long');
 if (defined $wns_long->[2])
 {
  my $wns_data = $wns_long->[2];
  $wns_data = utf82html($wns_data);
  my @parts = split('\s*,\s*', $wns_data);
  $out->{wnslong} = \@parts;
 }

 return $out;
}


return 1;

