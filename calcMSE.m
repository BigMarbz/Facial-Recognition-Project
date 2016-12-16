function MSE = calcMSE(x1,x2)
v1 = makeVector(x1);
v2 = makeVector(x2);
M = length(v1);
z=0;
    for ii = 1:M
        z = z+(v1(ii)-v2(ii))^2;
    end
MSE = (1/M)*z;
end