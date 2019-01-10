function [] = calcFAMDRISHFrom2SHand2Bvals_volume(SHmatName,mask,ref_vol,outname)
% given 2bvals and 2bvecs, calculate FA, MD, RISH for invidiual voxel


% load SH1200
% load SH3000

% evaluate both of 60 directions
% SHmatName = 'norm_dwi_SHfitOrder4_EvenOdd2.mat'
% mask = 'mask.nii.gz'
% ref_vol = 'norm_dwi.nii.gz' % volume space to save in
% outname = 'norm_dwi_SHfitOrder4_EvenOdd2_b1200b3000_metrics'

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))


load(SHmatName)
load('Jones60.mat')
dirs = g';
full_dirs = [0 0 0; dirs; dirs];

%mask = load_untouch_nii_gz(mask); mask = mask.img;
nii = load_untouch_nii_gz(ref_vol);

% want to evaluate each SHseries over 60 directions place in volumes
sz = size(SH1200);

if exist(mask)~=0
    mask = load_untouch_nii_gz(mask); mask = mask.img;
else
    disp('mask doesnt exist haha')
    mask = ones(sz(1),sz(2),sz(3));
end

if sz(4) == 15; order = 4; elseif sz(4) == 28; order = 6; end
[sh_sphere,~,~] = construct_SH_basis(order, dirs, 2, 'real');

DWI = zeros(sz(1),sz(2),sz(3),2*length(g)+1);
RISH1200_C0 = zeros(sz(1),sz(2),sz(3));
RISH1200_C2 = zeros(sz(1),sz(2),sz(3));
RISH1200_C4 = zeros(sz(1),sz(2),sz(3));
RISH3000_C0 = zeros(sz(1),sz(2),sz(3));
RISH3000_C2 = zeros(sz(1),sz(2),sz(3));
RISH3000_C4 = zeros(sz(1),sz(2),sz(3));
FAmap = zeros(sz(1),sz(2),sz(3));
MDmap = zeros(sz(1),sz(2),sz(3));
PEVmap = zeros(sz(1),sz(2),sz(3),3);

DWI(:,:,:,1) = double(mask);
bvals = [];
bvals(1) = 0;
bvals = [bvals 1200*ones(1,length(g)) 3000*ones(1,length(g))];

% Create b-matrix [n 6]
%gg = [g(:,1).^2 2*g(:,1).*g(:,2) 2*g(:,1).*g(:,3) g(:,2).^2 2*g(:,2).*g(:,3) g(:,3).^2];
%b = bsxfun(@times,bval,gg);
gg = [full_dirs(:,1).^2 2*full_dirs(:,1).*full_dirs(:,2) 2*full_dirs(:,1).*full_dirs(:,3) full_dirs(:,2).^2 2*full_dirs(:,2).*full_dirs(:,3) full_dirs(:,3).^2];
b = bsxfun(@times,bvals',gg);
b2 = [ones(size(DWI,4),1) -b];

for i = 1:sz(1)
    i
    for j = 1:sz(2)
        for k = 1:sz(3)
            if mask(i,j,k) == 1
                try
                SHlow = squeeze(SH1200(i,j,k,:));
                SHhigh = squeeze(SH3000(i,j,k,:));
                % calc RISH here
                RISH1200_C0(i,j,k) = calcRISH(SHlow,0);
                RISH1200_C2(i,j,k) = calcRISH(SHlow,2);
                RISH1200_C4(i,j,k) = calcRISH(SHlow,4);
                RISH3000_C0(i,j,k) = calcRISH(SHlow,0);
                RISH3000_C2(i,j,k) = calcRISH(SHlow,2);
                RISH3000_C4(i,j,k) = calcRISH(SHlow,4);
                %
                
                ODlow = real(sh_sphere * SHlow);
                ODhigh = real(sh_sphere * SHhigh);
                % DWI(i,j,k,2:end) = [ODlow' ODhigh'];
                dwi = squeeze([1 ODlow' ODhigh'])';
                covar = diag(dwi.^2);
                X = inv(b2'*covar*b2)*(b2'*covar)*log(dwi);
                %fit = exp(b2*X);
                %resid = abs(fit - dwi);
                %DWIB0(i,j,k) = fit(1);
                DT = single(X(2:end));
                vD = [DT(1) DT(2) DT(3); DT(2) DT(4) DT(5); DT(3) DT(5) DT(6)];
                [FA, MD, PEV]= calcFAMDPEV(double(vD));
                FAmap(i,j,k) = FA;
                MDmap(i,j,k) = MD;
                PEVmap(i,j,k,:) = PEV;
                catch
                    disp('error')
                end
            end
        end
    end
end

FAmap = real(FAmap);
MDmap = real(MDmap);
PEVmap = real(PEVmap);

% save as .mat matrix and nifti files
save([outname '.mat'],'FAmap','MDmap','PEVmap','RISH1200_C0','RISH1200_C2','RISH1200_C4','RISH3000_C0','RISH3000_C2','RISH3000_C4');

nii.img = single(FAmap);
nii.hdr.dime.dim(2:4) = size(FAmap);
nii.hdr.dime.dim(5) = 1;
save_untouch_nii_gz(nii,[outname '_FA.nii.gz']);

nii.img = single(MDmap);
nii.hdr.dime.dim(2:4) = size(MDmap);
nii.hdr.dime.dim(5) = 1;
save_untouch_nii_gz(nii,[outname '_MD.nii.gz']);

% nii.img = single(PEVmap);
% nii.hdr.dime.dim(2:5) = size(PEVmap);
% save_untouch_nii_gz(nii,[outname '_PEV.nii.gz']);
% 
% nii.img = single(RISH1200_C0);
% nii.hdr.dime.dim(2:4) = size(RISH1200_C0);
% nii.hdr.dime.dim(5) = 1;
% save_untouch_nii_gz(nii,[outname '_RISH1200_C0.nii.gz']);
% 
% nii.img = single(RISH1200_C2);
% nii.hdr.dime.dim(2:4) = size(RISH1200_C2);
% nii.hdr.dime.dim(5) = 1;
% save_untouch_nii_gz(nii,[outname '_RISH1200_C2.nii.gz']);
% 
% 
% nii.img = single(RISH1200_C4);
% nii.hdr.dime.dim(2:4) = size(RISH1200_C4);
% nii.hdr.dime.dim(5) = 1;
% save_untouch_nii_gz(nii,[outname '_RISH1200_C4.nii.gz']);

disp('done')


































