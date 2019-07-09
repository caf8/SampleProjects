%Load in heart rate video.
v = VideoReader('heart_rate_vid (1).MOV');

%Obtain height and width of video in order to create struct.
vidHeight = v.Height;
vidWidth = v.Width;

%Define struct that stores information surrounding the video.
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

%Loop through the frames in the video, placing each frame in the struct and
%the intensity of each frame in an array.
k = 1;
g=[];
while hasFrame(v)
    s(k).cdata = readFrame(v);
    g = [g, mean2(s(k).cdata)];
    k = k+1;
end

%Show a frame of the video.
image(s(5).cdata)



x = [1:1:length(g)];

%Obtain all the peaks of the data and all the peaks within a range.
[idx,idx]=findpeaks(g);
T=x(idx(2))-x(idx(1));

[peaks, locs] = findpeaks(g, 'MinPeakDistance',20);
[wrongPeaks, wrongLocs] = findpeaks(g);
 duration = v.Duration;

timePos = [];
wrongtimePos = [];
%Convert the data into the time domain, to be used for the heart rate
%calculation
for idx1 = 1:length(locs)
    timePos = [timePos, locs(idx1)*duration/length(g)];
    wrongtimePos  = [wrongtimePos, wrongLocs(idx1)*duration/length(g)];
    
end


%Plot the peaks of the data. First figure is all correct peaks. Second
%figure is all the peaks of the data.
figure
plot(x,g);
for indx2 = 1:length(locs)
    hold on
     plot(locs(indx2),peaks(indx2),'r*')
    
end
title('Intensity against frame number(peaks shown)');
xlabel('Frame number');
ylabel('Intensity');

figure
plot(x,g);
for indx3 = 1:length(wrongLocs)
    hold on
     plot(wrongLocs(indx3),wrongPeaks(indx3),'r*')
    
end
title('Intensity against frame number(false peaks shown)');
xlabel('Frame number');
ylabel('Intensity');


%Calculate the heart rate of the person in the video.
averageTimePerBeat = mean(diff(timePos));

heartrate = 1/averageTimePerBeat*60;

