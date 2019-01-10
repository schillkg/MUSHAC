% resize normalized A to C
% resize normalized A to D


flirt -in sA/A/norm_dwi.nii.gz -ref sA/C/norm_dwi.nii.gz -out sA/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sA/A/norm_dwi.nii.gz -ref sA/D/norm_dwi.nii.gz -out sA/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sB/A/norm_dwi.nii.gz -ref sB/C/norm_dwi.nii.gz -out sB/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sB/A/norm_dwi.nii.gz -ref sB/D/norm_dwi.nii.gz -out sB/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sC/A/norm_dwi.nii.gz -ref sC/C/norm_dwi.nii.gz -out sC/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sC/A/norm_dwi.nii.gz -ref sC/D/norm_dwi.nii.gz -out sC/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sD/A/norm_dwi.nii.gz -ref sD/C/norm_dwi.nii.gz -out sD/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sD/A/norm_dwi.nii.gz -ref sD/D/norm_dwi.nii.gz -out sD/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sE/A/norm_dwi.nii.gz -ref sE/C/norm_dwi.nii.gz -out sE/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sE/A/norm_dwi.nii.gz -ref sE/D/norm_dwi.nii.gz -out sE/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sF/A/norm_dwi.nii.gz -ref sF/C/norm_dwi.nii.gz -out sF/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sF/A/norm_dwi.nii.gz -ref sF/D/norm_dwi.nii.gz -out sF/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sG/A/norm_dwi.nii.gz -ref sG/C/norm_dwi.nii.gz -out sG/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sG/A/norm_dwi.nii.gz -ref sG/D/norm_dwi.nii.gz -out sG/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sH/A/norm_dwi.nii.gz -ref sH/C/norm_dwi.nii.gz -out sH/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sH/A/norm_dwi.nii.gz -ref sH/D/norm_dwi.nii.gz -out sH/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in sI/A/norm_dwi.nii.gz -ref sI/C/norm_dwi.nii.gz -out sI/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sI/A/norm_dwi.nii.gz -ref sI/D/norm_dwi.nii.gz -out sI/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch



flirt -in sJ/A/norm_dwi.nii.gz -ref sJ/C/norm_dwi.nii.gz -out sJ/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sJ/A/norm_dwi.nii.gz -ref sJ/D/norm_dwi.nii.gz -out sJ/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch



flirt -in sK/A/norm_dwi.nii.gz -ref sK/C/norm_dwi.nii.gz -out sK/A/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in sK/A/norm_dwi.nii.gz -ref sK/D/norm_dwi.nii.gz -out sK/A/A2D_norm_dwi.nii.gz -applyxfm -nosearch

% in testing data

flirt -in H/prisma/st/norm_dwi.nii.gz -ref H/prisma/sa/dwi.nii.gz -out H/prisma/st/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in H/prisma/st/norm_dwi.nii.gz -ref H/connectom/sa/dwi.nii.gz -out H/prisma/st/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in L/prisma/st/norm_dwi.nii.gz -ref L/prisma/sa/dwi.nii.gz -out L/prisma/st/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in L/prisma/st/norm_dwi.nii.gz -ref L/connectom/sa/dwi.nii.gz -out L/prisma/st/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in M/prisma/st/norm_dwi.nii.gz -ref M/prisma/sa/dwi.nii.gz -out M/prisma/st/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in M/prisma/st/norm_dwi.nii.gz -ref M/connectom/sa/dwi.nii.gz -out M/prisma/st/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in N/prisma/st/norm_dwi.nii.gz -ref N/prisma/sa/dwi.nii.gz -out N/prisma/st/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in N/prisma/st/norm_dwi.nii.gz -ref N/connectom/sa/dwi.nii.gz -out N/prisma/st/A2D_norm_dwi.nii.gz -applyxfm -nosearch


flirt -in O/prisma/st/norm_dwi.nii.gz -ref O/prisma/sa/dwi.nii.gz -out O/prisma/st/A2C_norm_dwi.nii.gz -applyxfm -nosearch

flirt -in O/prisma/st/norm_dwi.nii.gz -ref O/connectom/sa/dwi.nii.gz -out O/prisma/st/A2D_norm_dwi.nii.gz -applyxfm -nosearch


%% resize original data A to C and D


flirt -in sA/A/noTRnoTE_dwi.nii.gz -ref sA/C/norm_dwi.nii.gz -out sA/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sA/A/noTRnoTE_dwi.nii.gz -ref sA/D/norm_dwi.nii.gz -out sA/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sB/A/noTRnoTE_dwi.nii.gz -ref sB/C/norm_dwi.nii.gz -out sB/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sB/A/noTRnoTE_dwi.nii.gz -ref sB/D/norm_dwi.nii.gz -out sB/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sC/A/noTRnoTE_dwi.nii.gz -ref sC/C/norm_dwi.nii.gz -out sC/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sC/A/noTRnoTE_dwi.nii.gz -ref sC/D/norm_dwi.nii.gz -out sC/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sD/A/noTRnoTE_dwi.nii.gz -ref sD/C/norm_dwi.nii.gz -out sD/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sD/A/noTRnoTE_dwi.nii.gz -ref sD/D/norm_dwi.nii.gz -out sD/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sE/A/noTRnoTE_dwi.nii.gz -ref sE/C/norm_dwi.nii.gz -out sE/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sE/A/noTRnoTE_dwi.nii.gz -ref sE/D/norm_dwi.nii.gz -out sE/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sF/A/noTRnoTE_dwi.nii.gz -ref sF/C/norm_dwi.nii.gz -out sF/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sF/A/noTRnoTE_dwi.nii.gz -ref sF/D/norm_dwi.nii.gz -out sF/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sG/A/noTRnoTE_dwi.nii.gz -ref sG/C/norm_dwi.nii.gz -out sG/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sG/A/noTRnoTE_dwi.nii.gz -ref sG/D/norm_dwi.nii.gz -out sG/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sH/A/noTRnoTE_dwi.nii.gz -ref sH/C/norm_dwi.nii.gz -out sH/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sH/A/noTRnoTE_dwi.nii.gz -ref sH/D/norm_dwi.nii.gz -out sH/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sI/A/noTRnoTE_dwi.nii.gz -ref sI/C/norm_dwi.nii.gz -out sI/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sI/A/noTRnoTE_dwi.nii.gz -ref sI/D/norm_dwi.nii.gz -out sI/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sJ/A/noTRnoTE_dwi.nii.gz -ref sJ/C/norm_dwi.nii.gz -out sJ/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sJ/A/noTRnoTE_dwi.nii.gz -ref sJ/D/norm_dwi.nii.gz -out sJ/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in sK/A/noTRnoTE_dwi.nii.gz -ref sK/C/norm_dwi.nii.gz -out sK/A/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in sK/A/noTRnoTE_dwi.nii.gz -ref sK/D/norm_dwi.nii.gz -out sK/A/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

% in testing data

flirt -in H/prisma/st/noTRnoTE_dwi.nii.gz -ref H/prisma/sa/dwi.nii.gz -out H/prisma/st/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in H/prisma/st/noTRnoTE_dwi.nii.gz -ref H/connectom/sa/dwi.nii.gz -out H/prisma/st/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in L/prisma/st/noTRnoTE_dwi.nii.gz -ref L/prisma/sa/dwi.nii.gz -out L/prisma/st/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in L/prisma/st/noTRnoTE_dwi.nii.gz -ref L/connectom/sa/dwi.nii.gz -out L/prisma/st/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in M/prisma/st/noTRnoTE_dwi.nii.gz -ref M/prisma/sa/dwi.nii.gz -out M/prisma/st/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in M/prisma/st/noTRnoTE_dwi.nii.gz -ref M/connectom/sa/dwi.nii.gz -out M/prisma/st/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in N/prisma/st/noTRnoTE_dwi.nii.gz -ref N/prisma/sa/dwi.nii.gz -out N/prisma/st/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in N/prisma/st/noTRnoTE_dwi.nii.gz -ref N/connectom/sa/dwi.nii.gz -out N/prisma/st/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch


flirt -in O/prisma/st/noTRnoTE_dwi.nii.gz -ref O/prisma/sa/dwi.nii.gz -out O/prisma/st/A2C_noTRnoTE_dwi.nii.gz -applyxfm -nosearch

flirt -in O/prisma/st/noTRnoTE_dwi.nii.gz -ref O/connectom/sa/dwi.nii.gz -out O/prisma/st/A2D_noTRnoTE_dwi.nii.gz -applyxfm -nosearch



