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
use Sport_Collector::Archief_Voetbal_NL;
use Sport_Collector::Archief_Europacup_Voetbal;
use Sport_Collector::OS_Schaatsen;
use Sport_Collector::Archief_EK_WK_Voetbal;
use Sport_Collector::Stats_Eredivisie;
use Sport_Collector::Bookmarks_Index;
use Sport_Functions::Overig;
use Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = ('Exporter');
#=========================================================================

#=========================================================================
# CONTENTS OF THE PACKAGE:
#=========================================================================
$VERSION = '20.1';
# by Edwin Spee.

@EXPORT =
(#========================================================================
 '$withAdresses',
 '&handle_new_style_files',
 #========================================================================
);

our $withAdresses = ( -f File::Spec->catfile('Admin', 'Adressen_data2html.pm') );

sub handle_new_style_files($$$)
{# (c) Edwin Spee

 my ($opt, $lv, $lop) = @_;

 my $fast = 1; # set to 2 during debugging

 do_all_text_dir ($lop, 'search', [
  [2, 'all', sub {&file2str(File::Spec->catfile('Shob', 'search_setup.pl'));}, 'search.setup'],
 ]);

 my $style = 'epsig.css';
 do_all_text_dir ($lop, '', [
  [$fast, 'all', sub {&file2str(File::Spec->catfile('test', $style));}, $style],
 ]);

 do_all_text_dir ($lop, '', [
  [$fast, 'all', sub {&get_hopa;}, 'index.html'],
  [$fast, 'all', sub {&file2str(File::Spec->catfile('my_scripts', 'countdown.js'));}, 'countdown.js'],
  [2, 'all', sub {&get_epsig;}, 'epsig.html'],
  [$fast, 'all', sub {&get_stats;}, 'stats.html'],
  [2, 'all', sub {&get_tech_doc_kj;}, 'tech_doc_kj.html'],
  [2, 'all', sub {&get_tech_doc_shob;}, 'tech_doc_shob.html'],
  [2, 'all', sub {&get_tech_doc_adressen;}, 'tech_doc_adressen.html'],
  [$fast, 'all', sub {&get_sport_index('', '', '', -1, -1);}, 'sport.html'],
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

 do_all_text_dir ($lop, '', [
  [2, 'all', sub {&get_ek1996v;}, 'sport_voetbal_EK_1996_voorronde.html'],
  [2, 'all', sub {&get_ek1996;}, 'sport_voetbal_EK_1996.html'],
  [2, 'all', sub {&get_wk1998v;}, 'sport_voetbal_WK_1998_voorronde.html'],
  [2, 'all', sub {&get_wk1998;}, 'sport_voetbal_WK_1998.html'],
  [2, 'all', sub {&get_ek2000v;}, 'sport_voetbal_EK_2000_voorronde.html'],
  [2, 'all', sub {&get_ek2000;}, 'sport_voetbal_EK_2000.html'],
  [2, 'all', sub {&get_wk2002v;}, 'sport_voetbal_WK_2002_voorronde.html'],
  [2, 'all', sub {&get_wk2002;}, 'sport_voetbal_WK_2002.html'],
  [2, 'all', sub {&get_ek2004v;}, 'sport_voetbal_EK_2004_voorronde.html'],
  [2, 'all', sub {&get_ek2004;}, 'sport_voetbal_EK_2004.html'],
  [2, 'all', sub {&get_wk2006v;}, 'sport_voetbal_WK_2006_voorronde.html'],
  [2, 'all', sub {&get_wk2006;}, 'sport_voetbal_WK_2006.html'],
  [2, 'all', sub {&get_ek2008v;}, 'sport_voetbal_EK_2008_voorronde.html'],
  [2, 'all', sub {&get_ek2008;}, 'sport_voetbal_EK_2008.html'],
  [2, 'all', sub {&get_wk2010v;}, 'sport_voetbal_WK_2010_voorronde.html'],
  [2, 'all', sub {&get_wk2010;}, 'sport_voetbal_WK_2010.html'],
  [2, 'all', sub {&get_ek2012v;}, 'sport_voetbal_EK_2012_voorronde.html'],
  [2, 'all', sub {&get_ek2012;}, 'sport_voetbal_EK_2012.html'],
  [2, 'all', sub {&get_wk2014v;}, 'sport_voetbal_WK_2014_voorronde.html'],
  [2, 'all', sub {&get_wk2014;}, 'sport_voetbal_WK_2014.html'],
  [2, 'all', sub {&get_ek2016v;}, 'sport_voetbal_EK_2016_voorronde.html'],
  [2, 'all', sub {&get_ek2016;}, 'sport_voetbal_EK_2016.html'],
  [2, 'all', sub {&get_wk2018v;}, 'sport_voetbal_WK_2018_voorronde.html'],
  [2, 'all', sub {&get_wk2018;}, 'sport_voetbal_WK_2018.html'],
  [2, 'all', sub {&get_wkD2019;}, 'sport_voetbal_WKD2019.html'],
  [$fast, 'all', sub {&get_ek2020v;}, 'sport_voetbal_EK_2020_voorronde.html'],
  [$fast, 'all', sub {&get_wk2022v;}, 'sport_voetbal_WK_2022_voorronde.html']]);

  my $curYr = 2020;

  my @pages = ();
  foreach my $yr (1993 .. $curYr)
  {
    my $szn1 = yr2szn($yr);
    my $szn2 = $szn1;
       $szn2 =~ s/-/_/;

    my $dl = ($yr == $curYr ? $fast : 2);
    if ($yr >= 1994)
    {
      push @pages, [$dl, 'all', sub {&get_ec_webpage($szn1);}, "sport_voetbal_europacup_$szn2.html"];
    }
    push @pages, [$dl, 'all', sub {&get_betaald_voetbal_nl($yr);}, "sport_voetbal_nl_$szn2.html"];
    if ($yr % 4 == 2)
    {
      push @pages, [$dl, 'all', sub {&get_OS($yr);}, "sport_schaatsen_OS_$yr.html"],
    }
  }
  do_all_text_dir ($lop, '', \@pages);

  do_all_text_dir ($lop, '', [
  [$fast, 'all', sub {&officieuze_standen('officieus', 2020);}, 'sport_voetbal_nl_jaarstanden.html'],
  [$fast, 'all', sub {&officieuze_standen('uit_thuis', 2020);}, 'sport_voetbal_nl_uit_thuis.html'],

  [$fast, 'all', sub {&get_stats_eredivisie(2019, 2020, 0);}, 'sport_voetbal_nl_stats.html'],
  [$fast, '  u', sub {&get_stats_eredivisie(2019, 2020, 2);}, 'sport_voetbal_nl_stats_more.html']]);

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

return 1;
