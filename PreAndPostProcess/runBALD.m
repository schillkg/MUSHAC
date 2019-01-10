% run BALD
% basically running MatchSchemeGivenSH and MatchSchemeGivenSH_rescale for
% all Testing sets

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
%% A to see if it looks correct for all 3 cases
% clear; clc; close all;

sets = {'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'}
% % A=>B
for i = 1:length(sets)
    ii = sets{i}

DotMat = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/B/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/B/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/B/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/B/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/B/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

% A=>C
DotMat = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/C/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/C/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/C/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/C/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/C/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/A2C_noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

% A=>D
DotMat = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/D/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/D/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/D/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/D/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/D/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/A2D_noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Train_Data/' ii '/A/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

end


%% H
clear; clc; close all;

sets = {'H';'L';'M';'N';'O'}

for i = 1:length(sets)
    ii = sets{i}

    % A=>B
DotMat = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/H/connectom/st/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

% A=>C
DotMat = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2C_noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

% A=>D
DotMat = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.nii.gz']
bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.bvec']
bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.bval']
nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi_BALD.nii.gz']
MatchSchemeGivenSH(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name)

nii_name = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi_BALD_rescale.nii.gz']
orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2D_noTRnoTE_dwi.nii.gz']
orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
MatchSchemeGivenSH_rescale(DotMat,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

end


