function minPos = findMinimumErrorPosition(imgVec, imageDatabase) 
num1 = size(imageDatabase,1);
num2 = size(imageDatabase,2);

imagematrix=[];

    for c = 1:num2
        tempnum = calcMSE(imgVec,imageDatabase(:,c));
        imagematrix(c) = tempnum;
    end
    
[~,minPos] = find(imagematrix==min(min(imagematrix)));

end