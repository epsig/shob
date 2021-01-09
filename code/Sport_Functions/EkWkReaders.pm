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
 '&read_wk',
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

sub read_number_of_groups()
{
  my $last = 'A';
  while(my $line = <IN>)
  {
    if ($line =~ m/^g.,/)
    {
      my $group = substr($line, 1, 1);
      if ($group gt $last)
      {
        $last = $group;
      }
    }
  }
  my $number = 1 + ord($last) - ord('A');

  return $number;
}

sub read_wk($$)
{
  my $filein = shift;
  my $xmlfile = shift;

  my $tournement = $filein;
     $tournement =~ s/ekwk.//;
     $tournement =~ s/.csv//;

  my $remarks = $all_remarks->{ekwk}->get($tournement, 'allgroups');

  my @u;
  my $u16 = [];
  my $u8 = [];
  my $u4 = [];
  my $u34 = [];
  my $finale = [];

  my $fileWithPath = File::Spec->catfile($csv_dir, $filein);

  open (IN, "< $fileWithPath") or die "can't open $fileWithPath: $!\n";

  my $srt_rule = 3; # EK
     $srt_rule = 5; # WK

  my $number_of_groups = read_number_of_groups();
  if (defined $remarks)
  {
    my @ster = split('=', $remarks);
    my $ster = $ster[1];
    for(my $i = 0; $i < $number_of_groups; $i++)
    {
      my $a = chr(ord('A') + $i);
      $u[$i] = read_wk_part("g$a", "Groep $a", $srt_rule, $ster);
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
      $u[$i] = read_wk_part($group, "Groep $a", $srt_rule, $ster);
    }
  }

  $u16 = read_wk_part('8f', '8-ste finale', -1, undef);
  $u8 = read_wk_part('4f', 'kwart finale', -1, undef);
  $u4 = read_wk_part('2f', 'halve finale', -1, undef);
  $u34 = read_wk_part('f34','brons', -1, undef);
  $finale = read_wk_part('f','finale', -1, undef);
 
  my $ekwk = {grp => \@u, sort_rule => $srt_rule, u16 => $u16, uk => $u8, uh => $u4,
                            u34 => $u34, uf => $finale};
 
  if (-f $xmlfile)
  {
    my $p1 = XML::Parser->new(Style => 'Tree');
    my $tree = $p1->parsefile($xmlfile);
    my $xml = read_ekwk_xml();
    my $games = search_general($tree, 'games');
    foreach my $id (@$xml)
    {
      my $game = search_general($games, $id);
      my $details = fill_from_xml($game, $id);
      replace_opm_xml($ekwk, $id, $details);
    }
  }

  return $ekwk;

  close (IN);
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

sub read_voorronde($$$)
{
 my $file = shift;
 my $part = shift;
 my $type = shift;

 my $fileWithPath = File::Spec->catfile($csv_dir, $file);

 open(IN, "< $fileWithPath") or die "can't open file $fileWithPath: $!\n";

 my $retval;

 if ($type eq 'u')
 {
  my $tournement = basename($file);
     $tournement =~ s/u.csv//;
  my $remarks = $all_remarks->{ekwk_qf}->get($tournement, $part);
  my $ster;
  if (defined $remarks)
  {
    my @ster = split('=', $remarks);
    $ster = $ster[1];
  }
  $retval = read_wk_part($part, '', 3, $ster);
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
    $extra .= $line;
   }
  }
  $retval = $extra;
 }
 close (IN);
 return $retval;
}

sub read_ekwk_xml()
{
 seek(IN, 0, 0);

 my @xml = ();
 while(my $line = <IN>)
 {
  if ($line =~ m/ref=/)
  {
   chomp($line);
   my @parts = split /ref=/, $line;
   push @xml, $parts[1];
  }
 }

 return \@xml;
}

sub read_wk_part($$$$)
{
 my $group    = shift;
 my $title    = shift;
 my $srt_rule = shift;
 my $ster     = shift;

 seek(IN, 0, 0);
 my @games = ();

 my $ster_ = -1;
    $ster_ = $ster if (defined($ster));

 $games[0] = [$title, [1, $srt_rule, '', $ster_]];

 while(my $line = <IN>)
 {
  chomp($line);
  $line =~ s/, *#.*//;
  my @parts = split /,/, $line;
  if ($parts[0] eq $group)
  {
   my $a    = $parts[1];
   my $b    = $parts[2];
   my $dd   = $parts[3];
   my $time = $parts[4];
   my $aa   = $parts[5];
   my $bb   = $parts[6];
   if (scalar @parts == 3 and $a eq 'ster')
   {
    $games[0] = [$title, [1, $srt_rule, '', $b]];
   }
   elsif (scalar @parts == 6)
   {
    $aa   = $parts[4];
    $bb   = $parts[5];
    push @games, [$a,$b,[$dd,$aa,$bb]];
   }
   elsif (scalar @parts == 7)
   {
    $aa   = $parts[4];
    $bb   = $parts[5];
    my $cc   = $parts[6];
    push @games, [$a,$b,[$dd,$aa,$bb],$cc];
   }
   elsif (scalar @parts == 8)
   {
    my $city = $parts[7];
    push @games, [$a,$b,[[$dd,$time],$aa,$bb],$city];
   }
   elsif (scalar @parts >= 10)
   {
    my $wns   = $parts[8];
    my $spect = $parts[7];
    my $city  = $parts[9];
    my $opm   = $parts[10];
    if (defined($opm))
    {
     chomp($opm);
     push @games, [$a,$b,[[$dd,$time],$aa,$bb,{opm=>$opm,publiek=>$spect}],$wns,$city];
    }
    else
    {
     push @games, [$a,$b,[[$dd,$time],$aa,$bb,{publiek=>$spect}],$wns,$city];
    }
   }
   elsif (scalar @parts > 8 and $parts[7] =~ m/[a-z]/iso)
   {
    my $city = $parts[7];
    push @games, [$a,$b,[[$dd,$time],$aa,$bb],$city];
   }
   else
   {
    my $spect = $parts[7];
    my $city  = $parts[8];
    push @games, [$a,$b,[[$dd,$time],$aa,$bb,$spect],$city];
   }
  }
 }
 return \@games;
}

return 1;

