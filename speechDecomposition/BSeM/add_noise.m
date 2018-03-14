% add noise to  a speech signal

load handel.mat;

hfile= 'noisy.wav';

%y = wavread('daveno.wav');
y = y + randn(size(y)) * (1/100);
wavwrite(y, Fs, hfile);
nsamples=Fs;