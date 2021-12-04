
v_start = -0.5;
v_end = 0.5;
v_step = 0.005;
n_avg = 1;

filename = ['185K_C5R3_DCProbe_',datestr(now,'mmdd_HHMMSS'),'_',num2str(v_start),'to',num2str(v_end),'.mat'];


t_sleep = 0.1;

bias = v_start:v_step:v_end;
current = zeros(size(bias));


DC = Keithley2420('GPIB0::24::INSTR');
DC.Setup(0.1);
DC.SetVoltage(bias(1));
DC.on;

for i = 1:length(bias)
DC.SetVoltage(bias(i));
current_temp = 0;

for j = 1:n_avg
pause(t_sleep);
current_temp = current_temp+DC.ReadCurrent;
end
current(i) = current_temp/n_avg;

% DC.off;
end


DC.SetVoltage(0);
DC.off;
DC.close();

figure(1); hold on;
subplot(131);
plot(bias,current,'-o');
subplot(132);
plot(bias,abs(current),'-o');
set(gca,'YScale','log');
subplot(133);
dv_xax = 0.5*(bias(2:end) + bias(1:end-1));
di = current(2:end) - current(1:end-1);
plot(dv_xax, v_step./di);

save(filename, 'bias', 'current', '-v7.3');