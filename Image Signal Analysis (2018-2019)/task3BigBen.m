%Load in Big Ben image and convert it to YCbCr colour space.
bigBenImage = imread('Big_Ben.png');
YCBCRbigBen = rgb2ycbcr(bigBenImage);

%Extract colour components of big ben image.
ybigBen = YCBCRbigBen(:,:,1);
cbbigBen = YCBCRbigBen(:,:,2);
crbigBen = YCBCRbigBen(:,:,3);

%Reduce the Cb and Cr components by a factor of 8.
reducedcbbigBen = imresize(cbbigBen,0.125);
reducedcrbigBen = imresize(crbigBen,0.125);

%Create a 8x8 matrix of ones.
oneMatrix = ones(8, 'uint8');

%Returning components to original size using Kronecker tensor product.
resizedcbbigBen = kron(reducedcbbigBen, oneMatrix);

resizedcrbigBen = kron(reducedcrbigBen, oneMatrix);

%Recombine new Cb and Cr with Y component.
newImage = cat(3, ybigBen,resizedcbbigBen,resizedcrbigBen);


%Show different versions of big ben image.
figure
imshow(YCBCRbigBen);
title('YCbCr colour space version of Big Ben')

figure
imshow(newImage);
title('YCbCr colour space version of Big Ben with reduced Cb and Cr')

figure
finalImage = imsubtract(bigBenImage,newImage);
imshow(finalImage);
title('Difference Image showing original image minus reduced image (Big Ben)')

