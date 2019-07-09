%Load in Big Ben image.
bigBenImage = imread('Big_Ben.png');

%Convert image into grayscale.
greybigBenImage = rgb2gray(bigBenImage);

%Take 2D Discrete Cosine Transformation of grayscaled image.
dctimage = dct2(greybigBenImage);

%Show base and coloured version of DCT images.
figure
imshow(dctimage)
title('Base DCT Image of Big Ben')


figure
imshow(log(abs(dctimage)),[])
title('2D Discrete Cosine Transform (DCT) of Big Ben');
colormap(gca,jet(64))
colorbar


%EXTENSION - Change the value 100 to alter how the filter operates.
dctimage(abs(dctimage) > 100) = 0;

normalagain = idct2(dctimage);

figure
imshow(normalagain);
title('Reconstructed image of Big Ben after filtering (Threshold of 100)');
