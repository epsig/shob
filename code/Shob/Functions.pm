package Shob::Functions;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Error_Handling;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Algorithm::Diff qw(diff);
use File::Compare;
use File::Copy;
use File::Spec qw(catdir catfile);
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
 '&check_version',
 '&do_all_bin_dir',
 '&do_all_text_dir',
 '&ttlink',
 '&vimrc',
 '&diff_print',
 #========================================================================
);

sub check_version
{# (c) Edwin Spee
 # versie 1.1 08-may-2006 remote -> wh_epsig
 # versie 1.0 20-nov-2004 initiele versie

 my ($hst2, $host) = @_;

 if ($hst2 eq 'all')
 {return 1;}
 elsif ($host eq 'local' and $hst2 =~ m/l/iso)
 {return 1;}
 elsif ($host eq 'ubuntu' and $hst2 =~ m/u/iso)
 {return 1;}
 elsif ($host eq 'werk' and $hst2 =~ m/w/iso)
 {return 1;}
 elsif ($host eq 'wh_epsig' and $hst2 =~ m/r/iso)
 {return 1;}
 else
 {return 0;}
}

sub do_all_bin_dir
{# (c) Edwin Spee

 my ($dl1, $dl2, $hst2, $epsig, $brondir, @bestemming_dirs) = @_;

 my $host = get_host_id();
 my $version_ok = check_version($hst2, $host);
 unless (-d $brondir)
 {
  if ($version_ok and $verbose > 1)
  {
   print STDERR "warning: directory $brondir does not exists; skipping!\n";
  }
  return;
 }

 if (($dl2 <= $dl1) and $version_ok)
 {
  my $bestemming_dir = File::Spec->catdir(get_webdir(), @bestemming_dirs);
  if (not -d $bestemming_dir and not $epsig) {ask_mkdir($bestemming_dir);}

  my $dir1 = File::Spec->catdir($brondir);
  opendir (DIR, $dir1) or shob_error('open_dir', [$brondir]);
  while (my $file_bron = readdir(DIR))
  {
   if ($file_bron =~ m/\.(jpg|gif|ico)$/iso)
   {
    my $filenm1 = File::Spec->catfile($dir1, $file_bron);
    my $filenm2;
    if ($epsig)
    {
     $filenm2 = $bestemming_dir . $file_bron;
    }
    else
    {
     $filenm2 = File::Spec->catfile($bestemming_dir, $file_bron);
    }
    if (-f $filenm2)
    {
     my $retval_cmp = compare($filenm1, $filenm2);
     if ($retval_cmp == -1)
     {shob_error('compare', [$filenm1, $filenm2]);}
     elsif ($retval_cmp == 1)
     {
      print "copy $filenm1 -> $filenm2 ? (y/n)";
      my $answer = lees_regel;
      unless ($answer =~ m/n/iso)
      {my $retval_cp = copy($filenm1, $filenm2);
       unless ($retval_cp) {shob_error('copy', [$filenm2, $filenm1]);}
      }
     }
     else
     {
      if ($verbose > 1) {print " $file_bron;OK.$retval_cmp";}
     }
    }
    else
    {
     print "\n$file_bron;missing -> copying\n";
     my $retval_cp = copy($filenm1, $filenm2);
     unless ($retval_cp) {shob_error('copy', [$filenm2, $filenm1]);}
    }
   }
  }
  closedir DIR or shob_error('close_dir', [$dir1]);
 }
}

sub ask_mkdir
{# (c) Edwin Spee
 # versie 1.0 31-jan-2005 initiele versie

 my ($dir) = @_;

 if (get_prompt_mkdir())
 {
  print "Directory $dir does not exists; Make it ? (yjn) ";
  my $answer = lees_regel;
  if ($answer =~ m/n/iso)
  {
   print "\nOK, but Exit -1\n\n";
   exit -1;
  }
 }

 my $ok = mkdir $dir;
 unless ($ok) {shob_error('mkdir_fails', ["directory = $dir"]);}
}

sub subdir_catfile
{# (c) Edwin Spee
 # versie 1.1 31-jan-2005 + use of ask_mkdir
 # versie 1.0 05-jan-2005 initiele versie

 my ($subdir, $filenm_in) = @_;
 my $webdir = get_webdir();
 unless (-d $webdir)
 {
  ask_mkdir($webdir);
 }

 my $abs_subdir = File::Spec->catdir($webdir, $subdir);
 unless (-d $abs_subdir)
 {
  ask_mkdir($abs_subdir);
 }

 return ($subdir eq '/' ? $filenm_in : File::Spec->catfile($abs_subdir, $filenm_in));
}

sub do_all_text_dir
{# (c) Edwin Spee

 my ($dl1, $subdir, $commands) = @_;

 my $host = get_host_id();

 foreach my $command (@$commands)
 {
  my ($dl2, $hst2, $sub, $filenm_in) = @$command;
  if (($dl2 <= $dl1) and (check_version($hst2, $host)))
  {
   if (ref $filenm_in eq 'ARRAY')
   {set_error_filename($$filenm_in[0]);}
   else
   {set_error_filename($filenm_in);}

   my $data = &$sub;

   if (ref $filenm_in eq 'ARRAY')
   {
    foreach my $filenmi (@$filenm_in)
    {
     my $filenm = subdir_catfile ($subdir, $filenmi);
     if (-l $filenm)
     {
      if ($verbose > 1) {print "file $filenm is a symbolic link; skipped!\n";}
     }
     else
     {
      if ($opt == 2)
      {
       my_webpage_diff($data, $filenm,0);
      }
      else
      {
       check_and_print($data, $filenm, $opt);
      }
     }
    }
   }
   else
   {
    my $filenm = subdir_catfile ($subdir, $filenm_in);
    if ($opt == 2)
    {my_webpage_diff($data, $filenm, 0);}
    else
    {check_and_print($data, $filenm, $opt);}
   }
  }
  else
  {
   if ($verbose > 1)
   {if (ref $filenm_in eq 'ARRAY')
    {print 'Skipping ';
     foreach my $filenmi (@$filenm_in)
     {print "$filenmi, ";}
     print "\n";}
    else
    {print "Skipping $filenm_in.\n";}
   }
  }
  set_error_filename('');
 }
}

sub confirm
{# (c) Edwin Spee
 # versie 1.1 27-mrt-2005 gebruikt functie lees_stdin (vanwege timing)
 # versie 1.0 02-sep-2003 initiele versie

 my ($data, $filenm) = @_;
 print "Overwrite $filenm ? ";
 my $in = lees_stdin;
 my $retval = $in =~ m/n/iso ? 0:1;
 return $retval;
}

sub check_and_print
{# (c) Edwin Spee
 # versie 1.1 18-okt-2004 gebruik van shob_error bij open/close problemen
 # versie 1.0 02-sep-2003 initiele versie

 my ($data,$filenm,$opt) = @_;

 my $result = my_webpage_diff($data,$filenm, $opt == 3);
 if ($result == 0)
 {return;
 }
 elsif ($result == -1 or $opt == 1 or confirm($data,$filenm))
 {my @lines = split (/\n/ , $data);
  open (DOEL,">$filenm") or shob_error('open_write', [$filenm]);
  my $n1512 = ($filenm =~ m/\.csv/iso ? "\012" : "\n");
  foreach my $i (@lines)
  {next if $i =~ m/^$/iso;
   print DOEL $i,$n1512;
  }
  close DOEL or shob_error('close_write', [$filenm]);
 }
}

sub diff_print
{# (c) Edwin Spee

 my ($old, $new) = @_;

 my $cnt_dd = 0;
 my $cnt_rest = 0;

 my @diff = diff ($old, $new);
 for (my $i=0; $i < scalar @diff; $i++)
 {
  my $row = $diff[$i];
  for (my $j=0; $j < scalar @$row; $j++)
  {
   my ($pm, $linenr, $line) = @{$row->[$j]};
   if ($line =~ m/d\.d\./)
   {
    $cnt_dd++;
   }
   else
   {
    $cnt_rest++;
    print "$pm $linenr:$line\n";
   }
  }
 }
 return $cnt_rest;
}

sub my_webpage_diff
{# (c) Edwin Spee
 # versie 1.5 29-nov-2004 leesbaarheid verbeterd
 # versie 1.4 01-okt-2004 own_diff en with_line_nrs eruit
 # versie 1.3 13-sep-2004 gebruikt Algorith::Diff
 # versie 1.2 19-aug-2004 met hardgecodeerde logical with_line_nrs
 # versie 1.1 03-feb-2004 check op d.d. todaystr in new
 # versie 1.0 02-sep-2003 initiele versie

 my ($data, $filenm, $opt) = @_;
 my $found = 0;

 unless (-e $filenm)
 {if ($verbose > 0) {print "$filenm bestaat niet.\n";}
  return -1;
 }
 open (BRON, $filenm) or shob_error('open_read', [$filenm]);
 my @old = ();
 while (my $line = <BRON>)
 {
  chomp $line;
  push @old, $line;
 }
 close BRON or shob_error('close_read', [$filenm]);

 my @new = split (/\n+/ , $data);

 $found = diff_print (\@old, \@new);

 if ($verbose > 2 or ($verbose == 1 and $found > 0)) {print "$filenm: $found\n";}
 return $found;
}

sub ttlink
{# (c) Edwin Spee

 my ($p, $omschrijving, $optie) = @_;
# optie = 'gif' of 'tekst'

 my $url = qq(http://teletekst-data.nos.nl/webplus?p=$p);

 if ($omschrijving eq '')
 {return $url;}
 else
 {return qq(<a href="$url">$omschrijving</a>);}
}

sub vimrc
{# (c) Edwin Spee
 # versie 1.1 05-jan-2004 specifieke regels voor verschillende versies eruit kunnen halen
 # versie 1.0 03-jan-2004 initiele versie

 my $host = get_host_id();

 my $vimrc = qq(" Do not edit this file; it is generated by shob.pl!\n);
 my $file1 = File::Spec->catfile('Admin','_vimrc');
 my $file2 = File::Spec->catfile('Admin','_vimrc_diff');
 $vimrc .= file2str($file1);
 $vimrc .= ($host eq 'local' ? file2str($file2) : '');

# specifieke regels voor werk/pcthuis eruit halen indien ongewenst:
#if ($host ne 'werk')
#{
# $vimrc =~ s/^.*" alleen voor.*werk.*$//imgo;
#}
 if ($host ne 'local')
 {
  $vimrc =~ s/^.*" alleen voor.*pcthuis.*$//imgo;
 }

# tekst alleen voor sowieso eruit halen:
 $vimrc =~ s/ +" alleen voor.*$//imgo;

 my $shobdir;
 if (exists($ENV{SHOBDIR}))
 {
  $shobdir = $ENV{SHOBDIR};
  $shobdir =~ s/\\/\\\\/;
 }
 else
 {
  $shobdir = '.';
 }
 
 $vimrc =~ s/\%SHOBDIR\%/$shobdir/imgo;

 return $vimrc;
}

return 1;

