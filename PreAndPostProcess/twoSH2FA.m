function FA = twoSH2FA(SH1,bval1,SH2,bval2)
% given 2bvals and 2bvecs, calculate FA

addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))


load('Jones60.mat')
dirs = g';
full_dirs = [0 0 0; dirs; dirs];

sh_length = length(SH1);
if sh_length == 15; order = 4; elseif sh_length == 28; order = 6; end
[sh_sphere,~,~] = construct_SH_basis(order, dirs, 2, 'real');

bvals = [];
bvals(1) = 0;
bvals = [bvals bval1*ones(1,length(g)) bval2*ones(1,length(g))];

gg = [full_dirs(:,1).^2 2*full_dirs(:,1).*full_dirs(:,2) 2*full_dirs(:,1).*full_dirs(:,3) full_dirs(:,2).^2 2*full_dirs(:,2).*full_dirs(:,3) full_dirs(:,3).^2];
b = bsxfun(@times,bvals',gg);

b2 = [ones(length(bvals),1) -b];

ODlow = real(sh_sphere * SH1);
ODhigh = real(sh_sphere * SH2);
% DWI(i,j,k,2:end) = [ODlow' ODhigh'];
dwi = squeeze([1 ODlow' ODhigh'])';
covar = diag(dwi.^2);
X = inv(b2'*covar*b2)*(b2'*covar)*log(dwi);
%fit = exp(b2*X);
%resid = abs(fit - dwi);
%DWIB0(i,j,k) = fit(1);
DT = single(X(2:end));
vD = [DT(1) DT(2) DT(3); DT(2) DT(4) DT(5); DT(3) DT(5) DT(6)];
[FA, ~, ~]= calcFAMDPEV(double(vD));


