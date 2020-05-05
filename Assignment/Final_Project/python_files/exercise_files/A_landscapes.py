import numpy       as np
import matplotlib as mpl
import matplotlib.pyplot as plt


DEM=np.genfromtxt('wark_data/dem.asc',  dtype=float, autostrip=True)
slope=np.genfromtxt(...
hand=...
basin=...

#plot DEM
plt.figure(1)
DEM[DEM==-9999]=np.nan
plt.imshow(DEM, cmap='hsv')
plt.colorbar()
 
#plot HAND
plt.figure(2)
hand[hand==-9999]=np.nan
plt.imshow(...
plt.colorbar()


#make landscape classification
hillslope = np.array(slope) >...
plateau = (np.array(hand) > ...) & (np.array(slope)  ...)
wetland = (np.array(hand) <= ...
basin = np.array(basin)>0

hillslope_per = float(np.sum(...))/float(np.sum(basin))
wetland_per = float(np.sum(...
plateau_per = ...

landscapes=np.zeros((118,220))
landscapes[plateau]=1
landscapes[hillslope]=2
landscapes[wetland]=3

#plot landscapes
cmap = mpl.colors.ListedColormap(['white', 'red', 'green', 'blue'])
bounds=[0,1,2,3,4]
norm = mpl.colors.BoundaryNorm(bounds, cmap.N)

plt.figure(3)
plt.imshow(..., cmap=cmap, norm=norm)
plt.colorbar()
plt.show()





