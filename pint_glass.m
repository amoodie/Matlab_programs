% pint glass calculations
clear all; close all;

% dimensions
% top, inside       d=7.95cm    r=3.975cm
% bottom inside,    d=4.90cm    r=2.45cm 
% height = 12.5cm
I = 1.15; % to increase size to exactly 16oz
td = 7.95*I;
bd = 4.90*I;
tr = td/2;
br = bd/2;

h = 13.3;
dz = 0.01;

conv = 0.0338140227; % cm3 to oz

z = 0.01:dz:h;

r = (((tr-br)/h) * z) + 2.45;
A = pi .* (r.^2);

vol = A*conv*0.01;

totv = sum(vol);
cumsumv = cumsum(vol);
perc = cumsumv/totv;

data = [1 , 1.45; 2 , 2.9; 3, 4.05; 4, 5.1; 5, 6.3; 6, 7.2; 7, 8.0; 8, 8.75; 9, 9.45; 10, 10.2; 11, 10.9; 12, 11.65; 13, 12.3; 14, 12.7; 15, 13.3];
data(:,2) = (data(:,2) - 0.7 ); % 0.7 is bottom thickness
data(:,3) = data(:,1) / 16;

figure();
hold on;
set(gca,'FontSize',14);
axis([0 h 0 1]);
title('Pint glass analysis','FontSize',16);
xlabel('height of beer in glass (\itz\rm) (cm)');
ylabel('percent full');
set(gca,'YTick',0:0.1:1);
plot(z,perc,'LineWidth',2);
plot(data(:,2),data(:,3),'-*','Color',[1 0 0])
legend('Modeled','Experimental','Location','Northwest')
hold off;
print('-depsc','-r300','-painters', 'straight');

% or conversely height missing and perc lost
invperc = 1 - perc;

figure();
hold on;
set(gca,'FontSize',14);
axis([0 h 0 1]);
title('Beer lost','FontSize',16);
xlabel('length of not filled space (\itL\rm) (cm)');
ylabel('percent beer lost');
set(gca,'YTick',0:0.1:1);
plot(fliplr(z),invperc,'LineWidth',2);
hold off;
print('-depsc','-r300','-painters', 'invert');


