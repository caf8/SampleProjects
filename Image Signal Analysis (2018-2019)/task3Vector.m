%Load in Vector image and convert it to YCbCr colour space.
vectorImage = imread('vector.png');
YCBCRvector = rgb2ycbcr(vectorImage);

%Extract colour components of vector image.
ybigVector = YCBCRvector(:,:,1);
cbbigVector = YCBCRvector(:,:,2);
crbigVector = YCBCRvector(:,:,3);

%Reduce the Cb and Cr components by a factor of 8.
reducedcbVector = imresize(cbbigVector,0.125);
reducedcrVector = imresize(crbigVector,0.125);

%Create a 8x8 matrix of ones.
oneMatrix = ones(8, 'uint8');

%Returning components to original size using Kronecker tensor product.
resizedcbVector = kron(reducedcbVector, oneMatrix);

resizedcrVector = kron(reducedcrVector, oneMatrix);

%Recombine new Cb and Cr with Y component.
newImage = cat(3, ybigVector,resizedcbVector,resizedcrVector);


%Show different versions of vector image.
figure
imshow(YCBCRvector);
title('YCbCr colour space version of Vector')

figure
imshow(newImage);
title('YCbCr colour space version of Vector with reduced Cb and Cr')

figure
finalImage = imsubtract(vectorImage,newImage);
imshow(finalImage);
title('Difference Image showing original image minus reduced image (Vector)')

