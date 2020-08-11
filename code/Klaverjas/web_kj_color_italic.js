// try wordt niet door alle browsers ondersteunt,
// en is niet nodig voor grafische versie.
// daarom twee include-files.

function check_color_italic(o)
{
 var retval = true;
 try
 {o.style.color = "black";
  o.style.fontStyle = "normal";
 }
 catch (e)
 {
  window.alert("kan niet met kleur overweg\n"); // debug
  retval = false;
 }
 return retval;
}

