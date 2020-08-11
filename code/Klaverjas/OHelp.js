function OHelp(adm) {
// constructor voor klasse OHelp
//
// Interface:
//  constructor: trivial
//
//  HelpFunctie = function (optie)
//  geschiedenis = function (b)
//
// sub-functions (may change suddenly):
//  Help1(), Help2(), Help3()

// sub-data (may change suddenly):
var m_adm = adm; // local copy of pointer to OAdmin
var tekst1, tekst2;

this.Help1 = function ()
{if (m_adm.setadm.slag_nr == 8)
 {tekst1 = "Je moet je laatste kaart opleggen.";
  tekst2 = "";
  return;
 }
 tekst1 = 'Je moet een kaart opleggen: ';
 var hoeveel_mogen = m_adm.br.WelkeKaartenMogen(0);
 if (hoeveel_mogen[0] == 1)
 {tekst2 = "Je moet " + m_adm.setadm.c.SLMR[hoeveel_mogen[1]].naam + " opleggen.";}
 else if (hoeveel_mogen[0] == (9-m_adm.setadm.slag_nr))
 {tekst1='Je moet een (willekeurige) kaart opleggen.';
   // tekst2 = "";
   var tip = m_adm.strat.SpeelKaart(0);
   tekst2 = 'Tip: '+ m_adm.setadm.c.SLMR[tip].naam;
 } else
 {tekst2 = 'Je mag kiezen uit: ';
   for (var i=0; i<8; i++)
   {if (m_adm.br.GetDezeKaartenMogen(i))
    {tekst2 += m_adm.setadm.c.SLMR[i].naam + ";";
   }}
   var tip = m_adm.strat.SpeelKaart(0);
   tekst2 += ' Tip: '+ m_adm.setadm.c.SLMR[tip].naam;
 }}

this.Help2 = function ()
{var found = false;
 tekst1 = "Je moet uitkomen.";
 tekst2 = 'Hoogste van een kleur: ';
 for (var i=0; i<8; i++)
 {var c = m_adm.setadm.c.SLMR[i];
  if (!c.vgespeeld && c.IsHoogsteDezeKleur())
  {tekst2 += c.naam + ";";
   found = true;
 }}
 if (!found)
 {var tip =  m_adm.strat.KomUit(0, 'help');
  tekst2 = 'tip: ' + m_adm.setadm.c.SLMR[tip].naam;
 }
}

this.Help3 = function ()
{tekst1 = "Je moet troef kiezen.";
 var t = m_adm.strat.KiesTroef(0, 'help');
 tekst2 = 'Kies bijvoorbeeld: ' +KRHSlong[t[0]];
 if (dbg.debug && dbg.verbose > 1) {tekst2 += t[1];}
}

this.HelpFunctie = function (optie)
{
 var status = m_adm.status,
 a="Dit klavarjasspel is geschreven door Edwin Spee.",
 b='Opmerkingen ontvang ik graag per E-mail: info@epsig.nl';
 c='Versie: ' + versie + ' d.d. ' + dd;
 m_adm.status = -1;
 if (status == -2)
 {clearTimeout(m_adm.ID_timeout);}
 else if (status == -1)
 {return;}

 if (optie == 1)
 {if (status == 1 || status == 3)
  {if (m_adm.setadm.start_speler > 0){this.Help1();}
   else{this.Help2();}
  }else if (status == 2)
  {this.Help3();
  }else
  { // "algemene help functie";
   tekst1 = a;
   tekst2 = b + "\n" + c;
  }

  if (m_adm.scrn.groot_scherm && status != -2)
  {
   m_adm.scrn.OutputMSG1 (0, tekst1);
   m_adm.scrn.OutputMSG1 (1, tekst2);
  }
  else
  {
   m_adm.scrn.msg(tekst1 + "\n" + tekst2);
 }}
 else if (optie == 2)
 {m_adm.scrn.msg(a+"\n"+b+"\n"+c);}
 else if (optie == 3)
 {m_adm.scrn.msg("Je twee tegenstanders spelen op drie niveau's." +
"\nOp niveau 1 wordt netjes volgens de regels gespeeld." +
"\nOp niveau 2 wordt bij uitkomen een beetje nagedacht." +
"\nOp niveau 3 wordt ook bij het bijleggen een beetje nagedacht.");}
 else if (optie == 4)
 {this.geschiedenis(1);}

 if (status == -2)
 {ComputerAanZet_vervolg();
 } else
 {m_adm.status = status;}
}

this.geschiedenis = function (b)
// b == 1: uit help3 (knop i)
// b == 2: uit ComputerAanZet_vervolg om cookie aan te maken
{var found, found2 = false, OutSlagStr;
 var logstr = (b == 1
 ? "Overzicht slagen dit spel:"
 : 'Vorig potje: (troef = ' + KRHSlong[m_adm.setadm.g_troef] + ")");
 var outstr = logstr + "\n";
 for (var i = 1; i <= 8; i++)
 {found = false;
  OutSlagStr = "";
  for (var j=0; j<4; j++)
  {for (var k=0; k<32; k++)
   {var c = m_adm.setadm.c.SLMR[k];
    if (c.vgespeeld && c.slag == i && c.SlagIndex == j)
    {found = true;
     found2 = true;
     OutSlagStr += naam_short[Math.floor(k/8)] + ":" + c.naam + ";";
     break;
  }}}
  if (found)
  {outstr += "Slag " + i + ': ' + OutSlagStr + ((m_adm.scrn.groot_scherm || i%2==0) ? "\n":" ");
   logstr += "Slag_" + i + ":" + OutSlagStr + " ";
  } else {break;}}
 if (b == 2)
 {m_adm.vorig_overzicht = outstr + "\n";
  setCookie("kj_log", logstr);
  return;}
 if (!found2)
 {outstr += "nog geen kaarten gespeeld.\n";}
 else
 {if (!m_adm.scrn.groot_scherm)
  {outstr += m_adm.score.tussenstand();
 }}
 if (dbg.debug) {dbg.geschiedenis(outstr); return;}
 if (m_adm.scrn.groot_scherm) {outstr = m_adm.vorig_overzicht + outstr;}
 m_adm.scrn.msg(outstr);
}

} // end constructor OHelp
