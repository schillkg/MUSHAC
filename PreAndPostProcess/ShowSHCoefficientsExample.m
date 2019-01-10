% Example to show SH coefficients over a volume

clear; clc; close all;
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))
addpath(genpath('/Volumes/schillkg/MATLAB/dwmri_visualizer_v1_1_0'))

dwmri_vol = load_untouch_nii_gz('dwi.nii.gz'); dwmri_vol = dwmri_vol.img;
dwmri_vol = dwmri_vol(:,:,:,1);
%bvals = dlmread('dwi.bval');
bvals = 1;
sh_coefs_vol = load_untouch_nii_gz('norm_dwi_SHfitOrder6_EvenOdd2_SH1200.nii.gz','double'); sh_coefs_vol = sh_coefs_vol.img;
mask_vol = nifti_utils.load_untouch_nii_vol_scaled('mask.nii.gz','logical');
xform_RAS = nifti_utils.get_voxel_RAS_xform('dwi.nii.gz');
%xform_RAS = [1 0 0; 0 1 0; 0 0 1];

% Get visualizer
dv = dwmri_visualizer({sh_coefs_vol,dwmri_vol}, mask_vol, xform_RAS, 'sh_coefs', {bvals,6,20,false});
dv.plot_slice(59,'coronal','slice',1); axis equal;
dv.plot_slice(30,'axial','slice',1); axis equal;

sh_coefs_vol = load_untouch_nii_gz('norm_dwi_SHfitOrder6_EvenOdd2_SH3000.nii.gz','double'); sh_coefs_vol = sh_coefs_vol.img;
dv = dwmri_visualizer({sh_coefs_vol,dwmri_vol}, mask_vol, xform_RAS, 'sh_coefs', {bvals,6,20,false});
dv.plot_slice(59,'coronal','slice',1); axis equal;
dv.plot_slice(30,'axial','slice',1); axis equal;

%% testing

% Get visualizer
dv = dwmri_visualizer({sh_coefs_vol,dwmri_vol}, mask_vol, xform_RAS, 'sh_coefs', {bvals,6,20,false});
dv.plot_slice(100,'coronal','slice',1); axis equal;
dv.plot_slice(48,'axial','slice',1); axis equal;

sh_coefs_vol = load_untouch_nii_gz('norm_dwi_SHfitOrder6_EvenOdd2_SH3000.nii.gz','double'); sh_coefs_vol = sh_coefs_vol.img;
dv = dwmri_visualizer({sh_coefs_vol,dwmri_vol}, mask_vol, xform_RAS, 'sh_coefs', {bvals,6,20,false});
dv.plot_slice(100,'coronal','slice',1); axis equal;
dv.plot_slice(48,'axial','slice',1); axis equal;



% Get visualizer
dv = dwmri_visualizer({sh_coefs_vol,dwmri_vol}, mask_vol, xform_RAS, 'sh_coefs', {bvals,6,20,false});
dv.plot_slice(100,'coronal','slice',1); axis equal;
dv.plot_slice(60,'axial','slice',1); axis equal;
