import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

DEM=np.genfromtxt('Reclass/demmuthk.asc',  dtype=float, autostrip=True)
slope=np.genfromtxt('Reclass/slopemuthk.asc',  dtype=float, autostrip=True)
hand=np.genfromtxt('Reclass/handmuthk.asc',  dtype=float, autostrip=True)
basin=np.genfromtxt('Reclass/basin.asc',  dtype=float, autostrip=True)
LULC=np.genfromtxt('Reclass/lulc_muthk.asc')

#plot DEM
plt.figure(1)
DEM[DEM==-9999]=np.nan
plt.imshow(DEM, cmap='jet')
plt.colorbar()

#plot HAND
plt.figure(2)
hand[hand==-9999]=np.nan
plt.imshow(hand, cmap='jet')
plt.colorbar()

#plot Slope
plt.figure(3)
slope[slope==-9999]=np.nan
plt.imshow(slope, cmap='jet')
plt.colorbar()

#plot LULC
plt.figure(4)
LULC[LULC==-9999]=np.nan
plt.imshow(LULC, cmap='jet')
plt.colorbar()

#make landscape classification
hillslope = np.array(slope) >=4
plateau = (np.array(hand) > 1) & (np.array(slope) < 4)
wetland = (np.array(hand) <= 1) & (np.array(hand) > 0)
basin = np.array(basin)>0

hillslope_per = float(np.sum(hillslope))/float(np.sum(basin))
wetland_per = float(np.sum(wetland))/float(np.sum(basin))
plateau_per = float(np.sum(plateau))/float(np.sum(basin))



landscapes=np.zeros((482,573))
landscapes[plateau]=1
landscapes[hillslope]=2
landscapes[wetland]=3

#plot landscapes
cmap = mpl.colors.ListedColormap(['white', 'red', '#89fe05', 'blue'])
bounds=[0,1,2,3,4]
norm = mpl.colors.BoundaryNorm(bounds, cmap.N)

print(hillslope_per)
print(wetland_per)
print(plateau_per)


plt.figure(5)
plt.imshow(landscapes, cmap=cmap, norm=norm)
plt.colorbar()
plt.show()



