function svdBM3D = compute3DBlockDenoiseReduced(IDX,patches)
%funzione di 3D denoise sui blocchi
%OUTPUT: per ogni patch, le patch nel suo stack filtrate
%ma non lo faccio di tutti i blocchi 3D
global patchNumberReduced; global areaWindow; global softThres;
global Stack; global numIter; global iterationsIndex;
global matrixOptimSO;
%global patchNumber;
%
svdBM3D = zeros(Stack,areaWindow,patchNumberReduced);
svdBM3D_SAVE = zeros(patchNumberReduced,Stack*areaWindow);
matrixOptimSO = zeros(patchNumberReduced,areaWindow);
for ind = 1:patchNumberReduced
    reducedInd = ind;
    idxLocW = IDX(reducedInd,:);
    tempblock3DMatrix = patches(idxLocW',:);
    mean_Temp = 0;
    block3DMatrix    =   tempblock3DMatrix-mean_Temp;
    [~,svdBM3D(:,:,ind)] = denoiseSVD(block3DMatrix,ind);
    svdBM3D(:,:,ind) = svdBM3D(:,:,ind) + mean_Temp;
    svdBM3D_SAVE(ind,:) = (block3DMatrix(:))';
end

end
