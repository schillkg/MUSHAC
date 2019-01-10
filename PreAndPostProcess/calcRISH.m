function [val] = calcRISH(coefficents,order)

if order == 0
    array = coefficents(1);
    val = sum(array.^2);
elseif order == 2
    array = coefficents(2:6);
    val = sum(array.^2);
elseif order == 4
 array = coefficents(7:15);
    val = sum(array.^2);
end


