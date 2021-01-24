package Sport_Functions::EkWkReaders;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::XML;
use Sport_Functions::Overig;
use Sport_Functions::Readers;
use Sport_Functions::ListRemarks qw($all_remarks);
use Sport_Functions::AddMatch qw(&add_one_line);
use File::Basename;
use File::Spec;
use XML::Parser;
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
 '&read_ekwk',
 '&read_voorronde',
 '&read_voorronde_standen',
 #========================================================================
);

# (c) Edwin Spee

sub replace_opm_xml_inner($$$)
{
 my $pu   = shift;
 my $name = shift;
 my $pxml = shift;

 if (defined($pu))
 {
  for(my $i = 1; $i < scalar @$pu; $i++)
  {
   if (ref $pu->[$i]->[2]->[3] eq 'HASH')
   {
    my $opm = $pu->[$i]->[2]->[3]->{opm};
    if (defined($opm))
    {
     if ($opm =~ m/$name/)
     {
      $pu->[$i]->[2]->[3] = $pxml;
      return 1;
     }
    }
   }
  }
 }
 return -1;
}

sub replace_opm_xml($$$)
{
 my $puus = shift;
 my $name = shift;
 my $pxml = shift;

 my @expect = ('u16', 'uk', 'uh', 'uf', 'u34');
 foreach my $val (@expect)
 {
  my $pu = $puus->{$val};
  if (replace_opm_xml_inner($pu, $name, $pxml) > 0)
  {
    return;
  }
 }

 my $grp = $puus->{grp};
 if (defined($grp))
 {
  for(my $i = 0; $i < scalar @$grp; $i++)
  {
   if (replace_opm_xml_inner($grp->[$i], $name, $pxml) > 0)
   {
    return;
   }
  }
 }

}

sub read_number_of_groups($)
{
  my $lines = shift;

  my $last = 'A';
  foreach my $line (@$lines)
  {
    if ($line->{round} =~ m/^g.$/)
    {
      my $group = substr($line->{round}, 1, 1);
      if ($group gt $last)
      {
        $last = $group;
      }
    }
  }
  my $number = 1 + ord($last) - ord('A');

  return $number;
}

sub has_phase($$)
{
  my $lines = shift;
  my $phase = shift;

  foreach my $line (@$lines)
  {
    if ($line->{round} eq $phase)
    {
      return 1;
    }
  }
  return 0;
}

sub read_ekwk($$$$)
{
  my ($tournement, $filein, $xmlfile, $srt_rule) = @_;

  my $ekwk = {sort_rule => $srt_rule};

  my $remarks = $all_remarks->{ekwk}->get($tournement, 'allgroups');

  my $fileWithPath = File::Spec->catfile($csv_dir, $filein);

  my $ekwkLines = read_csv_with_header($fileWithPath);

  my $number_of_groups = read_number_of_groups($ekwkLines);
  if (defined $remarks)
  {
    my @ster = split('=', $remarks);
    my $ster = $ster[1];
    for(my $i = 0; $i < $number_of_groups; $i++)
    {
      my $a = chr(ord('A') + $i);
      $ekwk->{grp}->[$i] = read_wk_part($ekwkLines, "g$a", "Groep $a", $srt_rule, $ster);
    }
  }
  else
  {
    for(my $i = 0; $i < $number_of_groups; $i++)
    {
      my $a = chr(ord('A') + $i);
      my $group = "g$a";
      my $remarks_group = $all_remarks->{ekwk}->get($tournement, $group);
      my @ster = split('=', $remarks_group);
      my $ster = $ster[1];
      $ekwk->{grp}->[$i] = read_wk_part($ekwkLines, $group, "Groep $a", $srt_rule, $ster);
    }
  }

  if (has_phase($ekwkLines, '8f'))
  {
    $ekwk->{u16} = read_wk_part($ekwkLines, '8f', '8-ste finale', -1, undef);
  }
  $ekwk->{uk} = read_wk_part($ekwkLines, '4f', 'kwart finale', -1, undef);
  $ekwk->{uh} = read_wk_part($ekwkLines, '2f', 'halve finale', -1, undef);
  $ekwk->{u34} = read_wk_part($ekwkLines, 'f34','brons', -1, undef);
  $ekwk->{uf} = read_wk_part($ekwkLines, 'f','finale', -1, undef);
 
  if (-f $xmlfile)
  {
    my $p1 = XML::Parser->new(Style => 'Tree');
    my $tree = $p1->parsefile($xmlfile);
    my $xml = read_ekwk_xml($ekwkLines);
    my $games = search_general($tree, 'games');
    foreach my $id (@$xml)
    {
      my $game = search_general($games, $id);
      my $details = fill_from_xml($game, $id);
      replace_opm_xml($ekwk, $id, $details);
    }
  }

  return $ekwk;
}

sub read_voorronde_standen_inner($)
{
 my $part = shift;

 seek(IN, 0, 0);

 my @s = ([]);
 while (my $line = <IN>)
 {
  if ($line =~ m/^$part\b/)
  {
   chomp($line);
   my @parts = split /\s*,\s*/, $line;
   my (undef, $land, $g, $w, $d, $l, $p, $a, $b, $ster) = @parts;
   if (defined $ster)
   {
    push @s, [$land, $g,[$w,$d,$l],$p,[$a, $b],[$ster]];
   }
   else
   {
    push @s, [$land, $g,[$w,$d,$l],$p,[$a, $b]];
   }
  }
 }
 return \@s;
}

sub read_voorronde_standen($$$)
{
 my $file = shift;
 my $start = shift;
 my $cnt   = shift;

 my $fileWithPath = File::Spec->catfile($csv_dir, $file);

 if (not -f $fileWithPath) {return undef;}

 open(IN, "< $fileWithPath") or die "can't open file $fileWithPath: $!\n";

 my @s;
 for (my $i = 0; $i < $cnt; $i++)
 {
  my $a = chr(ord($start) + $i);
  if ($a eq ':') {$a = '10';}
  my $standA = read_voorronde_standen_inner("s$a");
  $standA->[0] = ["Groep $a"];
  $s[$i+1] = $standA;
 }
 close(IN);
 return \@s;
}

sub read_voorronde_part_u($$$)
{
  my $fileWithPath = shift;
  my $file         = shift;
  my $part         = shift;

  my $qfLines = read_csv_with_header($fileWithPath);
  my $tournement = basename($file);
     $tournement =~ s/[uv].csv//;
  my $remarks = $all_remarks->{ekwk_qf}->get_ml($tournement, $part, 1);
  my $ster;
  my $sortrule = 3;
  if (defined $remarks)
  {
    my @lines = split("\n", $remarks);
    foreach my $line (@lines)
    {
      my @parts = split('=', $line);
      if ($parts[0] eq 'star')
      {
        $ster     = $parts[1];
      }
      elsif ($parts[0] eq 'sort_rule')
      {
        $sortrule = $parts[1];
      }
    }
  }
  my $retval = read_wk_part($qfLines, $part, '', $sortrule, $ster);
  return $retval;
}

sub read_voorronde($$$)
{
  my $file = shift;
  my $part = shift;
  my $type = shift;

  my $fileWithPath = File::Spec->catfile($csv_dir, $file);

  if (not -f $fileWithPath) {return undef;}

  if ($type ne 'u' && $type ne 'po_new')
  {
    open(IN, "< $fileWithPath") or die "can't open file $fileWithPath: $!\n";
  }

  my $retval;

  if ($type eq 'u' || $type eq 'po_new')
  {
    $retval = read_voorronde_part_u($fileWithPath, $file, $part);
  }
  elsif ($type eq 'qf')
  {
    my @qf = ();
    while (my $line = <IN>)
    {
      if ($line =~ m/^$part/)
      {
        chomp($line);
        my @parts = split /,/, $line;
        push @qf, [$parts[1], $parts[2]];
      }
    }
    $retval = \@qf;
  }
  elsif ($type eq 'po')
  {
    my @po = ([]);
    while (my $line = <IN>)
    {
      if ($line =~ m/^$part/)
      {
        chomp($line);
        my @parts = split /,/, $line;
        my (undef, $a, $b, $dd, $aa, $bb, $dd2, $aa2, $bb2, $wns, $opm) = @parts;
        if ($aa2 =~ m/[a-z]/)
        { # apparently only one match
          my (undef, $a, $b, $dd, $aa, $bb, $wns, $stadium, $opm) = @parts;
          push @po, [$a,$b,[$dd,$aa,$bb,{opm=>$opm, stadion=>$stadium}],$wns];
        }
        else
        {
          push @po, [$a,$b,[$dd,$aa,$bb],[$dd2,$aa2,$bb2,{opm=>$opm}],$wns];
        }
      }
    }
    $retval = \@po;
  }
  elsif ($type eq 'extra')
  {
    my $extra = '';
    while (my $line = <IN>)
    {
      if ($line =~ m/^$part/)
      {
        # intentionally no chomp
        $line =~ s/^$part,//;
        $line =~ s/"//g;
        $extra .= $line;
      }
    }
    $retval = $extra;
  }

  if ($type ne 'u' && $type ne 'po_new')
  {
    close (IN);
  }
  return $retval;
}

sub read_ekwk_xml($)
{
  my $content = shift;

  my @xml = ();
  foreach my $line (@$content)
  {
    if (defined ($line->{remark}))
    {
      if ($line->{remark} =~ m/ref=/)
      {
        my @parts = split /ref=/, $line->{remark};
        push @xml, $parts[1];
      }
    }
  }

  return \@xml;
}

sub read_wk_part($$$$$)
{
  my $content  = shift;
  my $group    = shift;
  my $title    = shift;
  my $srt_rule = shift;
  my $ster     = shift;

  my $ster_ = -1;
     $ster_ = $ster if (defined($ster));

  my $isko = ($srt_rule < 1);

  my @games = ([$title, [1, $srt_rule, '', $ster_]]);

  foreach my $struct (@$content)
  {
    if ($struct->{round} eq $group)
    {
      add_one_line(\@games, $struct, $isko);
    }
  }
  return \@games;
}

return 1;

