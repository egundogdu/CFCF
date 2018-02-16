close all
clc
clearvars

%% Please arange "YOURLOCAL" appropriately

vidPath{1} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Data/VID/train/ILSVRC2015_VID_train_0000/';
vidPath{2} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Data/VID/train/ILSVRC2015_VID_train_0001/';
vidPath{3} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Data/VID/train/ILSVRC2015_VID_train_0002/';
vidPath{4} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Data/VID/train/ILSVRC2015_VID_train_0003/';

annoPath{1} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Annotations/VID/train/ILSVRC2015_VID_train_0000/';
annoPath{2} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Annotations/VID/train/ILSVRC2015_VID_train_0001/';
annoPath{3} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Annotations/VID/train/ILSVRC2015_VID_train_0002/';
annoPath{4} = 'YOURLOCAL/ILSVRC_VID/ILSVRC/Annotations/VID/train/ILSVRC2015_VID_train_0003/';

noOfVidsInVidPath = [1000 1000 1000 862];
noOfSamplesPerFile = 10000;
noOfFiles = 20;


for matNo = 1:noOfFiles
    imdb.filters = zeros(101, 101, 3, noOfSamplesPerFile, 'single');
    imdb.patches = zeros(101, 101, 3, noOfSamplesPerFile, 'single');
    imdb.desired = zeros(101, 101, 1, noOfSamplesPerFile, 'single');
    ite = 1;
    while ite <= noOfSamplesPerFile
        trainFolderID = randperm(4,1);
        VidID = randperm(noOfVidsInVidPath(trainFolderID),1);
        temp = dir(vidPath{trainFolderID});
        currDir = temp(3:end);
        imageDir = dir([fullfile(vidPath{trainFolderID},currDir(VidID).name) '/*.JPEG']);
        annoDir = dir([fullfile(annoPath{trainFolderID},currDir(VidID).name) '/*.xml']);
        num_frames = length(annoDir);
        %% frames
        flag = 0;
        while flag == 0
            frame = randperm(num_frames,1);
            frame2 = frame+round(10*randn);
            frame2 = min(frame2,num_frames);
            if frame2 < 0
                bok = 0;
            end
            frame2 = max(frame2,1);
            
            currXMLName = fullfile(annoPath{trainFolderID},currDir(VidID).name,annoDir(frame).name);
            currXMLObj = xml2struct_custom(currXMLName);
            currXMLName2 = fullfile(annoPath{trainFolderID},currDir(VidID).name,annoDir(frame2).name);
            currXMLObj2 = xml2struct_custom(currXMLName2);
            if isfield(currXMLObj.annotation,'object') && isfield(currXMLObj2.annotation,'object')
                flag = 1;
                continue;
            end
            
        end
        %% first
        [ posx, posy,  WW, HH] = readXMLForILSVRC( currXMLObj ); 
        currImageName = fullfile(vidPath{trainFolderID},currDir(VidID).name,imageDir(frame).name);
        im1 = imread(currImageName);
        if WW > 0.5*size(im1,2) || HH > 0.5*size(im1,1)
           continue; 
        end
        
        
        xs = floor(posx) + (1:WW) - floor(WW/2);
        ys = floor(posy) + (1:HH) - floor(HH/2);
        xs(xs < 1) = 1;
        ys(ys < 1) = 1;
        xs(xs > size(im1,2)) = size(im1,2);
        ys(ys > size(im1,1)) = size(im1,1);
        im_patch = im1(ys, xs, :);
        
        %% second
        [ posx2, posy2,  WW2, HH2] = readXMLForILSVRC( currXMLObj2 );
        motionX = round(0.5*WW2*(rand-0.5)); motionY = round(0.5*HH2*(rand-0.5));
        posx2 = posx2 + motionX; posy2 = posy2 + motionY;
        currImageName2 = fullfile(vidPath{trainFolderID},currDir(VidID).name,imageDir(frame2).name);
        im2 = imread(currImageName2);
        xs2 = floor(posx2) + (1:WW2) - floor(WW2/2);
        ys2 = floor(posy2) + (1:HH2) - floor(HH2/2);
        xs2(xs2 < 1) = 1;
        ys2(ys2 < 1) = 1;
        xs2(xs2 > size(im2,2)) = size(im2,2);
        ys2(ys2 > size(im2,1)) = size(im2,1);
        im_patch2 = im2(ys2, xs2, :);
        
        
        motion_scaled = 101*[motionY motionX]./([HH2 WW2]);
        [rs, cs] = ndgrid((1:101) - 50, (1:101) - 50);
        g_shifted = exp(-0.5 * ((((rs+motion_scaled(1)).^2 + (cs+motion_scaled(2)).^2) / 7^2)));
        
        imdb.filters(:,:,:,ite) = single(imresize(im_patch, [101 101]));
        imdb.patches(:,:,:,ite) = single(imresize(im_patch2, [101 101]));
        imdb.desired(:,:,:,ite) = single(imresize(g_shifted, [101 101]));
        
%         figure(1);
%         subplot(3,1,1); imshow(im_patch, []);
%         subplot(3,1,2); imshow(im_patch2, []);
%         subplot(3,1,3); imshow((imdb.desired(:,:,:,ite)), []);
        
%         figure(2);
%         subplot(3,1,1); imshow(uint8(imdb.filters(:,:,:,ite)), []);
%         rectangle('Position',[25 25 50 50]);
%         subplot(3,1,2); imshow(uint8(imdb.patches(:,:,:,ite)), []);
%         rectangle('Position',[25-motion_scaled(2) 25-motion_scaled(1) 50 50]);
%         subplot(3,1,3); imshow((imdb.desired(:,:,:,ite)), []);
%         drawnow;
%         figure(3); imshow(im1, []);
%         rectangle('Position', [ posx-WW/4, posy-HH/4, WW/2, HH/2]);
%         drawnow;
        fprintf('\n matNo: %d, ite: %d', matNo, ite);
        ite = ite + 1;
    end
    
    save(['IMDB_ILSVRC/imdbILSVRC' num2str(matNo)], 'imdb', '-v7.3');
    clear imdb
    
end