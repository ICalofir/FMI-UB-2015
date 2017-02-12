function myFunction() {
  var n = document.getElementById("numar").value;
  var sel = document.getElementById("select");
  var div = document.createElement("DIV");

  document.body.appendChild(div);

  for (let i = 0; i < n; ++i)
  {
    var btn = document.createElement("BUTTON");
    var txt = document.createTextNode("Button " + i.toString());
    btn.style.display = "block";
    btn.style.backgroundColor = sel.options[sel.selectedIndex].value;
    btn.onclick = function() {
      window.alert("Salut, sunt butonul " + i);
    };
    btn.appendChild(txt);
    div.appendChild(btn);
  }
}
