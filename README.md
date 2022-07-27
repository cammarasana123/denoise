# Overview
Denosing algorithm with different noise type and intensities.
Our method trains a network to predict the optimal thresholds of the singular value decomposition involved in the low-rank denoising of 2D images.

# Test
Launch the test file: *main.m*  

You can set the:  
-Ground truth input image;  
-Noise type: *gaussian, speckle, salt & pepper, poisson, exponential*;  
-Noise intensity: among the following parameters.  

| Noise intensities  | Parameters | Parameters    |
| ------------- | ------------- | ---|
| gaussian  | 0.01  | 0.02 |
| speckle   | 0.05  | 0.10 |
| salt & pepper | 0.05 | - |
| poisson | 1 | - |
| exponential | 5 | - |
 
The parameters have the following meaning:  
-*gaussian*: variance of the distribution;  
-*speckle*: speckle variance;  
-*salt & pepper*: noise frequency;  
-*exponential*: exponential factor.  

# Requirements
Tested with Matlab2021b.  

Toolbox:  
-Image processing  
-Deep Learning

Comment: Warnings may occur when loading the networks, due to compatibility issues between Tensorflow and Matlab. However, this will not affect the final results.

# Reference
Cammarasana, S., & Patane, G. (2022). Learning-based low-rank denoising. Signal, Image and Video Processing, 1-7.

# Results
We report a summary of the results; for further details, please refer to the paper.
![image results](https://raw.githubusercontent.com/cammarasana123/denoise/main/results/results.png)

*(a): speckle; (b): salt & pepper; (c): gaussian*

# Comment
The maximum dimension allowed of the input image is 600 X 600. This comes out with an initial approach for the selection of the patches, that has been abandoned. If you want to test images with higher dimension, you need to modify the way the position of the patches is computed. Currently, this is performed by reading a text file; this can be optimised through numeric values of the patches to be selected.
