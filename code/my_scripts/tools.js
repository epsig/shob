// 2419200000 = 28 * 24 * 60 * 60 * 1000;
// 28 dagen in ms
function setCookie(name, value) {
var today = new Date();
var expiry = new Date(today.getTime() + 2419200000);
 if (value != null && value != "")
  document.cookie=name + "=" + escape(value) + "; expires=" + expiry.toGMTString();
}
// end function setCookie

function getCookie(name) {
var koekkie = document.cookie;
  var index = koekkie.indexOf(name + "=");
  if (index == -1) return null;
  index = koekkie.indexOf("=", index) + 1;
  var endstr = koekkie.indexOf(";", index);
  if (endstr == -1) endstr = koekkie.length;
  return unescape(koekkie.substring(index, endstr));
}
// end function getCookie

