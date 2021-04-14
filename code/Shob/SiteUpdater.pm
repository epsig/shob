package Shob::SiteUpdater;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use File::Spec;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob::Algemeen;
use Shob::Stats_Website;
use Shob::Bookmarks;
use Shob::Functions;
use Shob::Politiek;
use Shob::Foto;
use Shob::Klaverjas_Funcs;
use Shob_Tools::Idate qw(&split_idate);
use Sport_Collector::Archief_Voetbal_NL;
use Sport_Collector::Archief_Europacup_Voetbal;
use Sport_Collector::OS_Schaatsen;
use Sport_Collector::Archief_EK_WK_Voetbal;
use Sport_Collector::Stats_Eredivisie;
use Sport_Collector::Bookmarks_Index;
use Sport_Functions::Seasons;
use Sport_Functions::Range_Available_Seasons qw(&get_sport_range);
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
 '$withAdresses',
 '&handle_all_files',
 #========================================================================
);

our $withAdresses = ( -f File::Spec->catfile('Admin', 'Adressen_data2html.pm') );

my $fast = 2; # set to 2 during debugging

sub handle_all_files($$$)
{
  handle_gen_files(@_);
  handle_sport_files(@_);
}

sub handle_gen_files($$$)
{# (c) Edwin Spee

 my ($opt, $lv, $lop) = @_;

 do_all_text_dir ($lop, 'search', [
  [2, 'all', sub {&file2str(File::Spec->catfile('Shob', 'search_setup.pl'));}, 'search.setup'],
 ]);

 my $style = 'epsig.css';
 do_all_text_dir ($lop, '', [
  [$fast, 'all', sub {&file2str(File::Spec->catfile('test', $style));}, $style],
 ]);

 do_all_text_dir ($lop, '', [
  [$fast, 'all', sub {&get_hopa;}, 'index.html'],
  [2, 'all', sub {&file2str(File::Spec->catfile('my_scripts', 'countdown.js'));}, 'countdown.js'],
  [2, 'all', sub {&file2str(File::Spec->catfile('my_scripts', 'validate_sport.js'));}, 'validate_sport.js'],
  [2, 'all', sub {&get_epsig;}, 'epsig.html'],
  [$fast, 'all', sub {&get_stats;}, 'stats.html'],
  [2, 'all', sub {&get_tech_doc_kj;}, 'tech_doc_kj.html'],
  [2, 'all', sub {&get_tech_doc_shob;}, 'tech_doc_shob.html'],
  [2, 'all', sub {&get_tech_doc_adressen;}, 'tech_doc_adressen.html'],
  [$fast, 'all', sub {&get_sport_index('', 'Ajax', 'Feyenoord', -1, -1, 0, 0);}, 'sport.html'],
  [2, 'all', sub {&get_reactie;}, 'reactie.html'],
  [2, 'all', sub {&get_dank();}, 'dank_u_wel.html'],
  [2, 'all', sub {&get_std_search_page;}, 'search.html'],
  [2, 'all', sub {&get_samenvatting_proefschrift();}, 'samenvatting_proefschrift.html'],
  [2, 'all', sub {&get_overzicht;}, 'overzicht.html'],
  [2, 'all', sub {&get_letters();}, 'anybrowser.html'],
  [2, 'all', sub {&get_ascii_codes;}, 'tmp_ascii_codes.html'],
  [2, 'all', sub {&get_bkmrks_treinen;}, 'bookmarks_treinen.html'],
  [2, 'all', sub {&get_bkmrks_html;}, 'bookmarks_computers.html'],
  [2, 'all', sub {&get_sport_links;}, 'bookmarks_sport.html'],
  [$fast, 'all', sub {&get_bkmrks_media;}, 'bookmarks_media.html'],
  [2, 'all', sub {&get_bkmrks_geld;}, 'tmp_bookmarks_geld.html'],
  [2, 'all', sub {&get_bkmrks_science;}, 'tmp_bookmarks_science.html'],
  [2, 'all', sub {&get_bkmrks_overheid;}, 'tmp_bookmarks_overheid.html'],
  [2, 'all', sub {&get_bkmrks_milieu;}, 'tmp_bookmarks_milieu.html'],
  [2, 'all', sub {&get_bkmrks('werk');}, 'tmp_bookmarks_werk.html'],
  [2, 'all', sub {&get_bkmrks('prive');}, 'tmp_bookmarks_prive.html'],
  [2, 'all', sub {&get_bkmrks('index');}, 'bookmarks.html'],
  [2, 'all', sub {&get_klaverjas_faq;}, 'klaverjas_faq.html']]);
# [1, ' rl', sub {&get_klaverjas_beta_versies;}, 'kj_beta_versies.html'],

  my $robots = File::Spec->catfile('Admin', 'robots.txt');
  if (-f $robots)
  {
    do_all_text_dir ($lop, '', [[2, ' rl', sub {&file2str($robots);}, 'robots.txt']]);
  }

 handle_kj($lop, 1);
 do_all_bin_dir($lop, 2, 'all', 0, 'Shob', '.');
 do_all_bin_dir($lop, 2, 'all', 0, 'include', 'include');
 do_all_bin_dir($lop, 2, 'all', 0, 'kj_img', 'include');
 do_all_bin_dir($lop, 2, 'all', 0, 'fotoalbum', 'fotoalbum');

 do_all_text_dir ($lop, 'fotoalbum', [
[2,  'rl', sub {&get_index_feb02;}, 'index_feb02.html'],
[2,  'rl', sub {&get_index_jun01;}, 'index_jun01.html'],
[2,  'rl', sub {&get_foto_zwemles;}, ['index_oct06.html', 'index.html'] ],
[2,  'rl', sub {&get_foto_sep_06;}, 'index_sep06.html'],
[2,  'rl', sub {&get_foto_mei_06;}, 'index_mei06.html'],
[2,  'rl', sub {&get_foto_feb_05;}, 'index_feb05.html'],
[2,  'rl', sub {&get_foto_sep_04;}, 'index_sep04.html'],
[2,  'rl', sub {&get_foto_carlijn_jan_04;}, 'index_jan04.html'],
[2,  'rl', sub {&get_index_mrt03;}, 'index_mrt03.html'],
[2,  'rl', sub {&get_index_okt01;}, 'index_okt01.html'] ]);

 if ($lop >= 2)
 {if (-f 'Admin/CV_Edwin_Spee.pm')
  {
   require Admin::CV_Edwin_Spee;
   Admin::CV_Edwin_Spee->import;
  
   my $cmds = [
   [2, 'all', sub {get_cv(1, $all_data, 2)}, 'cv.html'],
   [2,   'l', sub {get_cv(0, $all_data, 0)}, 'cv_nolinks.html'],
   ];
   do_all_text_dir ($lop, '', $cmds);
  }
 }

 if ($lop >= 4 && $withAdresses)
 {
  require Admin::Adressen_data2html;
  Admin::Adressen_data2html->import;

  type_pin();

  my $cmds = [
  [4,  'wl', sub {&get_adres_tabel(1, 0, 'html')}, get_filename_adressen(1, 'html', 1)],
  [4,  'wl', sub {&get_adres_tabel(1, 0, 'csv')}, get_filename_adressen(1, 'csv', 1)],
  [4,  'wl', sub {&get_adres_tabel(5, 0, 'csv')}, get_filename_adressen(5, 'csv', 1)],
  [4,  'rl', sub {&get_adres_tabel(6, 0, 'txt')}, get_filename_adressen(6, 'txt', 1)],
  [4,  'rl', sub {&get_adres_tabel(7, 0, 'csv')}, get_filename_adressen(7, 'csv', 1)],
  [4,  'rl', sub {&get_adres_tabel(5, 0, 'csv')}, 'gebruikers_lijst.csv'],
   ];
#if (get_filename_adressen(0, 0, 0) != 5) {die "aantal adreslijsten is ongelijk 5.\n";}
  do_all_text_dir ($lop, 'adressen', $cmds);
 }

 handle_vimrc($lop);
}

sub handle_kj($$)
{# (c) Edwin Spee

 my ($lop, $epsig) = @_;

 my $skip_beta_test = (get_history() or (not $epsig));
#my $skip_beta_test = 1;

 my $hostid = get_host_id();

 do_all_text_dir ($lop, '', [
  [3, 'all', sub {&get_kj_palmtop(1, 'adam', 'std');}, 'kj_klein_adam.html'],
  [3, 'all', sub {&get_kj_palmtop(1, 'rdam', 'std');}, 'kj_klein_rdam.html'],
  [3, 'all', sub {&get_klaverjas_std_scherm('gfx', 'adam', 'std');}, 'kj_gfx_adam.html'],
  [3, 'all', sub {&get_klaverjas_std_scherm('gfx', 'rdam', 'std');}, 'kj_gfx_rdam.html'],
  [3, 'all', sub {&get_klaverjas_std_scherm('txt', 'adam', 'std');}, 'kj_txt_adam.html'],
  [3, 'all', sub {&get_klaverjas_std_scherm('txt', 'rdam', 'std');}, 'kj_txt_rdam.html'],
  [3, 'all', sub {&get_kj_code('gfx', 'std')}, File::Spec->catfile('include', 'kj_code_gfx.js')],
  [3, 'all', sub {&get_kj_code('txt', 'std')}, File::Spec->catfile('include', 'kj_code_txt.js')] ]);
 do_all_bin_dir($lop, 2, 'all', 0, 'kj_img', 'include');

 if (not $skip_beta_test)
 {
  do_all_text_dir ($lop, '', [
   [3, ' rl', sub {&get_kj_palmtop(1, 'adam', 'beta');}, 'kj_klein_adam_beta.html'],
   [3, ' rl', sub {&get_kj_palmtop(1, 'rdam', 'beta');}, 'kj_klein_rdam_beta.html'],
   [3, ' rl', sub {&get_klaverjas_std_scherm('gfx', 'adam', 'beta');}, 'kj_gfx_adam_beta.html'],
   [3, ' rl', sub {&get_klaverjas_std_scherm('gfx', 'rdam', 'beta');}, 'kj_gfx_rdam_beta.html'],
   [3, ' rl', sub {&get_klaverjas_std_scherm('txt', 'adam', 'beta');}, 'kj_txt_adam_beta.html'],
   [3, ' rl', sub {&get_klaverjas_std_scherm('txt', 'rdam', 'beta');}, 'kj_txt_rdam_beta.html'],
   [3, ' rl', sub {&get_kj_code('gfx', 'beta')}, File::Spec->catfile('include', 'kj_code_gfx_beta.js')],
   [3, ' rl', sub {&get_kj_code('txt', 'beta')}, File::Spec->catfile('include', 'kj_code_txt_beta.js')] ]);

  do_all_text_dir ($lop, '', [
   [2, '  l', sub {&get_kj_palmtop(0, 'adam', 'test');}, 'kj_klein_adam_test.html'],
   [2, '  l', sub {&get_kj_palmtop(0, 'rdam', 'test');}, 'kj_klein_rdam_test.html'],
   [2, '  l', sub {&get_klaverjas_std_scherm('gfx', 'adam', 'test');}, 'kj_gfx_adam_test.html'],
   [2, '  l', sub {&get_klaverjas_std_scherm('gfx', 'rdam', 'test');}, 'kj_gfx_rdam_test.html'],
   [2, '  l', sub {&get_klaverjas_std_scherm('txt', 'adam', 'test');}, 'kj_txt_adam_test.html'],
   [2, '  l', sub {&get_klaverjas_std_scherm('txt', 'rdam', 'test');}, 'kj_txt_rdam_test.html'] ]);
 }
}

sub handle_vimrc($)
{# (c) Edwin Spee

 my $lop = $_[0];

 my $hostid = get_host_id();
 my $homedir = ($hostid eq 'local' ? 'C:' : $ENV{HOME} );
 my $vimrc = ($hostid eq 'local' ?
  File::Spec->catfile('C:', 'software', 'vim', '_vimrc') :
  File::Spec->catfile($homedir, '.vimrc') );
 my $vim_dir2 = ($hostid eq 'local' ?
  File::Spec->catdir('C:', 'software', 'vim', 'vim60') :
  File::Spec->catdir($homedir, '.vim') );
 my $fortran_plugin =
  File::Spec->catfile('Admin',
  $hostid eq 'local' ? 'fortran2.vim' : 'fortran.vim');

 if (-d 'Admin')
 {
  do_all_text_dir ($lop, '/', [
   [2, 'all', sub {&vimrc;}, $vimrc],
   [2, ' rw', sub {&file2str($fortran_plugin)},
   File::Spec->catfile($vim_dir2, 'ftplugin', 'fortran.vim')] ]);
 }
}

sub handle_sport_files($$$)
{
  my ($opt, $lv, $lop) = @_;

  my $ranges = get_sport_range();

  my $datum_fixed = get_datum_fixed();

  my $szn1 = $ranges->{topscorers_eredivisie}[1];
  my $szn2 = $ranges->{voetbal_nl}[1];
  my $curYrA = int($datum_fixed * 1E-4); # current calender year
  my $curYrB = szn2yr($szn2);            # year current season started

  my @pages = ([2, 'all', sub {&get_ekwk_gen('wkD2019');}, 'sport_voetbal_WKD2019.html']);

  foreach my $yr ($ranges->{global_first_year} .. $curYrB + 2)
  {
    my $szn1 = yr2szn($yr);
    my $szn2 = $szn1;
       $szn2 =~ s/-/_/;

    my $dl = ($yr >= $curYrB ? $fast : 2);

    if ($szn1 ge $ranges->{europacup}[0] && $szn1 le $ranges->{europacup}[1])
    {
      push @pages, [$dl, 'all', sub {&get_ec_webpage($szn1);}, "sport_voetbal_europacup_$szn2.html"];
    }

    if ($szn1 ge $ranges->{voetbal_nl}[0] && $szn1 le $ranges->{voetbal_nl}[1])
    {
      $dl = 1 if ($yr == 2006);
      push @pages, [$dl, 'all', sub {&get_betaald_voetbal_nl($yr);}, "sport_voetbal_nl_$szn2.html"];
    }

    if ($yr % 4 == 2 && $yr >= $ranges->{schaatsen}[0] && $yr <= $ranges->{schaatsen}[1])
    {
      push @pages, [$dl, 'all', sub {&get_OS($yr);}, "sport_schaatsen_OS_$yr.html"];
    }

    if ($yr % 2 == 0)
    {
      my $ekwk = ($yr % 4 == 0 ? 'ek' : 'wk');
      if ($yr >= $ranges->{ekwk}[0] && $yr <= $ranges->{ekwk}[1])
      {
        my $page_name = "sport_voetbal_" . uc($ekwk) . "_$yr.html";
        push @pages, [$dl, 'all', sub {&get_ekwk_gen($ekwk . $yr);}, $page_name];
      }

      if ($yr >= $ranges->{ekwk_qf}[0] && $yr <= $ranges->{ekwk_qf}[1])
      {
        my $page_name = "sport_voetbal_" . uc($ekwk) . "_${yr}_voorronde.html";
        push @pages, [$dl, 'all', sub {&get_ekwk_voorr_gen($ekwk . $yr);}, $page_name];
      }
    }
  }

  push @pages, [$fast, 'all', sub {&officieuze_standen('officieus', $curYrA);}, 'sport_voetbal_nl_jaarstanden.html'];
  push @pages, [$fast, 'all', sub {&officieuze_standen('uit_thuis', $curYrB);}, 'sport_voetbal_nl_uit_thuis.html'];

  push @pages, [$fast, 'all', sub {&get_stats_eredivisie($szn1, $szn2, 0);}, 'sport_voetbal_nl_stats.html'];
  push @pages, [$fast, 'all', sub {&get_stats_eredivisie($szn1, $szn2, 2);}, 'sport_voetbal_nl_stats_more.html'];

  do_all_text_dir ($lop, '', \@pages);
}

return 1;
