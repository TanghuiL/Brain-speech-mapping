% extract the envelopes
WAV_path = './WAV/*.wav';

file_list = dir(WAV_path);

for i = 1:length(file_list),
    
    [y,Fs] = wavread(['./WAV/' file_list(i).name]);
        
    env(i).signal = envelope(y, Fs);
    if Fs == 44100,
        env(i).signal = resample(env(i).signal,10, 441);
    else
        env(i).signal = resample(env(i).signal,10, 160);
    end
    env(i).name = file_list(i).name(1:end-4);
    file_list(i).name(1:end-4)
    
end

save('Extracted_Envelops','env')