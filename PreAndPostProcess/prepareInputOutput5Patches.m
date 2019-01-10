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
%names = {'G','I','J','K'}
%names = {'G'}

for blah = 1:length(names)

input = ['s' names{blah} '/A/norm_dwi_SHfitOrder4_EvenOdd2.mat']
mask = ['s' names{blah} '/A/mask.nii.gz']
output = ['s' names{blah} '/B/norm_dwi_SHfitOrder4_EvenOdd2.mat']
labelname = ['/Volumes/GRAID/Harmonization/SLANT/Train_s' names{blah} '_PRISMA-MPRAGE_seg_2AB.nii.gz']
savename=['s' names{blah} '_A2B_5Patches']

% input = ['s' names{blah} '/A/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/C/mask.nii.gz']
% output = ['s' names{blah} '/C/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% labelname = ['/Volumes/GRAID/Harmonization/SLANT/Train_s' names{blah} '_PRISMA-MPRAGE_seg_2C.nii.gz']
% savename=['s' names{blah} '_A2C_5Patches']

% input = ['s' names{blah} '/A/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/D/mask.nii.gz']
% output = ['s' names{blah} '/D/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% labelname = ['/Volumes/GRAID/Harmonization/SLANT/Train_s' names{blah} '_PRISMA-MPRAGE_seg_2D.nii.gz']
% savename=['s' names{blah} '_A2D_5Patches']

load(input)
iSH1200 = SH1200;
iSH3000 = SH3000;
clear SH1200 SH3000

load(output)
oSH1200 = SH1200;
oSH3000 = SH3000;

mask = load_untouch_nii_gz(mask);
mask = mask.img;
labels = load_untouch_nii_gz(labelname);
labels = labels.img;

sz = size(iSH1200)

index = 0;
for i=3:sz(1)-2
    for j=3:sz(2)-2
        for k=3:sz(3)-2
            %if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
            if mask(i,j,k)==1
                % if any have nan, inf, abs(>10), don't count
                temp = iSH1200(i-2:i+2,j-2:j+2,k-2:k+2,:);
                if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                    continue
                end
                temp = iSH3000(i-2:i+2,j-2:j+2,k-2:k+2,:);
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

input1200 = zeros(5,5,5,sz(4),index);
input3000 = zeros(5,5,5,sz(4),index);
labelsinput = zeros(5,5,5,1,index);        
output1200 = zeros(1,1,1,sz(4),index);
output3000 = zeros(1,1,1,sz(4),index);
disp(index)

index2 = 1;
for i=3:sz(1)-2
    for j=3:sz(2)-2
        for k=3:sz(3)-2
            %if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
            if mask(i,j,k)==1
                % if any have nan, inf, abs(>10), don't count
                temp = iSH1200(i-2:i+2,j-2:j+2,k-2:k+2,:);
                if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                    continue
                end
                temp = iSH3000(i-2:i+2,j-2:j+2,k-2:k+2,:);
                if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                    continue
                end
                
                input1200(:,:,:,1:sz(4),index2) = iSH1200(i-2:i+2,j-2:j+2,k-2:k+2,:);
                input3000(:,:,:,1:sz(4),index2) = iSH3000(i-2:i+2,j-2:j+2,k-2:k+2,:);
                output1200(1,1,1,1:sz(4),index2) = oSH1200(i,j,k,:);
                output3000(1,1,1,1:sz(4),index2) = oSH3000(i,j,k,:);
                
                labelsinput(:,:,:,1,index2) = labels(i-2:i+2,j-2:j+2,k-2:k+2);
                
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

input1200_row1 = input1200(1,:,:,:,:);
input1200_row2 = input1200(2,:,:,:,:);
input1200_row3 = input1200(3,:,:,:,:);
input1200_row4 = input1200(4,:,:,:,:);
input1200_row5 = input1200(5,:,:,:,:);
% input1200_row6 = input1200(6,:,:,:,:);
% input1200_row7 = input1200(7,:,:,:,:);

input3000_row1 = input3000(1,:,:,:,:);
input3000_row2 = input3000(2,:,:,:,:);
input3000_row3 = input3000(3,:,:,:,:);
input3000_row4 = input3000(4,:,:,:,:);
input3000_row5 = input3000(5,:,:,:,:);
% input3000_row6 = input3000(6,:,:,:,:);
% input3000_row7 = input3000(7,:,:,:,:);

% labels_row14 = labelsinput(1:4,:,:,:,:);
% labels_row57 = labelsinput(5:7,:,:,:,:);

save(savename,'-v7','input1200_row1','input1200_row2','input1200_row3','input1200_row4', ...
    'input1200_row5','input3000_row1','input3000_row2','input3000_row3','input3000_row4', ... 
    'input3000_row5','output1200','output3000','labelsinput');

% save(savename,'-v7','input1200','input3000','output1200','output3000');

end

