/* Dit programma is geschreven door:
 * Edwin Spee, E-mail: info@epsig.nl
 * Dit spel mag onbeperkt vaak gespeeld worden.
 * Alle overige rechten uitdrukkelijk voorbehouden.
 * Dit programma staat alleen legaal op:
 *  URL: http://www.epsig.nl
 * De Javascript-broncode is versleuteld om oneigenlijk gebruik te voorkomen.
 * Geinteresseerden kunnen de oorspronkelijke broncode onder voorwaarden inzien.
 */
var versie = "6.1";
var dd = "23 dec 2008";
// -----------------------------------------------------------
// versie overzicht
// versie 6.1, 23 dec 2008: computer wint ipv door computer verslagen
//                          n.a.v. email Andrew Plevier d.d. 10 okt 2008
// versie 6.02,28 sep 2008: with helemaal eruit; + method OScreenAdmin.SetValueColorStyle;
//                          UpdateKaartKleur -> UpdateTroefKleur
// versie 6.01,20 sep 2008: debug-code van geschiedenis naar dbg.geschiedenis
// versie 6.0, 13 sep 2008: speelkaart_23 helemaal nieuw bij niveau > 3.
// versie 5.8, 24 dec 2007: web_tabel eruit; js-menu vervangen door menu_bottum uit perl-deel;
//                          + check_form
// versie 5.7, 25 nov 2007: veel meer Object-georienteerd;
//                          meer timeouts, waardoor rustiger beeld
// versie 5.6,  2 aug 2007: settings, semi-automaat
// versie 5.5,  2 jul 2007: bugje uit SlagLigtAan; branch voor test/beta; debug opgepoetst
// versie 5.4,  5 aug 2006: gebruikt kk uit Analyseer_spel als vervanging van spieken
// versie 5.3, 30 apr 2006: kleine verbetering bij uitkomen
// versie 5.2, 22 jul 2005: kleur in tekst en palmtop-versie
// versie 5.1, 19 jul 2005: integratie palmtop-versie gfx/txt-versie
// versie 5.03,11 jun 2005: + link naar klaverjas_faq.html
// versie 5.02, 3 jun 2005: url -> www.epsig.nl
// versie 5.01,14 jan 2005: ander email-adres; iets andere versleuteling
// versie 4.9,  3 jan 2003: tabel aangepast aan klein netscape scherm
// versie 4.8, 27 dec 2002: diverse wijzigingen om webversie kleiner te maken.
// versie 4.7, 12 dec 2002: tabel als functie, div. kleine dingen, volgorde_form gefixeerd
// versie 4.63, 7 sep 2002: veel /* -> // ivm js_collect
// versie 4.62, 8 jan 2002: init_math naar schudkaarten
// versie 4.61, 3 jan 2002: minder globale vars
// versie 4.6, 17 dec 2001: initrandom, preload, split js-files
// versie 4.5 menu i.p.v. voet tabel
// versie 4.4 palmtop scherm aangepast; delay opleggen aangepast
// versie 4.3 strategie aangepast (vooral minder spekken)
// versie 4.2 pre-load verbeterd
// versie 4.1 cookies voor niveau, gfx-txt-palm, adam-rdam
// versie 3.5 bug met kaart4 (roem) opgelost
// versie 3.4 history toegevoegd
// versie 3.3 pre-load van de plaatjes
// versie 3.2 ook een grafische versie en keus Amsterdams/Rotterdams
// versie 3.11 werkt nu ook op palmtop
// versie 3.01 troefkleur kan in het begin weer veranderd worden
// versie 3.00 niveau 1-3; afronden op tientallen
// versie 2.03 buttons voorzien van monospace lettertype
//             g_status op -1 gezet tijdens help/info
// versie 2.02 Eerste verspreidde versie
//
var env,
matchadm,
dbg,
KRHSlong = ["Klaver","Ruiten","Schoppen","Harten"],
KRHS = ["K","R","S","H"],
naam_long = ["Jij","Links","Maat","Rechts"],
naam_short = ["j","l","m","r"];

function AmsRotStr(x){return AmsRotStr2(x)+"terdam";}
function AmsRotStr2(x){return x?"Ams":"Rot";}

function NieuwSpel()
{if (env.gfx())
 {matchadm.NieuwSpel();}
 else
 {window.location.reload();}
}

function IncSpelNiveau(i)
{env.IncNiveau(i);
 matchadm.strat.reset(env.niveau());}

function HelpFunctie(i)
{matchadm.help.HelpFunctie(i);}

function KiesTroef(i)
{matchadm.KiesTroef(i);}

function ComputerAanZet(i)
{matchadm.ComputerAanZet(i);}

function ComputerAanZet_vervolg()
{matchadm.ComputerAanZet_vervolg();}

function ComputerWeerAanZet(i)
{matchadm.ComputerWeerAanZet(i);}

function SpeelDeze(kaartn)
{matchadm.SpeelDeze(kaartn);}

function StartSpel()
{
 env          = new OEnvironment(document.BSpelNiveau);
 matchadm     = new OMatchAdmin(env);
 dbg          = new ODebug(env);

 if (matchadm.scrn.gfx) {PreLoad(0,0);}
 else {matchadm.status = 0; matchadm.NieuwSpel();}
}

