Author: Erhan Gundogdu

Contact Info: egundogdu87@gmail.com

Foreword: The code to train a fully CNN network [1] will be made available soon.

If you use our code or tracking results, please cite:

@ARTICLE{8291524,
author={E. Gundogdu and A. A. Alatan},
journal={IEEE Transactions on Image Processing},
title={Good Features to Correlate for Visual Tracking},
year={2018},
volume={PP},
number={99},
pages={1-1},
keywords={Computational modeling;Convolution;Correlation;Machine learning;Target tracking;Training;Visualization;correlation filters;deep feature learning;visual tracking},
doi={10.1109/TIP.2018.2806280},
ISSN={1057-7149},
month={},}

EXPERIMENTAL RESULTS:
The two .zip files are the results of OTB-2015 OPE and VOT2016 baseline.
Please note that VOT2016 is run only for one repetition since the tracker is deterministic.
The detailed information is available in [1] that details the feature learning framework CFCF and how it is integrated to C-COT [2]. For fair comparisons, the only changing feature type (w.r.t. C-COT) is the learned CFCF features which are extracted from the fine-tuned VGG-M-2048 network in [3]. 
Similarly, the additional features are utilized for VOT2016 experiments as in C-COT and the VOT2016 settings of C-COT can be found in https://github.com/martin-danelljan/Continuous-ConvOp.

VOT2017 Integration:
In order to integrate CFCF tracker and its configuration for VOT2017, please use the CFCF_Tracker.rar file and follow the instructions in README_ForVOT2017Tracker.txt file. This part of the code is already available in VOT2017 Webpage: http://www.votchallenge.net/vot2017/trackers.html

Training a fully-CNN model:
In order to train a fully-CNN model, please use the folder LEARN_CFCF folder and follow the instructions in FEATURE_LEARNING.txt file in this folder.

[1] E. Gundogdu and A. A. Alatan, "Good Features to Correlate for Visual Tracking," in IEEE Transactions on Image Processing, vol. PP, no. 99, pp. 1-1. doi: 10.1109/TIP.2018.2806280

[2] M. Danelljan, A. Robinson, F. Shahbaz Khan, and M. Felsberg, “Beyond correlation filters: Learning continuous convolution operators for visual tracking,” in ECCV, 2016.

[3] K. Chatfield, K. Simonyan, A. Vedaldi, and A. Zisserman. Return of the devil in the details: Delving deep into
convolutional nets. In BMVC. BMVA Press, 2014.
