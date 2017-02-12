var dictionary = {
  "acesta": "this",
  "este": "is",
  "un": "a"
};
var ok = true;

while (ok) {
  var word = prompt("Introduceti cuvantul:");
  if (word == null) {
    break;
  }

  var found = false;

  for (var w in dictionary) {
    if (w == word) {
      found = true;
      alert("Cuvantul tradus este: " + dictionary[w]);
    }
  }
  if (!found) {
    alert("Cuvantul nu a fost gasit in dictionar!");
  }

  if (!confirm("Continuati?")) {
    ok = false;
  }
}
