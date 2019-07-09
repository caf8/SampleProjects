%Load in Sky image and convert it to YCbCr colour space.
skyImage = imread('sky.png');
YCBCRSky = rgb2ycbcr(skyImage);

%Extract colour components of sky image.
ySky = YCBCRSky(:,:,1);
cbSky = YCBCRSky(:,:,2);
crSky = YCBCRSky(:,:,3);

%Creates array size of the colour components
a = 128+ zeros(size(ySky));

%Create the coloured components of sky image using the zeros and
%the different channels.
cbSky = cat(3, a, cbSky, a);
crSky = cat(3, a, a, crSky);

%Show different YCbCr components of sky image.
figure
imshow(YCBCRSky);
title('YCbCr colour space version of Sky')

figure
imshow(ySky);
title('Y component of Sky')

figure
imshow(ycbcr2rgb(cbSky));
title('Cb component of Sky')

figure
imshow(ycbcr2rgb(crSky));
title('Cr component of Sky')