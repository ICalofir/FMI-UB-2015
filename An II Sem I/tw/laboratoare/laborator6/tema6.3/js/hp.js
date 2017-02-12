var pers = [];

function persoana(nume, prenume, cnp, data_nasterii) {
  this.nume = nume;
  this.prenume = prenume;
  this.cnp = cnp;
  this.data_nasterii = data_nasterii;
}

function add() {
  var prenume = prompt("Prenume:");
  var nume = prompt("Nume:");
  var cnp = prompt("CNP:");
  var data_nasterii = prompt("Data nasterii:");

  var patt = /^\d{5}$/; //regex
  while (!patt.test(cnp)) {
    cnp = prompt("CNP invalid. Incercati din nou:");
    if (cnp == null) {
      cnp = -1;
      break;
    }
  }

  data_nasterii = new Date(data_nasterii);
  if (data_nasterii == "Invalid Date") {
    while (true) {
      data_nasterii = prompt("Introduceti din nou data nasterii: (Exemplu: yyyy, mm, zz)");

      if (data_nasterii == null) {
        data_nasterii = "";
        break;
      }

      data_nasterii = new Date(data_nasterii);
      if (data_nasterii != "Invalid Date") {
        break;
      }
    }
  }

  p = new persoana(nume, prenume, cnp, data_nasterii);
  pers.push(p);
}

function print_pers(p) {
  return p.prenume + " " + p.nume + " " + p.cnp + " " +p.data_nasterii;
}

function show() {
  var str = "";
  for (var i = 0; i < pers.length; ++i) {
    str += "<p>" + print_pers(pers[i]) + "</p>";
  }

  document.getElementById("informatii").innerHTML = str;
}

function select() {
  var str = "";
  var maxY = prompt("Introduceti varsta maxima:");
  var nowDate = new Date();

  for (var i = 0; i < pers.length; ++i) {
    var ms = nowDate.getTime() - pers[i].data_nasterii.getTime();
    var y = Math.floor(ms / 31556926000);

    if (y <= maxY) {
      str += print_pers(pers[i]) + "\n";
    }
  }

  alert(str);
}
