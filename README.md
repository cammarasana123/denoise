REFERENCE:
Cammarasana, Simone, and Giuseppe Patane. "Learning-based low-rank denoising." Signal, Image and Video Processing (2022): 1-7.

TESTED WITH:
Matlab2021b

TEST FILE:
main.m

Here, you can test the denoising of different images, with noise type and intensities.

Comment: the maximum dimension allowed is 600 X 600. This comes out with an initial approach for the selection of the patches, that has been abandoned. If you want to test images with higher dimension, you need to modify the way the position of the patches is computed. Currently, this is performed by reading a text file; this can be optimised through numeric values of the patches to select.
