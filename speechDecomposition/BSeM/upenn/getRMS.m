function ret = getRMS(X,inFS,window,outFS)
  nwindow = round(window*inFS);
  ninc = round(inFS/outFS);
  lastloc = length(X)-nwindow;
  nframes = round(lastloc*outFS/inFS);
  ret=zeros(nframes,1);
  hh = hamming(nwindow);
  for n=1:nframes
    s1 = (n-1)*ninc + 1;
    xx = X(s1:(s1+nwindow-1)).*hh;
    ret(n) = sqrt((xx'*xx)/nwindow);
  end
end

