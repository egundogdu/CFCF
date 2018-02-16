% clearvars -except imdb
%
% load('imdbForCFCF_diff_frames_1.mat');
% avIm = zeros(101,101,3,'single');
% randInds = randperm(5000,1000);
% for i = 1:1000
%     avIm = ((i-1)/(i))*avIm+imdb.patches(:,:,:,i)*(1)/(i);
% end
%
% imdb.filters = bsxfun(@minus, imdb.filters, ...
%     repmat(avIm,1,1,1,size(imdb.filters,4)));
% imdb.patches = bsxfun(@minus, imdb.patches, ...
%     repmat(avIm,1,1,1,size(imdb.patches,4)));
% load(['imdbForCFCF_' 'basketball' '.mat']);
% 
% 
% imdb.filters = bsxfun(@minus, imdb.filters, ...
%     repmat(128*ones(101,101,1),1,1,1,size(imdb.filters,4)));
% imdb.patches = bsxfun(@minus, imdb.patches, ...
%     repmat(128*ones(101,101,1),1,1,1,size(imdb.patches,4)));


close all
[rs, cs] = ndgrid((1:201) - 100, (1:201) - 100);
g = single(exp(-0.5 * (((rs.^2 + cs.^2) / 10^2))));
G = fft2(g);
randomId = randperm(10000,1);
losses = [];
psrs = [];
figH = figure(1);
load('YOURLOCAL/exp_vgg_finetuned/net-epoch-200.mat');
net.layers = net.layers(1:14);
%% forward propagation and half of the backpropogation and the loss calculation
[ LossVal, estimated, resX, resY, delLH, delLX, delLY] = DCFCF_forwardhalfback_Test( net, imdb, G, randomId, 0);
visInd = 1;
% figure(1); subplot(2,3,1); imshow(double(resY(end).x(:,:,1,visInd)), []); title('Feature map of epoch 1');
figure(1); subplot(2,3,1); imshow(estimated(:,:,1), []); title(['Est. resp. of epoch 1: ' sprintf('%.4f',LossVal)]);
losses = [losses LossVal];
psrs = [psrs (max(mat2gray(estimated(:)))-mean(mat2gray(estimated(:))))/std(mat2gray(estimated(:)))];
[rows1, cols1] = find(estimated==max(estimated(:)));

load('YOURLOCAL/exp_vgg_finetuned/net-epoch-200.mat');
net.layers = net.layers(1:14);
%% forward propagation and half of the backpropogation and the loss calculation
[ LossVal, estimated, resX, resY2, delLH, delLX, delLY] = DCFCF_forwardhalfback_Test( net, imdb, G, randomId, 0);
% figure(1); subplot(2,3,2); imshow(double(resY(end).x(:,:,1,1)), []); title('Feature map of epoch 400');
figure(1); subplot(2,3,2); imshow(estimated(:,:,1), []); title(['Est. resp. of epoch 90: ' sprintf('%.4f',LossVal)]);
losses = [losses LossVal];
psrs = [psrs (max(mat2gray(estimated(:)))-mean(mat2gray(estimated(:))))/std(mat2gray(estimated(:)))];
[rows2, cols2] = find(estimated==max(estimated(:)));
%%
[ LossVal, estimated] = CF_on_gray(imdb, G, randomId, avIm);
figure(1); subplot(2,3,3); imshow((imdb.desired(:,:,:,randomId)), []); title('Desired response')
figure(1); subplot(2,3,4); imshow(estimated, []); title(['Est. resp. by HOG features: ' sprintf('%.4f',LossVal)])
losses = [losses LossVal];
psrs = [psrs (max(mat2gray(estimated(:)))-mean(mat2gray(estimated(:))))/std(mat2gray(estimated(:)))];
[rows3, cols3] = find(estimated==max(estimated(:)));
losses
psrs
avIm = imresize(avIm,[size(imdb.filters,1),size(imdb.filters,2)]);
figure(1); subplot(2,3,5); imshow(uint8(imdb.filters(:,:,:,randomId)+avIm), []); title('Filter of the object');
figure(1); subplot(2,3,6); imshow(uint8(imdb.patches(:,:,:,randomId)+avIm), []); title('Patch of the object');
truesize(figH, [200 200])
tempD = imdb.desired(:,:,:,randomId);
[rowsD, colsD] = find(imdb.desired(:,:,:,randomId)==max(tempD(:)));
gtScale = 224/13;
gtScale2 = 224/14;
[norm([gtScale*rows1-rowsD gtScale*cols1-colsD]) norm([gtScale2*rows2-rowsD gtScale2*cols2-colsD]) norm([rows3-rowsD cols3-colsD])]



