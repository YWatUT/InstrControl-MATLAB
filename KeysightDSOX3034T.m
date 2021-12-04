classdef KeysightDSOX3034T
    % Keysight 350 MHz scope borrowed from Prof. Kulkarni's group
    
    %% Properties
    properties
        instr_handle
    end
    
    %% Methods
    methods
        function obj = KeysightDSOX3034T(instr_address)
            % Open the instrument at the given address
            try
                % need to change these lines
                obj.instr_handle = visa('ni',instr_address);
                obj.instr_handle.InputBufferSize = 20000;
                fopen(obj.instr_handle);
                disp('Keysight DSOX3034T connected successfully');
            catch ME
                disp(ME.message);
            end
        end
        
        
        function [data_array] = ReadWav(obj)
            % Read in a waveform and parse it into a value array
            obj.Send(':WAV:FORM ASCii');
            data_raw = query(obj.instr_handle,':WAV:DATA?');
            data_array = str2double(strsplit(data_raw(11:end),','));
        end
        
        function SetAverageNumber(obj,value)
            fprintf(obj.instr_handle,['ACQ:COUN ', num2str(value)] );
        end
        
        %% Utility Methods
        function output = query(obj, message)
            % Query anything using commands from the manual
            fprintf(obj.instr_handle,message);
            output = fscanf(obj.instr_handle);
        end
        
        function Autoscale(obj)
            wav = obj.ReadWav();
            WavMax = max(wav);
            WavMin = min(wav);
            Offset = (WavMax(1)+WavMin(1))./2;
            Scale = ceil((WavMax-WavMin)*1e3/6);
            obj.Send([':CHAN1:OFFS ',num2str(Offset)]);
            obj.Send([':CHAN1:SCAL ',num2str(Scale*1e-3)]);
        end
        
        function t = TimeAxis(obj)
            points = length(obj.ReadWav());
            TRange = str2double(obj.query(':TIMebase:RANGe?'));
            TInc = TRange./points;
            t = ((1:points)-1).*TInc;
        end
        
        function Send(obj,message)
            fprintf(obj.instr_handle,message);
        end
        
        function output = Read(obj)
            output = fscanf(obj.instr_handle);
        end
        
        function Run(obj)
            fprintf(obj.instr_handle, ':RUN');
        end
        
        function Stop(obj)
            fprintf(obj.instr_handle, ':STOP');
        end
        
        function close(obj)
            fclose(obj.instr_handle);
        end
    end
end