function [Qm] = HBVMod( Par, forcing )
%HBVpareto Calculates values of 3 objective functions for HBV model


Imax=Par(1);
Ce=Par(2);
Sumax=Par(3);
beta=Par(4);
Pmax=Par(5);
Tlag=Par(6);
Kf=Par(7);
Ks=Par(8);


Qo=forcing(:,1);
Prec=forcing(:,2);
Etp=forcing(:,3);

tmax=length(Prec);
Si=zeros(tmax,1); 
Su=zeros(tmax,1); 
Sf=zeros(tmax,1); 
Ss=zeros(tmax,1); 
Eidt=zeros(tmax,1);
Eadt=zeros(tmax,1);
Qtotdt=zeros(tmax,1);


Si(1)=0;
Su(1)=0;
Sf(1)=0;
Ss(1)=0;



dt=1;

%%
% Model 1 SOF1
for i=1:tmax
    Pdt=Prec(i)*dt;
    Epdt=Etp(i)*dt;
    % Interception Reservoir
    if Pdt>0
        Si(i)=Si(i)+Pdt;
        Pedt=max(0,Si(i)-Imax);
        Si(i)=Si(i)-Pedt;
        Eidt(i)=0;
    else
        % Evaporation only when there is no rainfall
        Pedt=0;
        Eidt(i)=min(Epdt,Si(i));
        Si(i)=Si(i)-Eidt(i);
    end
    if i<tmax
        Si(i+1)=Si(i);
    end
    
    % Unsaturated Reservoir
    if Pedt>0
        rho=(Su(i)/Sumax)^beta;            
        Su(i)=Su(i)+(1-rho)*Pedt;
        Qufdt=rho*Pedt;
    else
        Qufdt=0;
    end
    % Transpiration
    Epdt=max(0,Epdt-Eidt(i));
    Eadt(i)=Epdt*(Su(i)/(Sumax*Ce));
    Eadt(i)=min(Eadt(i),Su(i));
    Su(i)=Su(i)-Eadt(i);
    % Percolation
    Qusdt=(Su(i)/Sumax)*Pmax*dt;
    Su(i)=Su(i)-min(Qusdt,Su(i));
    if i<tmax
        Su(i+1)=Su(i);
    end
    % Fast Reservoir
    Sf(i)=Sf(i)+Qufdt;
    Qfdt= dt*Kf*Sf(i);
    Sf(i)=Sf(i)-min(Qfdt,Sf(i));
    if i<tmax
        Sf(i+1)=Sf(i);
    end
    % Slow Reservoir
    Ss(i)=Ss(i)+Qusdt;
    Qsdt= dt*Ks*Ss(i);
    Ss(i)=Ss(i)-min(Qsdt,Ss(i));
    if i<tmax
        Ss(i+1)=Ss(i);
    end
    Qtotdt(i)=Qsdt+Qfdt;
end


% Check Water Balance
Sf=Si(tmax)+Ss(tmax)+Sf(tmax)+Su(tmax);
Sin=0;
WB=sum(Prec)-sum(Eidt)-sum(Eadt)-sum(Qtotdt)-Sf+Sin;
% Offset Q
Weigths=Weigfun(Tlag);
Qm = conv(Qtotdt,Weigths);
Qm=Qm(1:tmax);
% Calculate objective
% ind=find(Qo>=0);
% QoAv=mean(Qo(ind));
% ErrUp=sum((Qm(ind)-Qo(ind)).^2);
% ErrDo=sum((Qo(ind)-QoAv).^2);
% Obj=1-ErrUp/ErrDo;

%% Plot
% hour=1:tmax;
% plot(hour,Qo,'g');
% hold on
% plot(hour,Qm,'r');
% legend('Qobs','Qmod');
