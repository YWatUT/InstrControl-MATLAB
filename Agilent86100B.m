classdef Agilent86100B
    % Class including methods for the Agilent 86100B
    % digital sampling oscilloscope...?
    
    %% properties
    properties
        instr_handle
    end
    
    
    %% Methods
    methods
        function obj = Agilent86100B(instr_address)
            % Open the scope at the given instrument address
            try
                obj.instr_handle = visa('ni',instr_address);
                obj.instr_handle.InputBufferSize = 20000;
                fopen(obj.instr_handle);
                disp('Scope connected successfully');
            catch ME
                disp(ME.message);
            end
        end
        
        function [data_array] = ReadWav(obj)
            % Read in a waveform and parse it into a value array
            data_raw = query(obj.instr_handle,':WAV:DATA?');
            data_array = str2double(strsplit(data_raw,','));
        end
        
        function SetDelay(obj, value)
            % Set time delay of the signal (after trigger?)
            fprintf(obj.instr_handle,[':TIMebase:POSition ',num2str(value)]);
        end
        
        function SetTimeScale(obj, value)
            fprintf(obj.instr_handle,[':TIMebase:SCALe ',num2str(value)]);
        end
        
        function SetCh1Offset(obj, value)
            % Set voltage offset of the signal
            fprintf(obj.instr_handle,[':CHANnel1:OFFSet ',num2str(value)]);
        end
        
        function SetCh1Scale(obj, value)
            % Set voltage scale of channel 1
            fprintf(obj.instr_handle,[':CHANnel1:SCALe ',num2str(value)]);
        end
        
        
        %% utility methods
        function SetDisplayMode(obj,param)
            % Acceptable parameters are
            % MINimum  INFinite  <persistent_value> (0.1-40)
            fprintf(obj.instr_handle,[':DISPlay:PERSistence ',param]);
        end
        function output = query(obj, message)
            % Query anything using commands from the manual
            fprintf(obj.instr_handle,message);
            output = fscanf(obj.instr_handle);
        end
        
        function t = TimeAxis(obj)
            points = length(obj.ReadWav());
            TRange = str2double(obj.query(':TIMebase:RANGe?'));
            TInc = TRange./points;
            t = ((1:points)-1).*TInc;
        end
        
        function close(obj)
            fclose(obj.instr_handle);
        end
        
    end
end