function imPixFilt = computeAggregatePixels(aggregatedPatches,varPatches)
%aggrega sui pixel i contributi delle patches
global patchNumberReduced; global Irows; global Icols; global halfWindow; global searchWindow;
global rcMatrix; global patchNumber;
imPixExtended = zeros( (Irows),(Icols) );
imPixExtendedVariance = zeros( (Irows),(Icols) );
varPatches = ones(size(varPatches));
for ind = 1:patchNumber
    [i,j] = ind2sub([Irows-halfWindow*2,Icols-halfWindow*2],ind);
    row = i + halfWindow;
    col = j + halfWindow;
    rowmhw = row - halfWindow;
    colmhw = col - halfWindow;
    rowphw = row + halfWindow;
    colphw = col + halfWindow;
    addPatch = reshape(aggregatedPatches(ind,:),[searchWindow,searchWindow]);
    addPatch = addPatch';
    imPixExtended( (rowmhw):(rowphw),(colmhw):(colphw)) = ...
        imPixExtended( (rowmhw):(rowphw),(colmhw):(colphw)) + addPatch*varPatches(ind);  
   imPixExtendedVariance( (rowmhw):(rowphw),(colmhw):(colphw)) = ...
    imPixExtendedVariance( (rowmhw):(rowphw),(colmhw):(colphw)) + varPatches(ind);
end
%imPixFilt = imPixExtended( (1+halfWindow):(end-halfWindow),(1+halfWindow):(end-halfWindow) );
%imPixVar = imPixExtendedVariance( (1+halfWindow):(end-halfWindow),(1+halfWindow):(end-halfWindow) );
imPixFilt = imPixExtended./imPixExtendedVariance;
end





