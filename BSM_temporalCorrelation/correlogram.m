% correlogram
function c = correlogram(x,y,t,time_window, MAX_DEL)
% x: first signal 
% y: second signal
% t: trigger signal contains the onsets
% time_window: time window of interest

if nargin == 4
    MAX_DEL = 100;
end

L = time_window(2)-time_window(1)+1;

for i = 1:MAX_DEL,
    
    td = [zeros(1,i-1) t(1:length(t)-i + 1)];
    n_obs = length(find(t~=0));
    
    t_sub = conv(td,ones(1, L),'same');
    x_sub = t_sub.*x;
    x_sub_nz = x_sub;
    x_sub_nz(t_sub == 0)=[];
    x_sub = reshape(x_sub_nz,[L n_obs]);
    
    t_sub = conv(t,ones(1, L),'same');
    y_sub = t_sub.*y;
    y_sub_nz = y_sub;
    y_sub_nz(t_sub == 0)=[];

    y_sub = reshape(y_sub_nz,[L n_obs]);
    mx = mean(x_sub,2)*ones(1,n_obs);
    my = mean(y_sub,2)*ones(1,n_obs);
    x_sub = x_sub - mx;
    y_sub = y_sub - my;
    c(:,i) = sum(x_sub .* y_sub, 2)./(sqrt(sum(x_sub.*x_sub,2)).*sqrt(sum(y_sub.*y_sub,2)));
    
end






