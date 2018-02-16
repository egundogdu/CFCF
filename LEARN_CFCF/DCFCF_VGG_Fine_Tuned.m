%% find average image
clearvars
load('IMDB_ILSVRC/imdbILSVRC1.mat');
avIm = zeros(101,101,3,'single');
randInds = randperm(1000,1000);
for i = 1:1000
    avIm = ((i-1)/(i))*avIm+imdb.patches(:,:,:,randInds(i))*(1)/(i);
end

TotEpochNo = 1;
for ite = 1:10
    imdbList = randperm(20);
    for aaName = 1:20
        
        clearvars -except aa TotEpochNo aaName ite avIm imdbList
        load(['IMDB_ILSVRC/imdbILSVRC' num2str(imdbList(aaName)) '.mat']);
        
        imdb.filters = bsxfun(@minus, imdb.filters, ...
            repmat(avIm,1,1,1,size(imdb.filters,4)));
        imdb.patches = bsxfun(@minus, imdb.patches, ...
            repmat(avIm,1,1,1,size(imdb.patches,4)));
        
        imdb.filters = imresize(imdb.filters, [224 224]);
        imdb.patches = imresize(imdb.patches, [224 224]);
        imdb.desired = imresize(imdb.desired, [224 224]);

        %% initializations for the network and the constant variables arrays etc.
        net1 = load('imagenet-vgg-m-2048.mat'); % download it from "http://www.vlfeat.org/matconvnet/pretrained/"
        net.layers = net1.layers(1:14);
        f1 = 0.01*randn(1,1,512,32, 'single'); b1 = zeros(1, 32, 'single'); % f1(3,3,:,:) = 1/30;
        net.layers{end+1} = struct('type', 'conv', ...
            'weights', {{f1, b1}}, ...
            'stride', 1, ...
            'pad', 0) ;
        net.layers{end+1} = struct('type', 'bnorm', 'name', 'bn1', ...
            'weights', {{ones(32, 1, 'single'), zeros(32, 1, 'single'), ...
            zeros(32, 2, 'single')}}, ...
            'epsilon', 1e-4, ...
            'learningRate', [2 1 0.1], ...
            'weightDecay', [0 0]) ;
        net = vl_simplenn_tidy(net);
        
%         selectInd = randperm(size(imdb.patches,4),uint16(size(imdb.patches,4)*1.0));
%         imdb_red.patches = imdb.patches(:,:,:,selectInd);
%         imdb_red.filters = imdb.filters(:,:,:,selectInd);
%         imdb_red.desired = imdb.desired(:,:,:,selectInd);
        
        [net, info] = CFCF_train(net, imdb, getBatch(), TotEpochNo ) ;
        TotEpochNo = TotEpochNo + 1;
        
    end
end



