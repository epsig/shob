package Shob_Tools::Error_Handling;
use strict; use warnings;
use Shob_Tools::Settings;
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
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&shob_error', '&set_error_filename',
 #========================================================================
);

#
# koppeling id met
# 1): 'warning|fatal|fatal_os',
# 2): formatstring (nu nog even korte tekst)
#
my %error_specs = (
open_read    => ['fatal_os', 'Error while opening file for reading'],
close_read   => ['fatal_os', 'Error while closing file for reading'],
open_write   => ['fatal_os', 'Error while opening file for writing'],
close_write  => ['fatal_os', 'Error while closing file for writing'],
open_dir     => ['fatal_os', 'Error while opening directory for reading'],
close_dir    => ['fatal_os', 'Error while closing directory for reading'],
open_pipe    => ['fatal_os', 'Error while opening pipe'],
close_pipe   => ['fatal_os', 'Error while closing pipe'],
mkdir_fails  => ['fatal_os', 'Error with mkdir'],
compare      => ['fatal_os', 'Error with comparing files'],
copy         => ['fatal_os', 'Error while copying files'],
notfound     => ['fatal_os', 'File not found'],
oef          => ['fatal',    'Reading error or EOF'],
strange_else => ['fatal',    'Unexpected else/case'],
not_yet_impl => ['fatal',    'Not (yet) implemented'],
undef_retval => ['fatal',    'Return value not defined'],
undef_arg    => ['fatal',    'Input argument not defined'],
notvaliddate => ['fatal',    'Not a valid date'],
tst_filename => ['warning',  ''],
);

my $filename = '';

sub set_error_filename($)
{# (c) Edwin Spee
 # versie 1.0 12-jan-2005 initiele versie

 $filename = $_[0];
 if ($verbose > 1) {print "error filename set to $filename.\n";}
}

sub print_stack()
{# (c) Edwin Spee
 # versie 1.1 14-feb-2005 ook STDERR in 2e print
 # versie 1.0 11-jan-2005 initiele versie

 print STDERR "\n\nStack:\n\n";
 my $i = 0;
 while(caller(++$i))
 {
  my($pack, $file, $line, $func) = caller($i);
  print STDERR "$file ; $line ; $func.\n";
 }
}

sub shob_error($$)
{# (c) Edwin Spee
 # versie 1.4 14-feb-2005 STDERR in elke print; controle op defined error_specs{id}
 # versie 1.3 11-jan-2005 gebruikt routine print_stack ipv veel argumenten
 # versie 1.2 10-jan-2005 print array @$p_params
 # versie 1.1 18-okt-2004 nieuwe opzet: 1 functie met type en ID
 # versie 1.0 23-jul-2004 initiele versie
 #
 # Usage shob_error('id', [args]);

 my ($id, $p_params) = @_;

 my ($type, $message);
 if (defined $error_specs{$id})
 {
  $type = $error_specs{$id}[0];
  $message = $error_specs{$id}[1];
 }
 else
 {
  print STDERR "Internal error: id=$id not recognized.\n";
  $type = 'fatal';
  $message = 'fatal';
 }

 if ($filename ne '')
 {
  print STDERR "\nError while making file $filename.\n\n";
  return if ($id eq 'tst_filename');
 }

 print_stack;

 if ($type eq 'fatal_os')
 {
  print STDERR "\nOS_ERROR:\n\n$!\n";
 }
 print STDERR "\nInformative message:\n\n";
 print STDERR "$message\n\n";

 if (scalar @$p_params)
 {
  foreach my $i (@$p_params)
  {
   print STDERR "arg(s): $i.\n";
  }
 }

 if ($type eq 'fatal' or $type eq 'fatal_os')
 {
  die "Fatal error, died.\n";
 }
 else
 {
  warn "not fatal, continue.\n";
 }
}
return 1;

