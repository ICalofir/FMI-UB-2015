function draw(event) {
  if (event.keyCode < 48 || event.keyCode > 57)
    return;

  var nr = event.keyCode - 48;
  var div = document.getElementById("d" + nr.toString());
  div.style.backgroundColor = "yellow";
}

function redraw(event) {
  if (event.keyCode < 48 || event.keyCode > 57)
    return;

  var nr = event.keyCode - 48;
  var div = document.getElementById("d" + nr.toString());
  div.style.backgroundColor = "lightblue";
}
