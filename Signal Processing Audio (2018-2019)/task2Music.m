load('p1.mat');
[y,FS] = audioread('01 Mr. Blue Sky.mp3');
samples = [length(y)-(145*FS), length(y)-(135*FS)];
[y1,FS] = audioread('01 Mr. Blue Sky.mp3',samples);


%y2 = filter(VoiceFilter,y1); %Filtering out the lower pitch noises using
%high-pass.
%y2 = filter(VoiceFilterLow,y1); %Filtering out the higher picth noises
%using low-pass
%y2 = filter(VoiceFilterJoint,y1); %Both the filters being applied in the
%form of a bandpass filter.
y2= y1  %When no filter is being applied.
sound(y2,FS);

t = (0:1/FS:(length(y2)-1)/FS);

%Time graph
figure
plot(t,y2)
title('Time graph of Mr Blue Sky');
xlabel('Time (s)')
ylabel('Amplitude')


%Frequency graph
y3 = fft(y2);
f = (0:length(y3)-1)*FS/length(y3);
figure
plot(f/1000,abs(y3));
title('Frequency graph of Mr Blue Sky');
xlabel('Frequency (kHz)')
ylabel('Amplitude')
