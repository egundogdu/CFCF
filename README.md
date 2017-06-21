Author: Erhan Gundogdu

Contact Info: egundogdu87@gmail.com

Foreword: The code to train a fully CNN network [1] will be made available soon.

If you use our code or tracking results, please cite:

	@misc{1704.06326,
	Author = {Erhan Gundogdu and A. Aydin Alatan},
	Title = {Good Features to Correlate for Visual Tracking},
	Year = {2017},
	Eprint = {arXiv:1704.06326},
	}

The two .zip files are the results of OTB-2015 OPE and VOT2016 baseline.
Please note that VOT2016 is run only for one repetition since the tracker is deterministic.
The detailed information is available in [1] that details the feature learning framework CFCF and how it is integrated to C-COT [2]. For fair comparisons, the only changing feature type (w.r.t. C-COT) is the learned CFCF features which are extracted from the fine-tuned VGG-M-2048 network in [3]. 
Similarly, the additional features are utilized for VOT2016 experiments as in C-COT and the VOT2016 settings of C-COT can be found in https://github.com/martin-danelljan/Continuous-ConvOp. 


[1] Erhan Gundogdu and A. Aydin Alatan. “Good Features to Correlate for Visual Tracking.” arXiv (2017)

[2] M. Danelljan, A. Robinson, F. Shahbaz Khan, and M. Felsberg, “Beyond correlation filters: Learning continuous convolution operators for visual tracking,” in ECCV, 2016.

[3] K. Chatfield, K. Simonyan, A. Vedaldi, and A. Zisserman. Return of the devil in the details: Delving deep into
convolutional nets. In BMVC. BMVA Press, 2014.
