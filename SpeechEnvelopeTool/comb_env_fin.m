function env_white_noise = comb_env_fin(env_f, fin_f,flag,fin_all)

if nargin ==2
    flag = 1;
end

env_white_noise = 0;
if flag == 1
    for i = 1:length(env_f),
        env_white_noise = env_white_noise + env_f{i}.*fin_f{i};
    end
else
    for i = 1:length(env_f),
        env_white_noise = env_white_noise + env_f{i}.*fin_all{1};
    end
    
end