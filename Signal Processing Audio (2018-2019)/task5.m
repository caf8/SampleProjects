
    load('p1.mat');
    [y,fs] = audioread ('audio_in_noise.wav');
    %y2 = y; %Used to play file without filter
    y2 = filter(task5Filter,y); %Used to filter out the noise
    player = audioplayer(y2,fs);
    play(player);
    
    
    t = (0:1/fs:(length(y2)-1)/fs);

    %Time Graph
    figure
    plot(t,y2);    
    title('Time Domain of audio in noise.wav after filtering');
    xlabel('Time (s)');
    ylabel('Amplitude');
  
    %Frequency Graph
    y1 = fft(y2);
    f = (0:length(y1)-1)*fs/length(y1);
    figure
    plot(f,abs(y1))
    title('Frequency Domain of audio in noise.wav after filtering');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
  