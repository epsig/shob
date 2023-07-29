package Shob_Tools::Settings;
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
$VERSION = '18.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&init_settings',
 '$local_version', '$all_data', '$opt', '$verbose',
 '&get_counter', '&inc_counter',
 '&init_host_id', '&get_host_id',
 '&init_webdir', '&get_webdir', '&overrule_webdir',
 '&set_history_on', '&get_history',
 '&get_datum_fixed', '&set_datum_fixed',
 '&no_prompt_mkdir', '&get_prompt_mkdir',
 '&get_CVS_tag',
 '$www_epsig_nl',
 #========================================================================
);

our ($local_version, $all_data, $opt, $verbose) = -1;
our  $www_epsig_nl  = '';

my ($counter, $HostId, $WebDir, $WD_His, $WbDrOld, $history, $ask_mkdir) =
    (0, '', '', '', '', 0, 1);

# datum gefixeerd om uit git te kunnen reproduceren:
my $datum_fixed = 20230729;
# version (ending on 0 is not tagged, so update this number before tagging)
my $CVS_tag = '20.0';

sub get_my_hostname()
{# (c) Edwin Spee

 # reset hash iterator:
 my $i = scalar keys %ENV;
 # main loop:
 while (my ($key, $val) = each %ENV)
 {if ($key =~ m/(^host$)|(hostname)|(wksta)/iso)
  {return $val;
 }}

 chomp(my $hostname = lc(`hostname`));
 if ($hostname eq '')
 {
  die "error with hostname.\n;"
  # shob_error werkt hier nog niet
 }
 return $hostname;
}

sub init_settings($$$)
{# (c) Edwin Spee

 my ($opt_in, $vrbs, $lv) = @_;

 $local_version = ($lv =~ m/n/iso ? 0 : 1);
 $all_data = $local_version;

 $opt = $opt_in;
 $verbose = $vrbs;

}

sub overrule_webdir($)
{# (c) Edwin Spee
 # versie 1.2 15-jul-2005 als $dir == --old: gebruik $WbDrOld;
 # versie 1.1 22-jun-2005 als $dir == --new: gebruik $WbDrNw;
 # versie 1.0 31-jan-2005 initiele versie

 my ($dir) = @_;

 if ($dir eq '--old')
 {
  $WebDir = $WbDrOld;
  $WD_His = $WbDrOld;
 }
 else
 {
  $WebDir = $dir;
  $WD_His = $dir;
 }
}

sub init_webdir($)
{# (c) Edwin Spee
 # versie 1.5 14-mar-2006 WbDrOld voor wh_epsig ->$HOME/WWW
 # versie 1.4 17-feb-2006 + wh_epsig
 # versie 1.3 18-aug-2005 aanpassing voor nieuwe directorystructuur op het werk
 # versie 1.2 25-mei-2005 + epsig
 # versie 1.1 31-jan-2005 uitbreiding i.v.m. history-optie
 # versie 1.0 21-jan-2005 initiele versie

 my ($id) = @_;

 if    ($id eq 'remote' or $id eq 'epsig')
 {
  $WebDir  = File::Spec->catdir($ENV{HOME}, 'WWW');
  $WD_His  = File::Spec->catdir($ENV{HOME}, 'WWW_old');
  $WbDrOld = $WebDir;
 }
 elsif    ($id eq 'wh_epsig')
 {
  $WebDir  = File::Spec->catdir($ENV{HOME}, 'Webhosting', 'htdocs');
  $WD_His  = File::Spec->catdir($ENV{HOME}, 'WWW_old');
  $WbDrOld = File::Spec->catdir($ENV{HOME}, 'WWW');
 }
 elsif ($id eq 'local')
 {
  $WebDir  = File::Spec->catdir('C:', 'www.epsig.nl');
  $WD_His  = File::Spec->catdir('C:', 'web_old');
  $WbDrOld = $WebDir;
 }
 elsif ($id eq 'ubuntu')
 {
  $WebDir  = File::Spec->catdir($ENV{HOME}, 'epsig', 'github', 'shob', 'pages');
  $WD_His  = File::Spec->catdir($ENV{HOME}, 'epsig', 'web_old');
  $WbDrOld = $WebDir;
 }
 else  
 {
  $WebDir  = File::Spec->catdir('..', 'pages');
  $WD_His  = File::Spec->catdir('..', 'web_old');
  $WbDrOld = $WebDir;
 }
}

sub get_webdir()
{# (c) Edwin Spee

 my $dir = ($history ? $WD_His : $WebDir);
 return $dir;
}

sub init_host_id()
{# (c) Edwin Spee

 my $id = get_my_hostname();

 if    ($id =~ m/wh.*shell/iso)         {$HostId = 'wh_epsig';}
 elsif ($id =~ m/pcthuis/iso)          {$HostId = 'local'   ;}
 elsif ($id =~ m/laptop/iso)           {$HostId = 'local'   ;}
 elsif ($id =~ m/spee-aspire-5630/iso) {$HostId = 'ubuntu'  ;}
 elsif ($id =~ m/n750wu/iso)           {$HostId = 'ubuntu'  ;}
 elsif ($id =~ m/xs4all/iso)
 {my $username = $ENV{LOGNAME};
  if ($username eq 'spee')
  {$HostId = 'remote';}
  else
  {die "unknown username $username.\n";}
  print "HostId, username = $HostId, $username.\n";
 }
 else  {$HostId = 'git';}

 if ($HostId eq 'remote' or $HostId eq 'wh_epsig')
 {
  $www_epsig_nl = 'https://www.epsig.nl';
 }
 elsif ($HostId eq 'local')
 {
  $www_epsig_nl = 'file:///c:/www.epsig.nl';
 }
 elsif ($HostId eq 'ubuntu')
 {
  # quick fix / as long as cgi-bin works locally
  # $www_epsig_nl = "$ENV{HOME}/epsig/github/shob/pages";
  $www_epsig_nl = 'https://www.epsig.nl';
 }
 else
 {
  $www_epsig_nl = '../pages/';
 }
}

sub get_host_id()
{# (c) Edwin Spee
 # versie 1.0 21-jan-2005 initiele versie

 return $HostId;
}

sub set_datum_fixed($)
{# (c) Edwin Spee

 my $dd = shift;
 $datum_fixed = $dd if ($dd > $datum_fixed);
}

sub get_datum_fixed()
{# (c) Edwin Spee

 return $datum_fixed;
}

sub get_CVS_tag()
{# (c) Edwin Spee
 # versie 1.0 03-feb-2005 initiele versie

 return $CVS_tag;
}

sub no_prompt_mkdir()
{# (c) Edwin Spee
 # versie 1.0 31-jan-2005 initiele versie

 $ask_mkdir = 0;
}

sub get_prompt_mkdir()
{# (c) Edwin Spee
 # versie 1.0 31-jan-2005 initiele versie

 return $ask_mkdir;
}

sub get_history()
{# (c) Edwin Spee
 # versie 1.0 31-jan-2005 initiele versie

 return $history;
}

sub set_history_on()
{# (c) Edwin Spee
 # versie 1.0 31-jan-2005 initiele versie

 $history = 1;
}

sub get_counter()
{# (c) Edwin Spee
 # versie 1.0 21-jan-2005 initiele versie

 return $counter;
}

sub inc_counter($)
{# (c) Edwin Spee
 # versie 1.0 21-jan-2005 initiele versie

 my ($id) = @_;

 $counter++;
}

return 1;

