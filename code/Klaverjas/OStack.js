function OStack (adm) {
//
// constructor for OStack
//
// Interface:
//
//  constructor:
//   see sub init
//  reset:
//   incl.  schudkaarten
//
this.SLMR = new Array(32);

this.SchudKaarten = function ()
{var i, j, ii, ki, temp;

// schud de stapel
 for (ii=0; ii<32; ii++)
 {ki = Math.floor(24*Math.random());
  if (Math.floor(ki/8) == Math.floor(ii/8)) ki += 8;
  temp = this.SLMR[ki];
  this.SLMR[ki] = this.SLMR[ii];
  this.SLMR[ii] = temp;
 }

// sorteer eerste 8 kaarten:
 ii = 0;
 for (ki=0; ki<4; ki++)    // loop over 4 kleuren
 {for (i=7; i<=14; i++)   // loop over 8 kaarten zelfde kleur
  {for (j=ii; j<8; j++)  // loop over 8 kaarten speler S
   {if (this.SLMR[j].waarde == i && this.SLMR[j].vkleur == ki)
    {temp = this.SLMR[ii];
     this.SLMR[ii++] = this.SLMR[j];
     this.SLMR[j] = temp;
     break;
 }}}}

}

this.init = function ()
{//vul de stapel
 for (var kk=0; kk<4; kk++)
 {for (var i=0; i<8; i++)
  {var ii = kk+Math.floor(i/2);
   if (ii>3) ii -= 4;
   this.SLMR[i+kk*8] = new OKaart(i+7, ii, this, adm);
 }}

 // meteen goed schudden bij eerste potje
 var now = new Date();
 var j = now.getSeconds() + now.getMinutes();
 for (var i=0; i<j; i++)
 {
  var ki = Math.floor(32*Math.random());
  var ii = Math.floor(32*Math.random());
  var temp = this.SLMR[ki];
  this.SLMR[ki] = this.SLMR[ii];
  this.SLMR[ii] = temp;
 }
}

this.reset = function ()
{
 this.SchudKaarten();
 for (var i=0; i<32; i++)
 {
  this.SLMR[i].reset();
 }
}

this.init();
} // end constructor OStack
