function [ Weigths ] = Weigfun( Tlag )
%WEIGFUN Summary of this function goes here
%   Detailed explanation goes here
nmax=ceil(Tlag);
if nmax==1 
    Weigths=1;
else
    Weigths=zeros(1,nmax);
    th=Tlag/2;
    nh=floor(th);
    for i=1:nh
        Weigths(i)=(i-.5)/th;
    end
    i=nh+1;
    Weigths(i)=(1+(i-1)/th)*(th-floor(th))/2+(1+(Tlag-i)/th)*(floor(th)+1-th)/2;
    for i=nh+2:floor(Tlag)
        Weigths(i)=(Tlag-i+.5)/th;
    end
    if Tlag>floor(Tlag)
        Weigths(floor(Tlag)+1)=(Tlag-floor(Tlag)).^2/(2*th);
    end
end
Weigths=Weigths/sum(Weigths);
% plot(Weigths);
