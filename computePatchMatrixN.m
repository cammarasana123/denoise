function patchesN = computePatchMatrixN(IND)
%Questa funzione calcola tutte le patch
%OUTPUT: 
    % I - sono le patches Ideali, quelle calcolate dall'immagine non noisy
    % N - quelle calcolate sull'immagine noisy
    % W - quelle con decomposizione wavelet
    % S - quelle con decomposizione SVD

global patchNumberReduced; global areaWindow;  global halfWindow; global rcMatrix; global patchNumber;
global Irows; global Icols;
patchesN = zeros( patchNumber,areaWindow ); %Righe = numero patches
for ind = 1:patchNumber %Calcolo la matrice delle patches #1
    [i,j] = ind2sub([Irows-halfWindow*2,Icols-halfWindow*2],ind);
    i = i + halfWindow;
    j = j + halfWindow;
    tempPatch = IND(i-halfWindow:i+halfWindow,j-halfWindow:j+halfWindow);
    tempPatch = tempPatch';
    patchesN(ind,:) = tempPatch(:);
end
end