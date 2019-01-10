function [] = PreprocessNormalizeData(data,bval,bvec,out_prefix,tr,te)
% Normalize data to b0

% open nifi, bvals, bvecs
% grab b0
% remove extra TR/TE at end of scans
% normalize data to b0, save as array, nifti, with grad, bval

% inputs
% Data, bval, bvec, order, out_prefix, TR, TE, even/odd
%order = 6;
%even_or_odd = 2; % 2 for even, 1 for odd
%real_or_complex = 'real'; % do not change this

%data = 'dwi.nii.gz'
%bval = 'dwi.bval'
%bvec = 'dwi.bvec'
%out_prefix = 'norm';
%tr = 'dwi.TR';
%te = 'dwi.TE';

% requires two toolboxes
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))

% read
nii = load_untouch_nii_gz(data);
bvals = dlmread(bval);
bvecs = dlmread(bvec);
if size(bvecs,2) == 3;
    bvecs = bvecs';
end

TR = dlmread(tr);
TE = dlmread(te);

% eliminate weird TR's TE's
dwi = nii.img;
notKeepTR = find(TR~=TR(1));
notKeepTE = find(TE~=TE(1));
notKeep = unique([notKeepTR notKeepTE]);
dwiR = dwi; bvalsR = bvals; bvecsR = bvecs;
dwiR(:,:,:,notKeep) = [];
bvalsR(notKeep) = [];
bvecsR(:,notKeep) = [];


% check sizes for consistency
if size(dwiR,4) ~= length(bvalsR) || length(bvalsR) ~= size(bvecsR,2) 
    error('sizes off')
end

%% re-save dwi, bval, bvec without additional TR, TE
nii.img = dwiR;
nii.hdr.dime.dim(2:5) = size(dwiR);
save_untouch_nii_gz(nii,['noTRnoTE_' data]);

dlmwrite(['noTRnoTE_' bvec],bvecsR')
dlmwrite(['noTRnoTE_' bval],bvalsR)

%%
    
% normalize
bvecsT = bvecsR';
gradients = bvecsT(bvalsR>0,:);
bvalues = bvalsR(bvalsR>0);

b0 = mean(dwiR(:,:,:,bvalsR==0),4);

dwi_vols = dwiR(:,:,:,bvals>0);
dwi_norm = dwi_vols;

for i = 1:size(dwi_vols,4)
    dwi_vol = squeeze(dwi_vols(:,:,:,i));
    new_dwi_vol = dwi_vol./b0;
    dwi_norm(:,:,:,i) = new_dwi_vol;
end

% save as dwi_norm, gradients, bvals
save([out_prefix '.mat'],'dwi_norm','gradients','bvalues');

% save as nifti, text, text
nii.img = dwi_norm;
nii.hdr.dime.dim(2:5) = size(dwi_norm);
save_untouch_nii_gz(nii,[out_prefix '_' data]);

dlmwrite([out_prefix '_' bvec],gradients)
dlmwrite([out_prefix '_' bval],bvalues)


disp('done')

















