clear all; close all;
%..........LOAD GROUND-TRUTH IMAGE........%
I = imread('./images/peppers.png');
%..........SET NOISE TYPE.................%
noiseType = 'gaussian';
noiseIntensity = 0.01;
%NOISE TYPE:
%gaussian, speckle, salt & pepper, poisson, exponential
%NOISE INTENSITY TABLE: (DIFFERENT COMBINATIONS ARE NOT AVAILABLE)
% gaussian: 0.01 | 0.02
% speckle: 0.05 | 0.10
% salt & pepper: 0.05 
% poisson: 1
% exponential: 5
[output,PSNR_VALUE,SSIM_VALUE] = algorithm(I,noiseType,noiseIntensity);
