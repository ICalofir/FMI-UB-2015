function init() {
  var testForm = document.getElementById("myform");
  testForm.onsubmit = function(ev) {
    ev.preventDefault();
  }
}

function myFunction() {
  var rezultat = document.getElementById("rezultat");
  var sum = 0;

  var int = document.getElementsByName("intrebare1");
  for (var i = 0; i < int.length; ++i) {
    if (int[i].checked) {
      if (int[i].value == "2") {
        ++sum;
      }
    }
  }

  int = document.getElementsByName("intrebare2");
  for (var i = 0; i < int.length; ++i) {
    if (int[i].checked) {
      if (int[i].value == "4") {
        ++sum;
      }
    }
  }

  int = document.getElementsByName("intrebare3");
  for (var i = 0; i < int.length; ++i) {
    if (int[i].checked) {
      if (int[i].value == "10") {
        ++sum;
      }
    }
  }

  rezultat.value = sum.toString();
}

function myReset() {
  var rezultat = document.getElementById("rezultat");
  rezultat.value = "";
}
