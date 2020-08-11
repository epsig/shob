function OKaart(lwaarde, lkleur, c, adm) {
// constructor voor klasse OKaart.

var SLMR = c.SLMR;
var m_adm = adm;

var istroef;

this.IsHoogsteDezeKleur = function ()
{var cmp_hoogte = this.hoogte();
 if (dbg.debug && SLMR == null) {m_adm.scrn.msg('error in OKaart/IsHoogsteDezeKleur.'); return;}
 for (var i=0; i<32; i++)
 {
  var cmp = SLMR[i];
  if (!cmp.vgespeeld && cmp.vkleur==this.vkleur && cmp.hoogte() > cmp_hoogte)
  {return false;}
 }
 return true;
}

this.hoogte = function ()
{return (istroef) ? m_adm.br.TroefVolgordeInv(this.waarde-7) : m_adm.br.VolgordeRestInv(this.waarde-7);}

this.punten = function ()
{return (istroef) ? m_adm.br.TroefPunten(this.waarde-7) : m_adm.br.PuntenRest(this.waarde-7);}

this.Hand2Tafel = function (slag_nr, speler, start_speler)
{
 this.vgespeeld = true;
 this.slag      = slag_nr;
 this.SlagIndex = (4+speler - start_speler)%4;
}

this.reset = function ()
// tevens impliciete declaratie.
{
 this.vgespeeld = false;
 this.slag      = -1;
 this.SlagIndex = -1;
}

this.settroef = function (k)
{
 istroef = (this.vkleur == k);
}

this.init = function ()
{
 this.waarde = lwaarde;
 this.vkleur = lkleur;
 this.kkindex = 8 * lkleur + lwaarde - 7;
 this.naam = KRHS[lkleur] + m_adm.br.nm(lwaarde-7);
 if (m_adm.scrn.gfx)
 {
  this.gifje = new Image(50,50);
  this.gifje.onLoad = "LoadFinished(1);";
  this.gifje.src = "include/" + this.naam  + ".gif";
 }
 this.reset();
}

this.init();

} // end constructor OKaart

