function [Imv,Image] = denoiseSVD(patch,ind)
%Denoise patch with CNN_SVD
global CNN_NET; global svm_LOAD;
global nofbins; global nofclusters;
global matrixOptimSO;
global iterationsIndex;
global uniformBins;
global noisetype;
     [U,S,V] = svd(patch,'econ');
     dS = diag(S);
     dSpad = zeros(1,49);
     dSpad(:,:) = dS;
     if strcmp(noisetype,'salt & pepper')
        [~,nolseEstimator] = fnolse(patch,noisetype);            
     elseif strcmp(noisetype,'gauss')
	    nolseEstimator = fnolse(patch,'gaussian');
     else
        nolseEstimator = fnolse(patch,noisetype);            
     end 
     bins =uniformBins(:,iterationsIndex);
     [~,idx] = min(abs(bins-nolseEstimator));
     if nolseEstimator < bins(idx)
        nolseBin = idx-1;
     else
        nolseBin = idx;
     end
     if nolseBin < 1 %serve a controllare che non esco dai bins
         nolseBin = 1;
     elseif nolseBin > nofbins
         nolseBin = nofbins;
     end
     if nofclusters > 1
         local_SVM_MODEL = svm_LOAD(nolseBin,iterationsIndex);
         local_SVM_MODEL_data = local_SVM_MODEL{:};
         labelPrediction = predict(local_SVM_MODEL_data,dSpad);
     else
         labelPrediction = 1;
     end
     local_CNN_NET = CNN_NET(nolseBin,labelPrediction,iterationsIndex);
     local_CNN_NET_data = local_CNN_NET{:};
     maxEig = max(dSpad);
     if maxEig ~= 0
        SigmaX = predict(local_CNN_NET_data,dSpad);
        SigmaX = SigmaX(1:49);
     else
        SigmaX = zeros(1,49); 
     end
     Image = U*diag(SigmaX')*V';
     Imv = Image(:);
     matrixOptimSO(ind,:) = SigmaX;
end
