% read event file
clear
event_data = importdata('s1498_4blocks_NEW_TEST.evt');
k = 0;
for i = 3:size(event_data.data,1),
    trig_data_p = event_data.data(i-2:i-1,3);
    trig_data = event_data.data(i,3);
    if ~any(trig_data==[16 23:25])
        continue
    end
    k = k+1;
    if trig_data == 16
        
        trig_code(k) = 13;
        time_info(k) = event_data.data(i,1);
    else
        trig_code(k) = 6*(trig_data_p(1) == 18) + 3*(trig_data_p(2) == 21) + (trig_data == 24) + 2*(trig_data == 25) + 1;
       
        time_info(k) = event_data.data(i,1);
    end
    
end

save('trgi_data','time_info','trig_code');