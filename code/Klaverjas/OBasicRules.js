function OBasicRules(ar) {
// constructor for OBasicRules

var CTroefVolgordeInv = [0, 1, 6, 4, 7, 2, 3, 5];
var CVolgordeRestInv  = [0, 1, 2, 6, 3, 4, 5, 7];

var CTroefPunten      = [0, 0, 14, 10, 20, 3, 4, 11];
var CPuntenRest       = [0, 0,  0, 10,  2, 3, 4, 11];

var Cnm               = ["-7", "-8", "-9", "10", "-B", "-V", "-H", "-A"];

var amsrot = ar;
var setadm = null;
var SLMR   = null;
var KaartOpTafel  = null;
var LigtOpTafel  = null;

var DezeKaartenMogen = new Array(8);

this.GetDezeKaartenMogen = function (i) {return DezeKaartenMogen[i];}
this.TroefVolgordeInv    = function (i) {return CTroefVolgordeInv[i];}
this.VolgordeRestInv     = function (i) {return CVolgordeRestInv[i];}
this.TroefPunten         = function (i) {return CTroefPunten[i];}
this.PuntenRest          = function (i) {return CPuntenRest[i];}
this.nm                  = function (i) {return Cnm[i];}

var hogetroef;
var speler;

this.HoogsteDezeKleurOpTafel = function (cmp_kleur)
{var mx = -1, j_found, j;
 for (j=0;j<4;j++)
 {if (LigtOpTafel[j])
  {
   var cmp = KaartOpTafel[j];
   if (cmp.vkleur == cmp_kleur && cmp.hoogte () > mx)
   {mx = cmp.hoogte ();
    j_found = j;
 }}}
 return (mx != -1 ? j_found : -1);
}

this.ZoekWinnaarSlag = function ()
// tevens te gebruiken om halverwege checks uit te voeren.
// wie heeft een hoge troef opgegooid ?
{
 var j_found = this.HoogsteDezeKleurOpTafel(setadm.g_troef);
 return (j_found != -1) ? j_found : this.HoogsteDezeKleurOpTafel(setadm.kleur_deze_slag);
}


// 1 bij troef trekken
// 2 bij niet troef ; Amsterdams ; maat heeft hoogste kaart
// 3 bij niet troef ; Amsterdams ; L/R heeft hoogste kaart
// 4 bij niet troef ; Rotterdams
// 3 en 4 hebben dezelfde regels
// 1 - overtroefen
//   - ondertroefen
//   - niet troef
// 2 - bekennen
//   - overtroefen of noch troefen noch bekennen
//   - ondertroefen
// 34- bekennen
//   - overtroefen
//   - noch troefen noch bekennen
//   - ondertroefen

this.OverTroefen = function ()
{var i, found = 0, kaartnr=0;
 for (i=8*speler;i<8*speler+8;i++)
 {
  var cmp = SLMR[i];
  if (cmp.vkleur == setadm.g_troef && !cmp.vgespeeld && cmp.hoogte() > hogetroef)
  {found++;
   DezeKaartenMogen[i-8*speler] = true;
   kaartnr = i;
 }}
 return [found, kaartnr];
}

this.Bekennen = function ()
{var i, found = 0, kaartnr=0;
 for (i=8*speler;i<8*speler+8;i++)
 {
  var cmp = SLMR[i];
  if (cmp.vkleur == setadm.kleur_deze_slag && !cmp.vgespeeld)
  {found++;
   DezeKaartenMogen[i-8*speler] = true;
   kaartnr = i;
 }}
 return [found, kaartnr];
}

this.NochTroefNochBekennen = function ()
{var i, found = 0, kaartnr=0;
 for (i=8*speler;i<8*speler+8;i++)
 {
  var cmp = SLMR[i];
  if (cmp.vkleur != setadm.kleur_deze_slag && cmp.vkleur != setadm.g_troef && !cmp.vgespeeld)
  {found++ ;
   DezeKaartenMogen[i-8*speler] = true;
   kaartnr = i;
 }}
 return [found, kaartnr];
}

this.OnderTroefen = function ()
{var i, found = 0, kaartnr=0;
 for (i=8*speler;i<8*speler+8;i++)
 {
  var cmp = SLMR[i];
  if (cmp.vkleur==setadm.g_troef && !cmp.vgespeeld && cmp.hoogte() < hogetroef)
  {found++ ;
   DezeKaartenMogen[i-8*speler] = true;
   kaartnr = i;
 }}
 return [found, kaartnr];
}

this.RestMarkeren = function ()
{var i, found = 0, kaartnr=0;
 for (i=8*speler;i<8*speler+8;i++)
 {if (! SLMR[i].vgespeeld)
  {found++ ;
   DezeKaartenMogen[i-8*speler] = true;
   kaartnr = i;
 }}
 return [found, kaartnr];
}

this.WelkeKaartType1 = function ()
{var found = this.OverTroefen();
 if (found[0] != 0) return found ;
 found = this.OnderTroefen();
 if (found[0] != 0) return found ;
 return this.RestMarkeren();
}

this.WelkeKaartType2 = function ()
{var found = this.Bekennen();
 if (found[0] != 0) return found ;
 var found1 = this.OverTroefen(), found2 = this.NochTroefNochBekennen();
 found = found1[0]+found2[0];
 if (found==0) return this.OnderTroefen();
 return [found,found==1?found1[1]+found2[1]:0];
}

this.WelkeKaartType34 = function ()
{var found = this.Bekennen();
 if (found[0] != 0) return found ;
 found = this.OverTroefen();
 if (found[0] != 0) return found ;
 found = this.NochTroefNochBekennen();
 if (found[0] != 0) return found ;
 return this.OnderTroefen();
}

this.WelkeKaartenMogen = function (s)
{
 speler = s;

 // Analyseer inmiddels opgegooide kaarten
 var i, typeslag, vhoogste = this.ZoekWinnaarSlag();
 // geval 1, 2, 3 of 4 ?
 if (setadm.g_troef == setadm.kleur_deze_slag)
 {typeslag = 1;}
 else
 {if (amsrot)
  {typeslag = (vhoogste == speler + 2 || vhoogste == speler - 2) ? 2 : 3;}
  else
  {typeslag = 4;}
 }

 for (i=0; i<8; i++) {DezeKaartenMogen[i] = false;}

 var coth = KaartOpTafel[vhoogste];
 hogetroef = (coth.vkleur==setadm.g_troef ? coth.hoogte() : -1);

 if (typeslag == 1)
 {return this.WelkeKaartType1();}
 else if (typeslag == 2)
 {return this.WelkeKaartType2();}
 else
 {return this.WelkeKaartType34();}
}

this.TelRoem = function ()
{var i, j, volgende1, volgende2, volgende3, vorige1;

 // check op 200 roem
 var roem200 = true;
 for (i=0;i<4;i++)
 {if (KaartOpTafel[i].waarde != 11) roem200 = false;}
 if (roem200) return 200;

 // check op 100 roem
 var roem100 = true;
 for (i=1;i<4;i++)
 {if (KaartOpTafel[i].waarde != KaartOpTafel[0].waarde)
   roem100 = false;}
 if (roem100) return 100;

 // zoek nu Stuk
 var found_troef_vrouw = false, found_troef_heer = false;
 for (j=0;j<4;j++)
 {
  var cot = KaartOpTafel[j];
  if (cot.vkleur == setadm.g_troef)
  {if (cot.waarde == 12) {found_troef_vrouw = true};
   if (cot.waarde == 13) {found_troef_heer = true};
 }}
 stuk = (found_troef_vrouw && found_troef_heer) ? 20 : 0;

 // "gewone" roem
 for (j=0;j<4;j++)
  // is er een volgende kaart van de zelfde kleur
  // vorige is een check op dubbeltellingen
 {volgende1 = false; vorige1 = false;
  for (i=0;i<4;i++)
  {if (KaartOpTafel[i].vkleur == KaartOpTafel[j].vkleur)
   {if (KaartOpTafel[i].waarde == KaartOpTafel[j].waarde+1)
     volgende1 = true;
    if (KaartOpTafel[i].waarde == KaartOpTafel[j].waarde-1)
     vorige1 = true;}}
  if (vorige1 || !volgende1) continue;
  volgende2 = false ; // zoek daarop volgende
  for (i=0;i<4;i++)
  {if (KaartOpTafel[i].vkleur == KaartOpTafel[j].vkleur)
   {if (KaartOpTafel[i].waarde == KaartOpTafel[j].waarde+2)
     volgende2 = true;}}
  if (!volgende2) continue;
  // 20 roem gevonden. Misschien 50 roem ?
  volgende3 = false ; // zoek daarop volgende
  for (i=0;i<4;i++)
  {if (KaartOpTafel[i].vkleur == KaartOpTafel[j].vkleur)
   {if (KaartOpTafel[i].waarde == KaartOpTafel[j].waarde+3)
    volgende3 = true;
  }}
  return ((volgende3 ? 50 : 20) + stuk);}
 return stuk;
}

this.BerekenScore = function ()
{
 var pnt = 0;
 for (var j=0; j<4; j++)
 {
  pnt += KaartOpTafel[j].punten();
 }
 
 return pnt;
}

this.Connect = function (set_adm)
{
 setadm = set_adm;
 SLMR   = set_adm.c.SLMR;
 KaartOpTafel  = set_adm.KaartOpTafel;
 LigtOpTafel  = set_adm.LigtOpTafel;
}

} // end constructor OBasicRules
