a = 0;
b = pi;
m = 10;
f = @(x) sin(x);
metoda1 = 'dreptunghi';
metoda2 = 'trapez';
metoda3 = 'Simpson';
metoda4 = 'Newton';
    
syms y;
I = int(sin(y), a, b);
I0 = Integrare(f, a, b, m, metoda1);
I1 = Integrare(f, a, b, m, metoda2);
I2 = Integrare(f, a, b, m, metoda3);
I3 = Integrare(f, a, b, m, metoda4);
    
I = vpa(I);
    
error(1) = abs(I - I0);
error(2) = abs(I - I1);
error(3) = abs(I - I2);
error(4) = abs(I - I3);
error