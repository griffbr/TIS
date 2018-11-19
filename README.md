# TIS: Tukey-Inspired Video Object Segmentation

Contact: Brent Griffin (griffb at umich dot edu)

## Publication
[Tukey-Inspired Video Object Segmentation](https://www.google.com "ArXiV Paper")<br />
[Brent A. Griffin](https://www.griffb.com) and [Jason J. Corso](http://web.eecs.umich.edu/~jjcorso/)<br />
IEEE Winter Conference on Applications of Computer Vision (WACV), 2019

Please cite our paper if you find it useful for your research.
```
@inproceedings{GrCoWACV2019,
  author = {Griffin, Brent A. and Corso, Jason J.},
  booktitle = {IEEE Winter Conference on Applications of Computer Vision (WACV)},
  title = {Tukey-Inspired Video Object Segmentation},
  year = {2019}
}
```

## Method

__TIS processes image data to find foreground objects.__ The outlier scale acts as a weighting that adapts to frame-to-frame video characteristics. In this example, we focus on optical flow magnitude with outliers depicted as black pixels (middle row). Flow distributions are offset from the median (bottom row) and include the interquartile range (solid lines) and outlier thresholds (dotted lines).
![alt text](https://github.com/griffbr/TIS/blob/master/figures/TIS_data.png "TIS processing of image data to find foreground objects")
<br />

__TISM processes and combines multiple segmentation masks for a collectively more robust method of segmentation.__
![alt text](https://github.com/griffbr/TIS/blob/master/figures/TISM.png "TISM processing of multiple segmentation masks")

## Results

__DAVIS results for state-of-the-art unsupervised methods.__ TIS-based methods achieve top results in all categories.
![alt text](https://github.com/griffbr/TIS/blob/master/figures/DAVIS16_Unsupervised.png "DAVIS results for state-of-the-art unsupervised methods")
<br />

__Visual comparison of segmentation methods on complete DAVIS dataset.__ TISM-based methods improve performance across all categories of supervision.
![alt text](https://github.com/griffbr/TIS/blob/master/figures/DAVIS16_plot.png "Visual comparison of segmentation methods on DAVIS dataset")

## Use
This software is for 