% load env and trials
clear
load('trials_Eng_normal_rate_55')

load('Extracted_Envelops');
ind = [8 10 12];
t = -1000:5:2500-5;
textmp={'Unint','Int','Original'}
colormp=['g' 'b' 'r'];

for i = 1:3,

    env_d{i} = downsample(env(ind(i)).signal,5);
    br(i,:) = mean(squeeze(trials(i).epoch(:,:,1)),1);
    
    [XCF{i}, Lags, Bounds] = crosscorr(br(i,:), env_d{i}',421);
    
    XCF{i} = corrmp(br(i,:),env_d{i}');
    %t = -2000:5:2000 + 420*5;
    %XCF{i} = conv(br(i,end:-1:1),env_d{i}');
    %subplot(3,1,i)
    plot(t,XCF{i},colormp(i));
    
    hold on
    %axis([-500 2000-5 -.5 1])
    ylabel(textmp{i})
    %{
    if 0
        corr_sig{i} = corrmp(br(i,:),env_d{i}');
    else
        corr_sig{i} = corrmp(br(i,end:-1:1),env_d{i}');
    end
    %}
end
legend('Unint','Int','Original')