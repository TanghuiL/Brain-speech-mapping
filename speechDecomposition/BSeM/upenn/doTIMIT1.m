sumfENV = zeros(150,1);
fid = fopen ("filelist"); 
# text file with 6300 lines, one per TIMIT audio file
while ((txt = fgetl(fid))>0)
%  printf("%s\n",txt);
  [X, FS] = wavread(txt);
  ENV = getENV(X,FS,.025,200); ENV = ENV-mean(ENV);
  ENV1 = zeros(2048,1);
  ENV1(1:length(ENV)) = ENV;
  fENV = fftshift(abs(fft(ENV1)));
  sumfENV = sumfENV+fENV(1025:1174);
end
sumfENV = sumfENV/6300;
sumfENV = 20*log10(sumfENV); sumfENV = sumfENV-max(sumfENV);
% amplitude spectrum has 1024 samples from 0 to Nyquist freq = 100 Hz
% ...so 100/1024 per sample
FF = (10:149)*100/1024;
# plot the results
hold off
plot(FF,sumfENV(11:150),'r+-')
hold on
xlabel("Frequency in Hz (from rectified waveform, 25 msec window, 200 Hz frame rate)")
ylabel("Amplitude in dB")
title("Average spectrum of rectified waveform envelope, 6300 TIMIT sentences")
plot([2.4 2.4],[-23 0],'b-')
text(1.0, -20, "2.4 Hz =")
axis([0 15 -23 0])
print -dpng TIMIT1.png 
