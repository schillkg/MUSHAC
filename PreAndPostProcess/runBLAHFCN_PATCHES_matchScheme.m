% run BLAHFCN_PATCHES results
% basically running MatchSchemeGivenSH_rescale for
% all Testing sets

clear; clc; close all;
addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))

%% H

sets = {'H';'L';'M';'N';'O'}

for i = 1:length(sets)
    ii = sets{i}

    % A=>B
    SH1200 = ['BLAHFCN_PATCHES_s' ii '_A2B_SH1200.nii.gz']; SH1200 = load_untouch_nii_gz(SH1200); SH1200 = SH1200.img;
    SH3000 = ['BLAHFCN_PATCHES_s' ii '_A2B_SH3000.nii.gz']; SH3000 = load_untouch_nii_gz(SH3000); SH3000 = SH3000.img;
    nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.nii.gz']
    bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.bvec']
    bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/st/dwi.bval']
    nii_name = ['Results/dwi_' ii '_A2B_PATCHES_rescale.nii.gz']
    orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.nii.gz']
    orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
    MatchSchemeGivenSH_rescale_v2(SH1200,SH3000,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

    % A=>C
    SH1200 = ['BLAHFCN_PATCHES_s' ii '_A2C_SH1200.nii.gz']; SH1200 = load_untouch_nii_gz(SH1200); SH1200 = SH1200.img;
    SH3000 = ['BLAHFCN_PATCHES_s' ii '_A2C_SH3000.nii.gz']; SH3000 = load_untouch_nii_gz(SH3000); SH3000 = SH3000.img;
    nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.nii.gz']
    bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.bvec']
    bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/sa/dwi.bval']
    nii_name = ['Results/dwi_' ii '_A2C_PATCHES_rescale.nii.gz']
    orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2C_noTRnoTE_dwi.nii.gz']
    orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
    MatchSchemeGivenSH_rescale_v2(SH1200,SH3000,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

    % A=>D
    SH1200 = ['BLAHFCN_PATCHES_s' ii '_A2D_SH1200.nii.gz']; SH1200 = load_untouch_nii_gz(SH1200); SH1200 = SH1200.img;
    SH3000 = ['BLAHFCN_PATCHES_s' ii '_A2D_SH3000.nii.gz']; SH3000 = load_untouch_nii_gz(SH3000); SH3000 = SH3000.img;
    nifti_template = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.nii.gz']
    bvec_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.bvec']
    bval_to_match = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/connectom/sa/dwi.bval']
    nii_name = ['Results/dwi_' ii '_A2D_PATCHES_rescale.nii.gz']
    orig_image = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/A2D_noTRnoTE_dwi.nii.gz']
    orig_bval = ['/Volumes/GRAID/Harmonization/Testing_Data/' ii '/prisma/st/noTRnoTE_dwi.bval']
    MatchSchemeGivenSH_rescale_v2(SH1200,SH3000,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)

end
