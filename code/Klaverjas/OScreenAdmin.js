function OScreenAdmin(env, adm) {
// constructor voor klasse OEnvironment
//
// Interface
// - Constructor
//   see init
// - UpdateTroefKleur
//

this.groot_scherm = env.groot_scherm();
this.gfx          = env.gfx();
var m_adm = adm;

this.wit = new Image(50,50);
this.KRHSgifje = new Array(4);

var volgorde_form = (this.groot_scherm ? [12, 10, 8, 11] : [5, 4, 1, 6]);
var use_color_italic;

this.debug_form = volgorde_form;

this.msg = function (x)
{
 window.alert(x);
 // window.confirm(x); kan net zo goed.
}

this.InitMSGLijst = function ()
{this.OutputMSG1 (0," ");
 if (this.groot_scherm) {this.OutputMSG1 (1," ");}
}

this.SetValueColorStyle = function (obj, s, k)
{
 obj.value = s;
 if (use_color_italic)
 {
  obj.style.color     = (k == 1 || k == 3) ? "red"    : "black";
  obj.style.fontStyle = (k == 2 || k == 3) ? "italic" : "normal";
}}

this.UpdateTroefKleur = function ()
{
 var troef = m_adm.setadm.g_troef, troef_kiezer = m_adm.setadm.troef_kiezer;
 if (this.gfx)
 {
  for (var j=0; j<4; j++)
  {
   document.images[j].src = (j == troef || troef == -1) ? this.KRHSgifje[j].src : this.wit.src;
 }}
 else
 {
  for (var j=0; j<4; j++)
  {
   var b = (j == troef || troef == -1);
   var value = b ? " " + KRHS[j] + " " : ' - ';
   this.SetValueColorStyle(document.KiesTroefKleur.elements[j], value, b ? j : -1);
 }}

 if (this.groot_scherm)
 {
  document.KiesTroefTxt.vld1.value = (troef == -1) ? "Kies troef:" : "Troef is:";
  document.ShowTroefKleur.HuidigeTroefKiezer.value = (troef_kiezer == -1) ? "---" : naam_long[troef_kiezer];
}}

this.UpdateIndeHand = function ()
{var i, volgorde = [6,5,4,7];
 if (this.gfx)
 {for (i=0; i<8; i++)
  {document.images[8+i].src=m_adm.setadm.c.SLMR[i].vgespeeld ? this.wit.src : m_adm.setadm.c.SLMR[i].gifje.src;}
   for (i=0; i<4; i++)
   {document.images[volgorde[i]].src=m_adm.setadm.LigtOpTafel[i] ? m_adm.setadm.KaartOpTafel[i].gifje.src : this.wit.src;}}
 else
 {for (i=0; i<8; i++)
  {var form_card = document.IndeHand.elements[i];
   if (m_adm.setadm.c.SLMR[i].vgespeeld)
   {
    this.SetValueColorStyle(form_card, "***", -1);
   }
   else
   {
    var c = m_adm.setadm.c.SLMR[i];
    this.SetValueColorStyle(form_card, c.naam, c.vkleur);
  }}
  for (i=0; i<4; i++)
  {var form_card = document.forms[volgorde_form[i]].elements[0];
   if (m_adm.setadm.LigtOpTafel[i])
   {
    var c = m_adm.setadm.KaartOpTafel[i];
    this.SetValueColorStyle(form_card, c.naam, c.vkleur);
   }
   else
   {
    this.SetValueColorStyle(form_card, "", -1);
 }}}
 if (this.groot_scherm)
 {ShowScore.HuidigeScoreU.value = m_adm.score.scoreU;
  ShowScore.HuidigeScoreC.value = m_adm.score.scoreC;
  ShowRoem.HuidigeRoemU.value = m_adm.score.roemU;
  ShowRoem.HuidigeRoemC.value = m_adm.score.roemC;
}}

this.Update_Score_Lijst = function ()
{
 if (this.groot_scherm)
 {
  var tse = document.TotaleScore.elements;
  if (m_adm.spel_nr < tse.length / 2)
  {
   tse[2*m_adm.spel_nr].value = m_adm.score.totaalU;
   tse[2*m_adm.spel_nr+1].value = m_adm.score.totaalC;
  }
  else
  {// scrollen
   for (i = 2; i < tse.length; i++)
   {
    tse[i-2].value = tse[i].value;
   }
   tse[tse.length-2].value = m_adm.score.totaalU;
   tse[tse.length-1].value = m_adm.score.totaalC;
}}}

function InitScoreLijst ()
{
 var tse = document.TotaleScore.elements;
 tse[0].value = 0;
 tse[1].value = 0;
 for (var i = 2; i < tse.length; i++)
 {
  tse[i].value = " ";
}}

this.OutputMSG1 = function (i, t)
{
 if (!this.groot_scherm && i == 1)
 {this.msg(t);}
 else
 {document.msg.elements[i].value = t;}
}

this.reset = function ()
{
 this.InitMSGLijst();
 if (this.groot_scherm) {InitScoreLijst();}
}

this.init = function ()
{
 this.reset();

 if (this.gfx)
 {
  this.wit.src = document.images[4].src;
  this.wit.onLoad = "LoadFinished(0);";
  for (var i=0; i<4; i++)
  {
   this.KRHSgifje[i] = new Image(40,40);
   this.KRHSgifje[i].onLoad = "LoadFinished(0);";
   this.KRHSgifje[i].src = "include/" + KRHS[i] + ".jpg";
 }}
 else
 {
  use_color_italic = check_color_italic(document.KiesTroefKleur.elements[0]);
 }
 document.BSpelNiveau.HuidigNiv.value = env.niveau();
}

this.init();

} // end constructor OScreenAdmin

