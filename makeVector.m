function vecOut = makeVector(matrixIn)
% This function accepts a matrix (matrixIn) as an input and returns the
% vectorized version of this matrix (vecOut) as an output 
    if isnumeric(matrixIn)~=1
        error('Error: Input matrix must be numeric');
    end
    
    if ndims(matrixIn)>2
        error('Matrix dimensions must be 2 or less');
    end
    
vecOut = matrixIn(:);

end