clear all
%close all

%run landscape classification
A_landscapes;

% forcing1= importdata('MUTHUKERA\muthkPET.txt');
% forcing1= importdata('MUTHUKERA\IMD_2001_2013.txt');
% forcing1= importdata('MUTHUKERA\Trial.txt');
% forcing1= importdata('MUTHUKERA\trial3.txt');
% forcing1= importdata('MUTHUKERA\trial_2.txt');
forcing1= importdata('Reclass/IMD_1975_2013.txt');
forcing = forcing1(:,1:3);

%Best from HBVmod
%Imax      Ce      Sumax       beta      Pmax      Tlag      Kf        Ks
%7.2644    0.9302  457.4499    3.4615    0.0849    2.4681    0.0806    0.0061
% with IMD data
%0.4302    0.9691  365.6936    1.2548    0.0942    9.3451    0.0976    0.0010    
%2.0635    0.9965   77.4019    1.5084    0.1814    0.1992    0.0994    0.0092
%          %      Imax   Ce    Sumax    beta      Pmax   Kf  
% ParPlateau  = [4.2644 0.9302 638.74  1.2548 0.0849 0.0806];%[3.2 0.50,17.40 0.95 1.76 0.91];   
% 
%         %        Imax  Ce     Sumax    beta   D     Kf  
% % ParHillslope = [7.2644 0.9302 457.4499 3.4615 .8 0.0806];%[3.25 0.50 321.99 0.99 0.40,0.97];
% ParHillslope = [7.2644 0.9302  676.08  1.2548 .8 0.0806];
% %               Imax Ce     Sumax    beta   Cmax Kf  
% ParWetland = [3.2644 0.9302 599.13 1.2548 0.65 0.0806]; %[9.94 0.50 53.25 0.70 0.65 0.45];

ParPlateau  = [2.06 0.9902 77  1.5 0.0849 0.45];%[3.2 0.50,17.40 0.95 1.76 0.91];   

        %        Imax  Ce     Sumax    beta   D     Kf  
% ParHillslope = [7.2644 0.9302 457.4499 3.4615 .8 0.0806];%[3.25 0.50 321.99 0.99 0.40,0.97];
ParHillslope_forest = [2.06 0.9902  77  1.5 .8 0.45];

ParHillslope_crop = [2.06 0.9902  200  1.5 .8 0.45];
%               Imax Ce     Sumax    beta   Cmax Kf  
ParWetland = [2.06 0.9902 200 1.5 0.65 0.45]; %[9.94 0.50 53.25 0.70 0.65 0.45];


              %  Ks     Tlag frac    frac1
ParCatchment =  [0.0092, 2.46, 0.70 0.5]; %[0.0281 2.21];0.006  ParCatchment =  [0.0281, 2.4681];

%landscape percentages
landscape_per=[plateau_per,hillslope_per,wetland_per];

[Qm,Ea,Sd] = FLEXtopo(ParPlateau,ParHillslope_forest,ParHillslope_crop,ParWetland,ParCatchment,forcing(:,1:3),landscape_per);
Qo = forcing(:,1);

figure ;
plot(Qm, 'red')
hold on
plot(Qo, 'blue')
hold off
legend('Qmod','Qobs');
% legend('Qmod');
figure
plot(Qm,Qo,'ro');
xlabel('Qm');
ylabel('Qo');
hold on;
line([0 50],[0 50]);
figure
plot(Sd);
hold on
plot(Ea,'r-') 
plot(forcing(:,end),'g-')
save('Qmod_Base_scenario.txt','Qm','-ascii');
save('Qob.txt','Ea','-ascii');