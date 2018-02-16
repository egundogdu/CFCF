function [ LossVal, estimated, resX, resY, ErrorSig, delLH, delLX, delLY] = DCFCF_forwardhalfback( net, imdb, G, indices, istrain )

reglambda = 0.01;
delLH = []; delLX = []; delLY = [];
Y = imdb.filters(:,:,:,indices);
X = imdb.patches(:,:,:,indices);
resY = vl_simplenn(net, Y, [], [], 'cudnn',true);
resX = vl_simplenn(net, X, [], [], 'cudnn',true);
F1 = fft2(resY(end).x);
g = ifft2(G); g = imresize(g, [size(F1,1) size(F1,2)]);
G = fft2(g);
G = gpuArray(G);

H1 = bsxfun(@rdivide, bsxfun(@times, conj(G), F1), sum(bsxfun(@times, F1, conj(F1)),3)+reglambda);
F2 = fft2(resX(end).x); % X(w) in the paper
estimated = real(ifft2(bsxfun(@times, conj(H1), (F2))));
estimated = sum(estimated,3);
actual2 = gpuArray(imresize(1*imdb.desired(:,:,:,indices)-0.0, [size(estimated,1) size(estimated,2)]));
ErrorSig = bsxfun(@minus, estimated, actual2);
LossVal = sum(ErrorSig(:).^2)/numel(ErrorSig)*size(ErrorSig,4);
LossVal = gather(LossVal);

if istrain
    E = fft2(ErrorSig);
    delLH = real(ifft2(bsxfun(@times, conj(E), F2)));
    delLX = ifft2(bsxfun(@times, E, H1));
    delLY = gpuArray(zeros(size(delLH,1),size(delLH,2),size(delLH,3),length(indices), 'single'));
    DY = sum(bsxfun(@times, F1, conj(F1)),3)+reglambda;
    B1 = bsxfun(@rdivide, conj(G),DY);
    FA = fft2(delLH);
    % l and k are interchanged with respect to the given order in the
    % paper.
    for k = 1:size(delLH,3)
        temp = 0;
        for l = 1:size(delLH,3)
            if k ~= l
                B2 = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),conj(F1(:,:,k,:))),...
                    DY.^2);
                C = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),(F1(:,:,k,:))),...
                    DY.^2);
                
                temp = temp + ifft2(bsxfun(@times, conj(-B2),FA(:,:,l,:))...
                    -bsxfun(@times, C,conj(FA(:,:,l,:))));
            else
                B2 = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),conj(F1(:,:,k,:))),...
                    DY.^2);
                C = bsxfun(@rdivide, ...
                    bsxfun(@times, bsxfun(@times,conj(G),F1(:,:,l,:)),(F1(:,:,k,:))),...
                    DY.^2);
                
                temp = temp + ifft2(bsxfun(@times,conj(bsxfun(@minus,B1,B2)),FA(:,:,l,:))...
                    -bsxfun(@times, C, conj(FA(:,:,l,:))));
            end
        end
        [ delLY(:,:,k,:) ] = temp;
    end
    delLY = single(real(delLY));
    delLX = single(real(delLX));
    
    ratioY = max(abs(real(delLY(:))))/0.02;
    delLY = delLY/ratioY;
    ratioX = max(abs(real(delLX(:))))/0.02;
    delLX = delLX/ratioX;   
    %% Uncomment for visualization
    %     visInd = 1;
    %     figure(3); imshow(resY(end).x(:,:,:,visInd), []);
    %     figure(4); imshow(resX(end).x(:,:,:,visInd), []);
    %     figure; imshow(estimated(:,:,:,visInd), []);
    %     figure(2); imshow(actual(:,:,:,visInd));
end

