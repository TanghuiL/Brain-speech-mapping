fid = fopen('s1498_4blocks_NEW_TEST.mul','rb');
g = 0;
while (1)
    s = fgetl(fid);
    if ~ischar(s) break; end
    
    if s~= -1
        disp(s)
        pause
    end
    %pause;
    g = g+1;
end