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
$VERSION = '21.0';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '&get_bkmrks_html',
 '&get_actueel',
 '&get_bkmrks_media',
 '&get_bkmrks_milieu',
 '&get_bkmrks_science',
 '&get_bkmrks_treinen',
 #========================================================================
);
our $links_csv = [];

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

sub get_bkmrks_html
{
  my @parts = (
    ['HTML (en CSS en JavaScript)', 'html'],
    ['Invoer/uitvoer standards', 'io_std'],
    ['Versiebeheer', 'versiebeheer'],
    ['Perl', 'perl'],
    ['Fortran-90', 'fortran'],
    ['Overig', 'overig'],
  );

  my $pout = fill_pout(\@parts);
  my $title = 'Bookmarks: Computers en internet';
  return maintxt2htmlpage($pout, $title, 'std', 20211016, {type1 => 'std_menu'});
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
        push @$links, {url => $ospage, description => 'Olymp. Winterspelen', date => 2.0, date => 3.3};
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
        $actueel .= qq(<li><a href="$rij->{url}">$rij->{description}</a>\n);
      }
      else
      {
        $actueel .= qq(<li>$rij->{description}\n);
      }
      if ($rij->{description} =~ m/brexit/iso)
      {
        $actueel .= qq(over (onder voorbehoud): <div id="brexit"> </div>\n);
      }
    }
    elsif ($rij->{date1} <= $deze_maand && $deze_maand  <= $rij->{date2})
    {
      print "Skipping: $rij->[1]\n";
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
    $actueel = "<li>geen grote evenementen deze maand.\n";
  }

  return $actueel;
}

sub get_bkmrks_media()
{# (c) Edwin Spee

my $actueel = get_actueel('media');

my $tt101 = ttlink(101, 'NOS Teletekst');
my $out = << "EOF";
<table>
<tr> <td valign=top> <center> <b> Het laatste nieuws </b> </center>
<ul>
 <li> $tt101
 <li><a href="http://www.rtlnieuws.nl/">RTL Nieuws</a>
 <li><a href="http://www.omroep.nl/nos/nieuws/">NOS Nieuws: hoofdpunten</a>
 <li><a href="http://www.text.nl/">Teletekst RTL4, 5 en Yorin</a>
 <li><a href="http://www.vrt.be/">Vlaamse Radio- en TV</a>
 <li><a href="http://news.bbc.co.uk/">BBC News</a>
 <li><a href="http://www.cnn.com/">CNN</a>
 <li><a href="http://dailynews.yahoo.com/">Yahoo</a>
 <li><a href="http://news.lycos.com/headlines/TopNews/">Lycos</a>
 <li><a href="http://www.anp.nl/">ANP</a>
</ul>
<td valign=top> <center> <b>Kalender / Actueel</b> </center>
<ul>
$actueel</ul>
<td valign=top> <center> <b>Divers</b> </center>
<ul>
 <li><a href="http://www.planet.nl/multimedia/">Planet Multimedia</a>
 <li><a href="http://www.webwereld.nl/">WebWereld</a>
 <li><a href="http://www.jorislange.nl/media/">Adressen Nederlandse media</a>
 <li><a href="http://www.eurotv.com/">The most complete European TV Guide Web</a>
 <li><a href="http://www.radiowereld.nl/">www.radiowereld.nl</a>
 <li><a href="http://www.amibo.demon.nl/juinen/">Juiner Courant</a>
</ul>
<tr> <td valign=top> <center> <b>Kranten op Internet</b> </center>
<ul>
 <li><a href="http://www.volkskrant.nl/">De Volkskrant</a>
 <li><a href="http://www.nrc.nl/">NRC</a>
 <li><a href="http://www.trouw.nl/">Trouw</a>
 <li><a href="http://www.ad.nl/">Algemeen Dagblad</a>
 <li><a href="http://www.sdu.nl/staatscourant/vandaag/">Staatscourant</a>
 <li><a href="http://www.telegraaf.nl/">De Telegraaf</a>
 <li><a href="http://www.gelderlander.nl/">De Gelderlander</a>
 <li><a href="http://www.leidschdagblad.nl/">Leidsch Dagblad</a>
 <li><a href="http://www.eindhovensdagblad.nl/">Eindhovens Dagblad</a>
 <li><a href="http://www.rotterdamsdagblad.nl/">Rotterdams Dagblad</a>
 <li><a href="http://www.stem.nl/">Dagblad De Stem</a>
</ul>
<td valign=top> <center> <b>TV</b> </center>
<ul>
 <li>De Nederlandse <a href="http://www.omroep.nl/">Publieke Omroep</a>
 <li><a href="http://www.rtl4.nl/">RTL 4</a>
 <li><a href="http://www.rtl5.nl/">RTL 5</a>
 <li><a href="http://www.yorin.nl/">Yorin</a>
 <li><a href="http://www.sbs6.nl/">SBS 6</a>
 <li><a href="http://www.tmf.nl/">TMF</a>
 <li><a href="http://www.foxtv.nl/">Fox TV</a>
 <li><a href="http://www.sire.nl/">SIRE</a>
</ul>
</td>
<td valign=top> <center> <b>Radio</b> </center>
<ul>
 <li><a href="http://www.concertzender.nl/">Concertzender</a>
 <li><a href="http://www.skyradio.nl/">Sky Radio</a>
 <!-- <li><a href="http://www.veronica.nl/veronicafm/">Radio Veronica</a> -->
 <li><a href="http://www.radio538.nl/">Radio 538</a>
 <li><a href="http://www.radio10.nl/">Radio 10 FM</a>
 <li><a href="http://www.radio-noordzee.nl/">Radio Noordzee Nationaal</a>
</ul>
</tr>
</table>
EOF
return maintxt2htmlpage(bespaar_bandbreedte($out), 'Bookmarks: media', 'title2h1',
 get_datum_fixed(), {type1 => 'std_menu'});
}

sub get_bkmrks_milieu()
{
  my @parts = (
  ['Algemeen', 'algemeen'],
  ['Onderzoek', 'onderzoek'],
  ['Tijdschriften', 'journals'],
  ['Organizaties', 'organizations'],
  ['Milieuvriendelijk transport: de fiets', 'fietsen'],
  );

  my $pout = fill_pout(\@parts);
  my $title = 'Bookmarks: Meteorologie en Milieu';
  return maintxt2htmlpage($pout, $title, 'std', 20211016, {type1 => 'std_menu'});
}

sub get_bkmrks_science()
{
  my $pout = fill_pout([['wetenschap', 'science']]);
  my $title = 'Bookmarks: wetenschap';
  return maintxt2htmlpage($pout, $title, 'std', 20211016, {type1 => 'std_menu'});
}

sub get_bkmrks_treinen
{
  my @parts = (
  ['reisplanners', 'trip_planners'],
  ['nieuwe infrastructuur', 'new_infra'],
  ['light rail', 'lightrail'],
  ['spoorwegbedrijven (reizigers)', 'railwaycompanies'],
  ['overige trein-sites-I', 'rail_rest1'],
  ['overige trein-sites-II', 'rail_rest2']
  );

  my $pout = fill_pout(\@parts);
  my $title = 'Bookmarks: treinen';
  return maintxt2htmlpage($pout, $title, 'std', 20211016, {type1 => 'std_menu'});
}

return 1;
