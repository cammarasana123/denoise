function [IDXV,DISTV,weightV] = computePatchDistanceV()
%questa funzione calcola la distanza tra le patches
%OUTPUT:
    % IDX = indice delle patches più vicine
    % DISTW = distanza con le patches più vicine
    % weightIDW = somma sulle colonne di IDXW, in pratica dice per ogni patch
    % in quanti Stack si trova
global Stack; global rcMatrix; global patchNumberReduced;
%global checkPixMatrix; global indMatrix;
kdModelV = KDTreeSearcher(rcMatrix);
[IDXV,DISTV] = knnsearch(kdModelV,rcMatrix,'k',Stack);
arrayPatches = (1:patchNumberReduced)';
repArrayPatches = repmat(arrayPatches,Stack,1);
oneArrayPatches = ones(size(repArrayPatches));
weightMatV = sparse(repArrayPatches,IDXV(:),oneArrayPatches,patchNumberReduced,patchNumberReduced);
weightV = sum(weightMatV);



end