function OScore(setting_rondaf, adm)
// constructor voor klasse OScore.
//
// interface:
//  init: koppeling aan setting_rondaf en adm
//  reset: zet tussenstand aan begin potje weer op 0.
//  WinnerIs: tekst aan einde potje
//  add_score: punten van slag aan tussenstand toevoegen
//  tussenstand: tekst aan einde slag
//
// note: bijna alle properties zijn van buiten direct te lezen en te schrijven.
{
 var pit_C;
 var afronden = setting_rondaf;
 var m_adm    = adm;
 
 this.add_score = function(w, pnt, roem, slag)
 {
  if (slag == 8) {pnt += 10;}

  if (w == 0 || w == 2)
  {
   pit_C++;
   this.scoreU += pnt;
   this.roemU += roem;
  }
  else
  {
   this.scoreC += pnt;
   this.roemC += roem;
  }
 }

 this.WinnerIs = function()
 // TODO: tekst en berekeningen uit elkaar halen.
 {
  var i, tkst,
  tkst_roemU = (this.roemU>0)?' + '+this.roemU+" roem":"",
  tkst_roemC = (this.roemC>0)?' + '+this.roemC+" roem":"";
  var tkst_pnt = 'jij+maat: ' + this.scoreU + " pnt" + tkst_roemU + ";\n" +
   'links+rechts: ' + this.scoreC + " pnt" + tkst_roemC + ".\n";
  var pit26 = (afronden ? 26 : 262);
  var tot16 = (afronden ? 16 : 162);
  if (m_adm.setadm.troef_kiezer == 0 || m_adm.setadm.troef_kiezer == 2)
  {
   if (pit_C == 8)
   {
    this.scoreU = pit26;
    tkst='Een mooie pit !';
   }
   else
   {
    if (this.scoreU + this.roemU <= this.scoreC + this.roemC)
    {
     this.scoreC = tot16; this.roemC += this.roemU ; this.roemU = 0; this.scoreU = 0;
     tkst = "Je bent nat gegaan.";
    }
    else
    {
     tkst = "Je hebt gewonnen:";
     if (afronden) {this.scoreC = Math.floor ((this.scoreC + 4) / 10);}
     this.scoreU = tot16 - this.scoreC;
   }}
  }
  else
  {
   if (pit_C == 0)
   {
    this.scoreC = pit26;
    tkst='Een pit, goed he ?';
   }
   else
   {
    if (this.scoreC + this.roemC <= this.scoreU + this.roemU)
    {
     this.scoreU = tot16; this.roemU += this.roemC ; this.roemC = 0; this.scoreC = 0;
     tkst='Je hebt me nat gespeeld !!!';
    }
    else
    {
     // nieuwe tekst n.a.v. email Andrew Plevier d.d. 10 okt 2008:
     tkst = "De computer wint.";
     if (afronden) {this.scoreU = Math.floor ((this.scoreU + 4) / 10);}
     this.scoreC = tot16 - this.scoreU;
  }}}
  this.totaalC += this.scoreC + (afronden ? this.roemC / 10 : this.roemC);
  this.totaalU += this.scoreU + (afronden ? this.roemU / 10 : this.roemU);

  var potjes = m_adm.spel_nr + 1;
  var PotjeStr = potjes + " potje" + (potjes > 1 ? "s" : "");
  var StandNa = (m_adm.spel_nr+1 == m_adm.stopna ? "E I N D S T A N D" : "stand na " +  PotjeStr);
  return (tkst + "\n" + tkst_pnt + StandNa +
': '
+ this.totaalU + " om " + this.totaalC);
 }

 this.reset = function()
 // tevens impliciete declaratie.
 {
  this.scoreC = 0;
  this.roemC  = 0;
  this.scoreU = 0;
  this.roemU  = 0;
  pit_C       = 0;
 }

 this.tussenstand = function()
 {
  var outstr = '\n\ntussenstand: ' + this.scoreU + "-" + this.scoreC + "\n";
  if (this.roemU + this.roemC)
  {
   outstr += "roem: " + this.roemU + "-" + this.roemC + "\n";
  }
  return outstr;
 }

 this.totaalU = 0;
 this.totaalC = 0;
 this.reset();
}

