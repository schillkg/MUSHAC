function [] = MatchSchemeGivenSH_rescale_v2(SH1200,SH3000,nifti_template,bvec_to_match,bval_to_match,nii_name,orig_image,orig_bval)
% given SH for a volume, and directions, get signal along direction
% inputs:
% desired b-values, desired b-vectors, b1200 SH, b3000 SH
% this code could be run after SH are estimated, in order to transform SH
% to signal with correspdoing B-vals and B-vecs
% _normalize: also normalizes to b0 of original image

% v2 takes SH1200 and SH3000 as input instead of DtoMat file

% DotMat = '/Volumes/GRAID/Harmonization/Testing_Data/H/prisma/st/norm_dwi_SHfitOrder4_EvenOdd2.mat'
% nifti_template = '/Volumes/GRAID/Harmonization/Testing_Data/H/connectom/st/dwi.nii.gz'
% bvec_to_match = '/Volumes/GRAID/Harmonization/Testing_Data/H/connectom/st/dwi.bvec'
% bval_to_match = '/Volumes/GRAID/Harmonization/Testing_Data/H/connectom/st/dwi.bval'
% nii_name = '/Volumes/GRAID/Harmonization/Testing_Data/H/connectom/st/dwi_BALD_rescale.nii.gz'
% 
% orig_image = '/Volumes/GRAID/Harmonization/Testing_Data/H/prisma/st/noTRnoTE_dwi.nii.gz'
% orig_bval = '/Volumes/GRAID/Harmonization/Testing_Data/H/prisma/st/noTRnoTE_dwi.bval'


%%
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))
addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))


%% load

% load(DotMat)
% SH1200 and SH3000

nii = load_untouch_nii_gz(nifti_template);

bvecs = dlmread(bvec_to_match);
bvals = dlmread(bval_to_match);

% nby3
if size(bvecs,2)~=3; bvecs = bvecs'; end

%% orig b0
% read
orig = load_untouch_nii_gz(orig_image);
orig = orig.img;

orig_bvals = dlmread(orig_bval);

b0 = mean(orig(:,:,:,orig_bvals==0),4);


%% 
sz = size(nii.img)
sh_sz = size(SH1200)


bvals0 = find(bvals == 0);
bvals1200 = find(bvals==1200);
bvals3000 = find(bvals==3000);

bvecs1200 = bvecs(bvals1200,:);
bvecs3000 = bvecs(bvals3000,:);

% nby3
%if size(bvecs1200,2)~=3; bvecs1200 = bvecs1200'; end
%if size(bvecs3000,2)~=3; bvecs3000 = bvecs3000'; end


if sh_sz(4) == 15; order = 4; elseif sh_sz(4) == 28; order = 6; end
[sh_sphere1200,~,~] = construct_SH_basis(order, bvecs1200, 2, 'real');
[sh_sphere3000,~,~] = construct_SH_basis(order, bvecs3000, 2, 'real');


%%

img_new = nii.img;
for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 1:sz(3)
            if SH1200(i,j,k,1)~=0
                % for each voxel
                dwi = zeros(sz(4),1);
                SH1200v = squeeze(SH1200(i,j,k,:));
                SH3000v = squeeze(SH3000(i,j,k,:));
                signal1200 = real(sh_sphere1200*SH1200v);
                signal3000 = real(sh_sphere3000*SH3000v);
                dwi([bvals0]) = 1;
                dwi(bvals1200) = signal1200;
                dwi(bvals3000) = signal3000;
                img_new(i,j,k,:) = b0(i,j,k)*dwi;
            end
        end
    end
end

nii.img = img_new;
save_untouch_nii_gz(nii,nii_name);



