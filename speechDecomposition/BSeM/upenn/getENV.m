function ret = getENV(X,inFS,window,outFS)
  nwindow = round(window*inFS);
  ninc = round(inFS/outFS);
  lastloc = length(X)-nwindow;
  nframes = round(lastloc*outFS/inFS);
  ret=zeros(nframes,1);
  hh = hamming(nwindow);
  hh = hh./sum(hh);
  for n=1:nframes
    s1 = (n-1)*ninc + 1;
    xx = abs(X(s1:(s1+nwindow-1))).*hh;
    ret(n) = sum(xx);
  end
end

