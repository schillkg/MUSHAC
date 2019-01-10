
# coding: utf-8

# In[1]:


import os
import numpy as np
from scipy.io import loadmat,savemat
import nibabel as nib
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt
import torch
import scipy.io as sio

bs_size = 1000

# bigger patch 5by5
# dropout layers
# adding channel of anatomical label for input
# do both SH1200 and SH3000 together


# In[2]:


dirs = ['A','B','C','D','E','F','G','I','J','K']

X = np.empty((5,5,5,31,0))
Y = np.empty((1,1,1,30,0))


# In[3]:


for i in range(len(dirs)):
#i = 0

    data_path = "/share5/nathv/CDMRI_Challenge_2018/patches/s%s_A2B_5Patches.mat" % (dirs[i])
    print(data_path)
    mat_contents = sio.loadmat(data_path)
    #print(mat_contents)
    
    X1 = mat_contents['input1200_row1']; X2 = mat_contents['input1200_row2']; X3 = mat_contents['input1200_row3']
    X4 = mat_contents['input1200_row4']; X5 = mat_contents['input1200_row5']

    Z1 = mat_contents['input3000_row1']; Z2 = mat_contents['input3000_row2']; Z3 = mat_contents['input3000_row3']
    Z4 = mat_contents['input3000_row4']; Z5 = mat_contents['input3000_row5']

    Y1 = mat_contents['output1200']; Y2 = mat_contents['output3000'];
    labels = mat_contents['labelsinput']
    dims=X1.shape
    print(dims)
    print(labels.shape)
    print(Y1.shape)

    # output is output1200 output3000

    XX = np.empty((5,5,5,31,dims[4]))
    YY = np.empty((1,1,1,30,dims[4]))

    XX[:,:,:,0,:] = labels[:,:,:,0,:]
    XX[0,:,:,1:16,:] = X1; XX[1,:,:,1:16,:] = X2; XX[2,:,:,1:16,:] = X3; XX[3,:,:,1:16,:] = X4; XX[4,:,:,1:16,:] = X5
    XX[0,:,:,16:32,:] = Z1; XX[1,:,:,16:32,:] = Z2; XX[2,:,:,16:32,:] = Z3; XX[3,:,:,16:32,:] = Z4; XX[4,:,:,16:32,:] = Z5

    #print(XX[1,1,1,:,10000])

    YY[:,:,:,0:15,:]=Y1; YY[:,:,:,15:31]=Y2

    #print(YY[:,:,:,:,10000])
    print(XX.shape)
    print(YY.shape)
    
    # remove NAN, INF
    from numpy import asarray as ar
    arr1 = np.squeeze(np.isnan(YY).any(axis=3))
    arr2 = np.squeeze(np.isinf(YY).any(axis=3))
    arr3 = ar(arr1) | ar(arr2)
    print(arr3.shape)

    XX = XX[:,:,:,:,~arr3]
    YY = YY[:,:,:,:,~arr3]
    print(XX.shape)
    print(YY.shape)

    # remove >10
    arr6 = np.squeeze(np.greater(np.abs(YY),10).any(axis=3))
    print(arr6.shape)
    XX = XX[:,:,:,:,~arr6]
    YY = YY[:,:,:,:,~arr6]
    print(XX.shape)
    print(YY.shape)

    #########
    remaining_samples = XX.shape
    remaining_samples = np.rint(remaining_samples[4])
    remaining_samples.astype(int)
    print(remaining_samples)
    elim_length = np.rint(remaining_samples/5)
    elim_length.astype(int)
    print(elim_length)
    print(elim_length.dtype)
    print(remaining_samples.dtype)
    arr7 = np.random.choice(remaining_samples.astype(int), elim_length.astype(int), replace = False)
    print(arr7.shape)
    mask = np.ones(remaining_samples.astype(int),dtype=bool)
    print(mask.shape)
    mask[[arr7]]=False
    print(mask)
    XX = XX[:,:,:,:,mask]
    YY = YY[:,:,:,:,mask]
    #Xv = Xv[:,:,:,:,arr7]
    #Xv = np.delete(X,arr7,axis=4)
    #Yv = np.delete(Y,arr7,axis=4)
    #Yv = Yv[:,:,:,:,arr7]
    print(XX.shape)
    print(YY.shape)
    #######
    
    X = np.append(X, XX, axis=4)
    Y = np.append(Y, YY, axis=4)


# In[4]:


del XX, YY, X1, X2, X3, X4, X5, Z1, Z2, Z3, Z4, Z5

print(X.shape)
print(Y.shape)


# In[5]:


from torch.utils.data import Dataset
from torchvision import transforms

class SHDataSet(Dataset):
    def __init__(self,X,Y):
        
        self.X = X
        self.Y = Y
        self.to_tensor = transforms.ToTensor()
        
    def __len__(self):
        return np.amax(X.shape)
    
    def __getitem__(self, i):
        
        vec_a = self.X[:,:,:,:,i]
        vec_b = self.Y[:,:,:,:,i]
        vec_a = np.transpose(vec_a, (3, 0, 1, 2))
        vec_b = np.transpose(vec_b, (3, 0, 1, 2))
        a = torch.Tensor(vec_a)
        b = torch.Tensor(vec_b.squeeze())
    
        return a,b


# In[6]:


shset = SHDataSet(X,Y)
print(len(shset))


# In[7]:


import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.autograd import Variable

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        #self.fc1 = nn.Linear(3 * 3 * 3 * 15, 600)
        self.cn1 = nn.Conv3d(31,128,kernel_size=(3,3,3),stride=1,padding=(1,1,1))
        self.cn2 = nn.Conv3d(128,128,kernel_size=(3,3,3),stride=1,padding=(1,1,1))
        ## self.mp = nn.MaxPool(2)
        #print(self.cn1.shape)
        #self.fc2 = nn.Linear(600,300)
        self.bn = nn.BatchNorm3d(128)
        self.fc2 = nn.Linear(128*5*5*5, 300)
        self.fc3 = nn.Linear(300,60)
        self.fc4 = nn.Linear(60,200)
        self.fc5 = nn.Linear(200,30)
        
    def forward(self, x):
        x = F.relu(self.cn1(x))
        x = F.relu(self.cn2(x))
        ## x = self.mp(x)
        print(x.shape)
        dimensions = x.shape
        x = self.bn(x)
        x = x.view(dimensions[0], -1)
        #x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = F.relu(self.fc3(x))
        x = F.relu(self.fc4(x))
        x = self.fc5(x)
        return x
        
net = Net()
print(net)  

optimizer = optim.SGD(net.parameters(), lr=0.001, momentum=0.9)
criterion = nn.MSELoss()


# In[8]:


from __future__ import print_function, division
import torch

def train(model, device, loader, optimizer):
    model.train()
    
    correct = 0
    total_loss = 0
    for batch_idx, (data, target) in enumerate(loader):
        data, target = Variable(data).float(), Variable(target).float()
        
        optimizer.zero_grad()
        output = model(data)
        output = output.to(device)

        loss = criterion(output,target)
        total_loss += loss.item()
      
        loss.backward()
        optimizer.step()
        
        print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(epoch, batch_idx*len(data),len(shset.X),100.*batch_idx/len(shset.X),loss.data[0]))

    avg_loss = total_loss / batch_idx
    print('\tTraining set: Average loss: {:.4f}'.format(avg_loss))
   
    return avg_loss

def test(model, device, loader):
    model.eval()

    correct = 0
    total_loss = 0

    for batch_idx, (data, target) in enumerate(loader):
        data, target = Variable(data).float(), Variable(target).float()

        output = model(data)
        output = output.to(device)

        loss = criterion(output, target)
        total_loss += loss.item()

    avg_loss = total_loss / batch_idx
    print('\tTesting set: Average loss: {:.4f}'.format(avg_loss))

    return avg_loss


# In[9]:


# batch_size = 16
validation_split = .2
shuffle_dataset = True
random_seed= 42

# Creating data indices for training and validation splits:
dataset_size = len(shset)
print(dataset_size)

indices = list(range(dataset_size))
split = int(np.floor(validation_split * dataset_size))
if shuffle_dataset :
    np.random.seed(random_seed)
    np.random.shuffle(indices)
train_indices, val_indices = indices[split:], indices[:split]

from torch.utils.data.sampler import SubsetRandomSampler

use_cuda = torch.cuda.is_available()
torch.manual_seed(1)
device = torch.device("cuda" if use_cuda else "cpu")
kwargs = {'num_workers': 1, 'pin_memory': True} if use_cuda else {}

# Creating PT data samplers and loaders:
train_sampler = SubsetRandomSampler(train_indices)
valid_sampler = SubsetRandomSampler(val_indices)

train_loader = DataLoader(shset, batch_size=bs_size, sampler=train_sampler)
validation_loader = DataLoader(shset, batch_size=bs_size, sampler=valid_sampler)


# In[10]:


import random

train_loss_file = 'BLAHFCN_L5PATCH_A2B_train_loss_split.txt'
f = open(train_loss_file, 'w')
f.close()
validate_loss_file = 'BLAHFCN_L5PATCH_A2B_validate_loss_split.txt'
f = open(validate_loss_file, 'w')
f.close()

model_file = 'BLAHFCN_L5PATCH_A2B_saved_model_split'


# In[ ]:


for epoch in range(1, 51):
        print('\nEpoch %d: ' % epoch)
        loss = train(net, device, train_loader, optimizer)

        with open(train_loss_file, "a") as file:
            file.write(str(loss))
            file.write('\n')

        loss = test(net, device, validation_loader)

        with open(validate_loss_file, "a") as file:
            file.write(str(loss))
            file.write('\n')

        if epoch % 5 == 0:
            with open(model_file, 'wb') as f:
                torch.save(net.state_dict(), f)


# In[ ]:





# In[ ]:




