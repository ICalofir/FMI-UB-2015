var ok = false;

function init() {
  if (localStorage.getItem("left") == null) {
    localStorage.setItem("left", "0");
    console.log("e nul");
  }

  if (localStorage.getItem("top") == null) {
    localStorage.setItem("top", "0");
  }

  var img = document.getElementById("myimg");
  img.style.left = localStorage.getItem("left") + "px";
  img.style.top = localStorage.getItem("top") + "px";
}

function activate() {
  ok = true;
}

function move(event) {
  if (!ok)
    return;

  var img = document.getElementById("myimg");

  if (event.keyCode == 37) { // stanga
    var pos = parseInt(img.style.left);
    if (pos - 10 > 0) {
      pos = pos - 10;
    }
    img.style.left = pos + "px";
  }

  if (event.keyCode == 39) { // dreapta
    var pos = parseInt(img.style.left);
    if (pos + 10 < screen.width - 220) {
      pos = pos + 10;
    }
    img.style.left = pos + "px";
  }

  if (event.keyCode == 40) { // jos
    var pos = parseInt(img.style.top);
    if (pos + 10 < screen.height - 270) {
      pos = pos + 10;
    }
    img.style.top = pos + "px";
  }

  if (event.keyCode == 38) { // sus
    var pos = parseInt(img.style.top);
    if (pos - 10 > 0) {
      pos = pos - 10;
    }
    img.style.top = pos + "px";
  }

  localStorage.setItem("left", parseInt(img.style.left));
  localStorage.setItem("top", parseInt(img.style.top));
}
