% DCSource = KeysightE36312A('USB0::0x2A8D::0x1102::MY59282614::INSTR');
DCSource = AgilentE3631A('ASRL4::INSTR');

% DCSource.Apply(0.1);
% DCSource.TurnOn;
% pause(2);
% DCSource.query('MEAS:CURR?')
% DCSource.query('APPL?')
% 
% DCSource.TurnOff;
% DCSource.close()