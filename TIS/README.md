# TIS: Tukey-Inspired Video Object Segmentation (TISS and TIS0)
Authors: Brent Griffin and Jason Corso
Contact: griffb@umich.edu
Date: 2018-11-19
Version: 1.0

This is the source code implementation for TISS and TIS0 from the following paper (cite this paper):
Griffin, B. and Corso, J. "Video Object Segmentation using Supervoxel-Based Gerrymandering"
http://arxiv.org/abs/1704.05165

## Files

demo.m - Demonstration of Tukey-Inspired Video Object Segmentation given images in the exampleTrial directory.<br />
TIS.m - Performs video object segmentation given directory information and configuration settings.

## Notes 

Supervoxel images are included with the examples but must be generated for new videos (see LIBSVX below).<br />
TIS0 algorithm can be run using video images alone.<br />
Output annotations exhibit slight variations each time optical flow data is re-processed due to stochastic processes.<br />
Code is currently configured to run in windows. Using an alternative OS will likely need reconfiguration of the external files listed below.

Have fun!

## Included External Files

C. Liu. Beyond Pixels: Exploring New Representations and Applications for Motion Analysis. Doctoral Thesis. Massachusetts Institute of Technology. May 2009.
	Optical Flow
	https://people.csail.mit.edu/celiu/OpticalFlow/
	
R. Margolin, L. Zelnik-Manor and A. Tal. "What Makes a Patch Distinct" in CVPR 2013
	Visual Saliency
	http://cgm.technion.ac.il/Computer-Graphics-Multimedia/Software/DstnctSal/


## Recommended External Files

LIBSVX: A Supervoxel Library and Benchmark for Early Video Processing
	Necessary for generating supervoxels for new videos.
	http://web.eecs.umich.edu/~jjcorso/r/supervoxels/

DAVIS: A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
	Includes 50 diverse videos with ground truth annotations and evaluation code.
	http://davischallenge.org/code.html
