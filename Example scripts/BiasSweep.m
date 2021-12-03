close(figure(1));
DCSource = KeysightE36312A('USB0::0x2A8D::0x1102::MY59282614::INSTR');
% Scope = KeysightDSOX3034T('USB0::0x2A8D::0x1764::MY59243306::INSTR'); % 350 MHz scope
Scope = KeysightMSOS404A('USB0::0x2A8D::0x904D::MY59300105::INSTR');

Indicator = ['180K_0-1V_','SampleCenterOffset_Lens_'];

BiasHigh = 1;
BiasLow = 0;
BiasStep = 0.02;

manual_avg = 10;

bias = BiasLow: BiasStep: BiasHigh;


DCSource.Apply(0);
DCSource.TurnOn(1);

StartScale = 5e-3;
Scope.Send(':WAV:SOUR CHAN1');
Scope.Send(':CHAN1:SCAL 5e-3');
Scope.Send(':CHAN1:OFFS 0');
Scope.Autoscale();

OperatingCurrent = zeros(size(bias));
WaveformLength = length(Scope.ReadWav());
t = Scope.TimeAxis();
Data = zeros(length(bias)+1, WaveformLength);

Waveform_temp = t - t;

figure(1); hold on;

for i = 1:length(bias)
    DCSource.Apply(bias(i));
    pause(5);
    Scope.Autoscale();
    Waveform_temp = Waveform_temp - Waveform_temp;
    for j = 1: manual_avg
    Waveform = Scope.ReadWav();
    pause(0.2);
    Waveform_temp = Waveform_temp + Waveform;
    end
    Waveform = Waveform_temp./manual_avg;
    Data(i,:) = Waveform;
    figure(1);
    plot(t, Waveform);

    
    OperatingCurrent(i) = DCSource.ReadCurrent();
end


DCSource.Apply(0);
disp('Block beam to take baseline');
Scope.Send(':CHAN1:SCAL 5e-3');
Scope.Send(':CHAN1:OFFS 0');
pause(5);
Scope.Autoscale();


pause();
Data(end,:) = Scope.ReadWav();




DCSource.TurnOff(1);
DCSource.close();
Scope.close();


filename = [Indicator,datestr(now,'mmdd_HHMMSS'),'.mat'];
save(filename,'t','bias','OperatingCurrent','Data','-v7.3');

