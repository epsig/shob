function ODebug(envir) {
// constructor voor klasse ODebug

this.debug   = envir.debug();
this.verbose = envir.verbose();
this.cpu     = 0;
this.icpu    = 0;
this.hcpu    = 0;
this.hicpu   = 0;
var nrm = 1.0;

function round_cent(x)
{var n = Math.floor(x);
 var c = Math.round(100 * (x - n));
 return (n + "." + (c < 10 ? "0" : "") + c);
}

function print_kk_debug(kk, KRHS, speler)
{var txt = "";
 for (i=0; i<4; i++) // loop over slmr
 {if (i!=speler)
  {if (i>0) {txt += "\n";}
   txt += i+":";
   for (j=0; j<4; j++) // loop over krhs
   {txt += " " + KRHS[j] + ': ';
    for (k=0; k<8; k++)
    {txt += Math.round(100*kk[32*i+8*j+k]/nrm);
     if (k<7) {txt += "-";}
 }}}}
return txt;
}

function debug_kk_slmr(SLMR, kk, zelf, KRHS)
{// checkt of kk-array wel klopt met kaarten in SLMR

 var retval = true;
 // voor alle kaarten: kaart nog in de hand, dus kk > 0
 for (var i=0; i<32; i++)
 {
  var speler = Math.floor(i/8);
  if (speler != zelf && !SLMR[i].vgespeeld && kk[32*speler + SLMR[i].kkindex] == 0)
  {matchadm.scrn.msg("kaart " + i + " verkeerd!");
   retval = false;
  }
 }

 // andersom, als kk=100, zit die er dan ook echt
 for (var kleur = 0; kleur < 4; kleur++)
 {for (var w = 0; w < 8; w++)
  {for (var speler = 0; speler < 4; speler++)
   {var lookfor = w + 8 * kleur;
    var ii = 32*speler + lookfor;
    if (speler != zelf && kk[ii] > 0.99*nrm)
    {var found = false;
     for (var j = 0; j < 8; j++)
     {var tmp = SLMR[speler*8 + j];
      if (tmp.kkindex == lookfor)
      {if (tmp.vgespeeld)
       {matchadm.scrn.msg("kaart " + ii + '100 %, maar al gespeeld!');
        matchadm.scrn.msg(print_kk_debug(kk, KRHS, zelf));
        retval = false;
       }
       else
       {found = true;
       }
      }
     }
     if (!found)
     {matchadm.scrn.msg("kaart " + ii + '100 %, maar niet gevonden.');
      matchadm.scrn.msg(print_kk_debug(kk, KRHS, zelf));
      retval = false;
     }
    }
   }
  }
 }
 return retval;
}

this.spieken_debug = function (SLMR)
{var outstr = "";
 for (var i=1; i<4; i++)
 {outstr += naam_short[i] + ": ";
  {for (var j=0; j<8; j++)
   {var c = SLMR[j+8*i];
    if (!c.vgespeeld)
    {outstr += c.naam + ";";}
  }}
  outstr += "\n";
 }
 return outstr;
}

this.retval_analyseerspel = function (SLMR, speler, KRHS, kk, from, tdebug, logtol, max_iter)
{
 debug_kk_slmr(SLMR, kk, speler, KRHS);

 tdebug.stoptimer();
 if (from != "troef_tegen")
 {this.hcpu += (tdebug.tooktime ); this.hicpu++;}
 else
 { this.cpu += (tdebug.tooktime );  this.icpu++;}

 if (from != "troef_tegen")
 {var tolstr = "1E" + logtol;
  return (print_kk_debug(kk, KRHS, speler) +
   '\nmax_iter, tol = ' + max_iter + ', ' + tolstr);}
}

this.debug_msg_1 = function (KRHSpnt)
{
 for (var j=0; j<4; j++)
 {KRHSpnt[j] = round_cent(KRHSpnt[j]);}

 var txt = ' [p: ' + KRHSpnt[0]+"-"+KRHSpnt[1] + "-" + KRHSpnt[2]+"-"+KRHSpnt[3]+"]";

 return txt;
}

this.debug_msg_2 = function (mx, df, j1, j2)
{
 mx = round_cent(mx);
 df = round_cent(df);
 var txt = 'mx/df = '+ mx + '/' +df + '(' + KRHS[j1] + ', '+ KRHS[j2]+')';
 return txt;
}

this.debug_msg_3 = function (mxf, f2, smxf, smxf2)
{
 var nm1 = matchadm.setadm.c.SLMR[mxf].naam;
 var nm2 = matchadm.setadm.c.SLMR[f2].naam;
 var diff = smxf - smxf2;
 var out = 'pnt ' + nm1 + ', ' + nm2;
 out += ' = ' + smxf + ',  ' + smxf2;
 out += '; df = ' + diff + '.';
 return out;
}

this.debug_msg_4 = function ( mxf, kk_out, p1, p2, p3, p13, ksll, roem, winnaar, wk, slimme_zet, nm,
 sll_bekend, slm_bekend, sll_troef, slm_troef, cnr, b, s_adm, slm_troeft_in, sll_troeft_in, timetaken)
{
 var slmz = new Array(8);
 for (var i=0; i<8; i++)
 {
  if (b.GetDezeKaartenMogen(i))
  {
   ksll[i] = round_cent(ksll[i]);
   wk[i] = round_cent(wk[i]);
   roem[i] = round_cent(roem[i]);
   slmz[i] = round_cent(slimme_zet[i]);
  }
 }
 return (kk_out
  + '\n p1 = ' + p1
  + '\n p2 = ' + p2
  + '\n p3 = ' + p3
  + '\n p13 = ' + p13
  + '\n ksll = ' + ksll
  + '\n roem = ' + roem
  + '\n wn = ' + winnaar
  + '\n wk = ' + wk
  + '\n sz = ' + slmz
  + '\n keus = ' + mxf + ' ' + nm
  + '\n bekennen l: ' + sll_bekend + ' m: ' +  slm_bekend
  + '\n heeft troef l: ' + sll_troef + ' m: ' + slm_troef
  + (cnr == 2 && s_adm.kleur_deze_slag != s_adm.g_troef ? '\n kans mt troeft in: ' + slm_troeft_in : '')
  + (s_adm.kleur_deze_slag != s_adm.g_troef ?  '\n kans op introeven: ' + sll_troeft_in : '')
  + '\n cpu = ' + timetaken + ' ms'
  );
}

this.geschiedenis = function (outstr)
{
 if (this.verbose > 1) {outstr += "\n" + this.spieken_debug(matchadm.setadm.c.SLMR);}
 var kk = new OSetAnalyse(matchadm, 0, env, "info");
 var debug_str = kk.out() + "\n" + this.icpu + ': ' + this.cpu + ";" + this.hicpu + ': ' + this.hcpu;
 if (matchadm.scrn.groot_scherm) {outstr += debug_str;}
 if (matchadm.vorig_overzicht != "" && !matchadm.scrn.groot_scherm)
 {matchadm.scrn.msg(matchadm.vorig_overzicht);}
 if (matchadm.scrn.groot_scherm) {outstr = matchadm.vorig_overzicht + outstr;}
 matchadm.scrn.msg(outstr);
 if (!matchadm.scrn.groot_scherm) {matchadm.scrn.msg(debug_str);}
}

check_form = function ()
{
// code om volgorde_form te bepalen bij verandering scherm:
 if (!matchadm.scrn.gfx)
 {
  var nameplayer = ["ShowKaartS", "ShowKaartL", "ShowKaartM", "ShowKaartR"];
  var volgorde_form = new Array(4);
  for (var i=0; i<document.forms.length; i++)
  {for (var kk=0; kk<4; kk++)
   {
    eval ("if (document."+nameplayer[kk]+" == document.forms[i]) volgorde_form[kk] = i;");
  }}
  var ok = true;
  for (var kk=0; kk<4; kk++)
  {if (volgorde_form[kk] != matchadm.scrn.debug_form[kk])
   {ok = false;
  }}
  if (!ok)
  {
   matchadm.scrn.msg
    ("Form check failed: " + volgorde_form + "<--->" + matchadm.scrn.debug_form);
  }
 }
}

this.init = function ()
{
 check_form();
}

this.init();

} // end constructor ODebug
