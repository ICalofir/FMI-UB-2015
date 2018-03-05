k = 2;
f = @(x) 8 * x^3 + 4 * x - 1;
a = 0;
b = 1;

for i = 1:2
    m = (a + b) / 2;
    if f(m) == 0
        break;
    end
    
    if f(a) * f(m) < 0
        b = m;
    else
        a = m;
    end
end

m
f(m)