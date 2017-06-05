function ploteazaEroareMisclasare(n, eroareMisclasare, eroareTeoretica)

hold on;

semilogx(n, eroareTeoretica * ones(size(n, 1), 1), 'r');
semilogx(n, eroareMisclasare, 'b');

end
