% make boxplots of NMSE for A=>B, A=>C, D=>D
% typically want to do NMSE (true-est)^2/true^2 vectors
% for A=>B
% make boxplots of each A,b,c,d,e,f,g,i,j,k
% for NMSE of FA
% for NMSE of MD
% for NMSE of RISH0, 2, 4

%% A=> B
subs = {'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'}
All = struct;

for i = 1:length(subs)
    t_data = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi.nii.gz']
    t_bval = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi.bval']
    t_bvec = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi.bvec']
    t_tr = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi.TR']
    t_te = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi.TE']
    
    e_data = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/dwi_BALD.nii.gz']
    
    masknii = ['/Volumes/GRAID/Harmonization/Train_Data/' subs{i} '/B/mask.nii.gz']

    [Truth, Estimated] = EvaluateHarmonisation(t_data,t_bval,t_bvec,t_tr,t_te,e_data,masknii);
    All(i).Truth = Truth;
    All(i).Estimated = Estimated;
end

figure;
% FA
for i = 1:10
    a = All(i).Truth.FA;
    b = All(i).Estimated.FA;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-1.2 1.8]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): FA NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_FA_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.FA;
    b = All(i).Estimated.FA;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 .06]) ; 
title('BALD (A=>B): FA squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_FA_squaredError.fig')
close all

% MD
figure;
for i = 1:10
    a = All(i).Truth.MD;
    b = All(i).Estimated.MD;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-.3 0.6]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): MD NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_MD_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.MD;
    b = All(i).Estimated.MD;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 7E-8]) ; 
title('BALD (A=>B): MD squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_MD_squaredError.fig')
close all

% RISH0 for b1200
figure;
for i = 1:10
    a = All(i).Truth.C0_12000;
    b = All(i).Estimated.C0_12000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-1.2 1.2]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): C0b1200 NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C0b1200_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.C0_12000;
    b = All(i).Estimated.C0_12000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 1.6]) ; 
title('BALD (A=>B): C0b1200 squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C0b1200_squaredError.fig')
close all

% RISH0 for b3000
figure;
for i = 1:10
    a = All(i).Truth.C0_30000;
    b = All(i).Estimated.C0_30000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-1.2 1.2]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): C0b3000 NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C0b3000_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.C0_30000;
    b = All(i).Estimated.C0_30000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 .16]) ; 
title('BALD (A=>B): C0b3000 squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C0b3000_squaredError.fig')
close all

% RISH2 for b1200
figure;
for i = 1:10
    a = All(i).Truth.C2_12000;
    b = All(i).Estimated.C2_12000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-1.2 1.2]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): C2b1200 NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C2b1200_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.C2_12000;
    b = All(i).Estimated.C2_12000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 .16]) ; 
title('BALD (A=>B): C2b1200 squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C2b1200_squaredError.fig')
close all

% RISH2 for b3000
figure;
for i = 1:10
    a = All(i).Truth.C2_30000;
    b = All(i).Estimated.C2_30000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(NormError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([-1.2 1.2]) ; line(xlim(), [0,0], 'Color', 'k'); 
title('BALD (A=>B): C2b3000 NormError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C2b3000_NormError.fig')
close all 
figure;
for i = 1:10
    a = All(i).Truth.C2_30000;
    b = All(i).Estimated.C2_30000;
    mask = All(i).Truth.mask; a = a(mask==1); b = b(mask==1); error = a-b; %NMSE = (a-b).^2./a.^2;
    squaredError = error.^2;
    NormError = error ./ a;
    boxplot(squaredError, 'positions', i, 'symbol',''); hold on;
end
xlim([.5 10.5])
ylim([0 .0016]) ; 
title('BALD (A=>B): C2b3000 squaredError') 
set(gca,'xtick',1:10,'xticklabel',{'sA','sB','sC','sD','sE','sF','sG','sI','sJ','sK'})
savefig('/Volumes/GRAID/Harmonization/Figs/BALD_AtoB_C2b3000_squaredError.fig')
close all

