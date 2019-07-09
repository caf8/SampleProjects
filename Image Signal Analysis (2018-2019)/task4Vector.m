%Load in Vector image.
vectorImage = imread('vector.png');

%Convert image into grayscale.
greyVectorImage = rgb2gray(vectorImage);

%Take 2D Discrete Cosine Transformation of grayscaled image.
dctimage = dct2(greyVectorImage);

%Show base and coloured version of DCT images.
figure
imshow(dctimage)
title('Base DCT Image of Vector')

figure
imshow(log(abs(dctimage)),[])
title('2D Discrete Cosine Transform (DCT) of Vector image');
colormap(gca,jet(64))
colorbar

%EXTENSION - Change the value 100 to alter how the filter operates.
dctimage(abs(dctimage) > 100) = 0; %Letters only < 0


normalagain = idct2(dctimage);

figure
imshow(normalagain);
title('Reconstructed image of Vector image after filtering (Threshold < 0)');

