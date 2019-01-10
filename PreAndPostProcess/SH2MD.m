function MD = SH2MD(SH,bval)
% given SH and bval, calculate FA for individual voxel


addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))


load('Jones60.mat')


dirs = g';
full_dirs = [0 0 0; dirs];

sh_length = length(SH);
if sh_length == 15; order = 4; elseif sh_length == 28; order = 6; end
[sh_sphere,~,~] = construct_SH_basis(order, dirs, 2, 'real');


bvals = [];
bvals(1) = 0;
bvals = [bvals bval*ones(1,length(g))];

% Create b-matrix [n 6]
%gg = [g(:,1).^2 2*g(:,1).*g(:,2) 2*g(:,1).*g(:,3) g(:,2).^2 2*g(:,2).*g(:,3) g(:,3).^2];
%b = bsxfun(@times,bval,gg);
gg = [full_dirs(:,1).^2 2*full_dirs(:,1).*full_dirs(:,2) 2*full_dirs(:,1).*full_dirs(:,3) full_dirs(:,2).^2 2*full_dirs(:,2).*full_dirs(:,3) full_dirs(:,3).^2];
b = bsxfun(@times,bvals',gg);

b2 = [ones(length(bvals),1) -b];

% % calc RISH here
% RISH1200_C0(i,j,k) = calcRISH(SHlow,0);
% RISH1200_C2(i,j,k) = calcRISH(SHlow,2);
% RISH1200_C4(i,j,k) = calcRISH(SHlow,4);
% RISH3000_C0(i,j,k) = calcRISH(SHlow,0);
% RISH3000_C2(i,j,k) = calcRISH(SHlow,2);
% RISH3000_C4(i,j,k) = calcRISH(SHlow,4);
% %
                
ODlow = real(sh_sphere * SH);
dwi = squeeze([1 ODlow'])';
covar = diag(dwi.^2);
X = inv(b2'*covar*b2)*(b2'*covar)*log(dwi);
%fit = exp(b2*X);
%resid = abs(fit - dwi);
%DWIB0(i,j,k) = fit(1);
DT = single(X(2:end));
vD = [DT(1) DT(2) DT(3); DT(2) DT(4) DT(5); DT(3) DT(5) DT(6)];
[~, MD, ~]= calcFAMDPEV(double(vD));
              
               
                
               