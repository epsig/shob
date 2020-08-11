function OMatchAdmin(envir) {
// constructor voor klasse OMatchAdmin

// de administratie voor het complete spel (n potjes).

this.AmsRot          = envir.AmsRot();
this.troef_offset    = -1;
this.spel_nr         = -1;
this.status          = -1;
// -99: uitgespeeld
// -2 : in timeout
// -1 : not ready
//  0 : na laden images
//  1 : wacht op kaart speler
//  2 : wacht op troef kleur
//  3 : wacht op verandering troef kleur of kaart speler
this.ID_timeout;
this.stopna          = envir.stopna();
this.autom           = envir.autom();
this.vorig_overzicht = "",

this.scrn            = new OScreenAdmin(envir, this);
this.br              = new OBasicRules(envir.AmsRot);
this.score           = new OScore(envir.round(), this);

this.setadm          = new OSetAdmin(this);
this.strat           = new OStrategy(this, env.niveau());
this.help            = new OHelp(this);

var winnaar = -1;
var std_timeout = 2000 / envir.tempo();

this.br.Connect (this.setadm);

this.reset = function ()
{
 if (this.spel_nr == -1) {this.troef_offset  = Math.floor (4*Math.random());}
// reset en incrementeer tellers:
 this.score.reset();
 this.SetTroef(-1);
 this.spel_nr++;
 this.setadm.reset((this.spel_nr+this.troef_offset)%4);
 this.scrn.UpdateTroefKleur();
 this.scrn.UpdateIndeHand();
}

this.KiesTroef = function (i)
{if (this.status > 1)
 {this.status = -1;
  this.scrn.InitMSGLijst();
  this.SetTroef(i);
  this.status = 3;

  this.SubAutoKomUit();
}}

this.FKiesTroef = function ()
{
 this.SetTroef(this.strat.KiesTroef(this.setadm.troef_kiezer, 'std'));
}

this.SetTroef = function (k)
{
 this.setadm.SetTroef(k);
 this.scrn.UpdateTroefKleur();
}

this.Hand2Tafel = function (speler, kaartnr)
{
 this.setadm.Hand2Tafel(speler, kaartnr);
 this.scrn.UpdateIndeHand();
 this.scrn.UpdateTroefKleur();
}

this.NieuwSpel = function ()
{
 if (this.status < 0) return;
 this.scrn.reset();
 this.spel_nr = -1;
 this.troef_offset = Math.floor (4*Math.random());
 this.reset();
 this.scrn.msg("Speel volgens de zgn. "+AmsRotStr(this.AmsRot)+"se regels!");

// speel totdat Speler 0 aan de beurt is.

 if (this.setadm.start_speler == 0)
 {
  if (this.SubAutoKiesTroef() < 0) {return;}
  this.SubAutoKomUit();
  this.scrn.UpdateIndeHand();
 }
 else
 {
  this.FKiesTroef();
  window.setTimeout("ComputerWeerAanZet(0);", std_timeout );
 }
}

this.einde_slag = function ()
{
 var t =
 ["Jij wint slag!",
  "Links wint slag.",
  "Je maat wint slag!",
  "Rechts wint slag."];

 // zoek winnaar slag, en update score
 winnaar = this.br.ZoekWinnaarSlag();
 var v_roem = this.br.TelRoem ();
 this.score.add_score(winnaar, this.br.BerekenScore(), v_roem, this.setadm.slag_nr);
 this.scrn.UpdateIndeHand();

 this.scrn.OutputMSG1(0, (v_roem > 0 ? 'Roem = ' + v_roem + '; ' : "") + t[winnaar]);

 return winnaar;
}

this.volgende_slag = function ()
{
 this.setadm.volgende_slag(winnaar);
 this.scrn.UpdateTroefKleur();
}

this.einde_potje = function ()
{
 this.scrn.msg(this.score.WinnerIs());
 this.scrn.Update_Score_Lijst();
 this.help.geschiedenis(2);
 if (this.spel_nr+1 == this.stopna) {this.status = -99; return true;}
 this.reset();
 return false;
}

this.NietVerzaakt = function (kaartn)
{if (this.setadm.start_speler == 0) return true;
 this.br.WelkeKaartenMogen(0);
 if (! this.br.GetDezeKaartenMogen(kaartn))
 {
  this.scrn.msg('Ho, ho ! niet vals spelen');
  return false;
 }
 else
 {
  return true;
 }
}

this.SpeelKaart = function (speler)
{
 this.Hand2Tafel(speler, this.strat.SpeelKaart(speler));
}

this.SpeelDeze = function (kaartn)
{
 if (kaartn > 7) {this.scrn.msg('vreemde kaart opgegooid.');}
 if (this.status == -2)
 {
  clearTimeout(this.ID_timeout);
  ComputerAanZet_vervolg();
  if (this.setadm.slag_nr == 1) return;
 }

 if ((this.status == 1 || this.status == 3) && ! this.setadm.c.SLMR[kaartn].vgespeeld)
 {
  this.status = -1;
  this.scrn.InitMSGLijst();
  if (this.NietVerzaakt (kaartn))
  {
   this.Hand2Tafel(0, kaartn);
   window.setTimeout("ComputerAanZet(1);", std_timeout );
  }
  else
  {
   this.status = 1;
 }}
 else if (this.status == 2)
 {
  this.help.HelpFunctie(1);
}}

this.SubAutoKiesTroef = function ()
{
 var t = -1;
 
 if (this.autom)
 {
  t = this.strat.KiesTroef(0, 'auto');
 }
 
 if (t < 0)
 {
  this.status = 2;
 }
 else
 {
  this.SetTroef(t);
  this.status = 3;
 }
 return t;
}

this.SubAutoKomUit = function ()
{
 if (this.autom)
 {
  var t = this.strat.KomUit(0, 'auto');
  if (t >= 0)
  {
   this.status = 1;
   this.SpeelDeze(t);
  }
 }
}

this.ComputerAanZet = function (s)
{
 var maxn  = [3, -1, 1, 2];

 // maak slag af.
 if (this.setadm.start_speler != 1)
 {
  this.SpeelKaart(s);
  var n = s+1;
  if (n <= maxn[this.setadm.start_speler])
  {
   var timeout = Math.max(1, std_timeout - this.strat.tooktime );
   window.setTimeout("ComputerAanZet("+n+");", timeout );
   return;
  }
 }

 // zoek winnaar slag, en update score
 winnaar = this.einde_slag();

 this.ID_timeout = window.setTimeout ("ComputerAanZet_vervolg();", std_timeout );
 this.status = -2;
}

this.ComputerAanZet_vervolg = function ()
{this.status = -1;
 if (this.setadm.slag_nr == 8)
 {
  if (this.einde_potje()) {return;}
  this.scrn.InitMSGLijst ();
  if (this.setadm.troef_kiezer > 0)
  {this.FKiesTroef();
  }
  else if (this.SubAutoKiesTroef() < 0) {return;}
 }
 else
 // volgende slag
 {
  this.scrn.InitMSGLijst ();
  this.volgende_slag();
 }
 window.setTimeout("ComputerWeerAanZet(0);", std_timeout );
}

this.ComputerWeerAanZet = function (x)
{
 var s = this.setadm.start_speler;
 var timeout = std_timeout;
 if (s > 0)
 {
  var n;
  if (x == 0)
  {
   this.Hand2Tafel(s, this.strat.KomUit(s, 'std'));
   n = s+1;
  }
  else
  {
   this.SpeelKaart(x);
   timeout = Math.max(1, std_timeout - this.strat.tooktime );
   // window.alert('times = ' + timeout + ' = ' + std_timeout + ' - ' + this.strat.tooktime );
   n = x+1;
  }
  if (n <= 3) {window.setTimeout("ComputerWeerAanZet("+n+");", timeout ); return;}
 }
 this.scrn.UpdateIndeHand();

 // wacht nu op zet speler

 this.status = 1;
 if (this.autom)
 {
  if (this.setadm.slag_nr == 8)
  {
   for (var i=0; i<8; i++)
   {if (!this.setadm.c.SLMR[i].vgespeeld)
    {
     window.setTimeout("SpeelDeze("+i+");", std_timeout);
     break;
  }}}
  else if (this.setadm.start_speler > 0)
  {
   var t = this.br.WelkeKaartenMogen(0);
   if (t[0] == 1)
   {
    window.setTimeout("SpeelDeze("+t[1]+");", std_timeout);
   }
  }
  else
  {
   this.SubAutoKomUit()
 }}
}

} // end constructor OMatchAdmin
