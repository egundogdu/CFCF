function [ LossVal, estimated, resX, resY, ErrorSig, delLH, delLX, delLY] = DCFCF_forwardhalfback_Test( net, imdb, G, indices, istrain )
delLH = []; delLX = []; delLY = [];
Y = imdb.filters(:,:,:,indices);
X = imdb.patches(:,:,:,indices);%.*repmat((hann(101)*hann(101)'),1,1,size(imdb.filters(:,:,:,indices),3),size(imdb.filters(:,:,:,indices),4));
resY = vl_simplenn(net, Y, [], [], 'Mode', 'test');
resX = vl_simplenn(net, X, [], [], 'Mode', 'test');
% resY = vl_simplenn(net, Y, [], []);
% resX = vl_simplenn(net, X, [], []);
resY(end).x = resY(end).x;%.*repmat((hann(101)*hann(101)'),1,1,size(resY(end).x,3),size(resY(end).x,4));
resX(end).x = resX(end).x;%.*repmat((hann(101)*hann(101)'),1,1,size(resY(end).x,3),size(resY(end).x,4));

F1 = fft2(resY(end).x); % Y(w) in the paper

g = ifft2(G); g = imresize(g, [size(F1,1) size(F1,2)]);
G = fft2(g);
G = gpuArray(G);

H1 = bsxfun(@rdivide, bsxfun(@times, conj(G), F1), repmat(sum(bsxfun(@times, F1, conj(F1)),3),1,1,size(F1,3),1)+0.01);
F2 = fft2(resX(end).x); % X(w) in the paper
estimated = real(ifft2(bsxfun(@times, conj(H1), (F2))));
estimated = sum(estimated,3);
actual = imdb.desired(:,:,:,indices);
% temp = real(ifft2(bsxfun(@minus,(bsxfun(@times, conj(H1), (F2))), fft2(actual))));

ErrorSig = bsxfun(@minus, estimated, imresize(actual, [size(estimated,1) size(estimated,2)]));
LossVal = sum(ErrorSig(:).^2)/numel(ErrorSig)*size(ErrorSig,4);
LossVal = gather(LossVal);
if istrain
    E = fft2(ErrorSig);
    delLH = real(ifft2(bsxfun(@times, conj(E), F2)));
    delLX = ifft2(bsxfun(@times, E, H1));
    
    delLY = gpuArray(zeros(size(delLH,1),size(delLH,2),size(delLH,3),length(indices), 'single'));
    DY = sum(bsxfun(@times, F1, conj(F1)),3)+0.01;
    B1 = bsxfun(@rdivide, conj(G),DY.^2);
    FA = fft2(delLH);
    
    for k = 1:size(delLH,3)
        temp = 0;
        for l = 1:size(delLH,3)
%             tempA = FA(:,:,l,:);
            if k ~= l
                B2 = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),conj(F1(:,:,k,:))),...
                    DY.^2);
                C = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),(F1(:,:,k,:)).^2),...
                    DY.^2);
                
                temp = temp + ifft2(bsxfun(@times, conj(-B2),FA(:,:,l,:))-bsxfun(@times, C,conj(FA(:,:,l,:))));
            else
                B2 = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),conj(F1(:,:,k,:))),...
                    DY.^2);
                C = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),(F1(:,:,k,:)).^2),...
                    DY.^2);
                
                temp = temp + ifft2(bsxfun(@times,conj(bsxfun(@minus,0.01*B1,B2)),FA(:,:,l,:))-bsxfun(@times, C, conj(FA(:,:,l,:))));
            end
        end
        [ delLY(:,:,k,:) ] = temp;
    end
    delLY = single(real(delLY));
    delLX = single(real(delLX));
    
    ratioXY = max(real(delLY(:)))/max(real(delLX(:)));
    delLY = delLY/ratioXY;
    %% visualization
    %     visInd = 1;
    %     figure(3); imshow(resY(end).x(:,:,:,visInd), []);
    %     figure(4); imshow(resX(end).x(:,:,:,visInd), []);
    
    %     figure; imshow(estimated(:,:,:,visInd), []);
    %     figure(2); imshow(actual(:,:,:,visInd));
end
