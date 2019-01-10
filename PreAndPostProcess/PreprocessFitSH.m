function [] = PreprocessFitSH(data,bval,bvec,out_prefix,order,even_or_odd,real_or_complex,mask,lambda)
% take normalized data, fit to X order spherical harmonics, save as matrix, nifti


% data = 'norm_dwi.nii.gz';
% bval = 'norm_dwi.bval';
% bvec = 'norm_dwi.bvec';
% out_prefix = 'norm_dwi';
% order = 6;
% even_or_odd = 2; % 2 for even, 1 for odd
% real_or_complex = 'real'; % do not change this
% %out_prefix = 'norm';
% %tr = 'dwi.TR';
% %te = 'dwi.TE';
% mask = 'mask.nii.gz';
% lambda = 0.006; % regularization parameter - do not change

%% toolboxes
% requires two toolboxes
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))


%% load

nii = load_untouch_nii_gz(data); volumes = nii.img;
bvals = dlmread(bval);
bvecs = dlmread(bvec);

if exist(mask)~=0
    mask = load_untouch_nii_gz(mask); mask = mask.img;
else
    disp('mask doesnt exist haha')
    mask = ones(size(volumes,1),size(volumes,2),size(volumes,3));
end

a = unique(bvals);

%% fit
% for each b-value
% loop through volume (where mask ==1), fit to SH, save as matrix

low_index = find(bvals==1200);
dirs_low = bvecs(low_index,:);
vols_low = volumes(:,:,:,low_index);

high_index = find(bvals==3000);
dirs_high = bvecs(high_index,:);
vols_high = volumes(:,:,:,high_index);

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

SH1200 = zeros(sz(1),sz(2),sz(3),co);
SH3000 = zeros(sz(1),sz(2),sz(3),co);

%% set up for 1200
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

%% set up for 3000

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


%% fit

for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 1:sz(3)
            if mask(i,j,k) == 1
                signal1200 = squeeze(vols_low(i,j,k,:));
                %sh_series1200 = SH_Fit_all(signal1200,dirs_low,order,lambda,real_or_complex,even_or_odd);
                % figure; showSH(sh_series1200,order,100,real_or_complex,even_or_odd)
                % SH1200(i,j,k,:) = sh_series1200;
                
                signal3000 = squeeze(vols_high(i,j,k,:));
                %sh_series3000 = SH_Fit_all(signal3000,dirs_high,order,lambda,real_or_complex,even_or_odd);
                % figure; showSH(sh_series3000,order,100,real_or_complex,even_or_odd)
                % SH3000(i,j,k,:) = sh_series3000;
                
                % Reconstruct signal with spherical harmonic coefficients using regularized fit
                sh_series1200 = (basis'*basis + lambda*L)\basis'*squeeze(signal1200);
                SH1200(i,j,k,:) = sh_series1200;
                
                sh_series3000 = (basis3000'*basis3000 + lambda*L3000)\basis3000'*squeeze(signal3000);
                SH3000(i,j,k,:) = sh_series3000;
                
            end
        end
    end
end

%% save
% save as dwi_norm, gradients, bvals
save([out_prefix '_SHfitOrder' num2str(order) '_EvenOdd' num2str(even_or_odd) '.mat'],'SH1200','SH3000');

nii.img = single(SH1200);
nii.hdr.dime.dim(2:5) = size(SH1200);
save_untouch_nii_gz(nii,[out_prefix '_SHfitOrder' num2str(order) '_EvenOdd' num2str(even_or_odd) '_SH1200.nii.gz']);

nii.img = single(SH3000);
nii.hdr.dime.dim(2:5) = size(SH3000);
save_untouch_nii_gz(nii,[out_prefix '_SHfitOrder' num2str(order) '_EvenOdd' num2str(even_or_odd) '_SH3000.nii.gz']);

disp('done')








