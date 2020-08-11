function OTimer() {
// constructor voor klasse OTimer.
//
// Interface:
//
//  constructor: triviaal
//
//  starttimer: start de timer
//  stoptimer:  stop de timer
//  tooktime:   (read-only) verschil tussen start en stop.

var start = new Date;
var stop = null;
this.tooktime = -1;

this.starttimer = function ()
{
 start = new Date;
 this.tooktime = -1;
}

this.stoptimer = function ()
{
 stop = new Date;
 this.tooktime = stop.getTime() - start.getTime();
}

}
