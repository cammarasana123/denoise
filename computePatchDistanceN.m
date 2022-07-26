function [IDXN,DISTN,weightIDN,weightIDMatN] = computePatchDistanceN(patchesN)
%questa funzione calcola la distanza tra le patches
%OUTPUT:
    % IDX = indice delle patches più vicine
    % DISTW = distanza con le patches più vicine
    % weightIDW = somma sulle colonne di IDXW, in pratica dice per ogni patch
    % in quanti Stack si trova
global Stack; global patchNumberReduced;
arrayPatches = (1:patchNumberReduced)';
repArrayPatches = repmat(arrayPatches,Stack,1);
oneArrayPatches = ones(size(repArrayPatches));
%---N----
kdModelN = KDTreeSearcher(patchesN);
[IDXN,DISTN] = knnsearch(kdModelN,patchesN,'k',Stack);
weightIDMatN = sparse(repArrayPatches,IDXN(:),oneArrayPatches,patchNumberReduced,patchNumberReduced);
weightIDN = sum(weightIDMatN);
%----
end