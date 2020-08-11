// TODO Object van maken
var settings_koekkies, kj_koekkies;
var debug, verbose, round, autom, stopna, tempo;

function debug_onoff()
{
 debug = !debug;
 set_button("debug_button", debug);
 settings_koekkies[0] = (debug ? 1 : 0);
 setkjkoekkie();
 }

function inc_verb(x)
{
 verbose = Math.min(4, Math.max(0, verbose + x));
 document.form1.verb_button.value = verbose;
 settings_koekkies[1] = verbose;
 setkjkoekkie();
 }

function inc_tempo(x)
{
 tempo = Math.min(9, Math.max(1, tempo + x));
 document.form1.tempo_button.value = tempo;
 settings_koekkies[5] = tempo;
 setkjkoekkie();
 }

function set_button(x,y)
{
 eval("document.form1." + x + ".value = " + (y?"'aan'":"'uit'"));
 }

function round_onoff()
{
 round = !round;
 set_button("round_button", round);
 settings_koekkies[2] = (round ? 1 : 0);
 setkjkoekkie();
 }

function autom_onoff()
{
 autom = !autom;
 set_button("autom_button", autom);
 settings_koekkies[3] = (autom ? 1 : 0);
 setkjkoekkie();
 }

function stop_na(x)
{
 settings_koekkies[4] = x;
 setkjkoekkie();
}

function init_settings_form(tv)
{
 var i, f = document.form1;
 getkjkoekkie();

 if (tv)
 {
  debug   = parseInt(settings_koekkies[0]) > 0;
  verbose = parseInt(settings_koekkies[1]);
  autom   = parseInt(settings_koekkies[3]) > 0;
 }
 round   = parseInt(settings_koekkies[2]) > 0;
 stopna  = parseInt(settings_koekkies[4]);
 tempo   = parseInt(settings_koekkies[5]);
 
 set_button("round_button", round);
 if (tv)
 {
  set_button("autom_button", autom);
  set_button("debug_button", debug);
 }
 if (tv) {f.verb_button.value = verbose;}
 f.tempo_button.value = tempo;
 switch (stopna) {
  case 16: i = 1; break;
  case 32: i = 2; break;
  case  4: i = 3; break; // debug
  default: i = 0;}
 f.stop_radio[i].checked=true;
}
