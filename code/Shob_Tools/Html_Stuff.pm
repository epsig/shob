package Shob_Tools::Html_Stuff;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
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
 '&html2utf8',
 '&utf82html',
 '&init_web_index',
 '&make_table',     '&ftable',
 '&ftr',  '&ftdl',  '&ftdr',  '&ftdc',  '&ftdx',  '&ftd', '&fth', '&tds',
 '&get_table_border',
 '&get2tables',     '&get3tables',

 '$web_index', '$nbsp',

 '&no_missing_values',
 '&no_empty_cells',

 '&yellow_red',
 '&fform',
 '&finput',
 #========================================================================
);

our $web_index = 'index.html';

our $nbsp      = '&nbsp;';

my $char_pairs = [
  ['&aacute;' ,"\xE1"],
  ['&acirc;'  ,"\xE2"],
  ['&ccedil;' ,"\xE7"],
  ['&eacute;' ,"\xE9"],
  ['&euml;'   ,"\xEB"],
  ['&icirc;'  ,"\xEE"],
  ['&iuml;'   ,"\xEF"],
  ['&oacute;' ,"\xF3"],
  ['&ocirc;'  ,"\xF4"],
  ['&ouml;'   ,"\xF6"],
  ['&egrave;' ,"\xE8"],
  ['&uuml;'   ,"\xFC"],
  ['&Eacute;' ,"\xC9"],
  ['&Ccedil;' ,"\xC7"],
];

sub html2utf8($)
{# (c) Edwin Spee

 my ($string) = @_;

 foreach my $pair (@$char_pairs)
 {
  my $html = $pair->[0];
  my $utf8 = $pair->[1];
  $string =~ s/$html/$utf8/sg;
 }
 return $string;
}

sub utf82html($)
{# (c) Edwin Spee

 my ($string) = @_;

 foreach my $pair (@$char_pairs)
 {
  my $html = $pair->[0];
  my $utf8 = $pair->[1];
  $string =~ s/$utf8/$html/sg;
 }
 return $string;
}

sub init_web_index($)
{# (c) Edwin Spee

 my ($local_version) = @_;

# overwrite initial value for non-local versions:
 if (not $local_version)
 {
  $web_index = '';
 }
}

sub no_missing_values($)
{# (c) Edwin Spee

 my $x = $_[0];
 return ($x != -1 ? $x : $nbsp);
}

sub no_empty_cells($@)
{# (c) Edwin Spee

 my ($option, @strings) = @_;
 my $txt;

 if (scalar @strings == 3)
 {if ($strings[2] eq '' and $strings[1] eq '')
  {$txt = fthd('td', {cols=>3}, $strings[0])}
  elsif ($strings[2] eq '')
  {$txt = ftdl($strings[0]) . fthd('td', {cols => 2}, $strings[1])}
  else
  {$txt = ftdl($strings[0]) . ftdl($strings[1]) . ftdl($strings[2])}
 }
 elsif (scalar @strings == 2)
 {if ($strings[1] eq '')
  {$txt = fthd('td', {cols => 2}, $strings[0])}
  else
  {$txt = ftdl($strings[0]) . ftdl($strings[1])}
 }
 else {shob_error('not_yet_impl', ['sub no_empty_cells nog niet generiek genoeg; sorry.']);}
 return $txt;
}

sub make_table($$@)
{# (c) Edwin Spee

 my ($option, $cols, @data) = @_;

 my $rows = int (($cols + scalar @data - 1) / $cols);

 for (my $i=1; $i < $cols; $i++)
 {
  push @data, $nbsp;
 }

 my $out = '';
 my $ii = 0;
 for (my $i=1; $i <= $rows; $i++)
 {
  my $row = '';
  for (my $j=1; $j <= $cols; $j++)
  {
   my $elm = $data[$ii++];
   $row .= ftdc($elm);
   if ($j != $cols) {$row .= "\n";}
  }
  $out .= ftr($row);
 }

 my $ret_val = ftable($option, $out);

 return $ret_val;
}

sub ftable($$)
{# (c) Edwin Spee

 my ($option, $txt) = @_;

 # default $option eq 'border'
 my $ts = '<table border cellspacing=0>';
 if ($option eq 'tabs')
 {$ts = '<table>';}
 elsif ($option eq 'width100%')
 {$ts = '<table width="100%">';}
 elsif ($option eq 'border_width100%')
 {$ts = '<table border cellspacing="0" width="100%">';}

 return "$ts$txt</table>\n";
}

sub ftr($)
{# (c) Edwin Spee

 my $txt = shift;
 return "<tr>$txt</tr>\n";
}

sub ftdl($)
{# (c) Edwin Spee

 my $txt = shift;
 return "<td>$txt</td>";
}

sub ftdr($)
{# (c) Edwin Spee

 my $txt = shift;
 return "<td class=r>$txt</td>";
}

sub ftdc($)
{# (c) Edwin Spee

 my $txt = shift;
 return "<td class=c>$txt</td>";
}

sub ftdx($$)
{# (c) Edwin Spee

 my ($align, $txt) = @_;

 if ($align eq 'l')
 {return ftdl($txt);}
 elsif ($align eq 'c' or $align eq 's')
 {return ftdc($txt);}
 elsif ($align eq 'r')
 {return ftdr($txt);}
 elsif ($align eq 'vtop')
 {return qq(<td valign="top">$txt</td>\n);}
 else
 {shob_error('strange_else', ["align = $align"]);}
}

sub fthd
{# (c) Edwin Spee

 my $type = shift;
 if (scalar @_ > 1)
 {
  my ($popts, $txt) = @_;
  my $retval = "<$type";
  foreach my $modifier ('cols', 'rows')
  {my $opt = $popts->{$modifier};
   if (defined $opt and $opt > 1)
    {$retval .= qq( ${modifier}pan="$opt");}}

  foreach my $modifier ('width', 'align', 'valign')
  {my $opt = $popts->{$modifier};
   if (defined $opt and $opt ne '')
    {$retval .= qq( $modifier="$opt");}}

  if (defined $popts->{class})
  {my $style = $popts->{class};
   if ($style ne '') {$retval .=qq( class=$style);}}  # without quotes (for historical reasons)!

  $retval .= '>' . $txt . "</$type>";
 }
 else
 {
  my $txt = shift;
  return "<$type>$txt</$type>";}
}

sub fth {fthd('th', @_);}
sub ftd {fthd('td', @_);}

sub tds($)
{# (c) Edwin Spee

 return fthd('td', {cols=>$_[0]}, $nbsp);
}

sub get_table_border($)
{# (c) Edwin Spee

 my $txt = $_[0];
 return ftable('border', ftr(ftdl($txt)));
}

sub get2tables($$)
{# (c) Edwin Spee

 my ($a, $b) = @_;
 my $aa = ftable('tabs', $a);
 my $bb = ftable('tabs', $b);
 my $style = {valign => 'top'};
 return ftable('border', ftr(fthd('td', $style, $aa) . fthd('td', $style, $bb)) );
}

sub get3tables($$$)
{# (c) Edwin Spee

 my ($a, $b, $c) = @_;
 my $aa = ftable('tabs', $a);
 my $bb = ftable('tabs', $b);
 my $cc = ftable('tabs', $c);
 my $style = {valign => 'top'};
 return ftable('border', ftr(fthd('td', $style, $aa) . fthd('td', $style, $bb) . fthd('td', $style, $cc)) );
}

sub yellow_red($)
{# (c) Edwin Spee

 my ($pdata) = @_;

 my $out = '';

 for (my $i = 0; $i < scalar @$pdata / 2; $i++)
 {
  if (2*$i+1 >= scalar @$pdata)
  {
    $out .= '<div class="row">';
    $out .= '<div class="column100" >';
    $out .= '<div class="colh" >';
    $out .= $pdata->[2*$i][0];
    $out .= '</div>';
    $out .= '<div class="colb" >';
    $out .= $pdata->[2*$i][1];
    $out .= '</div>';
    $out .= '</div>';
    $out .= '</div>';
  }
  else
  {
   $out .= '<div class="row">';
   for (my $j = 0; $j < 2; $j++)
   {
    $out .= '<div class="column" >';
    $out .= '<div class="colh" >';
    $out .= $pdata->[2*$i+$j][0];
    $out .= '</div>';
    $out .= '<div class="colb" >';
    $out .= $pdata->[2*$i+$j][1];
    $out .= '</div>';
    $out .= '</div>';
   }
   $out .= '</div>';
  }
 }

 $out .= << 'EOF';
</table>
EOF

 return $out;
}

sub fform($$)
{# (c) Edwin Spee

 my ($name, $txt) = @_;
 return qq(<form name="$name">$txt</form>\n);
}

sub finput($$$$$$)
{
 my ($type, $name, $value, $size, $class, $onclick) = @_;
 my $retval = '<input';
 if ($type ne '') {$retval .= qq( type="$type");}
 if ($name ne '') {$retval .= qq( name="$name");}
 $retval .= qq( value="$value");
 if ($size > 0) {$retval .= qq( size="$size");}
 if ($class ne '') {$retval .= qq( class="$class");}
 if ($onclick ne '') {$retval .= qq( onClick="$onclick");}
 $retval .= qq(/>\n);
 return $retval;
}

return 1;

