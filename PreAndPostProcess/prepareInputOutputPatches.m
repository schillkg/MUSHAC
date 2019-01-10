% for a dataset,
addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))
% take the M*N*O*15 SH set of input, with mask
% and if completely within mask
% make 3*3*3*15*X where X is all that apply, for input and output
% output is 1*1*1*15*X
% save as .mat for SH1200 and SH3000

names = {'A','B','C','D','E','F','G','I','J','K'}
names = {'G','I','J','K'}
%names = {'G'}

for blah = 1:length(names)

% input = ['s' names{blah} '/A/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/A/mask.nii.gz']
% output = ['s' names{blah} '/B/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=['s' names{blah} '_A2B_Patches']

% input = ['s' names{blah} '/A/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/C/mask.nii.gz']
% output = ['s' names{blah} '/C/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=['s' names{blah} '_A2C_Patches']

input = ['s' names{blah} '/A/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
mask = ['s' names{blah} '/D/mask.nii.gz']
output = ['s' names{blah} '/D/norm_dwi_SHfitOrder4_EvenOdd2.mat']
savename=['s' names{blah} '_A2D_Patches']

load(input)
iSH1200 = SH1200;
iSH3000 = SH3000;
clear SH1200 SH3000

load(output)
oSH1200 = SH1200;
oSH3000 = SH3000;

mask = load_untouch_nii_gz(mask);
mask = mask.img;

sz = size(iSH1200)

index = 0;
for i=2:sz(1)-1
    for j=2:sz(2)-1
        for k=2:sz(3)-1
            if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
                % if any have nan, inf, abs(>10), don't count
                temp = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                    continue
                end
                %input1200(:,:,:,sz(4),index) = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %input3000(:,:,:,sz(4),index) = iSH3000(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %output1200(1,1,1,sz(4),index) = oSH1200(i,j,k,:);
                %output3000(1,1,1,sz(4),index) = oSH3000(i,j,k,:);
                index = index+1;
            end
        end
    end
end

input1200 = zeros(3,3,3,sz(4),index);
input3000 = zeros(3,3,3,sz(4),index);              
output1200 = zeros(1,1,1,sz(4),index);
output3000 = zeros(1,1,1,sz(4),index);
disp(index)

index2 = 1;
for i=2:sz(1)-1
    for j=2:sz(2)-1
        for k=2:sz(3)-1
            if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
                % if any have nan, inf, abs(>10), don't count
                temp = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                    continue
                end
                input1200(1:3,1:3,1:3,1:sz(4),index2) = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                input3000(:,:,:,1:sz(4),index2) = iSH3000(i-1:i+1,j-1:j+1,k-1:k+1,:);
                output1200(1,1,1,1:sz(4),index2) = oSH1200(i,j,k,:);
                output3000(1,1,1,1:sz(4),index2) = oSH3000(i,j,k,:);
                index2 = index2+1;
            end
        end
    end
end               
   
disp(index2)

input1200 =single(input1200);
input3000 =single(input3000);
output1200 =single(output1200);
output3000 =single(output3000);

save(savename,'-v7','input1200','input3000','output1200','output3000');

end

