function my_alert() {
  var txt = document.createTextNode("Hey there!");

  var btn = document.createElement("BUTTON");
  btn.appendChild(document.createTextNode("OK"));
  btn.style.position = "absolute";
  btn.style.right = "0px";
  btn.style.bottom = "0px";

  var alert = document.createElement("DIV");
  alert.appendChild(txt);
  alert.appendChild(btn);
  alert.id = "myAlert";
  alert.style.position = "fixed";
  alert.style.border = "1px solid black";
  alert.style.textAlign = "center";
  alert.style.width = (txt.length + 200).toString() + "px";
  alert.style.maxWidth = "100%";
  alert.style.height = "50px";
  alert.style.left = "500px";
  alert.style.top = "57px";
  alert.style.backgroundColor = "#d3d3d3";
  alert.style.boxShadow = "5px 5px 5px grey";
  alert.style.zIndex = "2";

  document.body.appendChild(alert);

  // blochez pagina, sa nu se mai poata da click nicaieri, doar pe butonul "ok" de la alerta se mai poate da click
  var div = document.getElementById("block");
  div.style.position = "fixed";
  div.style.width = (screen.width + 1).toString() + "px";
  div.style.height = (screen.height + 1).toString() + "px";
  div.style.border = "1px solid black";
  div.style.left = "-1px";
  div.style.top = "-1px";
  div.style.zIndex = "1";

  btn.onclick = close_my_alert;
}

function close_my_alert() {
  document.body.removeChild(document.getElementById("myAlert"));
  var div = document.getElementById("block");
  div.style.zIndex = "-1";
}
