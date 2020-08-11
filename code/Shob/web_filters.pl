#!/usr/bin/perl -w
use strict;

open (BRON,'aap');
open (DOEL,'>noot');
while (<BRON>)
{my $x = $_;
 if ($x =~ m/^ *$/iso) {next;}
 elsif ($x =~ m/\d{4}/iso)
 {$x =~ s/^\s*//iso;
  print DOEL $x;}
 else
 { $x = lc($x);
   my $q = ($x =~m/'/iso ? '"' : "'");
   $x =~
s/^\s*\d+\s{2}(.*)\s{7}(\d{2})\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+-\s+(\d+)\s+(\d+)\s*$/[${q}NL$1${q},$2,[$3,$4,$5],$8,[$6,$7]],/iso;
   print DOEL "$x\n";
}}
 
close BRON;
close DOEL;
