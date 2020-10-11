package Sport_Functions::Readers;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Exporter;
use Sport_Functions::XML;
use Sport_Functions::Overig;
use File::Spec;
use XML::Parser;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&read_csv_file',
 '&read_csv_file_szn',
 '&read_csv',
 '&read_ec_csv',
 '&read_beker_csv',
 '$csv_dir',
 #========================================================================
);

# (c) Edwin Spee

our $csv_dir = 'Sport_Data';

sub read_csv_file($)
{
 my $fullname = shift;
 my @content;

 open(IN, "<$fullname") or die "can't open file $fullname for reading: $!";
 while(my $line = <IN>)
 {
  chomp($line);
  $line =~ s/ *#.*//;
  if ($line eq '') {next;}
  $line =~ s/^ +//;
  my @parts = split(' *, *', $line);
  push @content, \@parts;
 }
 close(IN);
 return \@content;
}

sub read_csv_file_szn($$)
{
 my $fullname = shift;
 my $seizoen = shift;

 my $content = read_csv_file($fullname);
 my $active = 0;
 my @content_szn;
 while(my $line = shift(@$content))
 {
  my @parts = @$line;
  if ($parts[0] =~ m/:$/)
  {
   $active = ($parts[0] =~ m/$seizoen/ ? 1 : 0);
  }
  elsif ($active)
  {
   push @content_szn, $line;
  }
 }
 return (\@content_szn);
}

sub read_csv($)
{
 my $filein = shift;
 my $fullname = File::Spec->catdir($csv_dir, $filein);

 my $aabb = 1;
 my @games;
 $games[0] = [''];
 my $content = read_csv_file($fullname);
 while(my $line = shift(@$content))
 {
  if ($line->[2] eq 'dd')
  {
    if ($line->[3] =~ m/result/)
    {
      $aabb = 0;
    }
    next;
  }
  my @values = @$line;
  my $a  = $values[0];
  my $b  = $values[1];
  my $dd = $values[2];
  my ($aa, $bb, $sp, $opm);
  if ($aabb)
  {
    $aa = $values[3];
    $bb = $values[4];
    $sp = $values[5];
    $opm = $values[6];
  }
  else
  {
    my $result = $values[3];
    my @results;
    if ($result eq '-')
    {
      @results = (-1,-1);
    }
    else
    {
      @results = split('-', $result);
    }
    $aa = $results[0];
    $bb = $results[1];
    $sp = $values[4];
    $opm = $values[5];
  }
  my $stadion;
  if (scalar(@values) > 5+$aabb)
  {
   for (my $i=5+$aabb; $i<scalar(@values); $i++)
   {
    if ($values[$i] eq 'dekuip')
    {$stadion = 'Rotterdam, de Kuip';}
    elsif ($values[$i] eq 'arena')
    {$stadion = 'Amsterdam, Arena';}
    if ($i == 5+$aabb and defined($stadion))
    {undef($opm);}
  }}
  my $game;
  if (scalar(@values) >=6+$aabb)
  {
   if (not defined($opm))
   {
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, stadion=>$stadion}]];
   }
   elsif ($opm eq 'afgelast')
   {
    $game = [$a, $b, [$dd, $aa, $bb, {afgelast => 1}]];
   }
   elsif ($opm =~ m/^wns=/)
   {
    my @parts = split /=/, $opm,2;
    my $wns = $parts[1];
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp}], $wns];
   }
   elsif ($opm =~ m/^stadion=/)
   {
    my @parts = split /=/, $opm,2;
    $stadion = $parts[1];
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, stadion=>$stadion}]];
   }
   else
   {
    $game = [$a, $b, [$dd, $aa, $bb, {publiek=>$sp, opm=>$opm, stadion=>$stadion}]];
   }
  }
  elsif (scalar(@values) >=5+$aabb)
  {
    if ($sp >= 0)
    {
      $game = [$a, $b, [$dd, $aa, $bb, $sp]];
    }
    else
    {
      $game = [$a, $b, [$dd, $aa, $bb]];
    }
  }
  elsif (scalar(@values) == 4+$aabb)
  {
   $game = [$a, $b, [$dd, $aa, $bb]];
  }
  elsif (scalar(@values) == 3+$aabb and $b eq 'straf')
  {
   $game = [$a, $b, $dd, $aa];
  }
  elsif (scalar(@values) == 2+$aabb)
  {
   $game = [$a, $b, [$dd]];
  }
  else
  {
   warn "unexpected line: $line.\n";
  }
  push @games, $game;
 }
 return \@games;
}

sub read_ec_summary($)
{
 my $lang = shift;

 my $retval = '';

 seek(IN, 0, 0);
 while (my $line = <IN>)
 {
  $line =~ s/ *#.*//;
  if ($line eq '') {next;}

  my @parts = split /,/, $line;
  if ($parts[0] eq 'summary' and $parts[1] eq $lang)
  {
    $retval .= $parts[2];
  }
 }
 return $retval;
}

sub read_ec_csv($)
{
 my $filein = shift;

 open (IN, "< $csv_dir/$filein") or die "can't open $filein: $!";

 my $sc = read_ec_part('supercup','','Europese Supercup');
 my $cl_v2 = read_ec_part('CL','v2','2e voorronde Champions League');
 my $cl_v3 = read_ec_part('CL','v3','3e voorronde Champions League');
 my $cl_po = read_ec_part('CL','po','play offs Champions League');

 my $el_v2 = read_ec_part('EL','v2','2e voorronde Europa League');
 my $el_v3 = read_ec_part('EL','v3','3e voorronde Europa League');
 my $el_po = read_ec_part('EL','po','play offs Europa League');

 my $ec = {
 extra => { supercup => $sc },
 CL => {
 qfr_2 => $cl_v2,
 qfr_3 => $cl_v3,
 playoffs => $cl_po,
 round_of_16 => read_ec_part('CL','8f', '8-ste finale C-L'),
 quarterfinal => read_ec_part('CL','4f', 'kwart finale C-L'),
 semifinal => read_ec_part('CL','2f', 'halve finale C-L'),
 final => read_ec_part('CL','f', 'finale C-L'),
 },
 EuropaL => {
 qfr => $el_v2,
 qfr_3 => $el_v3,
 playoffs => $el_po,
 round2 => read_ec_part('EL','16f', '8-ste finale E-L'),
 round_of_16 => read_ec_part('EL','8f', '8-ste finale E-L'),
 quarterfinal => read_ec_part('EL','4f', 'kwart finale E-L'),
 semifinal => read_ec_part('EL','2f', 'halve finale E-L'),
 final => read_ec_part('EL','f', 'finale E-L'),
 }
};

 my $summary = read_ec_summary('NL');
 if ($summary ne '') {$ec->{extra}->{summary} = $summary;}

 foreach my $l ('A'..'H')
 {
  my $g = read_ec_part('CL',"g$l","Champions League, Groep $l");
  if (defined($g))
  {
   $ec->{CL}{"group$l"} = $g;
  }
 }
 
 foreach my $l ('A'..'L')
 {
  my $g = read_ec_part('EL',"g$l","Europa League, Groep $l");
  if (defined($g))
  {
   $ec->{EuropaL}{"group$l"} = $g;
  }
 }
 
 close(IN);
 return $ec;
}

sub read_beker_csv($$$)
{
 my $filein = shift;
 my $subdir = shift;
 my $year   = shift;

 open (IN, "< $csv_dir/$subdir/$filein") or die "can't open $filein: $!";

 my $sc = read_ec_part('supercup','',"Johan Cruijff schaal $year");
 my $r2 = read_ec_part('r2', '', 'Tweede ronde');
 my $f8 = read_ec_part('8f', '', 'achtste-finales KNVB-beker');
 my $f4 = read_ec_part('4f', '', 'kwart-finale KNVB-beker');
 my $f2 = read_ec_part('2f', '', 'halve finale KNVB-beker');
 my $f = read_ec_part('f', '', 'finale KNVB-beker');
 my $opm = read_beker_opm();
 
 close(IN);

 my $beker = {
  extra => { supercup => $sc },
  beker => {
  round2 => $r2,
  round_of_16 => $f8,
  quarterfinal => $f4,
  semifinal => $f2,
  final => $f,
  beker_opm => $opm
 }};

 return $beker;
}

sub read_beker_opm()
{
 seek(IN, 0, 0);
 my $opm = '';
 while (my $line = <IN>)
 {
  my @parts = split /,/, $line,2;
  if ($parts[0] eq 'beker_opm')
  {
   $opm .= $parts[1];
  }
 }
 return $opm;
}

sub read_ec_part($$$)
{
 my $cupname = shift;
 my $phase   = shift;
 my $title   = shift;

 seek(IN, 0, 0);
 my @games;
 if ($phase =~ m/^g/iso) {
  $games[0] = ['', [1, 5, $title, -1]];
 } else {
  $games[0] = [$title];
 }
 my $total = 0;
 while(my $line = <IN>)
 {
  chomp($line);
  $line =~ s/ *#.*//;
  if ($line eq '') {next;}

  my @parts = split /,/, $line;
  if ($parts[0] eq $cupname and $parts[1] eq $phase)
  {
   my $a  = $parts[2];
   my $b  = $parts[3];
   my $dd1 = $parts[4];
   my $aa1 = $parts[5];
   my $bb1 = $parts[6];
   my $dd2 = $parts[7];
   my $aa2 = $parts[8];
   my $bb2 = $parts[9];
   my $wns = $parts[10];
   if ($aa1 >= 0) {$total++;}
   if (defined($wns))
   {
    push @games, [$a,$b,[$dd1,$aa1,$bb1],[$dd2,$aa2,$bb2],$wns];
    if ($aa2 >= 0) {$total++;}
   }
   elsif (defined($aa2))
   {
    chomp($aa2);
    push @games, [$a,$b,[$dd1,$aa1,$bb1],$dd2,$aa2];
   }
   elsif (defined($dd2) && $dd2 ne '')
   {
    push @games, [$a,$b,[$dd1,$aa1,$bb1],$dd2];
   }
   elsif (defined($bb1))
   {
    push @games, [$a,$b,[$dd1,$aa1,$bb1]];
   }
  }
  elsif ($parts[0] eq $cupname and $phase eq '')
  {
   my $a  = $parts[1];
   my $b  = $parts[2];
   my $dd = $parts[3];
   my $aa = $parts[4];
   my $bb = $parts[5];
   my $wns = $parts[6];
   my $opm = $parts[7];
   my $stadium = $parts[8];
   if (scalar @parts > 9) {
    my $dd2 = $parts[6];
    my $aa2 = $parts[7];
    my $bb2 = $parts[8];
    my $wns = $parts[9];
    chomp($wns);
    push @games, [$a,$b,[$dd,$aa,$bb],[$dd2,$aa2,$bb2],$wns];
   } elsif (defined($stadium)) {
    chomp($stadium);
    push @games, [$a,$b,[$dd,$aa,$bb],$wns,$stadium];
   }
   elsif (defined($opm)) {
    push @games, [$a,$b,[$dd,$aa,$bb,opm=>$opm],$wns];
   } else {
    push @games, [$a,$b,[$dd,$aa,$bb],$wns];
   }
  }
 }

 #print "debug: $cupname $phase ", scalar @games, "\n";
 if ($total == 12)
 {
  if ($cupname eq 'CL')
  {
   $games[0] = ['', [1, 5, $title, 2]];
  }
  else
  {
   $games[0] = ['', [1, 5, $title, 1]];
  }
 }
 
 if (scalar @games > 1)
 {
  return \@games;
 } else {
  return undef;
 }
}

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

return 1;

