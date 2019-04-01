% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (C) OMG Plc 2009.
% All rights reserved.  This softwarge is protected by copyright
% law and international treaties.  No part of this software / document
% may be reproduced or distributed in any form or by any means,
% whether transiently or incidentally to some other use of this software,
% without the written permission of the copyright owner.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part of the Vicon DataStream SDK for MATLAB.
trackerAPI;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


rng (546);
Samps=50000;
dev=openSup('COM6')

% trans=zeros(3,5000,10);
% rot=zeros(3,5000,10);
% Pos=zeros(3,3,5000,10);

%act_range=[50,50,50,50,50,50,50,50,50;
      
%actangem=[270,270,270,260,260,260,300,300,300;
%            500,500,500,500,500,500,500,500,500];%servo range--empiricaly decided
 act_range=[100 100 100 0 0 0 0 0 0;
            100 100 100 0 0 0 0 0 0];
act_rangem=[550 150 150 450 150 150 450 300 300;
            550 450 450 450 400 400 450 300 300];
ini(:,1) =act_range(1,:);%initial pressure of cambers
inim(:,1) =[450;450;450;450;450;450;450;450;450];%initial servo position
%inim(:,1) =[450;900;900;700;700;700;570;570;570];


no_act= length(act_range);
setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);


epsm=[15,15,15,15,15,15,15,15,15];%maximum change in servo motion
eps=15;%maximum change in pnemaitc pressure
softm=2;
soft=3;
smo=5;

del=0.6;% delay between data collection
for j=1:no_act
    tar(j,1)=randi([act_range(1,j),act_range(2,j)]); %target to reach in the actutator space
    % I use RANDI for easier communication
    tarm(j,1)=randi([act_rangem(1,j),act_rangem(2,j)]);
end

pause(10)
% Program options


Counter = 1;
% Loop until the message box is dismissed
while Counter<Samps
    
    tic
    
    
    pos(Counter)=readTracker;
  
    
    
    for j=1:no_act
  
        
        if abs(inim(j,Counter)-tarm(j,1))<epsm(j)
            if rand >0.1
            tarm(j,1)=randi([act_rangem(1,j),act_rangem(2,j)]);
            else
             tarm(j,1)=act_rangem(2,j);
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
    
end% while true
save test5000pnu.mat



setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);


