function env_f = envelope_filterbank(signal, Fs, nbank)

if size(signal,2)==2
    signal = signal(:,1);
end
% camirea
% a0 = 50;
% a1 = 4000;
% t = 0:.1:1;
% Fb = a0+(a1-a0)*(exp(4*t)-1)./(exp(4)-1);

f0 = 80;
f1 = 8820;%8820;
x0 = 1./2.1*log10(f0/165.4+.88);
x1 = 1./2.1*log10(f1/165.4+.88);
x = x0:(x1-x0)/nbank:x1;
f = 165.4*(10.^(2.1*x)-.88);

Fbs = f(1:end-1);
Fbe = f(2:end);

env_f = cell(1,length(Fbs));

for i = 1:length(Fbs),
    Wn = [Fbs(i) Fbe(i)]./(Fs/2);
    Wn(1) = max(0,Wn(1));
    Wn(2) = min(.95,Wn(2));
    if 0
    [sig_f,h{i}] = filter_mp(signal,Wn);
    else
        [b,a] = butter(2,Wn);
        %h{i} = freqz(b,a,w);
        sig_f = filter(b,a,signal);
    end
    [yd,ye] = decompose_envelope(sig_f, Fs);
    env_f{i} = ye;
    %env_f{i} = abs(hilbert(sig_f));
end
%hm = cell2mat(h);
%d= 2;
%{
Fbs = 50:50:4000;
Fbe = 100:50:4050;
env_f = cell(1,length(Fbs));

for i = 1:length(Fbs),
    Wn = [Fbs(i) Fbe(i)]./(Fs/2);
    [a,b] = butter(2,Wn);
    sig_f = filter(a,b,signal);
    env_f{i} = abs(hilbert(sig_f));
end
%}
