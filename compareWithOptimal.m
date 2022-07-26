clear all; close all;
stack = dlmread('results/STACK/STACK_cam_005_it1.txt');
GANSV = dlmread('results/GAN-SV_cam_005_it1.txt');
OPTSV = dlmread('/home/simone/Documenti/denoise/myNLM/AnalysosOn-onlyOptimization/results/optimalSV_cam_005.txt');
bins = dlmread('/home/simone/Documenti/denoise/myNLM/AnalysisOn-WNNM_CNN_SVM_UNIFORM-BIN_005/MODELS/IT1/uniformBins_it1.txt');
len = length(GANSV);
lenBin = length(bins);
nolse = zeros(len,1);
for i = 1:len
    blockLin = stack(i,:);
    block = reshape(blockLin,[90,49]);
    nolse(i) = fnolse(block,'speckle');
end

[sortedNolse,index] = sort(nolse); 

for i = 1:lenBin
    [~,idx] = min(abs(bins(i)-sortedNolse));
     if bins(i) < sortedNolse(idx)
        nolseIdx(i) = idx-1;
     else
        nolseIdx(i) = idx;
     end
     if nolseIdx(i) < 1 %serve a controllare che non esco dai bins
         nolseIdx(i) = 1;
     elseif nolseIdx(i) > len
         nolseIdx(i) = len;
     end   
end

deltaNorm = vecnorm(GANSV-OPTSV,2,2);
[~,idx] = sort(nolse);
plot(deltaNorm(idx));
xticks(nolseIdx)
v1 = num2str(bins(1),'%3.5f');
v2 = num2str(bins(2),'%3.5f');
v3 = num2str(bins(3),'%3.5f');
v4 = num2str(bins(4),'%3.5f');
v5 = num2str(bins(5),'%3.5f');
v6 = num2str(bins(6),'%3.5f');
v7 = num2str(bins(7),'%3.5f');
v8 = num2str(bins(8),'%3.5f');
v9 = num2str(bins(9),'%3.5f');
v10 = num2str(bins(10),'%3.5f');
v11 = num2str(bins(11),'%3.5f');
v12 = num2str(bins(12),'%3.5f');
%
xticklabels({v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12})
xtickangle(45)


