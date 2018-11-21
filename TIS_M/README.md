# TIS_M: Tukey-Inspired Video Object Segmentation
This is the source code implementation for TIS_M from:
[Tukey-Inspired Video Object Segmentation](https://arxiv.org/abs/1811.07958 "ArXiV Paper")<br />
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

## Files

demo.m - Demonstration of Tukey-Inspired Video Object Segmentation using a set of binary images.<br />
TISM.m - Performs video object segmentation given demo configuration.

## Method

__TIS_M processes and combines multiple segmentation masks__, generating a collectively more robust method of segmentation.
![alt text](https://github.com/griffbr/TIS/blob/master/figures/TISM.png "TIS_M processing of multiple segmentation masks")
