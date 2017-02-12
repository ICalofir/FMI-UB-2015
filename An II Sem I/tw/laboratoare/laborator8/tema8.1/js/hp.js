function myFunction() {
  var prenume = document.getElementById("prenume").value;
  var nume = document.getElementById("nume").value;
  var telefon = document.getElementById("telefon").value;

  var suc = document.getElementsByName("suc");
  var op = "";
  for (var i = 0; i < suc.length; ++i) {
    if (suc[i].checked) {
      op = suc[i].value;
    }
  }

  if (prenume == "" || nume == "" || telefon == "" || op == "") {
    window.alert("Va rugam completati toate campurile!");
  } else {
    window.alert(prenume + " " + nume + " cu numarul de telefon " + telefon + " a ales " + op + "!");
  }
}
