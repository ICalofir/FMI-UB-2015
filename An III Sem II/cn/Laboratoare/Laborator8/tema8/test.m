clear all
f=inline('exp(2*x)','x');
fp = inline('2*exp(2*x)','x');
x0=-1; xf=1; N=2;
X=linspace(x0,xf,(N+1)); %Nodurile de interpolare
Y=f(X); %Valorile lui f in nodurile de interpolare
x=linspace(x0,xf,100);% Diviziunea in baza careia se construiesc graficele
%Vectorul S reprezinta valorile functiei de interpolare cubica, S, in fiecare nod al discretizarii intervalului [-1,1] cu
%100 de noduri
fpa = fp(X(1)); %Se impune derivata in capetele intervalului [a,b]
fpb = fp(X(N+1));

%Procedura SplineC are ultimul parametru un scalar
for i = 1:length(x)
    S(i) = SplineC(X,Y,fpa,fpb,x(i));
end

figure(1)
hold on
plot(x,S,'k','Linewidth',3);%Reprezentarea grafica a functiei S
xlabel('x')
ylabel('y')
grid on
plot(x,f(x),'--r','Linewidth',3);
plot(X,f(X),'o','MarkerFaceColor','g','MarkerSize',10)
legend('S(x) - spline cubica','f(x)=e^{2x}','noduri de interpolare')

Sp = diff(S)./diff(x);
%diff calculeaza diferente intre doua elemente consecutive
%daca x = [x1 x2 ... xn], atunci diff(x) = [x2-x1 x3-x2 ... xn-xn-1]
%dimensiunea vectorului diff(x) este n-1

figure(2)
plot(x(1:length(x)-1),Sp,'k','Linewidth',3)
df = diff(f(x))./diff(x); %Derivata functiei f calculata numeric cu functia diff
hold on
plot(x(1:length(x)-1),df,'--r','Linewidth',3)
grid on
legend('derivata funciei S','derivata functiei f')
xlabel('x')
ylabel('y')

% Derivata de ordinul II a functiei S calculata numeric
Ss = diff(Sp)./diff(x(1:length(x)-1));
hold on

figure(3)
plot(x(1:length(x)-2), Ss,'k','Linewidth',3)%Derivata de ordinul II a functiei f calculata
%numeric
d2f = diff(df)./diff(x(1:length(x)-1));
hold on
plot(x(1:length(x)-2), d2f,'--r','Linewidth',3)
grid on
legend('derivata de ord. II a functiei S','derivata de ord. II a functiei f')
xlabel('x')
ylabel('y')