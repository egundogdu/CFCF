function [patches, filters, desired] = getSimpleNNBatch(imdb, batch)
% --------------------------------------------------------------------
patches = imdb.patches(:,:,:,batch);
filters = imdb.filters(:,:,:,batch);
desired = imdb.desired(:,:,:,batch);
