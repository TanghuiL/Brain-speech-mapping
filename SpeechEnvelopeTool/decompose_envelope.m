function [yd,ye] = decompose_envelope(y, Fs, nlevel)

N = 2; %filter order

ye = envelope(y,Fs);

if nargin == 2
    nlevel = 5;
end

yed = downsample(ye,100);
Fs = Fs/100;
%{
1. 'Slow' AM tier
2. 'Stress' AM tier
3. 'Syllable' AM tier
4. 'Sub-beat' AM tier
5. 'Fast' AM tier
%}
Fcs = [0.5 0.8; 0.8 2.3; 2.3 7; 7 20; 20 50]; % cutt-off frequencies

for lev = 1:nlevel
    
    Wn = Fcs(lev,:)/(Fs/2);
    [a,b] = butter(N,Wn);
    yd{lev} = filter(a,b,yed);
    
end

