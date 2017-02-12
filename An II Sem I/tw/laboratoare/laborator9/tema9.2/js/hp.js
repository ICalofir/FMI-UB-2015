var nr = 0;

function post() {
  var title = document.getElementById("titlu").value;
  var date = document.getElementById("date").value.toString();
  var text = document.getElementById("text").value;

  var a = document.createElement("ARTICLE");
  var txt = document.createTextNode(title + " " + date);
  a.appendChild(txt);
  var br = document.createElement("BR");
  a.appendChild(br);
  txt = document.createTextNode(text);
  a.appendChild(txt);
  br = document.createElement("BR");
  a.appendChild(br);
  br = document.createElement("BR");
  a.appendChild(br);

  document.getElementById("blog").appendChild(a);

  localStorage.setItem(nr, title + " " + date);
  ++nr;
}

function arhiva() {
  for (var i = 0; i < localStorage.length; ++i) {
    var p = document.createElement("P");
    var txt = document.createTextNode(localStorage[i]);
    p.appendChild(txt);

    document.getElementById("arhiva").appendChild(p);
  }
}

function init() {
  localStorage.clear();
}
