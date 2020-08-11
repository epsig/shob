function OSetAnalyse(adm, speler, env, from) {
// constructor voor klasse OSetAnalyse
//
// probeer te achterhalen wat de andere spelers in hun handen hebben.

var niveau  = env.niveau();
var m_adm   = adm;
var troef   = m_adm.setadm.g_troef;
var SLMR    = adm.setadm.c.SLMR;

var max_iter = niveau;
var logtol = 1-niveau;
var tol = Math.pow(10, logtol);
var nrm = 1.0;

var kk = new Array(4*32);
// TODO: virtual en cnt_virtual worden helemaal niet gebruikt!
var virtual = [null, null, null, null];
var cnt_virtual = 0;

var total = [0, 0, 0, 0];
var zeker = [0, 0, 0, 0];
var mogelijk1 = [0, 0, 0, 0];
var mogelijk2 = [0, 0, 0, 0];
var kleur_slag = new Array(9);

var debug_str;
var debug_speler = speler;

this.consistent_maken = function ()
{
 var i, j;
// vergelijking met aantal kaarten in de hand en welke zeker (iteratief?)
 for (j=0; j<32; j++)
 {var cnt = 0;
  for (i=0; i<4; i++)
  {if (i != speler && kk[j+32*i])
   {cnt += 1;
  }}
  if (cnt)
  {for (i=0; i<4; i++)
   {var perc = nrm / cnt;
    if (i != speler && kk[j+32*i])
    {kk[j+32*i] = perc;
 }}}}

 total = [0, 0, 0, 0];
 zeker = [0, 0, 0, 0];
 mogelijk1 = [0, 0, 0, 0];
 mogelijk2 = [0, 0, 0, 0];

 for (i=0; i<4; i++)
 {for (j=0; j<8; j++)
  {if (!SLMR[j+8*i].vgespeeld)
   {total[i]++;
 }}}
 for (i=0; i<4; i++)
 {if (i != speler)
  {for (j=0; j<32; j++)
   if (kk[j+32*i] == nrm)
   {zeker[i]++;
    // mogelijk2[i] += 100;
   }
   else if (kk[j+32*i] > 0)
   {mogelijk1[i]++;
    mogelijk2[i] += kk[j+32*i];
 }}}

 var found = false;
 for (i=0; i<4; i++)
 {if (i != speler)
  {if (total[i] == zeker[i])
   {for (j=0; j<32; j++)
    {if (kk[j+32*i] > 0 && kk[j+32*i] < nrm)
     {found = true;
      kk[j+32*i] = 0;
   }}}
   else if (total[i] == zeker[i] + mogelijk1[i])
   {found = true;
    for (j=0; j<32; j++)
    {if (kk[j+32*i] > 0 && kk[j+32*i] < nrm)
     {for (var ii=0; ii<4; ii++)
      {if (i != ii && ii != speler)
       {kk[j+32*ii] = 0;
      }}
      kk[j+32*i] = nrm;
   }}}
 }}

 if (found)
 {// snelle controle of volgende iteratie mogelijk iets oplevert:
  found = false;
  for (i=0; i<4*32; i++)
  {if (kk[i] > 0 && kk[i] < nrm)
   {found = true;
 }}}

 return found;
}

this.normeren = function ()
{var i, j, k, it, scale = 999, ready;
 outer:
 for (it=1; it<=max_iter; it++)
 {mogelijk2 = [0, 0, 0, 0];
  for (i=0; i<4; i++)
  {if (i != speler)
   {for (j=0; j<32; j++)
    {if (kk[j+32*i] != nrm && kk[j+32*i] > 0)
     {mogelijk2[i] += kk[j+32*i];
  }}}}

  ready = true;
  for (i=0; i<max_iter; i++)
  {if (i != speler && mogelijk2[i])
   {scale = nrm * (total[i]-zeker[i]) / mogelijk2[i];
    if (Math.abs(1.0 - scale) > tol)
    {ready = false;
     for (j=0; j<32; j++)
     {if (kk[j+32*i] > 0 && kk[j+32*i] < nrm)
      {kk[j+32*i] *= scale;
  }}}}}
  for (k=0; k<32; k++)
  {var sum = 0;
   for (i=0; i<4; i++)
   {if (i != speler)
    {sum += kk[k+32*i];
   }}
   if (sum != 0 && (Math.abs (sum - nrm) > tol*nrm))
   {scale = nrm / sum;
    ready = false;
    for (i=0; i<4; i++)
    {if (i != speler)
     {kk[k+32*i] *= scale;
  }}}}
  if (scale != 999 && dbg.verbose > 2) {adm.scrn.msg(it + " ; " + scale);}
  if (ready) {break outer;}
 }
}

this.SlagLigtAan = function (s, si)
{var i, j, pf = -1, hf = -1;
 var k = kleur_slag[s];

// eerst kijken of er in het begin is getroefd:
 for (i=0; i<32; i++)
 {
  var c = SLMR[i];
  if (c.vgespeeld && c.slag == s && c.vkleur == troef && c.SlagIndex < si)
  {
   k = troef;
 }}

 for (i=0; i<32; i++)
 {
  var c = SLMR[i];
  if (c.vgespeeld && c.slag == s && c.vkleur == k && c.hoogte() > hf && c.SlagIndex < si)
  {
   hf = c.hoogte();
   pf = i;
 }}
 return pf;
}

this.Analyseer_spel = function ()
{
 var tdebug = new OTimer();

 var i, j, k, l;

 // de kleur per slag opzoeken:
 for (i=0; i<32; i++)
 {var c = SLMR[i];
  if (c.vgespeeld && c.SlagIndex == 0)
  {kleur_slag[c.slag] = c.vkleur;
 }}

 // initialisatie: alles is mogelijk:
 for (i=0; i<4*32; i++)
 {kk[i] = 1;
 }

 // sowieso heeft de rest niet jouw kaarten:
 for (i=8*speler; i<8*speler+8; i++)
 {for (j=0; j<4; j++)
  {kk[SLMR[i].kkindex+32*j] = 0;
 }}

 // en sowieso heeft de rest niet de reeds opgegooide kaarten:
 for (i=0; i<32; i++)
 {if (SLMR[i].vgespeeld)
  {for (j=0; j<4; j++)
   {kk[SLMR[i].kkindex+32*j] = 0;
 }}}

 // bijzondere situaties
 for (i=0; i<4; i++)
 {if (i != speler)
  {for (j=0; j<8; j++)
   {var krt_ij = SLMR[j+8*i];
    if (krt_ij.vgespeeld && krt_ij.SlagIndex > 0)
    {
     // zoek wat uit rond hoogste slag tot dan:
     var knr = this.SlagLigtAan(krt_ij.slag, krt_ij.SlagIndex);
     var krth = SLMR[knr];
     var hkrth = krth.hoogte();
     var kl_sl_ij = kleur_slag[krt_ij.slag];

 // 1. controleer of speler niet heeft kunnen bekennen;
     if (krt_ij.vkleur != kl_sl_ij)
     {
 // 1.1. sowieso dan hele kleur op 0
      {for (k=0; k<8; k++)
       {kk[k+32*i+8*kl_sl_ij] = 0;
       }
      }
 // 1.2 controle op niet-troeven
      if (krt_ij.vkleur != troef && kl_sl_ij != troef)
      {
       var p = Math.floor(knr / 8);
       if (Math.abs(p-i) != 2 || !m_adm.AmsRot) // dan had er getroefd moeten worden
       {if (krth.vkleur == troef) // kan niet overtroeven
        {
         for (l=0; l<8; l++)
         {if (m_adm.br.TroefVolgordeInv(l) > hkrth)
          {kk[l+32*i+8*troef] = 0;
        }}}
        else // kan sowieso niet troeven
        {
         for (l=0; l<8; l++)
         {kk[l+32*i+8*troef] = 0;
        }}
       }
      }
     }

 // 2. check op troef
 // 2.1. troef trekken en ondertroeven
     if (krt_ij.vkleur == troef && kl_sl_ij == troef)
     {
      if (krt_ij.hoogte() < hkrth)
      {for (l=0; l<8; l++)
       {
        if (m_adm.br.TroefVolgordeInv(l) > hkrth)
        {
         kk[l+32*i+8*troef] = 0;
       }}
     }}

 // 2.2 introeven en ondertroeven
     if (krt_ij.vkleur == troef && kl_sl_ij != troef)
     {
      if (krth.vkleur == troef && krt_ij.hoogte() < hkrth)
      { // heeft alleen nog lage troefen:
       for (l=0; l<8; l++)
       {
        for (var kl=0; kl<4; kl++)
        {if (kl == troef)
         {if (m_adm.br.TroefVolgordeInv(l) > hkrth)
          {
           kk[l+32*i+8*troef] = 0;
         }}
         else
         {
          kk[l+32*i+8*kl] = 0; // kan niet bekennen
     }}}}}
    }
 }}}

 for (i=0; i<max_iter; i++)
 {
  if (!this.consistent_maken()) {break;}
  if (dbg.debug && dbg.verbose > 2) {m_adm.scrn.OutputMSG1(0, 'na consistent maken: iter='+i);}
 }

 this.normeren();

 debug_str = dbg.retval_analyseerspel(SLMR, speler, KRHS, kk, from, tdebug, logtol, max_iter);
}

this.kans_bekennen = function (s, kl)
{
 var p = 1.0;
 for (k=0; k<8; k++)
 {
  p *= 1.0 - kk[k + 32*s + 8*kl];
 }
 return 1.0 - p;
}

this.kans_hoger_dubbel = function (s, kl, sll_bekend, slm_bekend, sll_troef, slm_troef)
{
 var mag1 = new Array(32);
 var mag2 = new Array(32);
 if (kl == troef) {sll_troef = 0; slm_troef = 0;}
 for (var i=0; i<32; i++)
 {
  var kleur_i = Math.floor(i/8); 
  if (kleur_i == kl)
  {
   mag1[i] = 1.0;
   mag2[i] = 1.0;
  }
  else if (kleur_i == troef && troef != kl)
  {
   mag1[i] = 1.0 - sll_bekend;
   mag2[i] = 1.0 - slm_bekend;
  }
  else
  {
   mag1[i] = 1.0 - sll_bekend - (1.0 - sll_bekend) * sll_troef;
   mag2[i] = 1.0 - slm_bekend - (1.0 - slm_bekend) * slm_troef;
  }
 }

 var sll = (s + 1) % 4;
 var p = 0.0;
 var norm = 0.0;
 var E_roem = 0.0;
 for (var k=0; k<32; k++)
 {
  var has = mag1[k] * kk[k + 32*s];
  if (has)
  {
   var kleur_k = Math.floor(k/8); 
   var tmp = new OKaart(k+7-8*kleur_k, kleur_k, m_adm.setadm.c, m_adm);
   tmp.settroef(troef);
   m_adm.setadm.VirtueleZet(s, tmp, this);

   for (var k2=0; k2<32; k2++)
   {
    var has2 = mag2[k2] * kk[k2 + 32*sll];
    if (has2 && k != k2)
    {
     var kleur_k2 = Math.floor(k2/8); 
     var tmp2 = new OKaart(k2+7-8*kleur_k2, kleur_k2, m_adm.setadm.c, m_adm);
     tmp2.settroef(troef);
     m_adm.setadm.VirtueleZet(sll, tmp2, this);
     var winnaar = m_adm.br.ZoekWinnaarSlag();
     var roem = m_adm.br.TelRoem();
     m_adm.setadm.WisVirtueleZet(sll, this);
     // if (winnaar == s) {p += has * has2;} // op zich correct!
     if ((winnaar % 2) == (s % 2)) {p += has * has2;}
     norm += has * has2;
     E_roem += has*has2 * ((winnaar % 2) == (s % 2) ? roem : -roem);
    }
   }
   m_adm.setadm.WisVirtueleZet(s, this);
  }
 }
 return [p/norm, E_roem];
}

this.kans_hoger = function (s, kl, sll_bekend, sll_troef)
{
 var mag1 = new Array(32);
 if (kl == troef) {sll_troef = 0;}
 for (var i=0; i<32; i++)
 {
  var kleur_i = Math.floor(i/8); 
  if (kleur_i == kl)
  {
   mag1[i] = 1.0;
  }
  else if (kleur_i == troef && troef != kl)
  {
   mag1[i] = 1.0 - sll_bekend;
  }
  else
  {
   mag1[i] = 1.0 - sll_bekend - (1.0 - sll_bekend) * sll_troef;
  }
 }

 var sll = (s + 1) % 4;
 var p = 0.0;
 var norm = 0.0;
 var E_roem = 0.0;
 for (var k=0; k<32; k++)
 {
  var has = mag1[k] * kk[k + 32*s];
  if (has)
  {
   var kleur_k = Math.floor(k/8); 
   var tmp = new OKaart(k+7-8*kleur_k, kleur_k, m_adm.setadm.c, m_adm);
   tmp.settroef(troef);
   m_adm.setadm.VirtueleZet(s, tmp, this);

   var winnaar = m_adm.br.ZoekWinnaarSlag();
   var roem = m_adm.br.TelRoem();
//  if (winnaar == s) {p += has;}
   if ((winnaar % 2) == (s % 2)) {p += has;}
   norm += has;
   E_roem += has * ((winnaar % 2) == (s % 2) ? roem : -roem);
   m_adm.setadm.WisVirtueleZet(s, this);
  }
 }
 return [p/norm, E_roem];
}

this.VirtueleZet = function (s, c)
{
 virtual[s] = c;
 cnt_virtual++;
}

this.WisVirtueleZet = function (s)
{
 virtual[s] = null;
 cnt_virtual--;
}

 this.Analyseer_spel();

 this.perc = function(color, player, i) {return kk[32*player + 8*color + i];}
 this.out  = function() {return debug_str;}

} // end constructor OSetAnalyse

