sumfRMS = zeros(150,1);
fid = fopen ("filelist"); 
# text file with 6300 lines, one per TIMIT audio file
while ((txt = fgetl(fid))>0)
%  printf("%s\n",txt);
  [X, FS] = wavread(txt);
  RMS = getRMS(X,FS,.025,200);
  RMS1 = zeros(2048,1);
  RMS1(1:length(RMS)) = RMS;
  fRMS = fftshift(abs(fft(RMS1)));
  sumfRMS = sumfRMS+fRMS(1025:1174);
end
sumfRMS = sumfRMS/6300;
% amplitude specttrum has 1024 samples from 0 to Nyquist freq = 100 Hz
% ...so 100/1024 per sample
FF = (10:149)*100/1024;
# plot the results
hold off
plot(FF,20*log10(sumfRMS(11:150)),'r+-')
hold on
plot([2.4 2.4],[-23 -2],'b-')
%plot([2.9 2.9],[-23 -2],'g-')
text(1.0, -20, "2.4 Hz =")
%text(3.05,-15,"= 2.9 Hz")
xlabel("Frequency in Hz (of RMS amplitude, 25 msec window, 200 Hz frame rate)")
ylabel("Amplitude in dB")
title("Average spectrum of amplitude contour, 6300 TIMIT sentences")
axis([0 15 -23 0])
print -dpng TIMIT2.png 
