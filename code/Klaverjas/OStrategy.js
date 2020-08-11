function OStrategy(adm, level) {
// constructor voor klasse OStrategy.
//
// Interface:
//
//  constructor:
//   koppelt aan OSetAdmin
//
//  KiesTroef(speler, modus)
//  KomUit(speler):
//   incl. KomSlimUit, SlimsteZet, maar zonder Hand2Tafel
//  SpeelKaart(speler):
//   laag boven Kaart4 en Kaart34
//   incl. SlimsteZet, maar zonder Hand2Tafel
//  Verschil:
//   TODO not implemented yet
//   geeft verschil in punten tussen beste en een-na-beste kaart bij vorige aanroep van KomSlimUit of SpeelKaart
//  reset:
//   triviaal
//  tooktime: (readonly) cpu-time laatste Speelkaart
//

var m_adm  = adm;
var s_adm  = adm.setadm;
var b      = adm.br;
var SLMR   = adm.setadm.c.SLMR;
var niveau = level;
var speler;
var slimme_zet = new Array(8);
 
var cpu = new OTimer();
this.tooktime = -1;

this.KiesTroef = function (s, modus)
{var i, j, mx = 0, KRHSpnt = [0, 0, 0, 0],  retval;
 speler = s;
 for (i = 8*speler; i<8*speler+8;i++)
 {var c = SLMR[i];
  if (c.waarde == 11) {KRHSpnt[c.vkleur] += 20;}
  else if (c.waarde == 9) {KRHSpnt[c.vkleur] += 14;}
  else if (c.waarde == 14) {KRHSpnt[c.vkleur] += 5;}
  // Aas is ook mooie bijkaart
  else {KRHSpnt[c.vkleur] += 7;}
  KRHSpnt[c.vkleur] += b.TroefVolgordeInv(c.waarde-7)/28;
 }

 for (j=0;j<4;j++)
 {if (KRHSpnt[j] > mx)
  {mx = KRHSpnt[j];
   retval = j;
 }}

 if (modus == 'std')
 {return retval;}
 else if (modus == 'help')
 {
  return [retval, dbg.debug_msg_1(KRHSpnt)];
  return [retval, ''];
 }
 else
 {
   var df = 99; var jj;
   for (j=0;j<4;j++)
   {if (j != retval && (mx - KRHSpnt[j] < df))
    {df = mx - KRHSpnt[j];
      jj = j}
   }
  if (dbg.debug && dbg.verbose > 1) // && df < 7.5)
 {m_adm.scrn.OutputMSG1(0, dbg.debug_msg_2(mx, df, retval, jj));}
  if (df < 5) {return -1;}
  else {return retval;}
 }
}

this.SlimsteZet = function (filtertype)
{var i, max_found = -9999, i_found = -1, filter = new Array(8);

 if (filtertype == 1)
 {for (i=0; i<8; i++)
  {filter[i] = b.GetDezeKaartenMogen(i);
 }}
 else
 {for (i=0; i<8; i++)
  {filter[i] = !SLMR[i+8*speler].vgespeeld;
 }}

 for (i=0; i<8; i++)
 {if (filter[i] && ((i_found == -1) || (slimme_zet[i] > max_found)))
  {i_found = i;
   max_found = slimme_zet[i];
 }}

// for (i=0; i<8; i++)
// {if (filter[i] && i_found != i && slimme_zet[i] == max_found)
//  {m_adm.scrn.msg('maar '+i+' kan ook.');
// }}

 return i_found;
}

this.TroefTrekkenSlim = function ()
// versie 3.0: spieken vervangen door OSetAnalyse
{var i, zelf = 0, tot_gespeeld = 0;
 for (i=0;i<32;i++)
 {if (SLMR[i].vkleur == s_adm.g_troef && SLMR[i].vgespeeld) tot_gespeeld++;}

 for (i=8*speler;i<8*speler+8;i++)
 {if (SLMR[i].vkleur == s_adm.g_troef && ! SLMR[i].vgespeeld) zelf++;}

 if (zelf + tot_gespeeld == 8)
 {
  return false;
 }
 else if (zelf == 0)
 { // waarom roep je deze routine aan?
  return false;
 }
 else if (tot_gespeeld == 0)
 {
  return true;
 }
 else
 {
  var kk = new OSetAnalyse(m_adm, speler, env, "troef_tegen");
  var nr_tegen1 = (speler+1) % 4, tegen1 = 0, nr_tegen2 = (speler+3) % 4, tegen2 = 0;
  for (i=0; i<8; i++)
  {tegen1 += kk.perc(s_adm.g_troef, nr_tegen1, i);}
  for (i=0; i<8; i++)
  {tegen2 += kk.perc(s_adm.g_troef, nr_tegen2, i);}

  return (tegen1 + tegen2 > 0);
 }
}

this.KomSlimUit = function ()
{
 for (var i = 8*speler; i < 8*speler+8; i++)
 {
  var im8s = i-8*speler;
  var c = SLMR[i];
  if (c.vgespeeld) continue;
  if (c.vkleur == s_adm.g_troef)
  {if (c.waarde == 9 || c.waarde == 14)
   {slimme_zet[im8s] = (c.IsHoogsteDezeKleur())?90:-100;}
   else if (c.waarde <= 8 || c.waarde == 13) {slimme_zet[im8s] = 50;}
   else if (c.waarde == 10)
   {if (s_adm.slag_nr == 1)
    {slimme_zet[im8s] = 25;}
    else
    {slimme_zet[im8s] = (c.IsHoogsteDezeKleur())?90:-100;
   }}
   else if (c.waarde == 11)
   {slimme_zet[im8s] = 100;}
   else {slimme_zet[im8s] = 1;}

   if (!this.TroefTrekkenSlim ())
   {slimme_zet[im8s] -= 150;}
  }   
  else
  {if (c.waarde == 14)
   {slimme_zet[im8s] = 20 ;}
   else if (c.waarde == 10 || c.waarde == 12)
   {slimme_zet[im8s] = ((c.IsHoogsteDezeKleur())?15:5);}
   else
   {slimme_zet[im8s] = ((c.IsHoogsteDezeKleur())?12:8);}
}}}

this.KomUit = function (s, modus)
{
 speler = s;
 if (speler == 2 || niveau > 1)
 {this.KomSlimUit ();}
 else
 {for (var i=0; i<8; i++)
  {slimme_zet[i] = 0;
 }}
 var mxf = this.SlimsteZet(2);
 if (speler == 0 && modus == 'auto')
 {
  var smxf = slimme_zet[mxf];
  slimme_zet[mxf] = -999;
  var f2 = this.SlimsteZet(2);
  var smxf2 = slimme_zet[f2];
  if (dbg.debug && dbg.verbose > 0)
  {m_adm.scrn.OutputMSG1(0, dbg.debug_msg_3(mxf, f2, smxf, smxf2));}
  if (smxf - smxf2 > 9)
  {return mxf;}
  else
  {return -1;}
 }
 else
 {return mxf + 8 * speler;}
}

this.Kaart4 = function ()
{var i, winnaar, v_roem;
 for (i=8*speler;i<8*speler+8;i++)
 {
  var im8s = i-8*speler;
  var ci = SLMR[i];
  if (b.GetDezeKaartenMogen(im8s))
  {
   s_adm.VirtueleZet(speler, ci, null);
   winnaar = b.ZoekWinnaarSlag();
   v_roem = b.TelRoem();
   s_adm.WisVirtueleZet(speler, null);
   if (winnaar == speler)
   {if (ci.vkleur == s_adm.g_troef)
    {slimme_zet[im8s] = v_roem + 15;
    }else
    {slimme_zet[im8s] = v_roem + 20;
   }}
   else if ((winnaar % 2) == (speler % 2))
   {if (ci.vkleur == s_adm.g_troef)
    {slimme_zet[im8s] = v_roem + 25 - ci.punten();
    }else
    {if (ci.waarde == 10 && !ci.IsHoogsteDezeKleur())
     {slimme_zet[im8s] = v_roem + 31;}
     else
     {slimme_zet[im8s] = v_roem + 30 - ci.punten();
   }}}
   else
   {if (ci.vkleur == s_adm.g_troef)
    {slimme_zet[im8s] = -v_roem - 20 - ci.punten();
    }else
    {slimme_zet[im8s] = -v_roem - 20 - ci.punten();
}}}}}

this.Kaart23_niv4 = function (cnr)
{
 cpu.starttimer();
 var nrm = 1.0;
 var kk = new OSetAnalyse(m_adm, speler, env, "Kaart23");
 var sll = (speler + 1) % 4;
 var slm = (speler + 2) % 4;
 var sll_bekend = kk.kans_bekennen(sll, s_adm.kleur_deze_slag);
 var slm_bekend = kk.kans_bekennen(slm, s_adm.kleur_deze_slag);
 // TODO mag alleen overtroefen, dus ook binnen loop
 var sll_troef = kk.kans_bekennen(sll, s_adm.g_troef);
 var slm_troef = kk.kans_bekennen(slm, s_adm.g_troef);
 var sll_troeft_in = (1.0 - sll_bekend) * sll_troef;
 var slm_troeft_in = (cnr == 2 ? (1.0 - slm_bekend) * slm_troef : 0);
 if (s_adm.kleur_deze_slag == s_adm.g_troef) {sll_troeft_in = 0; slm_troeft_in = 0;}

 var p1 = new Array(8), p2 = new Array(8), p3 = new Array(8), p13 = new Array(8);
 var ksll = new Array(8), winnaar = new Array(8);
 var roem = new Array(8);
 var wk = new Array(8), szcp = new Array(8);
 for (var i=8*speler; i<8*speler+8; i++)
 {
  var im8s = i-8*speler;
  slimme_zet[im8s] = null; // debug
  if (b.GetDezeKaartenMogen(im8s))
  {
   var c = SLMR[i];
   s_adm.VirtueleZet(speler, c, kk);
   winnaar[im8s] = b.ZoekWinnaarSlag();
   if (cnr == 2)
   {
    var rtvlkk = kk.kans_hoger_dubbel(sll, s_adm.kleur_deze_slag, sll_bekend, slm_bekend, sll_troef, slm_troef);
    ksll[im8s] = rtvlkk[0];
    roem[im8s] = rtvlkk[1];
   }
   else
   {
    var rtvlkk = kk.kans_hoger(sll, s_adm.kleur_deze_slag, sll_bekend, sll_troef);
    ksll[im8s] = rtvlkk[0];
    roem[im8s] = rtvlkk[1];
   }
   s_adm.WisVirtueleZet(speler, kk);
   if ((c.vkleur != s_adm.kleur_deze_slag) && (c.punten() >= 10))
   {
    p1[im8s] = -100;
    p3[im8s] = -100;
   }
   else if (c.vkleur != s_adm.kleur_deze_slag)
   {
    p1[im8s] = -50 - c.hoogte();
    p3[im8s] = -50 - c.hoogte();
   }
   else
   {if (c.vkleur == s_adm.g_troef)
    {
     p1[im8s] = 25 - c.punten();
     p3[im8s] = 25 - c.punten();
    }
    else
    {if (c.waarde == 10)
     {
      p1[im8s] = 35 + (c.IsHoogsteDezeKleur() ? 25 : 0);
      p3[im8s] = 26;
     }
     else
     {
      p1[im8s] = 50 + c.hoogte();
      p3[im8s] = 50;
     }
    }
   }
   p2[im8s] = - 20 - c.punten();
   p13[im8s] = (winnaar[im8s] == speler ? p1[im8s] : p3[im8s]);

   wk[im8s] = 1.0 - ksll[im8s];
   
   slimme_zet[im8s] = p13[im8s] * wk[im8s] + p2[im8s]*(nrm-wk[im8s]) - roem[im8s];

 }}
 cpu.stoptimer();
 var timetaken = cpu.tooktime;
 if (speler == 0 && dbg.debug && dbg.verbose > 0)
 {var mxf = this.SlimsteZet(1); var nm = SLMR[mxf+8*speler].naam; // debug
  window.alert(dbg.debug_msg_4(mxf, kk.out(), p1, p2, p3, p13, ksll, roem, winnaar, wk, slimme_zet, nm,
   sll_bekend, slm_bekend, sll_troef, slm_troef, cnr, b, s_adm, slm_troeft_in, sll_troeft_in, timetaken));} // debug
}

this.Kaart23 = function ()
// note: speelt niet zo best; maar is veel sneller dan Kaart23_niv4
{var i, winnaar;
 for (i = 8*speler; i < 8*speler+8; i++)
 {
  var im8s = i-8*speler;
  if (b.GetDezeKaartenMogen(im8s))
  {s_adm.KaartOpTafel[speler] = SLMR[i];
   s_adm.LigtOpTafel[speler] = true;
   winnaar = b.ZoekWinnaarSlag();
   s_adm.LigtOpTafel[speler] = false;
   var c = SLMR[i];
   if ((c.vkleur != s_adm.kleur_deze_slag) && (c.punten() >= 10))
   {slimme_zet[im8s] = -100;}
   else if ((winnaar % 2) == (speler % 2))
   {if (c.vkleur == s_adm.g_troef)
    {slimme_zet[im8s] = 25- c.punten();
    }
    else
    {if (c.waarde == 10)
     {if (c.IsHoogsteDezeKleur())
      {slimme_zet[im8s] = 60;
      }
      else
      {slimme_zet[im8s] = 26;}
     }
     else
     {slimme_zet[im8s] = 50;}
    }
   }
   else
   {slimme_zet[im8s] = - 20 - c.punten();
}}}}

this.SpeelKaart = function (s)
{speler = s;
 cpu.starttimer();
 var retval;

 var i, gevonden = b.WelkeKaartenMogen(speler);
 if (gevonden[0] == 1)
 {retval = gevonden[1];
 }
 else  // meerdere mogelijk
 {if (speler % 2 == 1 && niveau < 3)
  {for (i=0; i<8; i++)
   {slimme_zet[i] = 0; // random uitkomen!
  }}
  else
  {var cnr = (4 + speler - s_adm.start_speler) % 4;
   if (cnr == 3)
   {this.Kaart4();}
   else if (niveau > 3 || speler % 2 == 0)
   {this.Kaart23_niv4(1 + cnr)
   }
   else
   {this.Kaart23();
  }}
  retval = 8*speler + this.SlimsteZet(1);
 }
 cpu.stoptimer();
 this.tooktime = cpu.tooktime;
 return retval;
}

this.reset = function (level)
{
 niveau = level;
 for (var i=0; i<8; i++) {slimme_zet[i] = 0;}
}

// vooralsnog lege constructor
}

