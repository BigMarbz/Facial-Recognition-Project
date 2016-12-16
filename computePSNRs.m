function PSNRs = computePSNRs(imgVec, imageDatabase) 

y = size(imageDatabase,2);
PSNRs= zeros(1,y);

for br=1:y
PSNRs(br) = calcPSNR(imgVec,imageDatabase(:,br));
end


end