
# coding: utf-8

# In[1]:


from __future__ import print_function, division
import os
import numpy as np
from scipy.io import loadmat,savemat
import nibabel as nib
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt
import torch
import scipy.io as sio
import h5py

bs_size = 1000
train_loss_file = 'BLAHFCN_PATCH_A2D_SH1200_train_loss_split.txt'

validate_loss_file = 'BLAHFCN_PATCH_A2D_SH1200_validate_loss_split.txt'

model_file = 'BLAHFCN_PATCH_A2D_SH1200_saved_model_split'
# v2: seperate training and testing and save as text
# v3: include all 10 datasets and concatenate!


# In[ ]:


dirs = ['A','B','C','D','E','F','G','I','J','K']

X = np.empty((3,3,3,15,0))
Y = np.empty((1,1,1,15,0))

#numbers = [6]
for i in range(len(dirs)):
#for i in numbers:
    #data_path = "/Users/kurtschilling/Data/harmonization/s%s_A2D_Patches.mat" % (dirs[i])
    data_path = "/share5/nathv/CDMRI_Challenge_2018/patches/s%s_A2D_Patches.mat" % (dirs[i])
    print(data_path)
    
    mat_contents = sio.loadmat(data_path)
    # mat_contents
    Xv = mat_contents['input1200']
    Xv = np.float64(Xv)
    print(X.shape)
    Yv = mat_contents['output1200']
    Yv = np.float64(Yv)
    
    print(Yv.shape)
    print(Xv.dtype)
    print(Yv.dtype)
    
    # remove NAN, INF
    from numpy import asarray as ar

    arr1 = np.squeeze(np.isnan(Yv).any(axis=3))
    arr2 = np.squeeze(np.isinf(Yv).any(axis=3))
    arr3 = ar(arr1) | ar(arr2)
    print(arr3.shape)

    #X = np.delete(X,arr3,4)
    #Y = np.delete(Y,arr3,4)
    Xv = Xv[:,:,:,:,~arr3]
    Yv = Yv[:,:,:,:,~arr3]
    print(Xv.shape)
    print(Yv.shape)

    # remove >10
    arr6 = np.squeeze(np.greater(np.abs(Yv),10).any(axis=3))
    print(arr6.shape)
    #X = np.delete(X,arr6,4)
    #Y = np.delete(Y,arr6,4)
    Xv = Xv[:,:,:,:,~arr6]
    Yv = Yv[:,:,:,:,~arr6]
    print(Xv.shape)
    print(Yv.shape)

    remaining_samples = Xv.shape
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
    Xv = Xv[:,:,:,:,mask]
    Yv = Yv[:,:,:,:,mask]
    #Xv = Xv[:,:,:,:,arr7]
    #Xv = np.delete(X,arr7,axis=4)
    #Yv = np.delete(Y,arr7,axis=4)
    #Yv = Yv[:,:,:,:,arr7]
    print(Xv.shape)
    print(Yv.shape)

    X = np.append(X, Xv, axis=4)
    Y = np.append(Y, Yv, axis=4)


# In[ ]:


print(X.shape)
print(Y.shape)
print(np.amax(X.shape))
print(np.amax(Xv.shape))


# In[ ]:


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
        
        #vec_a = np.reshape(self.X[i,:],(15, 1, 1))
        #vec_b = np.reshape(self.Y[i,:],(15, 1, 1))
        vec_a = self.X[:,:,:,:,i]
        vec_b = self.Y[:,:,:,:,i]
        #vec_a = np.reshape(self.X[i,:],(1, 15, 1))
        #vec_b = np.reshape(self.Y[i,:],(1, 15, 1))
        vec_a = np.transpose(vec_a, (3, 0, 1, 2))
        vec_b = np.transpose(vec_b, (3, 0, 1, 2))
        #a = self.to_tensor(vec_a)
        #b = self.to_tensor(vec_b)
        a = torch.Tensor(vec_a)
        b = torch.Tensor(vec_b.squeeze())
    
        return a,b
    


# In[ ]:


shset = SHDataSet(X,Y)
print(len(shset))


# In[ ]:


print(X.shape)
print(Y.shape)
print(X.dtype)
print(Y.dtype)


# In[ ]:


import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.autograd import Variable

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        #self.fc1 = nn.Linear(3 * 3 * 3 * 15, 600)
        self.cn1 = nn.Conv3d(15,128,kernel_size=(3,3,3),stride=1,padding=(1,1,1))
        #print(self.cn1.shape)
        #self.fc2 = nn.Linear(600,300)
        self.bn = nn.BatchNorm3d(128)
        self.fc2 = nn.Linear(128*3*3*3, 300)
        self.fc3 = nn.Linear(300,60)
        self.fc4 = nn.Linear(60,200)
        self.fc5 = nn.Linear(200,15)
        
    def forward(self, x):
        x = F.relu(self.cn1(x))
        #print(x.shape)
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


# In[ ]:



import torch

def train(model, device, loader, optimizer):
    model.train()

    correct = 0
    total_loss = 0

    for batch_idx, (data, target) in enumerate(loader):
        data, target = Variable(data).float(), Variable(target).float()
        
        optimizer.zero_grad()
        data = data.to(device)
        output = model(data)
        output = output.to(device)
		
        target = target.to(device)
        loss = criterion(output,target)
        total_loss += loss.item()
      
        loss.backward()
        optimizer.step()
        
        print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(epoch, batch_idx*len(data),len(shset.X),100.*batch_idx/len(shset.X),loss.item()))

    avg_loss = total_loss / batch_idx
    print('\tTraining set: Average loss: {:.4f}'.format(avg_loss))
   
    return avg_loss


# In[ ]:


def test(model, device, loader):
    model.eval()

    correct = 0
    total_loss = 0

    for batch_idx, (data, target) in enumerate(loader):
        data, target = Variable(data).float(), Variable(target).float()
		
        data = data.to(device)
        output = model(data)
        output = output.to(device)

        target = target.to(device)
        loss = criterion(output, target)
        total_loss += loss.item()

    avg_loss = total_loss / batch_idx
    print('\tTesting set: Average loss: {:.4f}'.format(avg_loss))

    return avg_loss


# In[ ]:


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

net = net.to(device)

# Creating PT data samplers and loaders:
train_sampler = SubsetRandomSampler(train_indices)
valid_sampler = SubsetRandomSampler(val_indices)

train_loader = DataLoader(shset, batch_size=bs_size, sampler=train_sampler, **kwargs)
validation_loader = DataLoader(shset, batch_size=bs_size, sampler=valid_sampler, **kwargs)


# In[ ]:


import random

#train_loss_file = 'BLAHFCN_PATCH_A2D_SH1200_train_loss_split.txt'
f = open(train_loss_file, 'w')
f.close()
#validate_loss_file = 'BLAHFCN_PATCH_A2D_SH1200_validate_loss_split.txt'
f = open(validate_loss_file, 'w')
f.close()

#model_file = 'BLAHFCN_PATCH_A2D_SH1200_saved_model_split'


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

