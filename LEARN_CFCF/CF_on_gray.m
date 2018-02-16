function [ LossVal, estimated] = CF_on_gray(imdb, G, indices, avIm)
Y = imdb.filters(:,:,:,indices);
X = imdb.patches(:,:,:,indices);
g = ifft2(G); g = imresize(g, [size(Y,1) size(Y,2)]);
G = fft2(g);
resY = get_feature_map(uint8(Y+imresize(avIm, [size(Y,1) size(Y,2)])));
resX = get_feature_map(uint8(X+imresize(avIm, [size(Y,1) size(Y,2)])));
resY = resY;%.*repmat((hann(101)*hann(101)'),1,1,size(resY,3),size(resY,4));
resX = resX;%.*repmat((hann(101)*hann(101)'),1,1,size(resY,3),size(resY,4));
F1 = fft2(resY); % Y(w) in the paper
% H1 = bsxfun(@rdivide, bsxfun(@times, conj(G), F1), bsxfun(@times, F1, conj(F1))+1*0.01);
H1 = bsxfun(@rdivide, bsxfun(@times, conj(G), F1), repmat(sum(bsxfun(@times, F1, conj(F1)),3),1,1,size(F1,3),1)+0.01);
F2 = fft2(resX); % X(w) in the paper

estimated = real(ifft2(bsxfun(@times, conj(H1), (F2))));
estimated = sum(estimated,3);

actual = imdb.desired(:,:,:,indices);
% temp = real(ifft2(bsxfun(@minus,(bsxfun(@times, conj(H1), (F2))), fft2(actual))));

ErrorSig = bsxfun(@minus, estimated, actual);
LossVal = sum(ErrorSig(:).^2)/numel(ErrorSig)*size(ErrorSig,4);

% figure; imshow(uint8(resY), []); figure; imshow(uint8(resX), []); figure; imshow(actual, []);