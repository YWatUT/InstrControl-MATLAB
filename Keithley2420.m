classdef Keithley2420
    % Keithley 2420 Sourcemeter
    
    %% Properties
    properties
        instr_handle
    end
    
    %% Methods
    methods
        %% Initialize
        function obj = Keithley2420(instr_address)
            % Open the instrument at the given address
            try
                % need to change these lines
%                 obj.instr_handle = visa('ni','USB0::0x2A80::0x1102::MY59282614::INSTR');
                obj.instr_handle = visa('ni',instr_address);
%                 obj.instr_handle.InputBufferSize = 20000;
                fopen(obj.instr_handle);
                disp('Keithley 2420 connected successfully');
                obj.write('*RST');
            catch ME
                disp(ME.message);
            end
        end
        
        %% Measurements
        function Setup(obj,varagin)
            obj.write(':syst:beep:stat 0');
            obj.write(':sour:volt:mode fixed');
            obj.write(':sens:func "curr"');
            if nargin ==2
                CurrentLimit = varagin(1);
            else
                CurrentLimit = 0.1;
            end
            obj.write([':sens:curr:prot ',num2str(CurrentLimit)]);
        end
        
        function SetVoltage(obj, voltage)
            obj.write([':sour:volt:lev ', num2str(voltage)]);
        end
        
        function SetCurrentLimit(obj, CurrentLimit)
            obj.write([':sens:curr:prot ',num2str(CurrentLimit)]);
        end
        
        function current = ReadCurrent(obj)
            data_raw = obj.query('meas:curr?');
            data_array = str2double(strsplit(data_raw,','));
            current = data_array(2);
        end
        
        function on(obj)
            obj.write(':outp on');
        end
        
        function off(obj)
            obj.write(':outp off');
        end
        
        %% Utility
        function write(obj,message)
            fprintf(obj.instr_handle,message);
        end
        
        function output = read(obj)
            output = fscanf(obj.instr_handle);
        end
        
        function output = query(obj, message)
            % Query anything using commands from the manual
            fprintf(obj.instr_handle,message);
            output = fscanf(obj.instr_handle);
        end

        function close(obj)
            fclose(obj.instr_handle);
            disp('Keithley 2420 instr handle closed');
        end
    end
end