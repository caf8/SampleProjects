%Load in Big Ben image.
bigBenImage = imread('Big_Ben.png');

%Extract colour components of big ben image.
redBigBen = bigBenImage(:,:,1);
greenBigBen = bigBenImage(:,:,2);
blueBigBen = bigBenImage(:,:,3);

%Create zeros array size of the colour components 
z = zeros(size(redBigBen));


%Create the coloured components of big ben image using the zeros and
%the different channels.
redBigBen = cat(3, redBigBen, z, z);
greenBigBen = cat(3, z, greenBigBen,z);
blueBigBen = cat(3,z,z,blueBigBen);

%Show different colour componenets of big ben image with colourbars.
%Colorbars created manually using linspace in RGB range.
figure
colorMap = [linspace(0,1,256)', zeros(256,2)];
colormap(colorMap);
imshow(redBigBen), colorbar
caxis([0,255]);
title('Red colour component of Big Ben Image')

figure
colorMap = [zeros(256,1),linspace(0,1,256)' zeros(256,1)];
colormap(colorMap);
imshow(greenBigBen), colorbar;
caxis([0,255]);
title('Green colour component of Big Ben Image')

figure
colorMap = [zeros(256,1), zeros(256,1), linspace(0,1,256)'];
colormap(colorMap);
imshow(blueBigBen), colorbar;
caxis([0,255]);
title('Blue colour component of Big Ben Image')