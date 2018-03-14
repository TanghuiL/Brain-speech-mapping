t = 0:1e-4:1;
x = [1+cos(2*pi*50*t)].*cos(2*pi*1000*t);
plot(t,x); set(gca,'xlim',[0 0.1]);
xlabel('Seconds'); ylabel('Amplitude');

y = hilbert(x);
env = abs(y);
plot(t,x); hold on;
plot(t,abs(y),'r','linewidth',2);
plot(t,-abs(y),'r','linewidth',2);
set(gca,'xlim',[0 0.1]);
xlabel('Seconds'); ylabel('Amplitude');



figure(3)
[x fs]=wavread('.\Sample\sample.wav');
t = 0:1/fs:(length(x)-1)/fs;
%{
y = hilbert(abs(x));
env = abs(y);
%}
y=envelope(x,fs);
plot(t',x); hold on;
plot(t,abs(y),'r','linewidth',2);
plot(t,-abs(y),'r','linewidth',2);
set(gca,'xlim',[0 2]);
xlabel('Seconds'); ylabel('Amplitude');

