var interval, timer, run;
var t, pos, sc, nowline;
var dict = [
  "ana",
  "are",
  "mere",
  "enciclopedie",
  "cuvinte",
  "ionut"
];
var line = [];

function rand(min, max) {
    return Math.floor(Math.random() * (max - min + 1) ) + min;
}

function next(event, element) {
  if (!run) {
    return;
  }

  if (event.keyCode == 32) {
    event.preventDefault();

    if (pos >= line[0].length)
      return;

    var txt = nowline;

    if (element.value == dict[line[0][pos]]) {
      ++sc;
      txt += '<span style="color:blue">' + dict[line[0][pos]] + "</span> ";
      nowline = txt;
      for (var i = pos + 1; i < line[0].length; ++ i) {
        txt += dict[line[0][i]] + " ";
      }
    } else {
      txt += '<span style="color:red">' + dict[line[0][pos]] + "</span> ";
      nowline = txt;
      for (var i = pos + 1; i < line[0].length; ++ i) {
        txt += dict[line[0][i]] + " ";
      }
    }
    ++pos;
    txt += "<br>" + line_to_string(1);
    document.getElementById("input").innerHTML = txt;

    element.value = "";
  }
}

function generate_line() {
  var v = [];
  var input = document.getElementById("input");

  var sum = 0;
  while (true) {
    var nr = rand(1, dict.length - 1);
    if (sum + 10 * dict[nr].length + 10 > input.clientWidth) {
      break;
    } else {
      sum += 10 * dict[nr].length + 10;
      v.push(nr);
    }
  }

  return v;
}

function line_to_string(nr) {
  var txt = "";
  for (var i = 0; i < line[nr].length; ++i) {
    txt += dict[line[nr][i]] + " ";
  }

  return txt;
}

function game() {
  if (pos >= line[0].length) {
    pos = 0;
    nowline = "";

    var txt = "";
    line[0] = line[1].slice();
    txt += line_to_string(0);
    txt += "<br>";
    line[1] = generate_line().slice();
    txt += line_to_string(1);
    document.getElementById("input").innerHTML = txt;
  }
}

function time() {
  --t;
  var p = document.getElementById("text");
  if (!t) {
    run = false;
    clearInterval(interval);
    clearInterval(timer);

    document.getElementById("input").innerHTML = "";
    document.getElementById("start").disabled = false;
    p.innerHTML = "Scor: " + sc;
    return;
  }
  p.innerHTML = "Time: 0:" + t;
}


function start() {
  run = true;
  pos = 0;
  sc = 0;
  t = 60;
  nowline = "";

  var txt = "";
  line[0] = generate_line().slice();
  txt += line_to_string(0);
  txt += "<br>";
  line[1] = generate_line().slice();
  txt += line_to_string(1);

  interval = setInterval(function(){game()}, 100);
  timer = setInterval(function(){time()}, 1000);

  document.getElementById("input").innerHTML = txt;
  document.getElementById("output").value = "";
  document.getElementById("start").disabled = true;
  var p = document.getElementById("text");
  p.innerHTML = "Time: 1:00";
}

function reset() {
  clearInterval(interval);
  clearInterval(timer);

  document.getElementById("input").innerHTML = "";
  document.getElementById("output").value = "";
  document.getElementById("start").disabled = false;
  var p = document.getElementById("text");
  p.innerHTML = "Scor: 0";
}
