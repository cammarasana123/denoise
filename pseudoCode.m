I = groundTruthImage;
%   noiseType = 'gaussian','speckle','poisson','salt & pepper', 'exponential';
%   noisyImage = imnoise(I,'gaussian',0,0.01);
%   noisyImage = imnoise(I,'gaussian',0,0.02);
%   noisyImage = imnoise(I,'speckle',0.05);
%   noisyImage = imnoise(I,'speckle',0.10);
%   noisyImage = imnoise(I,'poisson');
%   noisyImage = imnoise(I,'exponential');

N = noisyImage;
patchWidth = 49; %FIXED
nofiter = 5; % FIXED
nofbins = 5; %FIXED
nofclusters = 3; FIXED
stackSize = 90; %CAN BE CHANGED, > 49
%-------------LOAD MODELS-----------------
bins(nofbins+1,nofiter); = loadUniformBins();
svmModels(nofbins,nofiter) = readModelSVM();
learningModels(nofbins,nofclusters,nofiter) = readModelLearning();
%----------------------------------------
for iter = 1:nofiter
  P = computePatches(N,patchWidth);
  B3D = computeBlocks(P,patchWidth,stackSize);
  for i = 1:length(B3D)
    block = B3D(:,:,i);
    [U,S,V] = svd(block);
    s = diag(S);
    blockNoise = fnolse(block,noiseType);
    svmMdl = svmModels(blockNoise,iter);
    svmLabel = predict(svmMdl,dS);
    learningMdl = learningModels(blockNoise, svmLabel,iter);
    sPrediction = predict(learningMdl,s);
    blockPrediction = U*diag(sPrediction)*V';
    B3D_Prediction(:,:,i) = saveBlock(blockPrediction);
  end
  aggP = aggregatePatches(B3D_Prediction);
  imageReconstruction(:,:,iter) = patchesToImage(aggP);
end
