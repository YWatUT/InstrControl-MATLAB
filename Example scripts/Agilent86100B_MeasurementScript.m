clear;
clc;

%% Save path settings
sample_name = '20210915_B210416A_InSbHoleySample6_Device1_77K';
save_path = [pwd,'\',sample_name,'\'];
if ~exist(save_path, 'dir')
    mkdir(save_path)
end

close(figure(1));


%% Connecting socpe, basic settings
scope = Agilent86100B('GPIB0::7::INSTR');
scope.SetTimeScale(750e-12);
data = scope.ReadWav();
data_avg = zeros(size(data));
t = scope.TimeAxis();
% plot(t, data);

%%

scan_num = 400;
avg_num = 10;

file_name = [num2str(length(dir(save_path))-1),'_block4_77K_750ps_scan',...
    num2str(scan_num),'_avg',num2str(avg_num),'.mat'];
tic
for j = 1:avg_num
    data = scope.ReadWav();
for i = 1:scan_num
    temp = scope.ReadWav();
    figure(3); plot(t, temp)
    axis([t(1), t(end), -0.210 -0.090]);
    pause(0.02);
    data = min(data, temp);
end
    figure(1);
    hold on;
    plot(t, data);
    data_avg = data_avg+data;
end
toc
data_avg = data_avg./avg_num;
% h_avg = plot(t, data_avg,'-o');
% legend(h_avg, 'avg');

figure(2); hold on;
plot(t, data_avg);

save([save_path,file_name],'t','data_avg','-v7.3');

scope.close();
% 