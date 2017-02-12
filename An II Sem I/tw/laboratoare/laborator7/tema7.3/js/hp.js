function my_function() {
  var s = document.getElementsByTagName("span");

  for (var i = 0; i < s.length; ++i) {
    s[i].className = "highlight";
  }
}
