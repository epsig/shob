#!/usr/bin/perl
use strict; use warnings;

=head1 USAGE

 Shob - H E L P

 shob.pl [option(s)] command          : general usage
 
 shob.pl [option(s)]                  : interactive mode
 perl -c shob.pl                      : check syntax of shob.pl and its modules
 perl -d shob.pl [option(s) [command] : debug mode of perl

=head2 COMMANDS

 -d       : diff and replace most files
 -dl      : diff and replace -lopende- files
 -d2      : = -d
 -d4      : diff and replace all files
 -c       : check syntax of shob.pl and its modules
 -e       : edit coded addresses
 -diff_adres   = -di : cvs diff Admin/adressen_coded.txt -> decode
 -help         = -he : this help
 -history      = -hi : rebuild old website
 -version      = -v  : get version info
 -search term  = -s term : search for file containing a string term

=head2 OPTIONS

 --dir=str     = --d : output directory = str
 --mkdir       = --m : do not prompt for mkdir

=cut

use Time::HiRes qw(gettimeofday);
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
use Sport_Collector::OS_Funcs;
use Sport_Collector::Archief_EK_WK_Voetbal;
use Sport_Collector::Stats_Eredivisie;
use Sport_Collector::Bookmarks_Index;

my $withAdresses = ( -f File::Spec->catfile('Admin', 'Adressen_data2html.pm') );

sub handle_new_style_files($$$)
{# (c) Edwin Spee

 my ($opt, $lv, $lop) = @_;

 do_all_text_dir ($lop, 'search', [
  [2, 'all', sub {&file2str(File::Spec->catfile('Shob', 'search_setup.pl'));}, 'search.setup'],
 ]);

 my $style = 'epsig.css';
 do_all_text_dir ($lop, '', [
  [1, 'all', sub {&file2str(File::Spec->catfile('test', $style));}, $style],
 ]);

 do_all_text_dir ($lop, '', [
  [1, 'all', sub {&get_hopa;}, 'index.html'],
  [1, 'all', sub {&file2str(File::Spec->catfile('my_scripts', 'countdown.js'));}, 'countdown.js'],
  [2, 'all', sub {&get_epsig;}, 'epsig.html'],
  [1, 'all', sub {&get_stats;}, 'stats.html'],
  [2, 'all', sub {&get_tech_doc_kj;}, 'tech_doc_kj.html'],
  [2, 'all', sub {&get_tech_doc_shob;}, 'tech_doc_shob.html'],
  [2, 'all', sub {&get_tech_doc_adressen;}, 'tech_doc_adressen.html'],
  [1, 'all', sub {&get_sport_index('', '', '', -1, -1);}, 'sport.html'],
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
  [1, 'all', sub {&get_bkmrks_media;}, 'bookmarks_media.html'],
  [2, 'all', sub {&get_bkmrks_geld;}, 'tmp_bookmarks_geld.html'],
  [2, 'all', sub {&get_bkmrks_science;}, 'tmp_bookmarks_science.html'],
  [2, 'all', sub {&get_bkmrks_overheid;}, 'tmp_bookmarks_overheid.html'],
  [2, 'all', sub {&get_bkmrks_milieu;}, 'tmp_bookmarks_milieu.html'],
  [2, 'all', sub {&get_bkmrks('werk');}, 'tmp_bookmarks_werk.html'],
  [2, 'all', sub {&get_bkmrks('prive');}, 'tmp_bookmarks_prive.html'],
  [2, 'all', sub {&get_bkmrks('index');}, 'bookmarks.html'],
  [2, 'all', sub {&get_klaverjas_faq;}, 'klaverjas_faq.html'],
# [1, ' rl', sub {&get_klaverjas_beta_versies;}, 'kj_beta_versies.html'],

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
  [1, 'all', sub {&get_ek2020v;}, 'sport_voetbal_EK_2020_voorronde.html'],
  [1, 'all', sub {&get_wk2022v;}, 'sport_voetbal_WK_2022_voorronde.html'],

  [2, 'all', sub {&get_ec_webpage('1994-1995');}, 'sport_voetbal_europacup_1994_1995.html'],
  [2, 'all', sub {&get_ec_webpage('1995-1996');}, 'sport_voetbal_europacup_1995_1996.html'],
  [2, 'all', sub {&get_ec_webpage('1996-1997');}, 'sport_voetbal_europacup_1996_1997.html'],
  [2, 'all', sub {&get_ec_webpage('1997-1998');}, 'sport_voetbal_europacup_1997_1998.html'],
  [2, 'all', sub {&get_ec_webpage('1998-1999');}, 'sport_voetbal_europacup_1998_1999.html'],
  [2, 'all', sub {&get_ec_webpage('1999-2000');}, 'sport_voetbal_europacup_1999_2000.html'],
  [2, 'all', sub {&get_ec_webpage('2000-2001');}, 'sport_voetbal_europacup_2000_2001.html'],
  [2, 'all', sub {&get_ec_webpage('2001-2002');}, 'sport_voetbal_europacup_2001_2002.html'],
  [2, 'all', sub {&get_ec_webpage('2002-2003');}, 'sport_voetbal_europacup_2002_2003.html'],
  [2, 'all', sub {&get_ec_webpage('2003-2004');}, 'sport_voetbal_europacup_2003_2004.html'],
  [2, 'all', sub {&get_ec_webpage('2004-2005');}, 'sport_voetbal_europacup_2004_2005.html'],
  [2, 'all', sub {&get_ec_webpage('2005-2006');}, 'sport_voetbal_europacup_2005_2006.html'],
  [2, 'all', sub {&get_ec_webpage('2006-2007');}, 'sport_voetbal_europacup_2006_2007.html'],
  [2, 'all', sub {&get_ec_webpage('2007-2008');}, 'sport_voetbal_europacup_2007_2008.html'],
  [2, 'all', sub {&get_ec_webpage('2008-2009');}, 'sport_voetbal_europacup_2008_2009.html'],
  [2, 'all', sub {&get_ec_webpage('2009-2010');}, 'sport_voetbal_europacup_2009_2010.html'],
  [2, 'all', sub {&get_ec_webpage('2010-2011');}, 'sport_voetbal_europacup_2010_2011.html'],
  [2, 'all', sub {&get_ec_webpage('2011-2012');}, 'sport_voetbal_europacup_2011_2012.html'],
  [2, 'all', sub {&get_ec_webpage('2012-2013');}, 'sport_voetbal_europacup_2012_2013.html'],
  [2, 'all', sub {&get_ec_webpage('2013-2014');}, 'sport_voetbal_europacup_2013_2014.html'],
  [2, 'all', sub {&get_ec_webpage('2014-2015');}, 'sport_voetbal_europacup_2014_2015.html'],
  [2, 'all', sub {&get_ec_webpage('2015-2016');}, 'sport_voetbal_europacup_2015_2016.html'],
  [2, 'all', sub {&get_ec_webpage('2016-2017');}, 'sport_voetbal_europacup_2016_2017.html'],
  [2, 'all', sub {&get_ec_webpage('2017-2018');}, 'sport_voetbal_europacup_2017_2018.html'],
  [2, 'all', sub {&get_ec_webpage('2018-2019');}, 'sport_voetbal_europacup_2018_2019.html'],
  [2, 'all', sub {&get_ec_webpage('2019-2020');}, 'sport_voetbal_europacup_2019_2020.html'],
  [1, 'all', sub {&get_ec_webpage('2020-2021');}, 'sport_voetbal_europacup_2020_2021.html'],

  [2, 'all', sub {&get_betaald_voetbal_nl(1993);}, 'sport_voetbal_nl_1993_1994.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1994);}, 'sport_voetbal_nl_1994_1995.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1995);}, 'sport_voetbal_nl_1995_1996.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1996);}, 'sport_voetbal_nl_1996_1997.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1997);}, 'sport_voetbal_nl_1997_1998.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1998);}, 'sport_voetbal_nl_1998_1999.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(1999);}, 'sport_voetbal_nl_1999_2000.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2000);}, 'sport_voetbal_nl_2000_2001.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2001);}, 'sport_voetbal_nl_2001_2002.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2002);}, 'sport_voetbal_nl_2002_2003.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2003);}, 'sport_voetbal_nl_2003_2004.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2004);}, 'sport_voetbal_nl_2004_2005.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2005);}, 'sport_voetbal_nl_2005_2006.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2006);}, 'sport_voetbal_nl_2006_2007.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2007);}, 'sport_voetbal_nl_2007_2008.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2008);}, 'sport_voetbal_nl_2008_2009.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2009);}, 'sport_voetbal_nl_2009_2010.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2010);}, 'sport_voetbal_nl_2010_2011.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2011);}, 'sport_voetbal_nl_2011_2012.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2012);}, 'sport_voetbal_nl_2012_2013.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2013);}, 'sport_voetbal_nl_2013_2014.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2014);}, 'sport_voetbal_nl_2014_2015.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2015);}, 'sport_voetbal_nl_2015_2016.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2016);}, 'sport_voetbal_nl_2016_2017.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2017);}, 'sport_voetbal_nl_2017_2018.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2018);}, 'sport_voetbal_nl_2018_2019.html'],
  [2, 'all', sub {&get_betaald_voetbal_nl(2019);}, 'sport_voetbal_nl_2019_2020.html'],
  [1, 'all', sub {&get_betaald_voetbal_nl(2020);}, 'sport_voetbal_nl_2020_2021.html'],
  [1, 'all', sub {&officieuze_standen('officieus', 2020);}, 'sport_voetbal_nl_jaarstanden.html'],
  [1, 'all', sub {&officieuze_standen('uit_thuis', 2020);}, 'sport_voetbal_nl_uit_thuis.html'],

  [1, 'all', sub {&get_stats_eredivisie(2019, 2020, 0);}, 'sport_voetbal_nl_stats.html'],
  [1, '  u', sub {&get_stats_eredivisie(2019, 2020, 2);}, 'sport_voetbal_nl_stats_more.html'],

  [2, 'all', sub {&get_OS1994();}, 'sport_schaatsen_OS_1994.html'],
  [2, 'all', sub {&get_OS1998();}, 'sport_schaatsen_OS_1998.html'],
  [2, 'all', sub {&get_OS2002();}, 'sport_schaatsen_OS_2002.html'],
  [2, 'all', sub {&get_OS2006();}, 'sport_schaatsen_OS_2006.html'],
  [2, 'all', sub {&get_OS2010();}, 'sport_schaatsen_OS_2010.html'],
  [2, 'all', sub {&get_OS2014();}, 'sport_schaatsen_OS_2014.html'],
  [1, 'all', sub {&get_OS2018();}, 'sport_schaatsen_OS_2018.html'],
  [2, ' rl', sub {&file2str(File::Spec->catfile('Admin', 'robots.txt'));}, 'robots.txt'],
 ]);

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

sub print_version()
{# (c) Edwin Spee

  use Shob_Tools::Idate;

  my ($y, $m, $d) = split_idate(get_datum_fixed());
  my $mon = monthstr($m - 1);
  my $CVS_tag = get_CVS_tag();

  print << "EOF";

Version dated : $mon - $y.
Version number: $CVS_tag

EOF
}

sub sport_init()
{ # initializations for sport data

  use Sport_Collector::Archief_Oefenduels;
  use Sport_Collector::Teams;
  use Sport_Collector::Archief_Voetbal_NL_Uitslagen;
  use Sport_Collector::Archief_Voetbal_NL_Topscorers;

  initTeams();
  initEredivisieResults();
  init_tp_eerste_divisie();
  init_ec();

  read_schaatsers();

  set_laatste_speeldatum_u_nl();
  set_laatste_speeldatum_ec();
  set_laatste_speeldatum_ekwk();
  set_laatste_speeldatum_oefenduels();
  set_laatste_datum_statfiles();
}

sub shob_main_loop()
{# (c) Edwin Spee

 my @start_cpu = times;
 my $start_wt = gettimeofday;

 init_host_id();
 my $hostid = get_host_id();
 init_webdir($hostid);

 my $is_remote = ($hostid eq 'remote' or $hostid eq 'epsig' or $hostid eq 'wh_epsig');
 my $lv = $is_remote ? 'n' : 'y';
 my $nh = $lv;
 my $defaults = $is_remote ? 1 : 0;
 my $parts = 0;

 my $opt;
 my $cmd = '';

 foreach my $arg (@ARGV)
 {
  # handle --mkdir
  if ($arg =~ m/--m/iso)
  {
   no_prompt_mkdir();
  }
  # handle --dir=string
  if ($arg =~ m/--d.*=(.*)/iso)
  {
   my $dir = $1;
   print "Output dir = $dir\n";
   overrule_webdir($dir);
  }
 }

 if (scalar @ARGV)
 {
  my $command = $ARGV[scalar @ARGV - 1];
  if ($command =~ m/-(d.*)/iso)
  {
   $cmd = lc($1);
  }
  if ($command =~ m/-he/iso)
  {
   #print_help_page();
   system('perldoc', 'shob.pl');
   exit 0;
  }
  elsif ($command =~ m/-hi/iso)
  {
   print "\nRebuilding old website!\n\n";
   print_version();
   set_history_on;
   $cmd = 'd3';
  }
  elsif ($command =~ m/-h/iso)
  {
   print "-h is ambitious; use -help or -his:\n\n";
   #print_help_page();
   system('perldoc', 'shob.pl');
   exit 0;
  }
  elsif ($command =~ m/-c/iso)
  {
   print "OK\n"; # syntax ok.
   exit 0;
  }
  elsif ($command =~ m/-v/iso)
  {
   print_version();
   exit 0;
  }
  elsif ($command =~ m/-e/iso or $command =~ m/-di/iso)
  {
    if ($withAdresses)
    {
      require Admin::Adressen_data2html;
      Admin::Adressen_data2html->import;

      if ($command =~ m/-e/iso)
      {
        edit_addresses(0);
      }
      elsif ($command =~ m/-di/iso)
      {
        diff_adres();
      }
    }
    exit 0;
  }
  elsif ($ARGV[scalar @ARGV - 2] =~ m/-s/iso)
  {
   zoek_term($ARGV[scalar @ARGV - 1], File::Spec->curdir, 0);
   exit 0;
  }
 }

 if ($cmd eq '')
 {
  print 'Actie: defaults (d), make(1), print verschillen (2), make met confirm (3=d/dl/d3): ';
  $cmd = lees_regel;
 }

 sport_init();

 if ($cmd eq 'd' or $cmd eq 'dl' or $cmd =~ m/^d\d$/iso)
 {
  $defaults = 2;
  $opt = 3;

  if ($cmd eq 'dl')
  {
   $parts = 1;
  }
  elsif ($cmd =~ m/d(\d)/iso)
  {
   $parts = $1 - 1;
  }
 }
 elsif ($cmd =~ m/q/iso or $cmd =~ m/x/iso)
 {
  print "\nQuit.\n\n";
  exit 1;
 }
 else
 {
  $opt = $cmd;
 }

 if ($defaults <= 1)
 {
  print "Welke Onderdelen:\n";
  print '(vrijwel-)alles (0=d), lopend(1), kj(2) of test/nieuw (3): ';
  $parts = lees_regel;
  if ($parts =~ m/d/iso)
  {
   $defaults = 2;
   $parts = 0;
  }
 }

 if ($defaults == 0 and $parts != 2)
 {
  print 'Locale versie: (jyn) ';
  $lv = lees_regel;
  print 'Nette html (jyn) ';
  $nh = lees_regel;
 }

 init_settings($nh, $opt, 0, $lv);
 init_web_index($lv =~ m/n/iso ? 0 : 1);
 my $parts2 = ($parts < 2 ? 2 - $parts : $parts+1);
 handle_new_style_files($opt, $lv, $parts2);

 my @stop_cpu = times;
 my $stop_wt = gettimeofday;
 my $diff_wt = $stop_wt - $start_wt;
 printf "user:     %.2f\n", $stop_cpu[0] - $start_cpu[0];
 my $get_waiting_time = get_waiting_time;
 if ($get_waiting_time > 0.0)
 {
  printf "walltime: %.2f; waiting: %.2f; walltime - waiting: %.2f\n",
   $diff_wt , $get_waiting_time,
   $diff_wt - $get_waiting_time;
 }
 else
 {
  printf "walltime: %.2f\n", $diff_wt;
 }
 printf "aantal keer filter in sort: %i\n", get_counter();
}

shob_main_loop();

