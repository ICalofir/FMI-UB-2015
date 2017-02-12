function myFunction() {
  var e = document.getElementsByName("eveniment")[0].value;
  var d = new Date(document.getElementById("date").value.toString());
  var dnow = new Date();
  var ms = d.getTime() - dnow.getTime();

  var h = Math.floor(ms / 3600000);
  ms = ms - h * 3600000;
  var m = Math.floor(ms / 60000);
  ms = ms - m * 60000;
  var s = Math.floor(ms / 1000);
  h -= 2;

  var div = document.getElementById("afis");
  div.innerHTML = "Timp ramas pana la evenimentul " + e + ": " + h + ":" + m + ":" + s;
}

function start() {
  setInterval(myFunction, 1000);
}
