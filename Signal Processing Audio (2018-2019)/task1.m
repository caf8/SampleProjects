
%Defining data that is needed for time and frequecny analysis in signal
%processing.
fs = 10000;
t1 = 0:1/fs:10;
C2 = 261.62555;
ft = [t1*C2];

%Playing the sound that was created (middle C).
play1 = sin(2*pi*ft);
player = audioplayer(play1, fs);
play(player);

%Time Graph
figure
plot(t1, play1); 
title('Time Domain Graph of Middle C');
xlabel('Time(s)');
ylabel('Amplitude');

[idx,idx]=findpeaks(play1);
T=t1(idx(2))-t1(idx(1));

%Frequency Graph
figure
y = fft(play1);
f = (0:length(y)-1)*fs/length(y);
plot(f,abs(y))

[idx1,idx1] = findpeaks(abs(y));
F=f(idx1(2))-f(idx1(1));
title('Frequency Domain Graph of Middle C');
xlabel('Frequency (Hz)');
ylabel('Amplitude')



