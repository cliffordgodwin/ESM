clear all

% forcing=load('MUTHUKERA\muthkPET.txt');
forcing1= importdata('Reclass/IMD_1975_2013.txt');

Par = [6.15 0.68 89.15 1.85 0.09 1.10 0.1 0.008];


Qm = HBVMod(Par, forcing1(:,1:3));
Qo = forcing1(:,1);

figure(2)
plot(Qm, 'red')
hold on
plot(Qo, 'blue')
hold off
legend('Qmod','Qobs');
