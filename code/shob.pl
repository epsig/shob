#!/usr/bin/perl
use strict; use warnings;

=head1 USAGE

 Shob - H E L P

 shob.pl [option(s)] command          : general usage
 
 shob.pl [option(s)]                  : interactive mode
 perl -c shob.pl                      : check syntax of shob.pl and its modules
 perl -d shob.pl [option(s) [command] : debug mode of perl

=head2 COMMANDS

 -d       : diff and replace most files
 -dl      : diff and replace -lopende- files
 -d2      : = -d
 -d4      : diff and replace all files
 -c       : check syntax of shob.pl and its modules
 -e       : edit coded addresses
 -diff_adres   = -di : cvs diff Admin/adressen_coded.txt -> decode
 -help         = -he : this help
 -history      = -hi : rebuild old website
 -version      = -v  : get version info
 -search term  = -s term : search for file containing a string term

=head2 OPTIONS

 --dir=str     = --d : output directory = str
 --mkdir       = --m : do not prompt for mkdir

=cut

use Time::HiRes qw(gettimeofday);
use Pod::Usage;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Settings;
use Shob_Tools::General;
use ShobTest;
use Shob::SiteUpdater;

sub print_version()
{# (c) Edwin Spee

  use Shob_Tools::Idate;

  my ($y, $m, $d) = split_idate(get_datum_fixed());
  my $mon = monthstr($m - 1);
  my $CVS_tag = get_CVS_tag();

  print << "EOF";

Version dated : $mon - $y.
Version number: $CVS_tag

EOF
}

sub sport_init()
{ # initializations for sport data

  use Sport_Collector::Archief_Oefenduels;
  use Sport_Collector::Teams;
  use Sport_Collector::Archief_Voetbal_NL;
  use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
  use Sport_Collector::Archief_Voetbal_NL_Topscorers;
  use Sport_Collector::Archief_Europacup_Voetbal;
  use Sport_Collector::Archief_EK_WK_Voetbal;
  use Shob::Stats_Website;

  initTeams();
  initEredivisieResults();
  init_tp_eerste_divisie();
  init_ec();

  set_laatste_speeldatum_u_nl();
  set_laatste_speeldatum_ec();
  set_laatste_speeldatum_ekwk();
  set_laatste_speeldatum_oefenduels();
  set_laatste_datum_statfiles();
}

sub shob_main_loop()
{# (c) Edwin Spee

  my @start_cpu = times;
  my $start_wt = gettimeofday;

  init_host_id();
  my $hostid = get_host_id();
  init_webdir($hostid);

  my $is_remote = ($hostid eq 'remote' or $hostid eq 'epsig' or $hostid eq 'wh_epsig');
  my $lv = $is_remote ? 'n' : 'y';
  my $nh = $lv;
  my $defaults = $is_remote ? 1 : 0;
  my $parts = 0;

  my $opt;
  my $cmd = '';

  foreach my $arg (@ARGV)
  {
    # handle --mkdir
    if ($arg =~ m/--m/iso)
    {
      no_prompt_mkdir();
    }
    # handle --dir=string
    if ($arg =~ m/--d.*=(.*)/iso)
    {
      my $dir = $1;
      print "Output dir = $dir\n";
      overrule_webdir($dir);
    }
  }

  if (scalar @ARGV)
  {
    my $command = $ARGV[scalar @ARGV - 1];
    if ($command =~ m/-(d.*)/iso)
    {
      $cmd = lc($1);
    }
    if ($command =~ m/-he/iso)
    {
      pod2usage(-verbose => 2, -exitval => 0);
      exit;
    }
    elsif ($command =~ m/-hi/iso)
    {
      print "\nRebuilding old website!\n\n";
      print_version();
      set_history_on;
      $cmd = 'd3';
    }
    elsif ($command =~ m/-h/iso)
    {
      print "-h is ambitious; use -help or -his:\n\n";
      pod2usage(-verbose => 2, -exitval => 0);
      exit;
    }
    elsif ($command =~ m/-c/iso)
    {
      print "OK\n"; # syntax ok.
      exit 0;
    }
    elsif ($command =~ m/-test/iso)
    {
      test_something();
      exit 0;
    }
    elsif ($command =~ m/-v/iso)
    {
      print_version();
      exit 0;
    }
    elsif ($command =~ m/-e/iso or $command =~ m/-di/iso)
    {
      if ($withAdresses)
      {
        require Admin::Adressen_data2html;
        Admin::Adressen_data2html->import;

        if ($command =~ m/-e/iso)
        {
          edit_addresses(0);
        }
        elsif ($command =~ m/-di/iso)
        {
          diff_adres();
        }
      }
      exit 0;
    }
    elsif ($ARGV[scalar @ARGV - 2] =~ m/-s/iso)
    {
      zoek_term($ARGV[scalar @ARGV - 1], File::Spec->curdir, 0);
      exit 0;
    }
  }

  if ($cmd eq '')
  {
    print 'Actie: defaults (d), make(1), print verschillen (2), make met confirm (3=d/dl/d3): ';
    $cmd = lees_regel;
  }

  sport_init();

  if ($cmd eq 'd' or $cmd eq 'dl' or $cmd =~ m/^d\d$/iso)
  {
    $defaults = 2;
    $opt = 3;

    if ($cmd eq 'dl')
    {
      $parts = 1;
    }
    elsif ($cmd =~ m/d(\d)/iso)
    {
      $parts = $1 - 1;
    }
  }
  elsif ($cmd =~ m/q/iso or $cmd =~ m/x/iso)
  {
    print "\nQuit.\n\n";
    exit 1;
  }
  else
  {
    $opt = $cmd;
  }

  if ($defaults <= 1)
  {
    print "Welke Onderdelen:\n";
    print '(vrijwel-)alles (0=d), lopend(1), kj(2) of test/nieuw (3): ';
    $parts = lees_regel;
    if ($parts =~ m/d/iso)
    {
      $defaults = 2;
      $parts = 0;
    }
  }

  if ($defaults == 0 and $parts != 2)
  {
    print 'Locale versie: (jyn) ';
    $lv = lees_regel;
    print 'Nette html (jyn) ';
    $nh = lees_regel;
  }

  init_settings($nh, $opt, 0, $lv);
  init_web_index($lv =~ m/n/iso ? 0 : 1);
  my $parts2 = ($parts < 2 ? 2 - $parts : $parts+1);
  handle_new_style_files($opt, $lv, $parts2);

  my @stop_cpu = times;
  my $stop_wt = gettimeofday;
  my $diff_wt = $stop_wt - $start_wt;
  printf "user:     %.2f\n", $stop_cpu[0] - $start_cpu[0];
  my $get_waiting_time = get_waiting_time;
  if ($get_waiting_time > 0.0)
  {
    printf "walltime: %.2f; waiting: %.2f; walltime - waiting: %.2f\n",
      $diff_wt , $get_waiting_time,
      $diff_wt - $get_waiting_time;
  }
  else
  {
    printf "walltime: %.2f\n", $diff_wt;
  }
  printf "aantal keer filter in sort: %i\n", get_counter();
}

shob_main_loop();

