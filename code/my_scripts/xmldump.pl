#!/usr/bin/perl
use strict;
use warnings;

use XML::Parser;
use Data::Dumper;

my $verbose = 0;

sub search
{
 my ($tree, @keys) = @_;

 my $t = $tree;
 foreach my $k (@keys)
 {
  my $found = 0;
  foreach my $i (@{$t})
  {if ($found) {$t = $i; last;}
   elsif ($i eq $k) {$found = 1;}
   print "$k - $i .\n" if ($verbose);
  }
  if ($found == 0) {return [];}
 }
 print "$t\n" if ($verbose);
 return $t;
}

sub chronological
{
 my $t = shift;
 my $out = '';
 foreach my $i (@{$t})
 {
  if (ref $i eq 'ARRAY')
  {
   my $min = $i->[0]{min};
   $out .= "$min' $i->[2]\n";
 }}
 return $out;
}

my $p1 = XML::Parser->new(Style => 'Tree');
my $tree = $p1->parsefile('WK_2010.xml');

my $pt_kp = search($tree, 'games', 'group_phase', 'groupG', 'PT_KP');
my $t = search($pt_kp, 'match_report', 'stats', 'chronological');
print chronological($t);

#print Dumper($t);

