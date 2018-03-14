function  add_noise()

if nargin == 0
    [FileName,PathName] = uigetfile({'*.wav', 'wave files (*.wav)'},'Select a sound file');
end
[y, Fs] = wavread([PathName FileName]);
filename = [PathName FileName(1:end-4) 'noise.wav'];

 

y_noise = randn(size(y));
y_energy = sum(y.^2);


% Lowpass filter
Fbe = 8000;%8820;
Wn = [Fbe]./(Fs/2);
Wn = .99;
[a,b] = butter(2,Wn);
y_noise = filter(a,b,y_noise);
noise_energy = sum(y_noise.^2);
y_noise = y_noise./noise_energy*y_energy;


wavwrite(y_noise, Fs, filename);
% add noise to  a speech signal

%{


load handel.mat;

hfile= 'noisy.wav';

%y = wavread('daveno.wav');
y = y + randn(size(y)) * (1/100);
wavwrite(y, Fs, hfile);
nsamples=Fs;

%}