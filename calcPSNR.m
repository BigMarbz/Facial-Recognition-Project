 function PSNR = calcPSNR(x1,x2,maxX) 
    if nargin < 3
          maxX = 1;
    end
    
tempvar = calcMSE(x1,x2);
    if tempvar == 0
        PSNR = 100;
    else
        PSNR = 10*log10((maxX^2)/tempvar);
    end    
    
 end
 