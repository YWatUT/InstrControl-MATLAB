
scope = visa('ni','GPIB0::7::INSTR');
scope.InputBufferSize = 20000;

fopen(scope);
% data_array = ReadWav(scope);
% t = 1:1350;
% plot(t, data_array);
% fclose(scope);