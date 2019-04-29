
%function matchingDegree=calMatchingDegree(transformedRefValExt,attrWeightExt,noOfRules,ExtRef)
function matchingDegree=calMatchingDegreeDisV2(transformedRefVal,attrWeight)
Y=attrWeight;
attrWeight=attrWeight/max(attrWeight);
for i=1:size(transformedRefVal,3)
    cc(:,:,i)=power(transformedRefVal(:,:,i),attrWeight(i));
end    
matchingDegree=sum(cc,3);


return
end