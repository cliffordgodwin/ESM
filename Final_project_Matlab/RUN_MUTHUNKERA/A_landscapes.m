clear all

%load data

DEM=importdata('Reclass/demmuthk.asc');
slope=importdata('Reclass/slopemuthk.asc');  
hand=importdata('Reclass/handmuthk.asc');
% hand=importdata('Reclass/hand200muthk.asc');
basin=importdata('Reclass/basin.asc');
LULC=importdata('Reclass/lulc_muthk.asc');

%% plots of data
%plot DEM

figure(1)
DEM(DEM==-9999)=NaN;

colormap('jet');
imagesc(DEM);
colorbar;

%%
%plot HAND
hand(hand==-9999)=NaN;
figure(2)
colormap('jet');
imagesc(hand);
colorbar;

%%
%plot slope
slope(slope==-9999)=NaN;
figure(3)
colormap('jet');
imagesc(slope);
colorbar;

%%
%plot LULC
LULC(LULC==-9999)=NaN;
figure(3)
colormap('jet');
imagesc(LULC);
colorbar;

%% make landscape classification

hillslope = slope>=4;
plateau = hand>1 & slope<4;
wetland = hand<=1 & hand>0;
basin = hand>=0;

%calculate percentages
hillslope_per = sum(hillslope)/sum(basin);
wetland_per = sum(wetland)/sum(basin);
plateau_per = sum(plateau)/sum(basin);

disp(hillslope_per)
disp(wetland_per)
disp(plateau_per)
%matrix with landscape classes
landscapes=zeros(482,573);
landscapes(plateau)=1;
landscapes(hillslope)=2;
landscapes(wetland)=3;


%% plot landscapes

figure(4)
rgbmap=[1,1,1
        1,0,0
        0,1,0
        0,0,1];
colormap(rgbmap);
imagesc(landscapes);
colorbar;
%AE
PL=plateau;
HL=hillslope;
WL=wetland;


