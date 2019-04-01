%addpath('C:\Users\tom\Desktop\matlab_aurora');

rng (35353);
Samps=2000; 
dev=openSup('COM5')%% OF ARDUINO 

    useTX = 0;
    commPort = 'COM3'; %% OF THE MAGNETIC TRACKER (IF AURORA)

act_range=[0 0 0 0 0 0 0 0 0;
    200 200 200 200 200 200 0 0 0]; %% PNEUMATIC RANGE CHANGE VALUES AND SIZE ACCORDINGLY
act_rangem=[450 280 280 250 450 250 250 250 450
            720 500 500 500 680 500 500 500 450]; %% motot RANGE CHANGE VALUES AND SIZE ACCORDINGLY
ini(:,1) =act_range(1,:);%initial pressure of cambers
inim(:,1) =act_rangem(2,:);


no_act= length(act_range);
setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);



%% no need to change
epsm=[15,15,15,15,15,15,15,15,15];%maximum change in servo motion
eps=10;%maximum change in pnemaitc pressure
softm=4;
soft=10;
smo=5;

del=1;% delay between data collection
for j=1:no_act
    tar(j,1)=randi([act_range(1,j),act_range(2,j)]); %target to reach in the actutator space
    % I use RANDI for easier communication
    tarm(j,1)=randi([act_rangem(1,j),act_rangem(2,j)]);
end

pause(10)

try
    %% Aurora Comm

    
    
    
    % open up the serial port.
    aurora = serial(commPort, 'BaudRate', 9600, 'terminator', 'CR', 'BytesAvailableFcnMode', 'terminator');
    fopen(aurora);
   
    %% send a serial break to ensure default set-up.
    serialbreak(aurora)
    [reply, count, msg] = fscanf(aurora);
    if( count <= 0 )
        error('%s', msg)
    elseif( ~strcmpi( reply(1:5), 'RESET') )
        fclose(aurora);
        error('Error: System did not receive the initial RESET');
    end
    
    %% reset the baud rate of the serial port.
    % first change the aurora baud rate.
    % fprintf(aurora, 'COMM 60001');
    % reply = fscanf(aurora);
    % fprintf(['COMM 60001 Reply: ', reply]);
    % if( ~strcmpi(reply(1:4), 'OKAY') )
    %     fclose(aurora);
    %     error('Error: COMM 60001 failed');
    % end
    % now change the system baud rate.
    % set(aurora, 'BaudRate', 921600, 'StopBits', 1, 'FlowControl', 'hardware');
    % pause(1);
    
    %% init the system.
    fprintf(aurora, 'INIT '); % note that the extra space is important here.
    reply = fscanf(aurora);
    fprintf(['INIT Reply: ', reply])
    if( ~strcmpi(reply(1:4), 'OKAY') )
        fclose(aurora);
        error('Error: INIT command failed.');
    end
    
    %% set up the port handles.
    
    % any port handles need freeing?
    fprintf(aurora, 'PHSR 01');
    phsr_reply = fscanf(aurora);
    fprintf(['PHSR 01 Reply: ', phsr_reply]);
    loc = 1;
    nToFree = hex2dec(phsr_reply(1:2));
    loc = loc + 2;
    if(nToFree > 0)
        for i = 1:nToFree
            handle = phsr_reply(loc:loc+1);
            fprintf(aurora, 'PHF %s', handle);
            reply = fscanf(aurora);
            if( ~strcmpi(reply(1:4), 'OKAY') )
                fclose(aurora);
                error('Error: PHF command failed.');
            end
            loc = loc + 5;
        end
    end
    
    
    % any port handles need to be initialized?
    fprintf(aurora, 'PHSR 02');
    phsr_reply = fscanf(aurora);
    fprintf(['PHSR 02 Reply: ', phsr_reply]);
    loc = 1;
    nToInit = hex2dec(phsr_reply(1:2));
    loc = loc + 2;
    if(nToInit > 0)
        for i = 1:nToInit
            handle = phsr_reply(loc:loc+1);
            send = sprintf('PINIT %s', handle);
            fprintf(['Sending... ', send, '\n']);
            fprintf(aurora, send);
            reply = fscanf(aurora);
            if( ~strcmpi(reply(1:4), 'OKAY') )
                fclose(aurora);
                error('Error: PINIT command failed.');
            end
            loc = loc + 5;
        end
    end
    
    % any port handle need to be enabled?
    fprintf(aurora, 'PHSR 03');
    phsr_reply = fscanf(aurora);
    fprintf(['PHSR 03 Reply: ', phsr_reply]);
    loc = 1;
    nToEnable = hex2dec(phsr_reply(1:2));
    loc = loc + 2;
    if(nToEnable > 0)
        for i = 1:nToEnable
            handle = phsr_reply(loc:loc+1);
            send = sprintf('PENA %sD', handle);
            fprintf(['Sending... ', send, '\n']);
            fprintf(aurora, send);
            reply = fscanf(aurora);
            if( ~strcmpi(reply(1:4), 'OKAY') )
                fclose(aurora);
                error('Error: PENA command failed.');
            end
            loc = loc + 5;
        end
    end
    
    % fprintf(aurora, 'SFLIST 03');
    fprintf(aurora, 'VSEL 3');
    reply = fscanf(aurora);
    fprintf(['FF: ', reply]);
    
    % start tracking.
    fprintf(aurora, 'TSTART ');
    reply = fscanf(aurora);
    fprintf(['TSTART Reply: ', reply]);
    if( ~strcmpi(reply(1:4), 'OKAY') )
        fclose(aurora);
        error('Error: TSTART command failed.');
    end
    
    
%% GETTING SAMPLES FOR LEARNING
    Counter = 1;
    while Counter<Samps
        % tx
        
        tic
        fprintf(aurora, 'TX 0001');
        reply = fscanf(aurora);
       % fprintf(['TX 0001 Reply: ', reply]);
        pos{Counter}=reply;
        
        
        
        for j=1:no_act
            
            
            if abs(inim(j,Counter)-tarm(j,1))<epsm(j)
                tarm(j,1)=randi([act_rangem(1,j),act_rangem(2,j)]);
                if rand >0.2
                elseif rand >0.5
                    tarm(j,1)=act_rangem(2,j);
                else
                    tarm(j,1)=act_rangem(1,j);
                end
                inim(j,Counter+1)=inim(j,Counter);
            else
                inim(j,Counter+1)=inim(j,Counter)- randi([0,epsm(j)])*sign((inim(j,Counter)-tarm(j,1)));
            end
            
            if abs(ini(j,Counter)-tar(j,1))<eps
                tar(j,1)=randi([act_range(1,j),act_range(2,j)]);
                ini(j,Counter+1)=ini(j,Counter);
            else
                ini(j,Counter+1)=ini(j,Counter)- randi([0,eps])*sign((ini(j,Counter)-tar(j,1)));
            end
            
            
            
            
        end
        % inim(7:9,Counter+1)=inim(7:9,Counter)+(inim(4:6,Counter+1)-inim(4:6,Counter))*(22/32);
        % ini(:,Counter+1)=act_range(1,:);
        
        %     if abs(ini(1,Counter)-tar(1,1))<eps
        %         tar(1,1)=randi([act_range(1,1),act_range(2,1)]);
        %            ini(1:3,Counter+1)=ini(1:3,Counter);
        %     else
        %         ini(1,Counter+1)=ini(1,Counter)- randi([0,eps])*sign((ini(1,Counter)-tar(1,1)));
        %          ini(2,Counter+1)=ini(1,Counter+1);
        %          ini(3,Counter+1)=ini(1,Counter+1);
        %     end
        %     vals=[0, 150, 255];
        %     for j=4:6
        %         pk=randi(3);
        %         ini(j,Counter+1)= vals(pk);
        %     end
        % setSup(ini(1,Counter+1),ini(2,Counter+1),ini(3,Counter+1),ini(4,Counter+1),ini(5,Counter+1),ini(6,Counter+1),ini(7,Counter+1),ini(8,Counter+1),ini(9,Counter+1),inim(1,Counter+1),inim(2,Counter+1),inim(3,Counter+1),inim(4,Counter+1),inim(5,Counter+1),inim(6,Counter+1),inim(7,Counter+1),inim(8,Counter+1),inim(9,Counter+1),dev);
        for ii=1:smo
            diff=ini(:,Counter+1)-ini(:,Counter);
            diffm=inim(:,Counter+1)-inim(:,Counter);
            addp=floor(diff*ii/smo);
            addm=floor(diffm*ii/smo);
            setSup((ini(1,Counter)+addp(1)),(ini(2,Counter)+addp(2)),(ini(3,Counter)+addp(3)),(ini(4,Counter)+addp(4)),(ini(5,Counter)+addp(5)),(ini(6,Counter)+addp(6)),(ini(7,Counter)+addp(7)),(ini(8,Counter)+addp(8)),(ini(9,Counter)+addp(9)),(inim(1,Counter)+addm(1)),(inim(2,Counter)+addm(2)),(inim(3,Counter)+addm(3)),(inim(4,Counter)+addm(4)),(inim(5,Counter)+addm(5)),(inim(6,Counter)+addm(6)),(inim(7,Counter)+addm(7)),(inim(8,Counter)+addm(8)),(inim(9,Counter)+addm(9)),dev);
            pause(0.1)
            
        end
        
        
        
        pause(del)
        Counter = Counter + 1
        
        toc
    end
    %[a(i),b(i)]=NDIAuroraPoseOrientation(reply);
    % get some data using BX...
    for i = 1:1
        
        
        % bx
        fprintf(aurora, 'BX 0001');
        fprintf('%s\n', aurora.TransferStatus);
        pause(1/40)
        if( aurora.BytesAvailable > 0 )
            reply = fread(aurora,aurora.BytesAvailable, 'char');
            hexreply = dec2hex(reply');
            bxreply = '';
            for j=1:length(hexreply)
                bxreply = [bxreply, hexreply(j,:)];
            end
            fprintf(['BX 0001 Reply: ', bxreply, '\n']);
        end
        
        
    end
    
    
    
    % stop tracking.
    fprintf(aurora, 'TSTOP ');
    
    reply = fscanf(aurora);
    fprintf(['TSTOP Reply: ', reply]);
    if( ~strcmpi(reply(1:4), 'OKAY') )
        fclose(aurora);
        error('Error: TSTOP command failed.');
    end
    
    
catch
    fclose(aurora);
    delete(aurora);
    clear aurora;
    
closeSup(dev)
    
end







