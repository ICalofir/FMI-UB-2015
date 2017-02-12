var l = [];
var lw = [];
var style = [];
var stylew = [];

function rand(min, max) {
    return Math.floor(Math.random() * (max - min + 1) ) + min;
}

function tasta(event) {
  if (event.keyCode < 65 || event.keyCode > 90)
    return;

  var c = String.fromCharCode(event.keyCode + 32);
  var nowc = l.shift();
  var nowstyle = style.shift();

  if (c != nowc) {
    lw.push(nowc);
    stylew.push(nowstyle);
  } else {
    console.log(nowstyle);
    if (nowstyle != 1) {
      --nowstyle;
      l.unshift(nowc);
      style.unshift(nowstyle);
    }
  }
}

function myFunction() {
  var c = String.fromCharCode(rand(97, 122));
  var st = rand(1, 4);

  l.push(c);
  style.push(st);

  var s = "";

  for (var i = 0; i < lw.length; ++i) {
    s += '<span style="color:red;">';
    if (stylew[i] == 2) {
      s += "<i>" + lw[i] + "</i>";
    } else if (stylew[i] == 3) {
      s += "<b>" + lw[i] + "</b>";
    } else if (stylew[i] == 4) {
      s += "<b>" + "<i>" + lw[i] + "</i>" + "</b>";
    } else {
      s += lw[i];
    }
    s += "</span>";
  }

  for (var i = 0; i < l.length; ++i) {
    if (style[i] == 2) {
      s += "<i>" + l[i] + "</i>";
    } else if (style[i] == 3) {
      s += "<b>" + l[i] + "</b>";
    } else if (style[i] == 4) {
      s += "<b>" + "<i>" + l[i] + "</i>" + "</b>";
    } else {
      s += l[i];
    }
  }

  var div = document.getElementById("d");
  div.innerHTML = s;
  div.style.fontSize = "20px";

  if (9.3 * l.length > div.clientWidth)
  {
    window.alert("Ai pierdut!");
    location.reload();
  }

  console.log(l.length);
}

function start() {
  // myFunction();
  setInterval(myFunction, 100);
}
