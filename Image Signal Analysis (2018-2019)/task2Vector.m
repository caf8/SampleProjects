%Load in Vector image and convert it to YCbCr colour space.
vectorImage = imread('vector.png');
YCBCRVector = rgb2ycbcr(vectorImage);

%Extract colour components of vector image.
yVector = YCBCRVector(:,:,1);
cbVector = YCBCRVector(:,:,2);
crVector = YCBCRVector(:,:,3);

%Creates array size of the colour components
a = 128+ zeros(size(yVector));

%Create the coloured components of vector image using the zeros and
%the different channels.
cbVector = cat(3, a, cbVector, a);
crVector = cat(3, a, a, crVector);

%Show different YCbCr components of vector image.
figure
imshow(YCBCRVector);
title('YCbCr colour space version of Vector image')

figure
imshow(yVector);
title('Y component of Vector image')

figure
imshow(ycbcr2rgb(cbVector));
title('Cb component of Vector image')

figure
imshow(ycbcr2rgb(crVector));
title('Cr component of Vector image')