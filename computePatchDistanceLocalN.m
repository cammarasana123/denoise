function [IDXN,DISTN,weightIDN,weightIDMatN] = computePatchDistanceLocalN(patchesN,IDXV)
%questa funzione calcola la distanza tra le patches
%OUTPUT:
    % IDX = indice delle patches più vicine
    % DISTW = distanza con le patches più vicine
    % weightIDW = somma sulle colonne di IDXW, in pratica dice per ogni patch
    % in quanti Stack si trova
global Stack; global patchNumberReduced; global rcMatrix; global indMatrix; global patchNumber;
global Irows; global Icols; global localSearchArea; global halfWindow;
arrayPatches = (1:patchNumberReduced)'; 
repArrayPatches = repmat(arrayPatches,Stack,1);
oneArrayPatches = ones(size(repArrayPatches));
%---N----
%kdModelN = KDTreeSearcher(patchesN);
%[IDXN,DISTN] = knnsearch(kdModelN,patchesN,'k',Stack);
%weightIDMatN = sparse(repArrayPatches,IDXN(:),oneArrayPatches,patchNumberReduced,patchNumberReduced);
%weightIDN = sum(weightIDMatN);
%----
%linArrRow = (1+halfWindow):(Irows-halfWindow);
%linArrCol = (1+halfWindow):(Icols-halfWindow);
%[arrCol,arrRow] = meshgrid(linArrCol,linArrRow);
%V = [arrRow(:),arrCol(:)];
% linArrRow = 1:(Irows-halfWindow*2);
% linArrCol = 1:(Icols-halfWindow*2);
% [arrCol,arrRow] = meshgrid(linArrCol,linArrRow);
% V = [arrRow(:),arrCol(:)];
% IDXV = zeros(length(V),4*(localSearchArea+1) * (localSearchArea+1));
% for i = 1:length(V)
%     index = zeros(1,(localSearchArea+1)*(localSearchArea+1)*4);
%     x = V(i,1);
%     y = V(i,2);
%     mx = max(1,x-localSearchArea);
%     Mx = min(Irows-2*halfWindow,x+localSearchArea);
%     my = max(1,y-localSearchArea);
%     My = min(Icols-2*halfWindow,y+localSearchArea);
%     [mgrx,mgry] = meshgrid(mx:Mx,my:My);
%     pts = [mgrx(:),mgry(:)];
%     for ii = 1:length(pts)
%         index(ii) = sub2ind([Irows-halfWindow*2,Icols-halfWindow*2],pts(ii,1),pts(ii,2));
%     end
%     IDXV(i,:) = index;
% end
IDXN = zeros(patchNumberReduced,Stack);
DISTN = zeros(patchNumberReduced,Stack);
for i = 1:patchNumberReduced
    reducedInd = indMatrix(i);   
    reducedIDXV = IDXV(reducedInd,:);
    nnzReducedIDXV = nonzeros(reducedIDXV);
    patchesToSearchIn = patchesN(nnzReducedIDXV,:);
    kdModelN = KDTreeSearcher(patchesToSearchIn);
    [tempI,tempD] = knnsearch(kdModelN,patchesN(reducedInd,:),'k',Stack);
    IDXN(i,:) = IDXV(reducedInd,tempI');
    DISTN(i,:) = tempD;
end
weightIDMatN = sparse(repArrayPatches,IDXN(:),oneArrayPatches,patchNumberReduced,patchNumber);
weightIDN = sum(weightIDMatN);

end