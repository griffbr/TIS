# TIS_0 and TIS_S: Tukey-Inspired Video Object Segmentation
[Brent A. Griffin](https://www.griffb.com) and [Jason J. Corso](http://web.eecs.umich.edu/~jjcorso/)<br />
IEEE Winter Conference on Applications of Computer Vision (WACV), 2019 <br />

This is the source code implementation for TIS_0 and TIS_S from the following paper:
[Tukey-Inspired Video Object Segmentation](https://arxiv.org/abs/1811.07958 "ArXiV Paper")<br />


Please cite our paper if you find it useful for your research.
```
@inproceedings{GrCoWACV2019,
  author = {Griffin, Brent A. and Corso, Jason J.},
  booktitle = {IEEE Winter Conference on Applications of Computer Vision (WACV)},
  title = {Tukey-Inspired Video Object Segmentation},
  year = {2019}
}
```

## Files

demo.m - Demonstration of Tukey-Inspired Video Object Segmentation using image data from videos in exampleDirectory.<br />
TIS.m - Performs video object segmentation given directory information and configuration settings.

## Notes 

The TIS_0 algorithm can be run using video images alone.<br />
Output annotations exhibit slight variations each time optical flow data is re-processed due to stochastic processes.<br />
For TIS_S, supervoxel images are included with the examples but must be generated for new videos (see LIBSVX below).

This Code is currently configured to run on Windows. If using another OS, reconfigure the external files listed below for best results.

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


## Method

__TIS processes image data to find foreground objects.__ The outlier scale acts as a weighting that adapts to frame-to-frame video characteristics. In this example, we focus on optical flow magnitude with outliers depicted as black pixels (middle row). Flow distributions are offset from the median (bottom row) and include the interquartile range (solid lines) and outlier thresholds (dotted lines).
![alt text](https://github.com/griffbr/TIS/blob/master/figures/TIS_data.png "TIS processing of image data to find foreground objects")
<br />
