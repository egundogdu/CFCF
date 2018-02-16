Installation Instructions for CFCF Tracker:

CFCF is the combination of the methods in [1] and [2].
For the tracking application, the method is based on [2]. 
Hence, the following installation instructions should be followed to reproduce the results.
The source code folder CFCF already includes the compiled libraries.
Re-compiling the libraries is strongly recommended in Ubuntu OS.

The results of the submitted tracker are obtained in the environment with the following properties:
	Operating System: Ubuntu 14.04 LTS
	Matlab Version: 2015a
	CPU: Intel Xeon E5 2623 v3 x 8 CPU at 3.0 GHz
	GPU: NVidia Tesla K40 GPU
	CUDA-Toolkit Version: 7.5.18
	External Libraries: MatConvNet, PDollar Toolbox and mtimesx (they already exist in the source code folder, and they will be compiled automatically.)	
	

Installation with GPU Support:
	(0) A PC that has an NVIDIA GPU card with compute capability more than 2.0 is required.
	(1) Open MATLAB and go to CFCF directory, where the source code exists.
	(2) Run install.m file to compile the necessary external libraries. 
	(These libraries are MatConvNet [3] and PDOllar Toolbox [4] and mtimesx as in [2]. ).
	(3) Copy the tracker_CFCF.m and configuration.m file to the vot-workspace.
	(The configuration.m file is necessary, because there is a line related to setting the trax_timeout global parameter to 600.)
	(4) Inside tracker_CFCF.m file, replace CFCF_LOCATION with the actual location of the folder CFCF (the source code folder).

	
Installation without GPU Support:
	
Remark: The above steps are for compiling the source code in a PC with a GPU support.
If it is required to run the code without GPU support, the following instructions should be followed.
If the below steps are followed, two GPU-related functions will be deleted and renamed. 
For another installation with GPU support, the source code folder should be re-extracted from the zip archive of the source code.

	(1) Open MATLAB and go to CFCF directory, where the source code exists.
	(2) Run install_CPU.m file to compile the necessary external libraries.
	If OS is Windows, run install_CPU_Windows instead.
	(These libraries are MatConvNet [3] and PDOllar Toolbox [4] and mtimesx as in [2]. ).
	(3) Copy the tracker_CFCF.m and configuration.m file to the vot-workspace.
	(The configuration.m file is necessary, because there is a line related to setting the trax_timeout global parameter to 600.)
	(4) Inside tracker_CFCF.m file, replace CFCF_LOCATION with the actual location of the folder CFCF (the source code folder).

	The remaining steps must only be performed if the libraries are compiled in Windows without GPU support:
	(5) Delete get_cnn_layers.m and load_cnn.m files. 
	(6) Rename get_cnn_layers_CPU.m and load_cnn_CPU.m as get_cnn_layers.m and load_cnn.m.
	(7) Inside get_cnn_layers.m and load_cnn.m files, change the names of the functions as get_cnn_layers and load_cnn

Remark: For reproducing the learned model CFCF as in [1], one should extract LEARN_CFCF.zip
and follow the instructions in LEARN_CFCF/FEATURE_LEARNING.txt file. The network model has been trained multiple times as instructed
and very similar results are obtained.

Utilized Hardware Properties: 
	Visual object tracking has been performed by utilizing the source code of the method in C-COT [2]. In order to
	integrate our fully convolutional features to C-COT, CNN feature extraction part is fulfilled in MatConvnet (Matlab 2015a) with the
	NVidia Tesla K40 GPU. The remaining part of the tracker is performed in the Intel Xeon E5 2623 v3 x 8 CPU at 3.0 GHz.


REFERENCES
[1] Erhan Gundogdu and A. Aydin Alatan. “Good Features to Correlate for Visual Tracking.” arXiv (2017)
[2] M. Danelljan, A. Robinson, F. Shahbaz Khan, and M. Felsberg, “Beyond correlation filters: Learning continuous convolution operators for visual tracking,” in ECCV, 2016.
[3] Webpage: http://www.vlfeat.org/matconvnet/ GitHub repository: https://github.com/vlfeat/matconvnet
[4] Piotr Dollár. "Piotr’s Image and Video Matlab Toolbox (PMT)." Webpage: https://pdollar.github.io/toolbox/ GitHub repository: https://github.com/pdollar/toolbox