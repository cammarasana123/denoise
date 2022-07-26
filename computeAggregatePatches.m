function [aggregatedPatches,aggregatedPatches_from_WNNM] = computeAggregatePatches(IDXW,svdBM3DMS,weightV)
%Aggrega le patches, dato che ognuna può essere in vari stack
%poi le normalizza
global patchNumberReduced; global areaWindow; global indMatrix; global patchNumber;
aggregatedPatches = zeros(patchNumber,areaWindow);
for ind = 1:patchNumberReduced %Faccio l'aggregation delle patches
    %reducedInd = indMatrix(ind);
    reducedInd = ind;
    whichAffectW = IDXW(reducedInd,:)';
    aggregatedPatches(whichAffectW,:) = aggregatedPatches(whichAffectW,:) + svdBM3DMS(:,:,ind);    
end
%aggregatedPatches_from_WNNM = aggregatedPatches./(weightV'+eps);
aggregatedPatches_from_WNNM = aggregatedPatches';
aggregatedPatches = aggregatedPatches ./(weightV'+eps);

end