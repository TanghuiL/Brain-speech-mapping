close all
clear all


%figure


    

y=wavread('Q1.wav');
yy=squeeze(y(:,1));

  x=hilbert(yy);
 
 
 upenv=abs(x);

 
 lowenv=-abs(x);

% plot(y);

% hold on;

plot(upenv,'r');

hold on

plot(lowenv,'b')


% % % % % % % % % % % % % % % % % % % % 
% 
% Fs = 1000;
%     t = 0:0.001:1-0.001;
%     % 250-Hz sine wave modulated at 10 Hz
%     x = [1+cos(2*pi*10*t)].*cos(2*pi*250*t);
%     y = hilbert(x);
%     plot(t,x,'k'); hold on;
%     plot(t,abs(y),'b','linewidth',2);
%     plot(t,-abs(y),'b','linewidth',2);