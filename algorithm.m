function [OUTPUT_PRINT,PSNR_PRINT,SSIM_PRINT] = algorithm(I,noiseType,noiseIntensity);
%---GLOBALS---
global patchNumber; global areaWindow; global halfWindow; global Stack;
global softThres; global Irows; global Icols; global searchWindow;
global patchNumberReduced; global indMatrix; global rcMatrix; global localSearchArea;
global iterationsIndex; global numIter;
global nofbins; global nofclusters;
global noisetype;
global CNN_NET; global svm_LOAD; global uniformBins;

disp('LOADING NETWORKS...');
disp('Possible warnings due to compatibility issues between Tensorflow and Matlab')
[rows,cols,channels] = size(I);
if channels == 3
    I = rgb2gray(I);
end
I = imresize(I,[256,256]); %maximum image size: 600 x 600
%...........NOISE APPLICATION.............%
noisetype = noiseType;
if strcmp(noisetype,'exponential')
    NS = exprnd(noiseIntensity,size(I));
    X = double(I);
    Xnoisy = X + NS;
end
if strcmp(noisetype,'poisson')
    Xnoisy = imnoise(I,'poisson');
end
if strcmp(noisetype,'gaussian')
    Xnoisy = imnoise(I,'gaussian',0,noiseIntensity);
end
if strcmp(noisetype,'speckle')
    Xnoisy = imnoise(I,'speckle',noiseIntensity);
end
if strcmp(noisetype,'salt & pepper')
    Xnoisy = imnoise(I,'salt & pepper',noiseIntensity);
end
%-------------------------------------%
nofbins = 5; nofclusters = 3; numIter = 5;
CNN_NET = cell(nofbins,nofclusters,numIter); %QUESTE SONO LE GAN
svm_LOAD = cell(nofbins,numIter); %QUESTI GLI SVM MODEL
uniformBins = zeros(nofbins+1,numIter);
NOISETYPE = upper(noisetype);
NOISEINTENSITY = num2str(noiseIntensity); NOISEINTENSITY = strrep(NOISEINTENSITY,'.','');
%CNN_NET
for it = 1:numIter
    for i = 1:nofbins
        for j = 1:nofclusters
            bins_str = num2str(i);
            clusters_str = num2str(j);
            it_str = num2str(it);
            modelfile = strcat('./MODELS_',NOISETYPE,'_',NOISEINTENSITY,'/SVM_5_3/IT',it_str,'_STACK/tfModel_',bins_str,'_',clusters_str,'.h5');
            CNN_NET(i,j,it) = {importKerasNetwork(modelfile)};
        end
        if nofclusters > 1
        svmfile = strcat('./MODELS_',NOISETYPE,'_',NOISEINTENSITY,'/SVM_5_3/IT',it_str,'_STACK/svdmodel_it',it_str,'noise_001noc3_bin_',num2str(i),'.mat');
            svm_LOAD(i,it) = {loadLearnerForCoder(svmfile)};
        end
    end
    binsPath = strcat('./MODELS_',NOISETYPE,'_',NOISEINTENSITY,'/SVM_5_3/IT',it_str,'_STACK/svm-uniformBins_',noisetype,'_it',it_str,'_stack_bins',bins_str,'_noise001.txt');
    tempBins = readmatrix(binsPath);
    uniformBins(:,it) = tempBins(:);
end
disp('End of network Loading');
disp('Start Denoising');
%-------------------------------------------
IN = uint8(Xnoisy);
ID = im2double(I);
IN = im2double(IN);
IND_INPUT = double(IN);
%--- PARAMETERS (CHANGING THESE PARAMETERS MAY LEAD TO ERRORS)
searchWindow = 7; 
Stack = 90;
softThres = 0.25;
localSearchArea = 30; 
%---SUPPORT PARAMETERS---%
areaWindow = searchWindow^2;
halfWindow = floor(searchWindow/2);
[Irows,Icols] = size(IN);
check = readMatrixAdapted();
IDXV = computeNeighbour();
patchNumberReduced = length(indMatrix);
patchNumber = (Irows-halfWindow*2) * (Icols-halfWindow*2);
%fprintf('number of patches = %d\n',patchNumberReduced);
%---GLOBAL MATRICES----%
IMOUT = zeros(Irows,Icols,numIter);
PSNR = zeros(numIter,1);
SSIM = zeros(numIter,1);
%---------------------------%
%-------- ALGORITHM --------%
%---------------------------%
for iterationsIndex = 1:numIter
    tic
IND = IND_INPUT;
[m,n] = size(IND);
patchesN = computePatchMatrixN(IND);
if mod(iterationsIndex,2) == 1
    Stack = Stack - 10;
end
if Stack < 50
    Stack = 50;
end
[IDX,DIST,weight] = computePatchDistanceLocalN(patchesN,IDXV);
svdBM3DM = compute3DBlockDenoiseReduced(IDX,patchesN);
[aggregatedPatches,aggregatedPatches_from_WNNM] = computeAggregatePatches(IDX,svdBM3DM,weight);
weight_from_WNNM = repmat(full(weight),[areaWindow,1]);
imPixFilt_from_WNNM = Patch2Im(aggregatedPatches_from_WNNM,weight_from_WNNM);
%
IND_INPUT = imPixFilt_from_WNNM;
IMOUT(:,:,iterationsIndex) = IND_INPUT;
PSNR(iterationsIndex) = psnr(ID,IND_INPUT);
SSIM(iterationsIndex) = ssim(ID,IND_INPUT);
fprintf('iterations = %d | %d \n',iterationsIndex, numIter);
     toc
end
PSNR_PRINT = PSNR(numIter);
SSIM_PRINT = SSIM(numIter);
OUTPUT_PRINT = IMOUT(:,:,numIter);
end