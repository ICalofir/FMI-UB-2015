function myFunction() {
  var input = document.getElementById("input").value;
  var sel = document.getElementById("select");
  sel = sel.options[sel.selectedIndex].value;
  var text = document.getElementById("text").value;

  if (isNaN(input) && sel == "numar") {
    window.alert("Nu ati introdus un numar si ati selectat un numar!");
    return;
  } else if (!isNaN(input) && sel == "string") {
    window.alert("Ati introdus un numar si ati selectat un string!");
    return;
  }

  if (text.length > 20) {
    window.alert("Ati introdus mai multe caractere decat este permis!");
    return;
  }

  window.alert("Succes!");
}
