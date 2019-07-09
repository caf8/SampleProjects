%Load in Big Ben image and convert it to YCbCr colour space.
bigBenImage = imread('Big_Ben.png');
YCBCRbigBen = rgb2ycbcr(bigBenImage);

%Extract colour components of big ben image.
ybigBen = YCBCRbigBen(:,:,1);
cbbigBen = YCBCRbigBen(:,:,2);
crbigBen = YCBCRbigBen(:,:,3);

%Creates array size of the colour components
a = 128+ zeros(size(ybigBen));


%Create the coloured components of big ben image using the zeros and
%the different channels.
cbbigBen = cat(3, a, cbbigBen, a);
crbigBen = cat(3, a, a, crbigBen);

%Show different YCbCr components of big ben image.
figure
imshow(YCBCRbigBen);
title('YCbCr colour space version of Big Ben')

figure
imshow(ybigBen);
title('Y component of Big Ben')

figure
imshow(ycbcr2rgb(cbbigBen));
title('Cb component of Big Ben')

figure
imshow(ycbcr2rgb(crbigBen));
title('Cr component of Big Ben')