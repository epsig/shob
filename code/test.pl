#!/usr/bin/perl -T
use strict;
use warnings;

print "Content-type: text/html\n\n";

print "hello world!\n";

print "<pre>\n";

foreach my $key (sort keys(%ENV)) {
  print "$key = $ENV{$key}<p>";
}
print "</pre>\n";

