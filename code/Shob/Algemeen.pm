package Shob::Algemeen;
use strict; use warnings;
#=========================================================================
# DECLARATION OF THE PACKAGE
#=========================================================================
# following text starts a package:
use Shob_Tools::Settings;
use Shob_Tools::General;
use Shob_Tools::Html_Stuff;
use Shob_Tools::Idate;
use Shob_Tools::Html_Head_Bottum;
use Sport_Functions::List_Available_Pages;
use Shob::Klaverjas_Funcs;
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
 '&get_epsig',
 '&get_reactie',
 '&get_dank',
 '&get_samenvatting_proefschrift',
 #========================================================================
);

sub get_epsig
{# (c) Edwin Spee
 # versie 1.0 20-mar-2006 initiele versie

 my $out = << 'EOF';
epsig = eps + sig (zonder dubbele s)
<br> eps = epsilon = Griekse e; e = eerste letter van Edwin
<br> sig = sigma = Griekse s; s = eerste letter van Spee
<p>
Het was in 2005 &eacute;&eacute;n van de weinige vrije domeinnamen met weinig letters
en nog uit te spreken ook.
<p>
Verder worden epsilon en sigma veel gebruikt in <a href="cv.html">mijn vakgebied</a>.
<p>
Geinig, toch?
<p>
Edwin Spee
<br>webmaster www.epsig.nl.
<p> &nbsp;
EOF

 my $title = 'Hoezo, epsig?';
 my $pout = [[$title, $out]];
 return maintxt2htmlpage($pout, $title, 'std', 20060520, {type1 => 'std_menu'});
}

sub get_reactie
{# (c) Edwin Spee

my $out = << 'EOF';
Opmerkingen over deze website?
<br>
Jouw opmerkingen mogen vari&euml;ren van nieuwe of verhuisde links, typefouten.
Ook als je het niet (helemaal) eens bent met de inhoud, hoor ik dat graag.
<p>
Of misschien wil je iets kwijt over mijn klaverjas-spel.
<br>
Lees in dat geval a.u.b. eerst de <a href="klaverjas_faq.html">Klaverjas FAQ</a>
(FAQ = Frequently Asked Questions = Veel gestelde vragen).
<p>
Je opmerkingen kun je kwijt op: <a href="https://github.com/epsig/shob/discussions">GitHub Discussions</a>.
<p>
Alvast bedankt voor de moeite !
<p>
Edwin Spee.
<hr>
EOF

 my $t = 'Reacties op website www.epsig.nl';
 my $pout = [[$t, $out]];
 return maintxt2htmlpage($pout, $t, 'std', 20180521, {type1 => 'std_menu', skip1 => 0});
}

sub get_dank()
{# (c) Edwin Spee

 my $out = << 'EOF';
Dank u wel voor uw reactie.
<br>
Ik zal proberen binnen een week te reageren.
<p>
met vriendelijke groet,
<br>
Edwin Spee.
<p>
EOF

 return maintxt2htmlpage($out, 'Dank u wel voor uw reactie!',
  'title2h1', 20050616, {type1 => 'std_menu'});
}

sub get_samenvatting_proefschrift()
{# (c) Edwin Spee

 my $out = file2str(File::Spec->catfile('include', 'samenvatting_phd.html'));

 return maintxt2htmlpage($out, 'Samenvatting proefschrift Edwin Spee',
 'title2h1', 20050530, {type1 => 'small_menu'});
}

return 1;
