function [fa,md,pev,e] = calcFAPEV(D)
if(length(D)==6)
 DT = [D(1) D(2) D(3);D(2) D(4) D(5); D(3) D(5) D(6)];
else
    DT=D;
end
 [v,e] = eigs(DT);
 [i,j]=find(abs(e)==max(abs(e(:))));
 pev=v(:,i(1));
 e = sort([e(1,1) e(2,2) e(3,3)]);
 fa = calcFA(e(3),e(2),e(1));
 md = sum(e)/3;