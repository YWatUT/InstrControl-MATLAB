classdef KeysightE36312A
    % Keysight DC source borrowed from Prof. Kulkarni's group
    
    %% Properties
    properties
        instr_handle
    end
    
    %% Methods
    methods
        function obj = KeysightE36312A(instr_address)
            % Open the instrument at the given address
            try
                % need to change these lines
%                 obj.instr_handle = visa('ni','USB0::0x2A80::0x1102::MY59282614::INSTR');
                obj.instr_handle = visa('ni',instr_address);
%                 obj.instr_handle.InputBufferSize = 20000;
                fopen(obj.instr_handle);
                disp('Keysight E36312A connected successfully');
            catch ME
                disp(ME.message);
            end
        end
        
        function Apply(obj,value)
            % only doing channel 1 for the time being
            fprintf(obj.instr_handle,['APPL CH1, ',num2str(value)]);
        end
        
        function I = ReadCurrent(obj)
            I = str2double(obj.query('MEAS:CURR?'));
        end
        
        function TurnOn(obj, varagin)
            if nargin==1
                channel = '1';
            elseif nargin==2
                channel = varagin(1);
                if channel == 1 || channel == 2 || channel == 3
                    channel = num2str(channel);
                else 
                    disp('Outside Channel Range!')
                end
            else
                disp('Too many input parameters! Only enter channel n#');
            end
            
            fprintf(obj.instr_handle, ['OUTP 1, (@',channel,')']); 
        end
        
        function TurnOff(obj, varagin)
            if nargin==1
                channel = '1';
            elseif nargin==2
                channel = varagin(1);
                if channel == 1 || channel == 2 || channel == 3
                    channel = num2str(channel);
                else 
                    disp('Outside Channel Range!')
                end
            else
                disp('Too many input parameters! Only enter channel n#');
            end
            
            fprintf(obj.instr_handle, ['OUTP 0, (@',channel,')']); 
        end
        
        function output = query(obj, message)
            % Query anything using commands from the manual
            fprintf(obj.instr_handle,message);
            output = fscanf(obj.instr_handle);
        end

        function close(obj)
            fclose(obj.instr_handle);
        end
    end
end