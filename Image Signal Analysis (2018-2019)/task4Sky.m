%Load in Sky image.
skyImage = imread('sky.png');

%Convert image into grayscale.
greySkyImage = rgb2gray(skyImage);

%Take 2D Discrete Cosine Transformation of grayscaled image.
dctimage = dct2(greySkyImage);

%Show base and coloured version of DCT images.
figure
imshow(dctimage)
title('Base DCT Image of Sky')



figure
imshow(log(abs(dctimage)),[])
title('2D Discrete Cosine Transform (DCT) of Sky');
colormap(gca,jet(64))
colorbar

%EXTENSION - Change the value 100 to alter how the filter operates.
dctimage(abs(dctimage) > 500) = 0;

normalagain = idct2(dctimage);

figure
imshow(normalagain);
title('Reconstructed image of sky after filtering (Threshold of 500)');

