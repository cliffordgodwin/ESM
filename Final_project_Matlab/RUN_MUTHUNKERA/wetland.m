function [Fluxes, States, Ss] = wetland( timestep, Par, forcing, Fluxes, States, Ss, landscape_per )

Imax=Par(1);
Ce=Par(2);
Sumax=Par(3);
beta=Par(4);
Cmax=Par(5);
Kf=Par(6);


% 
Qo=forcing(:,1);
Prec=forcing(:,2);
Etp=forcing(:,3);


Si=States.Si; 
Su=States.Su; 
Sf=States.Sf; 

Eidt=Fluxes.Eidt;
Eadt=Fluxes.Eadt;
Qfdt=Fluxes.Qfdt;




%%

%current timestep
 t=timestep;
 dt=1;
 tmax=length(Prec);
    Pdt=Prec(t)*dt;
    Epdt=Etp(t)*dt;

    % Interception Reservoir
    if Pdt>0
        Si(t)=Si(t)+Pdt;
        Pedt=max(0,Si(t)-Imax);
        Si(t)=Si(t)-Pedt;
        Eidt(t)=0;
    else
        % Evaporation only when there is no rainfall
        Pedt=0;
        Eidt(t)=min(Epdt,Si(t));
        Si(t)=Si(t)-Eidt(t);
     end
    if t<tmax
        Si(t+1)=Si(t);
    end
    % Unsaturated Reservoir
   if Pedt>0
        rho=(Su(t)/Sumax)^beta;            
        Su(t)=Su(t)+(1-rho)*Pedt;
        Qufdt=rho*Pedt;
    else
        Qufdt=0;
    end
        
    % Transpiration
    Epdt=max(0,Epdt-Eidt(t));
    Eadt(t)=Epdt*min(Su(t)/(Sumax*Ce),1);
    Eadt(t)=min(Eadt(t),Su(t));
    Su(t)=Su(t)-Eadt(t);
    
    % Capillary rise
    Qrdt=(1-Su(t)/Sumax)* Cmax*dt;
          
    %check if the groundwater has enough water (note: you need to use the landscape
    %percentage!!!)
    Qrdt=min(Qrdt,Ss(t)/landscape_per);
    
    %su cannot be more than sumax
    if( (Su(t) + Qrdt) >Sumax)
       
        Qrdt = Sumax - Su(t);
    end
    
    Su(t) = Su(t)+Qrdt;     
    Ss(t) = Ss(t)-Qrdt*landscape_per;
    
    if t<tmax
        Su(t+1)=Su(t);
    end
    
    % Fast Reservoir
   Sf(t)=Sf(t)+Qufdt;
    Qfdt(t)= dt*Kf*Sf(t);
    Sf(t)=Sf(t)-min(Qfdt(t),Sf(t));
    if t<tmax
        Sf(t+1)=Sf(t);
    end
    
    
    %save output
    States.Si = Si;
    States.Su = Su;
    States.Sf = Sf; 
    
    Fluxes.Eidt=Eidt;
    Fluxes.Eadt=Eadt;
    Fluxes.Qfdt=Qfdt;
      
 
    
    
end
