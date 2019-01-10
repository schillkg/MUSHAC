% preprocessing

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))


%% 1. normalization
% run the following in every directory:
clear; clc; close all; clear all;
data = 'dwi.nii.gz'; bval = 'dwi.bval'; bvec = 'dwi.bvec';
out_prefix = 'norm'; tr = 'dwi.TR'; te = 'dwi.TE';
PreprocessNormalizeData(data,bval,bvec,out_prefix,tr,te)

%% 2. SH Fit
% run the following in every directory:
addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))

clear; clc; close all;
data = 'norm_dwi.nii.gz';
bval = 'norm_dwi.bval';
bvec = 'norm_dwi.bvec';
out_prefix = 'norm_dwi';
order = 6;
even_or_odd = 2; % 2 for even, 1 for odd
real_or_complex = 'real'; % do not change this
mask = 'mask.nii.gz';
lambda = 0.006; % regularization parameter - do not change

PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
order = 4;
PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)

%% 3. Resize A2C and A2D
% use PreProcessResize.m (actually command line commands)
% these are already normalized (named A2C_norm_dwi.nii.gz and
% A2D_norm_dwi.nii.gz
% just need SH fit on them

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))

clear; clc; close all;
data = 'A/A2C_norm_dwi.nii.gz'; out_prefix = 'A/A2C_norm_dwi';
bval = 'A/norm_dwi.bval'; bvec = 'A/norm_dwi.bvec'; 
order = 6;
even_or_odd = 2; % 2 for even, 1 for odd
real_or_complex = 'real'; % do not change this
mask = 'C/mask.nii.gz';
lambda = 0.006; % regularization parameter - do not change

PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
order = 4;
PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)

clear;
data = 'A/A2D_norm_dwi.nii.gz'; out_prefix = 'A/A2D_norm_dwi';
bval = 'A/norm_dwi.bval'; bvec = 'A/norm_dwi.bvec'; 
order = 6;
even_or_odd = 2; % 2 for even, 1 for odd
real_or_complex = 'real'; % do not change this
mask = 'D/mask.nii.gz';
lambda = 0.006; % regularization parameter - do not change

PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
order = 4;
PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)

% for testing data, slightly different here
clear;
data = 'prisma/st/A2C_norm_dwi.nii.gz'; out_prefix = 'prisma/st/A2C_norm_dwi';
bval = 'prisma/st/norm_dwi.bval'; bvec = 'prisma/st/norm_dwi.bvec'; 
order = 6;
even_or_odd = 2; % 2 for even, 1 for odd
real_or_complex = 'real'; % do not change this
mask = 'prisma/sa/mask.nii.gz';
lambda = 0.006; % regularization parameter - do not change

PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
order = 4;
PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)

clear;
data = 'prisma/st/A2D_norm_dwi.nii.gz'; out_prefix = 'prisma/st/A2D_norm_dwi';
bval = 'prisma/st/norm_dwi.bval'; bvec = 'prisma/st/norm_dwi.bvec'; 
order = 6;
even_or_odd = 2; % 2 for even, 1 for odd
real_or_complex = 'real'; % do not change this
mask = 'connectom/sa/mask.nii.gz';
lambda = 0.006; % regularization parameter - do not change

PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
order = 4;
PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)

%% Take both SH shells and calc FA, MD, PEV, RISH 

SHmatName = 'A/norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'A/mask.nii.gz'
ref_vol = 'A/norm_dwi.nii.gz'
outname = 'A/norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'A/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'C/mask.nii.gz'
ref_vol = 'A/A2C_norm_dwi.nii.gz'
outname = 'A/A2C_norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'A/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'D/mask.nii.gz'
ref_vol = 'A/A2D_norm_dwi.nii.gz'
outname = 'A/A2D_norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'B/norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'B/mask.nii.gz'
ref_vol = 'B/norm_dwi.nii.gz'
outname = 'B/norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'C/norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'C/mask.nii.gz'
ref_vol = 'C/norm_dwi.nii.gz'
outname = 'C/norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'D/norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'D/mask.nii.gz'
ref_vol = 'D/norm_dwi.nii.gz'
outname = 'D/norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

% for testing data:
SHmatName = 'prisma/st/norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'prisma/st/mask.nii.gz'
ref_vol = 'prisma/st/norm_dwi.nii.gz'
outname = 'prisma/st/norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'prisma/st/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'prisma/sa/mask.nii.gz'
ref_vol = 'prisma/st/A2C_norm_dwi.nii.gz'
outname = 'prisma/st/A2C_norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)

SHmatName = 'prisma/st/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat'
mask = 'connectom/sa/mask.nii.gz'
ref_vol = 'prisma/st/A2D_norm_dwi.nii.gz'
outname = 'prisma/st/A2D_norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'
calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)




