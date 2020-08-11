package Sport_Functions::Filters;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Error_Handling;
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
 '&filter_opvallend', '&filter_datum', '&filter_team',
 '&combine_puus',
 #========================================================================
);

sub filter_opvallend($$)
{# (c) Edwin Spee
 # versie 1.1 26-jan-2005 verhuist vanuit web_sport_funcs en stijlaanpassingen
 # versie 1.0 23-feb-2004 initiele versie

 my ($pu, $optie) = @_;
 # pu = pointer naar uitslagen-array
 # optie = 1 abs. verschil
 # optie = 2 max. uit, thuis
 # optie = 3 sum uit, thuis

 my $rows = scalar @$pu;
 my $lookfor = -1;
 for (my $i=1; $i<$rows; $i++)
 {
  my $row = $pu->[$i];
  if ($row->[1] eq 'straf') {next;}
  if (scalar @{$row->[2]} > 2)
  {
   my $r_u = $row->[2];
   if ($r_u->[1] == -1) {next;}
   if ($optie == 1)
   {
    $lookfor = max($lookfor, abs($r_u->[1] - $r_u->[2]));
   }
   elsif ($optie == 2)
   {
    $lookfor = max($lookfor, max($r_u->[1] , $r_u->[2]));
   }
   elsif ($optie == 3)
   {
    $lookfor = max($lookfor,     $r_u->[1] + $r_u->[2] );
   }
   else
   {
    shob_error('not_yet_impl', ["optie = $optie"]);
   }
  }
 }

 my @result = ($pu->[0]);
 for (my $i=1; $i<$rows; $i++)
 {
  my $row = $pu->[$i];
  if ($row->[1] eq 'straf') {next;}
  if (scalar @{$row->[2]} > 2)
  {
   my $r_u = $row->[2];
   if ($r_u->[1] == -1) {next;}
   if ($optie == 1)
   {
    if ($lookfor == abs($r_u->[1] - $r_u->[2]))
    {
     push(@result,$row);
    }
   }
   elsif ($optie == 2)
   {
    if ($lookfor == max($r_u->[1] , $r_u->[2]))
    {
     push(@result,$row);
    }
   }
   elsif ($optie == 3)
   {
    if ($lookfor ==     $r_u->[1] + $r_u->[2] )
    {
     push(@result, $row);
    }
   }
  }
 }
 return \@result;
}

sub combine_puus
{# (c) Edwin Spee

 my @puus = @_;

 my @result = ($puus[0]->[0]);

 foreach my $u (@puus)
 {
  for (my $i=1; $i<scalar @$u; $i++)
  {
   push(@result, $u->[$i])
 }}
 return \@result;
}

sub filter_datum($$$)
{# (c) Edwin Spee

 my ($d1, $d2, $pu) = @_;
 my @result = ($pu->[0]);
 my $rows = scalar @$pu;
 for (my $i=1; $i<$rows; $i++)
 {
  if ($pu->[$i][1] eq 'straf') {next;}
  my $datum = $pu->[$i][2][0];
  if (ref $datum eq 'ARRAY') {$datum = $datum->[0];}
  if ($datum >= $d1 and $datum <= $d2)
  {
   push(@result, $pu->[$i]);
  }
 }
 return \@result;
}

sub filter_team($$$)
{# (c) Edwin Spee
 # versie 2.1 26-jan-2005 verhuisd vanuit web_sport_funcs en stijlaanpassingen
 # versie 2.0 11-aug-2003 zoek patroon moet aanwezig zijn, i.p.v. volledig matchen
 # versie 1.0 begin--2003 initiele versie

 my ($pntr_lookfor, $count,$pu) = @_;
 my @result = ($pu->[0]);
 my $rows = scalar @$pu;
 my $cnt_lookfor = scalar @$pntr_lookfor;
 if ($verbose > 2) {print "lookfor = @$pntr_lookfor \n";}
 for (my $i=1; $i<$rows; $i++)
 {
  my $found = 0;
  for (my $k=0; $k < $cnt_lookfor; $k++)
  #if ($pntr_lookfor->[$k] eq $pu->[$i][0])
  {
   if ($pu->[$i][0] =~ m/$pntr_lookfor->[$k]/is or $pu->[$i][0] =~ m/\//iso)
   {
    $found++;
   }
   # elsif ($pntr_lookfor->[$k] eq $pu->[$i][1])
   elsif ($pu->[$i][1] =~ m/$pntr_lookfor->[$k]/is  or $pu->[$i][0] =~ m/\//iso)
   {
    $found++;
   }
  }
  if (($count == -1 and $found == 0) or ($count > 0 and $found >= $count))
  {
   push (@result, $pu->[$i]);
  }
 }
 return \@result;
}

return 1;

