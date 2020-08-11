package Sport_Functions::Get_Land_Club;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Sport_Collector::Teams;
use Shob_Tools::Html_Stuff;
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
 '&expand',
 '&expand_list',
 #========================================================================
);

sub get_club_land($$$$)
{# (c) Edwin Spee

 my ($club, $land, $club_flag, $land_flag) = @_;
# club: 5 letterige code voor club
# land: 2 letterige code voor land waar club voor uit komt
# club_flag: flag: true=short clubname; false=long clubname
# land_flag: flag: true=print landcode; false=print full landname

 my $str_club;
 if ($club_flag)
 {$str_club = clubs_short($club);}
 else
 {$str_club = $clubs{$club};}

 my $str_land;
 if ($land_flag)
 {$str_land = land_acronym($land);}
 else
 {$str_land = $landcodes{$land};}

 my $result = $str_club .' ('. $str_land .')';

# indien van toepassing, substitute:
# club (stad)(land) -> club (stad; land)
 $result =~ s/(.*)\((.*)\) \((.*)\)/$1($2; $3)/iso;
 return $result;
}

sub expand($$)
{# (c) Edwin Spee

# TODO : functie is nu een puinhoop !!!

my ($code, $optie) = @_;
my $lcode = substr($code,0,2);
my $retval;
if ($code =~ m/^[12][A-H]/iso) # voor WK-loting
{$retval = $code;}
elsif ($code =~ m/^._.$/iso) # voor WK-loting
{$retval = $code;}
elsif (length($code) == 2)
{$retval = $landcodes{$code};}
elsif (length($code) == 3 and $optie == 3)
{$retval = clubs_short('NL'.$code);}
elsif (length($code) == 3)
{$retval = $clubs{'NL'.$code};}
elsif (length($code) > 5 or length($code) == 1)
{$retval = $code;}
elsif ($optie==3)
{$retval = clubs_short($code);}
elsif ($optie==4)
{$retval = get_club_land($code, $lcode, 1, 1);}
elsif ($optie==1)
{$retval = get_club_land($code, $lcode, 0, 1);}
elsif ($optie==0 or $lcode eq 'NL')
{$retval = $clubs{$code};}
elsif ($optie==2)
{$retval = get_club_land($code, $lcode, 0, 0);}

 if (defined $retval)
 {return $retval;}
 else
 {shob_error('undef_retval', [$code, $optie]);}
}

sub expand_list($$)
{# (c) Edwin Spee

 my ($l, $opts) = @_;

 my $out = '';
 my $i = 0;
 foreach my $r (@$l)
 {
  my $txt_row = '';
  $txt_row .= ftdr(++$i) if ($opts->{numbered});
  $txt_row .= ftdl(expand($r->[0], -1));
  $txt_row .= ftd({cols => 3}, $r->[1]) if ($opts->{opms});
  $out .= ftr($txt_row);
 }

 return $out;
}

return 1;

