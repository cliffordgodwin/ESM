#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
get_ipython().run_line_magic('matplotlib', 'inline')
import pandas as pd
import matplotlib.pyplot as plt 


# In[102]:


def read_file_base(file):
    data= pd.read_csv(file, skiprows=(0, 1, 2, 3), header=[1], parse_dates=[0])
    return data


# In[81]:


K_y= 1
Pot_yield = 45 #(kg/ha)
Area = 112907 #ha (??)
b0 = 5
b1 = 0.25
WQ_f = 1
irrigation = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.6, 0.8, 0.9, 1]
print (len(irrigation))


# In[103]:


file = r"C:\Users\fabrizia\Downloads\ESM.csv"
data=read_file_base(file)
display(data.head(4))


# In[122]:


#Scenario 1 
def data_frame(i):
    keep_q = 'Q_observed.' + str(i + 1)
    keep_e = 'Ea.' + str(i+1)
    df = data[['Date', 'Q_observed (mm/day)', 'P (mm/day)', 'Ep (mm/day)', keep_q, keep_e]].copy()
    return df


# In[130]:


Scenario1_df = data_frame(0)
Scenario2_df = data_frame(1)
Scenario3_df = data_frame(2)
Scenario4_df = data_frame(3)
Scenario5_df = data_frame(4)
Scenario6_df = data_frame(5)
Scenario7_df = data_frame(6)
Scenario8_df = data_frame(7)
Scenario9_df = data_frame(8)
Scenario10_df = data_frame(9)
Scenario11_df= data_frame(10)


# In[ ]:



    

