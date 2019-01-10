% for a dataset,
addpath(genpath('/Volumes/schillkg/SchillingScripts/Harmonization_Scripts'))
addpath(genpath('/Volumes/schillkg/MATLAB/spherical_harmonics'))
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306'))
% take the M*N*O*15 SH set of input, with mask
% and if completely within mask
% make 3*3*3*15*X where X is all that apply, for input and output
% output is 1*1*1*15*X
% save as .mat for SH1200 and SH3000

names = {'H','L','M','N','O'}

for blah = 1:length(names)

% input = [names{blah} '/prisma/st/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% %mask = [names{blah} '/A/mask.nii.gz']
% %output = [names{blah} '/B/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=[names{blah} '_A2B_Patches']

% input = ['s' names{blah} '/A/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/C/mask.nii.gz']
% output = ['s' names{blah} '/C/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=['s' names{blah} '_A2C_Patches']

% input = ['s' names{blah} '/A/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% mask = ['s' names{blah} '/D/mask.nii.gz']
% output = ['s' names{blah} '/D/norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=['s' names{blah} '_A2D_Patches']

input = [names{blah} '/prisma/st/norm_dwi_SHfitOrder4_EvenOdd2.mat']
savename=[names{blah} '_A2B_5Patches']

load(input)
iSH1200 = SH1200;
iSH3000 = SH3000;
clear SH1200 SH3000

sz = size(iSH1200)



input1200 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));
input3000 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));              
output1200 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));
output3000 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));


index2 = 1;
for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            %if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
                % if any have nan, inf, abs(>10), don't count
                if i==1 || j==1 || k==1 || i==sz(1) || j==sz(2) || k==sz(3)
                    index2=index2+1;
                    continue
                else
                temp = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                %    continue
                %end
                input1200(1:3,1:3,1:3,1:sz(4),index2) = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                input3000(:,:,:,1:sz(4),index2) = iSH3000(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %output1200(1,1,1,1:sz(4),index2) = oSH1200(i,j,k,:);
                %output3000(1,1,1,1:sz(4),index2) = oSH3000(i,j,k,:);
                index2 = index2+1;
                end
            %end
        end
    end
end               
   
disp(index2)

input1200 =single(input1200);
input3000 =single(input3000);

input1200_1 = input1200(1,1,:,:,:);
input1200_2 = input1200(1,2,:,:,:);
input1200_3 = input1200(1,3,:,:,:);
input1200_4 = input1200(2,1,:,:,:);
input1200_5 = input1200(2,2,:,:,:);
input1200_6 = input1200(2,3,:,:,:);
input1200_7 = input1200(3,1,:,:,:);
input1200_8 = input1200(3,2,:,:,:);
input1200_9 = input1200(3,3,:,:,:);

input3000_1 = input3000(1,1,:,:,:);
input3000_2 = input3000(1,2,:,:,:);
input3000_3 = input3000(1,3,:,:,:);
input3000_4 = input3000(2,1,:,:,:);
input3000_5 = input3000(2,2,:,:,:);
input3000_6 = input3000(2,3,:,:,:);
input3000_7 = input3000(3,1,:,:,:);
input3000_8 = input3000(3,2,:,:,:);
input3000_9 = input3000(3,3,:,:,:);

save(savename,'-v7','input1200_1','input1200_2','input1200_3','input1200_4', ...
    'input1200_5','input1200_6','input1200_7','input1200_8','input1200_9', ...
    'input3000_1','input3000_2','input3000_3','input3000_4', ... 
    'input3000_5','input3000_6','input3000_7','input3000_8', ... 
    'input3000_9');

%%
input = [names{blah} '/prisma/st/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
savename=[names{blah} '_A2C_5Patches']

load(input)
iSH1200 = SH1200;
iSH3000 = SH3000;
clear SH1200 SH3000

sz = size(iSH1200)



input1200 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));
input3000 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));              
output1200 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));
output3000 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));


index2 = 1;
for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            %if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
                % if any have nan, inf, abs(>10), don't count
                if i==1 || j==1 || k==1 || i==sz(1) || j==sz(2) || k==sz(3)
                    index2=index2+1;
                    continue
                else
                temp = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                %    continue
                %end
                input1200(1:3,1:3,1:3,1:sz(4),index2) = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                input3000(:,:,:,1:sz(4),index2) = iSH3000(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %output1200(1,1,1,1:sz(4),index2) = oSH1200(i,j,k,:);
                %output3000(1,1,1,1:sz(4),index2) = oSH3000(i,j,k,:);
                index2 = index2+1;
                end
            %end
        end
    end
end               
   
disp(index2)

input1200 =single(input1200);
input3000 =single(input3000);

input1200_1 = input1200(1,1,:,:,:);
input1200_2 = input1200(1,2,:,:,:);
input1200_3 = input1200(1,3,:,:,:);
input1200_4 = input1200(2,1,:,:,:);
input1200_5 = input1200(2,2,:,:,:);
input1200_6 = input1200(2,3,:,:,:);
input1200_7 = input1200(3,1,:,:,:);
input1200_8 = input1200(3,2,:,:,:);
input1200_9 = input1200(3,3,:,:,:);

input3000_1 = input3000(1,1,:,:,:);
input3000_2 = input3000(1,2,:,:,:);
input3000_3 = input3000(1,3,:,:,:);
input3000_4 = input3000(2,1,:,:,:);
input3000_5 = input3000(2,2,:,:,:);
input3000_6 = input3000(2,3,:,:,:);
input3000_7 = input3000(3,1,:,:,:);
input3000_8 = input3000(3,2,:,:,:);
input3000_9 = input3000(3,3,:,:,:);

save(savename,'-v7','input1200_1','input1200_2','input1200_3','input1200_4', ...
    'input1200_5','input1200_6','input1200_7','input1200_8','input1200_9', ...
    'input3000_1','input3000_2','input3000_3','input3000_4', ... 
    'input3000_5','input3000_6','input3000_7','input3000_8', ... 
    'input3000_9');

%%

% input = [names{blah} '/prisma/st/A2C_norm_dwi_SHfitOrder4_EvenOdd2.mat']
% savename=[names{blah} '_A2C_Patches']

input = [names{blah} '/prisma/st/A2D_norm_dwi_SHfitOrder4_EvenOdd2.mat']
savename=[names{blah} '_A2D_5Patches']

load(input)
iSH1200 = SH1200;
iSH3000 = SH3000;
clear SH1200 SH3000

sz = size(iSH1200)


input1200 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));
input3000 = zeros(3,3,3,sz(4),sz(1)*sz(2)*sz(3));              
output1200 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));
output3000 = zeros(1,1,1,sz(4),sz(1)*sz(2)*sz(3));


index2 = 1;
for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            %if sum(sum(sum(mask(i-1:i+1,j-1:j+1,k-1:k+1))))==27
                % if any have nan, inf, abs(>10), don't count
                if i==1 || j==1 || k==1 || i==sz(1) || j==sz(2) || k==sz(3)
                    index2=index2+1;
                    continue
                else
                temp = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %if sum(isnan(temp(:)))>0 || sum(isinf(temp(:)))>0 || length(temp(abs(temp)>10))>0 % skip
                %    continue
                %end
                input1200(1:3,1:3,1:3,1:sz(4),index2) = iSH1200(i-1:i+1,j-1:j+1,k-1:k+1,:);
                input3000(:,:,:,1:sz(4),index2) = iSH3000(i-1:i+1,j-1:j+1,k-1:k+1,:);
                %output1200(1,1,1,1:sz(4),index2) = oSH1200(i,j,k,:);
                %output3000(1,1,1,1:sz(4),index2) = oSH3000(i,j,k,:);
                index2 = index2+1;
                end
            %end
        end
    end
end               
   
disp(index2)
input1200 =single(input1200);
input3000 =single(input3000);

input1200_1 = input1200(1,1,:,:,:);
input1200_2 = input1200(1,2,:,:,:);
input1200_3 = input1200(1,3,:,:,:);
input1200_4 = input1200(2,1,:,:,:);
input1200_5 = input1200(2,2,:,:,:);
input1200_6 = input1200(2,3,:,:,:);
input1200_7 = input1200(3,1,:,:,:);
input1200_8 = input1200(3,2,:,:,:);
input1200_9 = input1200(3,3,:,:,:);

input3000_1 = input3000(1,1,:,:,:);
input3000_2 = input3000(1,2,:,:,:);
input3000_3 = input3000(1,3,:,:,:);
input3000_4 = input3000(2,1,:,:,:);
input3000_5 = input3000(2,2,:,:,:);
input3000_6 = input3000(2,3,:,:,:);
input3000_7 = input3000(3,1,:,:,:);
input3000_8 = input3000(3,2,:,:,:);
input3000_9 = input3000(3,3,:,:,:);

save(savename,'-v7','input1200_1','input1200_2','input1200_3','input1200_4', ...
    'input1200_5','input1200_6','input1200_7','input1200_8','input1200_9', ...
    'input3000_1','input3000_2','input3000_3','input3000_4', ... 
    'input3000_5','input3000_6','input3000_7','input3000_8', ... 
    'input3000_9');

end
