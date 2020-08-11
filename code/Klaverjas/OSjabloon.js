function OSjabloon (par1, par2, ... ) {
//
// constructor for OSjabloon
//
// Interface:
//
//  constructor:
//   see sub init
//  aap:
//   bla, bla, ....
//  noot:
//   bla, bla, ....
//
var x = par1;
var y = par2;

this.aap = "default"; // zo min mogelijk van dit soort: van buiten ongecontroleerd aan te passen!

this.noot = function()
{
 // vb spaties in for-loop:
 for (var i=0; i<8; i++)
 {
  // js_collect haalt spaties weg, tenzij er een enkele quot in de regel staat:
  var out = 'string met spaties.';
  var txt = "zonder_spaties.";

  // body loop;
 }
 return x;
}

this.init = function()
{
 // hier de initialisatie code;
}

this.init();
} // end constructor OSjabloon
