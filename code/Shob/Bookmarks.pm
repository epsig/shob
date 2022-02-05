package Shob::Bookmarks;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Head_Bottum;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Shob_Tools::Error_Handling;
use Shob::Functions;
use Sport_Functions::Readers;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '21.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_bkmrks_gen',
 '&get_actueel',
 #========================================================================
);
our $links_csv = [];
our $config_csv = [];

sub get_bookmarks_cell($)
{
  my $part = shift;

  if (scalar @$links_csv == 0)
  {
    my $fileWithPath = File::Spec->catfile(File::Spec->updir(), 'data', 'bookmarks', 'archive.csv');
    $links_csv = read_csv_with_header($fileWithPath);
  }

  my $cell = "\n<ul>\n";
  foreach my $link (@$links_csv)
  {
    if ($link->{chapter} eq $part)
    {
      my $url = $link->{url};
      if ($url =~ m/ttpage.(\d\d\d)/)
      {
        $cell .= '<li>' . ttlink($1, $link->{description}) . "</li>\n";
      }
      else
      {
        $cell .= qq(<li><a href="$link->{url}">$link->{description}</a></li>\n);
      }
    }
  }
  $cell .= "</ul>\n";

  return $cell;
}

sub fill_pout($)
{
  my $parts = shift;

  my @pout = ();
  foreach my $part (@$parts)
  {
    push @pout, [$part->[0], get_bookmarks_cell($part->[1])];
  }
  return \@pout;
}

sub get_actueel($)
{# (c) Edwin Spee

  my ($edition) = @_; # 'hopa' or 'media'

  my $fileWithPath = File::Spec->catfile(File::Spec->updir(), 'data', 'bookmarks', 'current.csv');
  my $links = read_csv_with_header($fileWithPath);

# datum gefixeerd om uit CVS te kunnen reproduceren:
  my $datum_fixed = get_datum_fixed();
  my ($yr, $deze_maand_fixed, $day) = split_idate($datum_fixed);
  my $deze_maand = 1+(localtime())[4];
  my $deze_mday  = (localtime())[3];
  $deze_maand_fixed += $day / 31;
  $deze_maand += $deze_mday / 31;

  if (($yr % 2) == 0)
  {
    my $EK_WK = $yr % 4;
    my $EK_WK_str = ($EK_WK ? 'WK' : 'EK');
    my $ekwk_url = "sport_voetbal_${EK_WK_str}_${yr}.html";
    my $webdir = get_webdir();

    my $voorronde = '_voorronde';
    $voorronde = '' if (-f File::Spec->catfile($webdir, $ekwk_url));

    $ekwk_url = "sport_voetbal_${EK_WK_str}_${yr}$voorronde.html";
    shob_error('notfound', [$ekwk_url]) if (not -f File::Spec->catfile($webdir, $ekwk_url));

    push @$links, {url => $ekwk_url, description => "$EK_WK_str-voetbal", date1 => 5.5, date2 => 7.5};
    if ($yr % 4 == 2)
    {
      my $ospage = "sport_schaatsen_OS_$yr.html";
      if (-f File::Spec->catfile($webdir, $ospage))
      {
        push @$links, {url => $ospage, description => 'Olymp. Winterspelen', date1 => 1.0, date2 => 3.3};
      }
    }
  }

  my $totaal = 0; my $totaal2 = 0;
  my $found_diff = 0;
  my $actueel = '';
  foreach my $rij (@$links)
  {
    my $in_between = ($rij->{date1} <= $deze_maand_fixed && $deze_maand_fixed <= $rij->{date2});
    $in_between = 1 if ($rij->{date2} > 13 and $deze_maand_fixed <= $rij->{date2} - 12);
    if ($in_between)
    {
      $totaal++;
      if (defined $rij->{url})
      {
        $actueel .= qq(<li><a href="$rij->{url}">$rij->{description}</a></li>\n);
      }
      else
      {
        $actueel .= qq(<li>$rij->{description}</li>\n);
      }
    }
    elsif ($rij->{date1} <= $deze_maand && $deze_maand  <= $rij->{date2})
    {
      print "Skipping: $rij->{description}\n";
      $found_diff = 1;
    }
  }

  if ($found_diff and $edition ne 'media' and not get_history())
  {
    print "Datum in bookmarks-media is niet up-to-date! Druk op ENTER.\n";
    lees_stdin;
  }

  if ($totaal == 0)
  {
    $actueel = "<li>geen grote evenementen deze maand.</li>\n";
  }

  return $actueel;
}

sub get_bkmrks_gen($)
{
  my $page = shift;

  if (scalar @$config_csv == 0)
  {
    my $fileWithPath = File::Spec->catfile(File::Spec->updir(), 'data', 'bookmarks', 'config.csv');
    $config_csv = read_csv_with_header($fileWithPath);
  }

  my @parts = ();
  my $dd;
  my $title;
  foreach my $line (@$config_csv)
  {
    if ($line->{page} eq $page)
    {
      if ($line->{key} eq 'dd')
      {
        $dd = $line->{value};
      }
      elsif ($line->{key} eq 'title')
      {
        $title = $line->{value};
      }
      else
      {
        push @parts, [$line->{key}, $line->{value}];
      }
    }
  }
  my $pout = fill_pout(\@parts);

  if ($page eq 'media')
  {
    my $actueel = "<ul>" . get_actueel('media') . "</ul>\n";
    $pout->[2] = ['Actueel', $actueel];
    $dd = get_datum_fixed();
  }

  return maintxt2htmlpage($pout, $title, 'std', $dd, {type1 => 'std_menu'});
}

return 1;
