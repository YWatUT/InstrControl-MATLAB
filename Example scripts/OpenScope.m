% Scope = KeysightDSOX3034T('USB0::0x2A8D::0x1764::MY59243306::INSTR');
Scope = AgilentDSO9404A('USB0::0x0957::0x9009::MY52250112::INSTR');

t = Scope.TimeAxis();
wav_raw = Scope.ReadWav();
plot(t, wav_raw)
