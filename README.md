# Learning-Based Low-Rank Denoising
 In this repository, you can find the trained networks for the prediction of the optimal singular values of the SVD.

 Short guide: <br/>
 1) Apply the block-matching algorithm to a 2D gray-scale image <br/>
    1.1) Patch size MUST be 7X7, stack size can be any number greater than 49.  <br/>
    1.2) Apply the economic SVD to each 3D block: *svd(block,'econ')*. <br/>
 2) Use the proper network to predict the optimal singular values. Networks are classified by:  <br/>
    2.1) Noise type and intensity: Gaussian (0-mean, 0.01 variance), Speckle (0.05-variance), Salt&Pepper (0.05 intensity); different noise types or intensities need a new training. This parameter is the NOISE. <br/>
    2.2) Iteration step: at each iteration, the proper network must be used. This parameter is the ITERATION. <br/>
    2.3) Noise intensity. Use the NOLSE estimator (link1, link2) to estimate the noise of the 3D block. Remember to use the proper type_noise parameter, in the fnolse function. Once you have computed the NOLSE estimator, select the proper noise bin in the file "svm-uniformBins...txt". If the noise is lower than the first value, you fall in the first bin; if higher than the last value, you fall in the last bin. There is a total number of 5 bins. The output bin is the NOLSE CLASSIFICATION. <br/>
    2.4) SVM prediction: use the "svdmodel....mat" file to predict the SVM classification of the 3D block. Be careful to use the right SVM model, according to the NOLSE metric computed at 2.3; that means, if the NOLSE metric predicts a noise bin = 3, you must use the "svdmodel_itxxx_bin_3.mat." model. You can use the Matlab function *predict(model,3Dblock)*. There is a total number of 3 labels of the prediction. The output of the prediction is the SVM CLASSIFICATION. <br/>
    2.5) Select the proper network according to: */MODELS_{NOISE}/IT_{ITERATION}/tfModel_{NOLSE CLASSIFICATION}_{SVM CLASSIFICATION}.h5*; you can use the Matlab function *predict(model,svArray)*. <br/>
    2.6) Note: we use *loadLearnerForCoder* and *importKerasNetwork* for importing the SVM and h5 model, respectively.
 3) The predicted singular values are used to reconstruct each 3D block.  <br/>
 4) Through the block-matching aggregation, an iteration of the method is completed. <br/>
 5) You can proceed with the next iteration (starting from point 1, where the input image is now the output of point 4 ). You can apply a maximum number of FIVE iterations. <br/>
    
    
 link1: https://ieeexplore.ieee.org/abstract/document/6600966 <br/>
 link2: https://it.mathworks.com/matlabcentral/fileexchange/63172-noise-estimator-estimation-for-various-types-of-noise
 
