function [Qm,Ea,Sd] = FLEXtopo( ParPlateau, ParHillslope_forest,ParHillslope_crop, ParWetland, ParCatchment, forcing, landscapes )
%HBVpareto Calculates values of 3 objective functions for HBV model


%parameters and constants
Ks=ParCatchment(1); %%#ok<NASGU>
Tlag=ParCatchment(2);
frac = ParCatchment(3);
frac1 = ParCatchment(4);
tmax=length(forcing(:,1));
dt=1;


%initialize states
States_plateau.Si = zeros(tmax,1);
States_plateau.Su = zeros(tmax,1);
States_plateau.Sf = zeros(tmax,1);

States_hillslope.Si = zeros(tmax,1);
States_hillslope.Su = zeros(tmax,1);
States_hillslope.Sf = zeros(tmax,1);

States_hillslope_forest.Si = zeros(tmax,1);
States_hillslope_forest.Su = zeros(tmax,1);
States_hillslope_forest.Sf = zeros(tmax,1);

States_hillslope_crop.Si = zeros(tmax,1);
States_hillslope_crop.Su = zeros(tmax,1);
States_hillslope_crop.Sf = zeros(tmax,1);

States_wetland.Si = zeros(tmax,1);
States_wetland.Su = zeros(tmax,1);
States_wetland.Sf = zeros(tmax,1);

Ss=zeros(tmax,1); 

%initialize fluxes
Fluxes_plateau.Eidt = zeros(tmax,1);
Fluxes_plateau.Eadt = zeros(tmax,1);
Fluxes_plateau.Qusdt = zeros(tmax,1);
Fluxes_plateau.Qfdt = zeros(tmax,1);

Fluxes_hillslope.Eidt = zeros(tmax,1);
Fluxes_hillslope.Eadt = zeros(tmax,1);
Fluxes_hillslope.Qusdt = zeros(tmax,1);
Fluxes_hillslope.Qfdt = zeros(tmax,1);

Fluxes_hillslope_forest.Eidt = zeros(tmax,1);
Fluxes_hillslope_forest.Eadt = zeros(tmax,1);
Fluxes_hillslope_forest.Qusdt = zeros(tmax,1);
Fluxes_hillslope_forest.Qfdt = zeros(tmax,1);

Fluxes_hillslope_crop.Eidt = zeros(tmax,1);
Fluxes_hillslope_crop.Eadt = zeros(tmax,1);
Fluxes_hillslope_crop.Qusdt = zeros(tmax,1);
Fluxes_hillslope_crop.Qfdt = zeros(tmax,1);

Fluxes_wetland.Eidt = zeros(tmax,1);
Fluxes_wetland.Eadt = zeros(tmax,1);
Fluxes_wetland.Qusdt = zeros(tmax,1);
Fluxes_wetland.Qfdt = zeros(tmax,1);

Qsdt=zeros(tmax,1);
Qtotdt=zeros(tmax,1);
Ea = zeros(tmax,1);
Sd = zeros(tmax,1);
Def = 0;
%%
%loop over time
for i=1:tmax
    
      
    %plateau
    [Fluxes_plateau, States_plateau] = plateau(i, ParPlateau, forcing, Fluxes_plateau, States_plateau);
        
    %hillslope
    [Fluxes_hillslope_forest, States_hillslope_forest] = hillslope(i, ParHillslope_forest, forcing, Fluxes_hillslope_forest, States_hillslope_forest);
    [Fluxes_hillslope_crop, States_hillslope_crop] = hillslope(i, ParHillslope_crop, forcing, Fluxes_hillslope_crop, States_hillslope_crop);
    %wetland
    [Fluxes_wetland, States_wetland] = wetland(i, ParWetland, forcing, Fluxes_wetland, States_wetland, Ss, landscapes(3));
    % Slow Reservoir
    Ss(i)=Ss(i)+((1-frac)*Fluxes_hillslope_forest.Qusdt(i) + frac*Fluxes_hillslope_crop.Qusdt(i))*dt*landscapes(2)+ Fluxes_wetland.Qusdt(i)*dt*landscapes(3)+ Fluxes_plateau.Qusdt(i)*dt*landscapes(1);
    %SP:
    Ea(i) = ((1-frac)*Fluxes_hillslope_forest.Eadt(i)+frac*Fluxes_hillslope_crop.Eadt(i))*landscapes(2)+Fluxes_plateau.Eadt(i)*landscapes(1)+Fluxes_wetland.Eadt(i)*landscapes(3);
    Ea_w =  Fluxes_wetland.Eadt(i)*landscapes(3);
    %SP:
    Def = min(Ss(i),frac1*(forcing(i,3)-Ea_w));
    
    Ss(i) = Ss(i)-Def;
%     if Def<0
%         Ea(i)
%         forcing(i,3)
%     end
    Ea(i) = Ea(i) + frac1*Def;
    
    %SP:
    Qsdt(i)= dt*Ks*Ss(i);
    Ss(i)=Ss(i)-min(Qsdt(i),Ss(i));
    if i<tmax
        Ss(i+1)=Ss(i);
    end
    
    %total discharge

    Qtotdt(i)=Qsdt(i)+((1-frac)*Fluxes_hillslope_forest.Qfdt(i) + frac*Fluxes_hillslope_crop.Qfdt(i))*landscapes(2)+Fluxes_plateau.Qfdt(i)*landscapes(1)+Fluxes_wetland.Qfdt(i)*landscapes(3);        
    
%     Qsdt(i)= dt*Ks*Ss(i);
%     Ss(i)=Ss(i)-min(Qsdt(i),Ss(i));
%     if i<tmax
%         Ss(i+1)=Ss(i);
%     end
%     
%     %total discharge
%     Qtotdt(i)=Qsdt(i)+Fluxes_hillslope.Qusdt(i)*landscapes(2)+Fluxes_plateau.Qusdt(i)*landscapes(3)+Fluxes_wetland.Qusdt(i)*landscapes(3);
%     
%     Def = min(Sd(i),0.5*(forcing(i,3)-Ea(i)));
%     
%     Sd(i) = Sd(i)-Def;
%     if Def<0
%         Ea(i)
%         forcing(i,3)
%     end
%     Ea(i) = 0.5*Ea(i) + 0.5*(Ea(i)+Def);
%     tmp =min(50,Sd(i)+Qtotdt(i));
% % if Def<0
% %         Ea(i)= forcing(i,3)
% % else 
% %      Ea(i) = 0.5*Ea(i) + 0.5*(Ea(i)+Def);
% % end
% % Sd(i) = Sd(i)-Def;
% %     tmp =min(50,Sd(i)+Qtotdt(i));
%     if i<tmax
%         Sd(i+1)=tmp;
%     end
%     Qtotdt(i) = Qtotdt(i)-(tmp-Sd(i));
    
    
end

%apply lag functions
Weigths=Weigfun(Tlag);
Qm = conv(Qtotdt,Weigths);
Qm=Qm(1:tmax);


