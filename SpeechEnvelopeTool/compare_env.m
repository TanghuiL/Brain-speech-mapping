% compare the envelopes
Nbank = 16;
[signal,Fs] = wavread('H:\MyData\SpeechEnvelopeTool\Sample\Sample_different_filterbanks\P5_1.wav');
env_f_16 = envelope_filterbank(signal, Fs, 16);
env_f_1 = envelope_filterbank(signal, Fs, 1);

len_signal = length(signal);
fin_f = fin_structure_filterbank(Fs,len_signal, Nbank);
fin_all = fin_structure_filterbank(Fs,len_signal, 1);

env_white_noise1 = comb_env_fin(env_f_16, fin_f,2,fin_all);
[yd,ye1] = decompose_envelope(env_white_noise1, Fs);

env_white_noise16 = comb_env_fin(env_f_16, fin_f,1,fin_all);
[yd,ye16] = decompose_envelope(env_white_noise16, Fs);
[yd,ye_signal] = decompose_envelope(signal, Fs);

figure
plot(ye_signal)
hold on
plot(ye1,'g-')
plot(ye16,'r-')

r16 = ye_signal./(ye16+(abs(ye16)<1e-2));
r1 = ye_signal./(ye1+(abs(ye1)<1e-2));
yer1 = ye1.*r1;
yer16 = ye16.*r16;
env_white_noise1_r = env_white_noise1.*r1;
env_white_noise16_r = env_white_noise16.*r16;

figure
subplot(311)
plot(signal)
%hold on
subplot(312)
plot(env_white_noise1_r,'g-')
subplot(313)
plot(env_white_noise16_r,'r-')

 if 0
    lwindow = round(.05*Fs);
    noverlap = round(.04*Fs);
    nfft = round(.05*Fs);
    figure();
    F = 0:80;
    [S,F,T] = spectrogram(ye1',lwindow,noverlap,F,Fs,'yaxis');
else
    lwindow = round(.05*Fs);
    noverlap = round(.04*Fs);
    nfft = round(.05*Fs);
    figure();
    F = 0:1000;
    [S,F,T] = spectrogram(signal',lwindow,noverlap,F,Fs,'yaxis');
    imagesc(T,F,abs(S))
    set(gca,'YDir','normal')
    xlabel('Time(s)')
    ylabel('Frequency (Hz)')
    title('Spectrogram')
end
imagesc(T,F,abs(S))
set(gca,'YDir','normal')
xlabel('Time(s)')
ylabel('Frequency (Hz)')
title('Spectrogram')