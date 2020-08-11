// versie 1.2, 27 dec 2002: diverse wijzigingen om webversie kleiner te maken.
// versie 1.1, 7 sep 2002: /* -> //
// module vanaf 17 dec 2001

// TODO: er een klasse van maken.
//  of onderdeel van OScreenAdmin, en OScreenAdmin uitbreiden met method Ready
//  of preload er helemaal uit, en bij opgooien check op complete.

var Loaded = [0,0];
function LoadFinished(i, c)
{Loaded[i]++;
 matchadm.scrn.OutputMSG1(1,37 - Loaded[0] - Loaded[1]);
}

function PreLoad(j,preloadi)
// begin nested functions.
{function count_loaded_img()
 {var i, j = 0;
  if (matchadm.scrn.wit.complete) {j++;}
  for (i=0 ; i<4 ; i++)
  {if (matchadm.scrn.KRHSgifje[i].complete) {j++;}}
  for (i=0 ; i<32 ; i++)
  {if (matchadm.setadm.c.SLMR[i].gifje.complete) {j++;}}
  return Math.max(j,Loaded[0] + Loaded[1]);}

 function next_check(j,i)
 {window.setTimeout("PreLoad(" +j+ "," +i+ ");",500);}

 function PreLoadImg(j)
 {for (var i=0 ; i<(j==2?4:16) ; i++)
  {document.images[i].src = (j==2)?matchadm.scrn.KRHSgifje[i].src:matchadm.setadm.c.SLMR[16*j+i].gifje.src;}}
// end nested functions.

 var show_preload = true;
 var l = count_loaded_img();

 if (preloadi++ == 0 && j==0)
 {if (show_preload) PreLoadImg(2);
  matchadm.scrn.OutputMSG1(0,'Plaatjes worden geladen, even geduld aub.');}
 matchadm.scrn.OutputMSG1(1,37-l);
 if (j <= 1)
 {if ((preloadi > (2+3*j)) && (l >= (5+16*j) || preloadi > (10+20*j)))
  {if (show_preload) PreLoadImg(j);
   next_check(j+1,preloadi);}
  else
  {next_check(j,preloadi);}}
 else if (j == 2)
 {if ((preloadi > 8) && (l == 37 || preloadi > 50))
  {matchadm.status=0;
   NieuwSpel();}
  else
  {next_check(2,preloadi);}}}

