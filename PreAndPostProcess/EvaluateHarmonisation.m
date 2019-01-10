function [Truth, Estimated] = EvaluateHarmonisation(t_data,t_bval,t_bvec,t_tr,t_te,e_data,masknii)
% FAtrue,FAest,MDtrue,MDest,RISH0true,est,RISH2true,est,RISH4true,est,mask
% typically want to do NMSE (true-est)^2/true^2 vectors
% this will only work on Training_Data (have TR/TE disrepancy)

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))
order = 4; lambda = 0.006;

%% inputs
% t_data = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi.nii.gz'
% t_bval = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi.bval'
% t_bvec = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi.bvec'
% t_tr = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi.TR';
% t_te = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi.TE';
% 
% e_data = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/dwi_BALD.nii.gz'
% 
% masknii = '/Volumes/GRAID/Harmonization/Train_Data/sA/B/mask.nii.gz';

%% REMOVE TR/TE

nii = load_untouch_nii_gz(t_data);
e_nii = load_untouch_nii_gz(e_data);
mask = load_untouch_nii_gz(masknii); mask = mask.img;

bvals = dlmread(t_bval);
bvecs = dlmread(t_bvec);
if size(bvecs,2) == 3;
    bvecs = bvecs';
end

TR = dlmread(t_tr);
TE = dlmread(t_te);

% eliminate weird TR's TE's
t_dwi = nii.img;
e_dwi = e_nii.img;

notKeepTR = find(TR~=TR(1));
notKeepTE = find(TE~=TE(1));
notKeep = unique([notKeepTR notKeepTE]);
dwiR = t_dwi; bvalsR = bvals; bvecsR = bvecs; dwiR_ = e_dwi;
dwiR(:,:,:,notKeep) = []; dwiR_(:,:,:,notKeep) = [];
bvalsR(notKeep) = [];
bvecsR(:,notKeep) = [];

g = bvecsR; b = bvalsR;
if size(g,2) ~= 3
    g = g';
end

% check sizes for consistency
if size(dwiR,4) ~= length(bvalsR) || length(bvalsR) ~= size(bvecsR,2) || size(dwiR,4) ~= size(dwiR_,4)
    error('sizes off')
end


%% fit FA, MD

sz = size(dwiR);

gg = [g(:,1).^2 2*g(:,1).*g(:,2) 2*g(:,1).*g(:,3) g(:,2).^2 2*g(:,2).*g(:,3) g(:,3).^2];
bmat = bsxfun(@times,b(:),gg);
b2 = [ones(sz(4),1) -bmat];

% loop, calculate DTI measures
FAtrue = zeros(sz(1),sz(2),sz(3));
MDtrue = zeros(sz(1),sz(2),sz(3));
FAest = zeros(sz(1),sz(2),sz(3));
MDest = zeros(sz(1),sz(2),sz(3));

for i = 1:sz(1)
    i
    for j = 1:sz(2)
        for k = 1:sz(3)
            if mask(i,j,k) == 1
                try
                
                dwi_est = squeeze(dwiR_(i,j,k,:));
                dwi_true = squeeze(dwiR(i,j,k,:));
                
                dwi = dwi_est; dwi(dwi==0)=5e-4;
                covar = diag(dwi.^2);
                X = inv(b2'*covar*b2)*(b2'*covar)*log(dwi);
                DT = single(X(2:end));
                vD = [DT(1) DT(2) DT(3); DT(2) DT(4) DT(5); DT(3) DT(5) DT(6)];
                [FA, MD, ~]= calcFAMDPEV(double(vD));
                FAest(i,j,k) = FA;
                MDest(i,j,k) = MD;
                
                dwi = dwi_true; dwi(dwi==0)=5e-4;
                covar = diag(dwi.^2);
                X = inv(b2'*covar*b2)*(b2'*covar)*log(dwi);
                DT = single(X(2:end));
                vD = [DT(1) DT(2) DT(3); DT(2) DT(4) DT(5); DT(3) DT(5) DT(6)];
                [FA, MD, ~]= calcFAMDPEV(double(vD));
                FAtrue(i,j,k) = FA;
                MDtrue(i,j,k) = MD;
                
                catch
                    disp('error')
                end
            end
        end
    end
end

FAtrue = real(FAtrue);
MDtrue = real(MDtrue);
FAest = real(FAest);
MDest = real(MDest);

%% normalize

b0 = mean(dwiR(:,:,:,b==0),4);
b0_ = mean(dwiR_(:,:,:,b==0),4);

for i = 1:sz(4)
    dwi_vol = squeeze(dwiR(:,:,:,i));
    new_dwi_vol = dwi_vol./b0;
    dwi_norm(:,:,:,i) = new_dwi_vol;
    
    dwi_vol = squeeze(dwiR_(:,:,:,i));
    new_dwi_vol = dwi_vol./b0_;
    dwi_norm_(:,:,:,i) = new_dwi_vol;
end

%% fit SH, calc RISH

low_index = find(b==1200);
dirs_low = g(low_index,:);
vols_low = dwi_norm(:,:,:,low_index);
vols_low_ = dwi_norm_(:,:,:,low_index);

high_index = find(b==3000);
dirs_high = g(high_index,:);
vols_high = dwi_norm(:,:,:,high_index);
vols_high_ = dwi_norm_(:,:,:,high_index);

even_or_odd = 1; real_or_complex = 'real';
% size of output
if  even_or_odd==1
    co =(order + 1)*(order + 1);  %% k is the # of coefficients
else
    if even_or_odd==2
        co =(order + 2)*(order + 1)/2;  %% k is the # of coefficients
    else
        error('even_or_odd can only be 1 or 2');
    end
end

sz = size(vols_low);

SH1200true = zeros(sz(1),sz(2),sz(3),co);
SH3000true = zeros(sz(1),sz(2),sz(3),co);
SH1200est = zeros(sz(1),sz(2),sz(3),co);
SH3000est = zeros(sz(1),sz(2),sz(3),co);

% set up for 1200
if any(size(dirs_low)==3)
    if size(dirs_low,2) ~=3
        dirs_low = dirs_low';
    else
        dirs_low = dirs_low;
    end
else
    error('DIRECTIONS ARE NOT DEFINED ON R3')
end

% Legendre Polynomial
P0 = []; Laplac2 = [];
for L=0:even_or_odd:order
    for m=-L:L
        Pnm = legendre(L, 0); factor1 = Pnm(1);
        P0 = [P0; factor1];
        Laplac2 = [Laplac2; (L^2)*(L + 1)^2];
    end
end
L = diag(Laplac2);
[basis,~,~] = construct_SH_basis(order,dirs_low,even_or_odd,real_or_complex);

% set up for 3000
if any(size(dirs_high)==3)
    if size(dirs_high,2) ~=3
        dirs_high = dirs_high';
    else
        dirs_high = dirs_high;
    end
else
    error('DIRECTIONS ARE NOT DEFINED ON R3')
end

% Legendre Polynomial
P0 = []; Laplac2 = [];
for L=0:even_or_odd:order
    for m=-L:L
        Pnm = legendre(L, 0); factor1 = Pnm(1);
        P0 = [P0; factor1];
        Laplac2 = [Laplac2; (L^2)*(L + 1)^2];
    end
end
L3000 = diag(Laplac2);
[basis3000,~,~] = construct_SH_basis(order,dirs_high,even_or_odd,real_or_complex);

RISH1200_C0true = zeros(sz(1),sz(2),sz(3));
RISH1200_C2true = zeros(sz(1),sz(2),sz(3));
RISH1200_C4true = zeros(sz(1),sz(2),sz(3));
RISH3000_C0true = zeros(sz(1),sz(2),sz(3));
RISH3000_C2true = zeros(sz(1),sz(2),sz(3));
RISH3000_C4true = zeros(sz(1),sz(2),sz(3));
RISH1200_C0est = zeros(sz(1),sz(2),sz(3));
RISH1200_C2est = zeros(sz(1),sz(2),sz(3));
RISH1200_C4est = zeros(sz(1),sz(2),sz(3));
RISH3000_C0est = zeros(sz(1),sz(2),sz(3));
RISH3000_C2est = zeros(sz(1),sz(2),sz(3));
RISH3000_C4est = zeros(sz(1),sz(2),sz(3));

for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 1:sz(3)
            if mask(i,j,k) == 1
                
                signal1200 = squeeze(vols_low(i,j,k,:));
                signal3000 = squeeze(vols_high(i,j,k,:));
                sh_series1200 = (basis'*basis + lambda*L)\basis'*squeeze(signal1200);
                SH1200true(i,j,k,:) = sh_series1200;
                RISH1200_C0true(i,j,k) = SH2RISH(sh_series1200,0);
                RISH1200_C2true(i,j,k) = SH2RISH(sh_series1200,2);
                RISH1200_C4true(i,j,k) = SH2RISH(sh_series1200,4);
                sh_series3000 = (basis3000'*basis3000 + lambda*L3000)\basis3000'*squeeze(signal3000);
                SH3000true(i,j,k,:) = sh_series3000;
                RISH3000_C0true(i,j,k) = SH2RISH(sh_series3000,0);
                RISH3000_C2true(i,j,k) = SH2RISH(sh_series3000,2);
                RISH3000_C4true(i,j,k) = SH2RISH(sh_series3000,4);
                
                signal1200 = squeeze(vols_low_(i,j,k,:));
                signal3000 = squeeze(vols_high_(i,j,k,:));
                sh_series1200 = (basis'*basis + lambda*L)\basis'*squeeze(signal1200);
                SH1200est(i,j,k,:) = sh_series1200;
                RISH1200_C0est(i,j,k) = SH2RISH(sh_series1200,0);
                RISH1200_C2est(i,j,k) = SH2RISH(sh_series1200,2);
                RISH1200_C4est(i,j,k) = SH2RISH(sh_series1200,4);
                sh_series3000 = (basis3000'*basis3000 + lambda*L3000)\basis3000'*squeeze(signal3000);
                SH3000est(i,j,k,:) = sh_series3000;
                RISH3000_C0est(i,j,k) = SH2RISH(sh_series3000,0);
                RISH3000_C2est(i,j,k) = SH2RISH(sh_series3000,2);
                RISH3000_C4est(i,j,k) = SH2RISH(sh_series3000,4);
            end
        end
    end
end





Truth = struct;
Estimated = struct;


Truth.FA = FAtrue;
Truth.MD = MDtrue;
Truth.SH1200 = SH1200true;
Truth.SH3000 = SH3000true;
Truth.C0_12000 = RISH1200_C0true;
Truth.C2_12000 = RISH1200_C2true;
Truth.C4_12000 = RISH1200_C4true;
Truth.C0_30000 = RISH3000_C0true;
Truth.C2_30000 = RISH3000_C2true;
Truth.C4_30000 = RISH3000_C4true;
Truth.mask = mask;

Estimated.FA = FAest;
Estimated.MD = MDest;
Estimated.SH1200 = SH1200est;
Estimated.SH3000 = SH3000est;
Estimated.C0_12000 = RISH1200_C0est;
Estimated.C2_12000 = RISH1200_C2est;
Estimated.C4_12000 = RISH1200_C4est;
Estimated.C0_30000 = RISH3000_C0est;
Estimated.C2_30000 = RISH3000_C2est;
Estimated.C4_30000 = RISH3000_C4est;



end



