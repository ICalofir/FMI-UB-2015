function change_p(nr) {
  document.getElementById("p" + nr).style.color = "green";
}

function default_p(nr) {
  document.getElementById("p" + nr).style.color = "black";
}

function search_cuv() {
  var str = prompt("Introduceti cuvantul urmat de numarul paragrafului:")
  var astr = str.split(" ");

  var text = document.getElementById("p" + astr[1]).textContent
  var atext = text.split(" ");

  var ap = 0;
  for (var i = 0; i < atext.length; ++i) {
    if (astr[0] == atext[i]) {
      ++ap;
    }
  }

  alert("Numarul de aparitii al cuvantului " + astr[0] + " in paragraful " + astr[1] + " este: " + ap);
}
