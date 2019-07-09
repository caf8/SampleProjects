load('p1.mat');
[y,FS] = audioread('voice.mp3');
y1 = filter(voicebandpassgap,y); %Filter for band-pass with larger gap
%y1 = filter(voicebandpassNogap,y); %Filter for band-pass with small gap
%y1 = filter(voiceHighest,y); %Filter for High-pass, with highest range
%y1 = filter(voiceNextHighest,y); %Filter for High-pass, with next highest range
%y1 = filter(voiceLowest,y); %Filter for low-pass, with lowest range
%y1 = filter(voiceNextLowest,y); %Filter for low-pass, with next lowest range
%y1= y; %When no filter is being applied.


sound(y1,FS);
t = (0:1/FS:(length(y1)-1)/FS);


%Time graph
figure
plot(t,y1)
title('Time graph of voice audio with Highest High-pass filter');
xlabel('Time (s)')
ylabel('Amplitude')


%Frequency graph
y2 = fft(y1);
f = (0:length(y2)-1)*FS/length(y2);
figure
plot(f/1000,abs(y2));
title('Frequency graph of voice audio with Highest High-pass filter');
xlabel('Frequency (kHz)')
ylabel('Amplitude')
