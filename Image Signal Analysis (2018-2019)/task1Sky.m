%Load in Sky image
skyImage = imread('sky.png');

%Extract colour components of sky image.
redSkyImage = skyImage(:,:,1);
greenSkyImage = skyImage(:,:,2);
blueSkyImage = skyImage(:,:,3);

%Create zeros array size of the colour components 
z = zeros(size(redSkyImage));


%Create the coloured components of sky image using the zeros and
%the different channels.
redSkyImage = cat(3, redSkyImage, z, z);
greenSkyImage = cat(3, z, greenSkyImage,z);
blueSkyImage = cat(3,z,z,blueSkyImage);


%Show different colour componenets of sky image with colourbars.
%Colorbars created manually using linspace in RGB range.
figure
colorMap = [linspace(0,1,256)', zeros(256,2)];
colormap(colorMap);
imshow(redSkyImage), colorbar
caxis([0,255]);
title('Red colour component of Sky Image')

figure
colorMap = [zeros(256,1),linspace(0,1,256)' zeros(256,1)];
colormap(colorMap);
imshow(greenSkyImage), colorbar;
caxis([0,255]);
title('Green colour component of Sky Image')

figure
colorMap = [zeros(256,1), zeros(256,1), linspace(0,1,256)'];
colormap(colorMap);
imshow(blueSkyImage), colorbar;
caxis([0,255]);
title('Blue colour component of Sky Image')





