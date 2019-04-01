
Samps=50000;
dev=openSup('COM5')
act_range=[0 0 0 0 0 0 0 0 0;
    200 200 200 200 200 200 0 0 0];
act_rangem=[450 280 280 250 450 250 250 250 450
            720 500 500 500 680 500 500 500 450];
ini(:,1) =act_range(1,:);%initial pressure of cambers
inim(:,1) =act_rangem(2,:);
inim(1,1)=450;
inim(1,5)=450;

no_act= length(act_range);
setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);


%epsm=[15,15,15,15,15,15,15,15,15];%maximum change in servo motion
epsm=[20,15,15,15,20,15,15,15,15];
eps=40;%maximum change in pnemaitc pressure
softm=4;
soft=10;
smo=5;

del=0.6;% delay between data collection
for j=1:no_act
    tar(j,1)=randi([act_range(1,j),act_range(2,j)]); %target to reach in the actutator space
    % I use RANDI for easier communication
    tarm(j,1)=randi([act_rangem(1,j),act_rangem(2,j)]);
end

pause(10)

try
    % Aurora Comm
    useTX = 0;
    commPort = 'COM3';
    
    
    
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
    
    
    % get some data using TX..
    
    Counter = 1;
    pk=randi(2000);
    pdis=30;
%     
     target(1,1:pdis)=200*ones(pdis,1);
 target(2,1:pdis)=linspace(-150,150,pdis);
 target(3,1:pdis)=-400*ones(pdis,1);
 
      target(1,pdis+1:2*pdis)=linspace(200,70,pdis);
 target(2,pdis+1:2*pdis)=150*ones(pdis,1);
 target(3,pdis+1:2*pdis)=linspace(-400,-250,pdis);
 
      target(1,2*pdis+1:3*pdis)=70*ones(pdis,1);
 target(2,2*pdis+1:3*pdis)=linspace(150,-150,pdis);
 target(3,2*pdis+1:3*pdis)=-250*ones(pdis,1);
 
      target(1,3*pdis+1:4*pdis)=linspace(70,200,pdis);
 target(2,3*pdis+1:4*pdis)=-150*ones(pdis,1);
 target(3,3*pdis+1:4*pdis)=linspace(-250,-400,pdis);
%  
% 
%  target(:,4*pdis+1:8*pdis)=target(:,:);
    while Counter<Samps
        % tx
        
        
             if mod(Counter,200)==0
                pk=randi(3000);
            end
        %target(:,Counter)=posi(:,pk);
        %targeto(:,Counter)=sin(Counter/20);
        %targeto(:,Counter)=0;
        targeto(:,Counter)=[0*sin(Counter/10),0*sin(Counter/10)];
        
        fprintf(aurora, 'TX 0001');
        %fprintf(aurora, 'TX 1001');
        reply = fscanf(aurora);
        
        
        s=reply;
        if strcmp(s(5:11), 'MISSING')
            %whole(:,i)=NaN;
            posnow(Counter,1:3)=0;
            orinow(Counter,1:3)=0;
        else
            [waste,whole(:,Counter)]=NDIAuroraPoseOrientation((reply));
            
            posnow(Counter,:)=whole(Counter).pose;
            for j=1:3
                if abs(posnow(Counter,j))<400
                    posnow(Counter,j)=posnow(Counter,j)/4;
                elseif abs(posnow(Counter,j))>400&&abs(posnow(Counter,j))<1050
                    posnow(Counter,j)=(posnow(Counter,j)-250*sign(posnow(Counter,j)))/4;
                elseif abs(posnow(Counter,j))>1700&&abs(posnow(Counter,j))<2400
                    posnow(Counter,j)=(posnow(Counter,j)-750*sign(posnow(Counter,j)))/4;
                elseif abs(posnow(Counter,j))>2400
                    posnow(Counter,j)=(posnow(Counter,j)-1000*sign(posnow(Counter,j)))/4;
                else
                    posnow(Counter,j)=(posnow(Counter,j)-500*sign(posnow(Counter,j)))/4;
                end
            end
            whole(Counter).orientation=normr(whole(Counter).orientation);
            quatori(Counter,:)= whole(Counter).orientation;
            [orinow(Counter,1),orinow(Counter,2),orinow(Counter,3)]=quat2angle(whole(Counter).orientation);
            
        end
        
        
        
        orivec(:,Counter)=[sin(orinow(Counter,3))*cos(orinow(Counter,2)),sin(orinow(Counter,2)),cos(orinow(Counter,3))*cos(orinow(Counter,2))];
        
        if Counter==1
            jacd(:,:)=zeros(6,8);
            jacdp(:,:)=zeros(6,6);
        else
           for kk=1:8
             asd(:,1)=inim([1:8],Counter);
             asd(kk,1)=inim(kk,Counter)+10;
             jacd(:,kk)=net([inim(1:8,Counter);ini(1:6,Counter);posnow(Counter,[1:3])';orivec([1:3],Counter); asd(:,1);ini(1:6,Counter)])-[posnow(Counter,[1:3])';orivec([1:3],Counter)];
           end
            for kk=1:6
             asdp(:,1)=ini([1:6],Counter);
             asdp(kk,1)=inim(kk,Counter)+20;
             jacdp(:,kk)=net([inim(1:8,Counter);ini(1:6,Counter);posnow(Counter,[1:3])';orivec([1:3],Counter);inim(1:8,Counter); asdp(:,1)])-[posnow(Counter,[1:3])';orivec([1:3],Counter)];
           end
        end
        
        errpos=[target(:,Counter)-posnow(Counter,[1:3])';0;0;0];
        
       %comp=net([inim([1:8],Counter);ini([1:6],Counter);target(1:3,Counter);posnow(Counter,1:3)';targeto(1,Counter);orivec(3,Counter)]);
       %comp=net([inim([1:8],Counter);ini([1:6],Counter);target(1:3,Counter);posnow(Counter,1:3)']);
        % comp=net([inim([1:8],Counter);ini([1:6],Counter);target([1:3],Counter);posnow(Counter,[1:3])';targeto(:,Counter);orivec([2,3],Counter)]);
       
       
       %comp=net([inim([1:8],Counter);ini([1:6],Counter);target([1,3],Counter);posnow(Counter,[1,3])';targeto(1,Counter);orivec(3,Counter)]);
   
         
        ini(:,Counter+1) =act_range(1,:);%initial pressure of cambers
        inim(:,Counter+1) =act_rangem(1,:);
        
        inim([1:8],Counter+1)=inim([1:8],Counter)+1*pinv(jacd)*errpos;
        ini([1:6],Counter+1)=ini([1:6],Counter)+1*pinv(jacdp)*errpos;
        
        for jj=1:9
            if  inim(jj,Counter+1)<act_rangem(1,jj)
                inim(jj,Counter+1)=act_rangem(1,jj);
            end
            
            if  inim(jj,Counter+1)>act_rangem(2,jj)
                inim(jj,Counter+1)=act_rangem(2,jj);
            end
            
            if  ini(jj,Counter+1)<act_range(1,jj)
                ini(jj,Counter+1)=act_range(1,jj);
            end
            
            if  ini(jj,Counter+1)>act_range(2,jj)
                ini(jj,Counter+1)=act_range(2,jj);
            end
        end
        
        for ii=1:smo
            diff=ini(:,Counter+1)-ini(:,Counter);
            diffm=inim(:,Counter+1)-inim(:,Counter);
            addp=floor(diff*ii/smo);
            addm=floor(diffm*ii/smo);
            setSup((ini(1,Counter)+addp(1)),(ini(2,Counter)+addp(2)),(ini(3,Counter)+addp(3)),(ini(4,Counter)+addp(4)),(ini(5,Counter)+addp(5)),(ini(6,Counter)+addp(6)),(ini(7,Counter)+addp(7)),(ini(8,Counter)+addp(8)),(ini(9,Counter)+addp(9)),(inim(1,Counter)+addm(1)),(inim(2,Counter)+addm(2)),(inim(3,Counter)+addm(3)),(inim(4,Counter)+addm(4)),(inim(5,Counter)+addm(5)),(inim(6,Counter)+addm(6)),(inim(7,Counter)+addm(7)),(inim(8,Counter)+addm(8)),(inim(9,Counter)+addm(9)),dev);
            pause(0.1)
            % inim(:,Counter)=inim(:,Counter)+addm;
        end
        
        pause(del)
        hop=orivec(:,Counter);
      %  err(1,Counter)=rssq(target(1:3,Counter)-posnow(Counter,1:3)');
         err=rssq(target(1:3,Counter)-posnow(Counter,1:3)')
        Counter=Counter+1
        
    end
    
    finalerror= rms(posnow'-target');
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



%pointserror=(target(:,9:10:39)-posnow(:,9:10:39));

scatter3(posi(1,:),posi(2,:),posi(3,:),'r')
hold on
scatter3(target(1,:),target(2,:),target(3,:),'b')
scatter3(posnow(2:end,1),posnow(2:end,2),posnow(2:end,3),'g')



% quiver3(posnow(1,9:10:end),posnow(2,9:10:end),posnow(3,9:10:end),orinow(1,9:10:end),orinow(2,9:10:end),orinow(3,9:10:end))
% hold on
% quiver3(target(1,:),target(2,:),target(3,:),targetori(1,:),targetori(2,:),targetori(3,:),'g')
%



