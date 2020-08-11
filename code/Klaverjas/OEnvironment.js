function OEnvironment(button_level)
// constructor voor klasse OEnvironment
//
// Interface
// - init: triviaal, koppeling aan button_level (kan null zijn)
// - IncNiveau(i): verander spel-niveau (i mag ook negatief)
// - properties:
//    groot_scherm
//    gfx
//    AmsRot
//    debug
//    verbose
//    round
//    autom
//    stopna
//    tempo
//    niveau
//
// - sub-functions (may change suddenly)
//   - setkjkoekkie TODO apart object OkjKoekkie
//   - getkjkoekkie
//

{
 var ml = 4;
 var kj_koekkies = new Array(3);
 var settings_koekkies, level;
 var Cbig_scr, Cgfx, CAmsRot;
 var Cdebug, Cverbose, Cround, Cautom, Cstopna, Ctempo;
 var BNiv = button_level;

 function f(x) {return (document.URL.indexOf(x) >= 0);}

 this.setkjkoekkie = function ()
 {
  setCookie("kj", kj_koekkies.join("_"));
  setCookie("kj_settings", settings_koekkies.join("_"));
 }

 this.getkjkoekkie = function ()
 {
  var kj_koekkie = getCookie("kj");
  if (kj_koekkie == null)
  {kj_koekkie = "Ams_gfx_1";
  }
  kj_koekkies = kj_koekkie.split("_");

  var settings_koekkie = getCookie("kj_settings");
  if (settings_koekkie == null) {settings_koekkie = "0_0_1_0_inf_3";}
  settings_koekkies = settings_koekkie.split("_");
 }

 this.init = function ()
 {
  Cbig_scr = !f("klein");
  Cgfx     = f("gfx");
  CAmsRot  = !f("rdam");

  this.getkjkoekkie();
  kj_koekkies[0] = AmsRotStr2(CAmsRot);
  kj_koekkies[1] = (Cgfx ? "gfx" : (Cbig_scr ? "txt" : "palm"));

  Cdebug    = parseInt(settings_koekkies[0]) > 0;
  Cverbose  = parseInt(settings_koekkies[1]);
  Cround    = parseInt(settings_koekkies[2]) > 0;
  Cautom    = parseInt(settings_koekkies[3]) > 0;
  Cstopna   = parseInt(settings_koekkies[4]);
  Ctempo    = parseInt(settings_koekkies[5]);

  if (Cdebug) {ml = 5;} // debug-only voorlopig

  level = parseInt(kj_koekkies[2]);
  if (!isNaN(level))
  {
   level = Math.min(ml, Math.max(1, level));
  }
  else
  {
   level = 3;
   this.setkjkoekkie();
  }
 }

 this.groot_scherm = function () {return Cbig_scr;}
 this.gfx          = function () {return Cgfx;}
 this.AmsRot       = function () {return CAmsRot;}
 this.debug        = function () {return Cdebug;}
 this.verbose      = function () {return Cverbose;}
 this.round        = function () {return Cround;}
 this.autom        = function () {return Cautom;}
 this.stopna       = function () {return Cstopna;}
 this.tempo        = function () {return Ctempo;}
 this.niveau       = function () {return level;}

 this.IncNiveau    = function (i)
 {
  var oldlevel = level;
  level = Math.min(ml, Math.max(1, level + i));
  if (oldlevel != level)
  {
   if (BNiv) {BNiv.HuidigNiv.value = level;}
   kj_koekkies[2] = level;
   this.setkjkoekkie();
  }
 }

 this.init();
}
