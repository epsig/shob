function OSetAdmin (adm) {
// constructor voor klasse OSetAdmin

// de administratie voor een (1) set (potje/8 slagen).
// Bevat o.a. SLMR, KaartOpTafel, LigtOpTafel
// slag_nr, g_troef, kleur_deze_slag, start_speler en troef_kiezer.

this.slag_nr         = -1;
this.g_troef         = -1;
this.kleur_deze_slag = -1;
this.start_speler    = -1;
this.troef_kiezer    = -1;
this.c               = new OStack(adm);
this.KaartOpTafel    = new Array(4);
this.LigtOpTafel     = new Array(4);

this.reset = function (t)
{
 this.c.reset();
 for (var i=0; i<4; i++) {this.LigtOpTafel[i]=false;}
 this.slag_nr = 1;
 this.kleur_deze_slag = -1;
 this.troef_kiezer = t;
 this.start_speler = this.troef_kiezer;
}

this.SetTroef = function (k)
{
 this.g_troef = k;
 for (var i=0; i<32; i++)
 {this.c.SLMR[i].settroef(k);
 }
}

this.Hand2Tafel = function (speler, kaartnr)
{
 var cnr = this.c.SLMR[kaartnr];
 this.KaartOpTafel[speler] = cnr;
 this.LigtOpTafel[speler] = true;
 cnr.Hand2Tafel(this.slag_nr, speler, this.start_speler);

 if (this.start_speler == speler)
 {this.kleur_deze_slag = cnr.vkleur;}
}

this.VirtueleZet = function (s, c, kk)
{
 this.KaartOpTafel[s] = c;
 this.LigtOpTafel[s] = true;
 if (kk) {kk.VirtueleZet(s, c);}
}

this.WisVirtueleZet = function (s, kk)
{
 this.KaartOpTafel[s] = null;
 this.LigtOpTafel[s] = false;
 if (kk) {kk.WisVirtueleZet(s);}
}

this.volgende_slag = function (winnaar)
{
 this.slag_nr++;
 this.start_speler = winnaar;
 for (var i=0; i<4; i++)
 {this.LigtOpTafel[i] = false;}
 this.kleur_deze_slag = -1;
}

} // end constructor OSetAdmin
