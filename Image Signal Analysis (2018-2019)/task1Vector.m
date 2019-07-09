%Load in Vector image.
vectorImage = imread('vector.png');

%Extract colour components of sky image.
redVector = vectorImage(:,:,1);
greenVector = vectorImage(:,:,2);
blueVector = vectorImage(:,:,3);


%Create zeros array size of the colour components 
z = zeros(size(redVector));

%Create the coloured components of vector image using the zeros and
%the different channels.
redVector = cat(3, redVector, z, z);
greenVector = cat(3, z, greenVector,z);
blueVector = cat(3,z,z,blueVector);


%Show different colour componenets of vector image with colourbars.
%Colorbars created manually using linspace in RGB range.
figure
colorMap = [linspace(0,1,256)', zeros(256,2)];
colormap(colorMap);
imshow(redVector), colorbar
caxis([0,255]);
title('Red colour component of Vector Image')

figure
colorMap = [zeros(256,1),linspace(0,1,256)' zeros(256,1)];
colormap(colorMap);
imshow(greenVector), colorbar;
caxis([0,255]);
title('Green colour component of Vector Image')

figure
colorMap = [zeros(256,1), zeros(256,1), linspace(0,1,256)'];
colormap(colorMap);
imshow(blueVector), colorbar;
caxis([0,255]);
title('Blue colour component of Vector Image')