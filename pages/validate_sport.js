function validateDate(date)
{
  if (date.length != 8)
  {
    alert("Both dates must be given and with 8 digits.");
    return false;
  }
  var dd = parseInt(date);
  if (dd.isNaN)
  {
    alert("Date must be a number (e.g. 20210202).");
    return false;
  }
  if (dd < 19700000 || dd > 21000000)
  {
    alert("Date out of range.");
    return false;
  }
  return true;
}
function validateForm() {
  var           success = validateDate(document.forms["myForm"]["dd1"].value);
  if (success) {success = validateDate(document.forms["myForm"]["dd2"].value)};
  if (success)
  {
    if (document.forms["myForm"]["dd1"].value > document.forms["myForm"]["dd2"].value)
    {
      alert("First date must be before second date.")
      success = false;
    }
  }
  if (success)
  {
    if (document.forms["myForm"]["c1"].value == document.forms["myForm"]["c2"].value)
    {
      alert("Clubs must be different.");
      success = false;
    }
  }
  return success;
}
