function generate_cuprins() {
  if (generate_cuprins.generated == "true") {
    return;
  }

  var v = [
    "submeniu1",
    "submeniu2",
    "submeniu3"
  ];
  var txt;
  var s = document.createElement("SECTION");

  var title = document.createElement("H1");
  txt = document.createTextNode("Cuprins");
  title.appendChild(txt);
  s.appendChild(title);

  var list = document.createElement("UL");
  s.appendChild(list);

  for (var i = 0; i < v.length; ++i) {
    var li = document.createElement("LI");
    list.appendChild(li);

    var stitle = document.createElement("H2");
    li.appendChild(stitle);
    txt = document.createTextNode(v[i]);
    stitle.appendChild(txt);
  }

  document.body.insertBefore(s, document.body.children[0]);

  generate_cuprins.generated = "true";
}
