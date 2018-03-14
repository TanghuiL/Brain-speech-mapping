function fin_f = fin_structure_filterbank(Fs,len_signal, nbank)


f0 = 80;
f1 = 8820;% 8820
x0 = 1./2.1*log10(f0/165.4+.88);
x1 = 1./2.1*log10(f1/165.4+.88);
x = x0:(x1-x0)/nbank:x1;
f = 165.4*(10.^(2.1*x)-.88);

Fbs = f(1:end-1);
Fbe = f(2:end);
fin_f = cell(1,length(Fbs));
signal = randn(len_signal,1);
for i = 1:length(Fbs),
    Wn = [Fbs(i) Fbe(i)]./(Fs/2);
    Wn(1) = max(0,Wn(1));
    Wn(2) = min(.95,Wn(2));
    [sig_f,h{i}] = filter_mp(signal,Wn);
    %[a,b] = butter(2,Wn);
    %sig_f = filter(a,b,signal);
    %env_f = abs(hilbert(sig_f));
    fin_f{i} = sig_f/sqrt(mean(sig_f.^2));%./(ye + (ye == 0));%./(sig_f + (sig_f == 0));
end


%{
Fbs = 50:50:4000;
Fbe = 100:50:4050;
fin_f = cell(1,length(Fbs));
signal = randn(len_signal,1);
for i = 1:length(Fbs),
    Wn = [Fbs(i) Fbe(i)]./(Fs/2);
    [a,b] = butter(2,Wn);
    sig_f = filter(a,b,signal);
    env_f = abs(hilbert(sig_f));
    fin_f{i} = sig_f./(env_f + (env_f == 0));
end

%}