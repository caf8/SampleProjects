%Load in Sky image and convert it to YCbCr colour space.
skyImage = imread('sky.png');
YCBCRsky = rgb2ycbcr(skyImage);

%Extract colour components of sky image.
ybigSky = YCBCRsky(:,:,1);
cbbigSky = YCBCRsky(:,:,2);
crbigSky = YCBCRsky(:,:,3);

%Reduce the Cb and Cr components by a factor of 8.
reducedcbSky = imresize(cbbigSky,0.125);
reducedcrSky = imresize(crbigSky,0.125);

%Create a 8x8 matrix of ones.
oneMatrix = ones(8, 'uint8');

%Returning components to original size using Kronecker tensor product.
resizedcbSky = kron(reducedcbSky, oneMatrix);

resizedcrSky = kron(reducedcrSky, oneMatrix);

%Recombine new Cb and Cr with Y component.
newImage = cat(3, ybigSky,resizedcbSky,resizedcrSky);

%Show different versions of sky image.
figure
imshow(YCBCRsky);
title('YCbCr colour space version of Sky')

figure
imshow(newImage);
title('YCbCr colour space version of Sky with reduced Cb and Cr')

figure
finalImage = imsubtract(skyImage,newImage);
imshow(finalImage);
title('Difference Image showing original image minus reduced image (Sky)')

