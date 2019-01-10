function fa = calcFA(l1,l2,l3)
if(length(l1)==6)
    T = [l1([1 2 3])'; l1([2 4 5])'; l1([3 5 6])'];
    l1 = eigs(T);
end
if(size(l1,1)==3 && size(l1,2)==3)
    l1 = eigs(l1);
end
if(length(l1)==3)
    l3=l1(3);
    l2=l1(2);
    l1=l1(1);
end
l1 = max(l1,0);
l2 = max(l2,0);
l3 = max(l3,0);

lm = (l1+l2+l3)/3;
if(lm==0)
    fa=0;
else
fa = sqrt(3/2)*sqrt((l1-lm).^2+(l2-lm).^2+(l3-lm).^2)./sqrt(l1.^2+l2.^2+l3.^2);
end
% if(fa~=real(fa))
%     disp('?');
% end