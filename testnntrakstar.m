
rosshutdown;
rosinit('http://isupport.local:11311');

sub = rossubscriber('/position_topic');
msgc = receive(sub,10);

subt = rossubscriber('/high_level_control/target_position_topic');
msgt = receive(subt,10);

load('heidelberg2.mat')
%load('testfinal4000_nn.mat')
%load('newtest2000nn.mat')
rng (743);
Samps=500000;
dev=openSup('/dev/ttyS101')


 act_range=[150 150 150 0 0 0 0 0 0;
            150 150 150 0 0 0 0 0 0];
act_rangem=[550 200 200 450 200 200 450 300 300;
            550 450 450 450 400 400 450 300 300];
        
        
ini(:,1) =act_range(1,:);%initial pressure of cambers
inim(:,1) =[550;450;450;450;400;400;450;300;300];%initial servo position

no_act= length(act_range);
setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);
%%SETTING TO ZERO

epsm=15;%maximum change in servo motion
eps=15;%maximum change in pnemaitc pressure
smo=10;

del=0.6;% delay between data collection

% pause(10)
%
 target(1,1:10)=100*ones(50,1);
 target(2,1:10)=linspace(-100,200,50);
 target(3,1:10)=-300*ones(10,1);
% 
%  target(1,11:20)=linspace(32,55,10);
%  target(2,11:20)=5*ones(10,1);
%  target(3,11:20)=0*ones(10,1);
% 
%  target(1,21:30)=55*ones(10,1);
%  target(2,21:30)=5*ones(10,1);
%  target(3,21:30)=linspace(0,-10,10);
% 
%  target(1,31:40)=linspace(55,32,10);
%  target(2,31:40)=5*ones(10,1);
%  target(3,31:40)=-10*ones(10,1);
% 
%   target(1,41:50)=32*ones(10,1);
% target(2,41:50)=5*ones(10,1);
% target(3,41:50)=linspace(-10,0,10);
% 
%  target(1,51:60)=linspace(32,55,10);
%  target(2,51:60)=5*ones(10,1);
%  target(3,51:60)=0*ones(10,1);
% 
%  target(1,61:70)=55*ones(10,1);
%  target(2,61:70)=5*ones(10,1);
%  target(3,61:70)=linspace(0,-10,10);
% 
%  target(1,71:80)=linspace(55,32,10);
%  target(2,71:80)=5*ones(10,1);
%  target(3,71:80)=-10*ones(10,1);

%
%
%
%  target(:,81:160)=target(:,80:-1:1);
%
%  target(:,161:320)=target(:,1:160);

Counter = 1;
pk=randi(4000);

%while Counter<Samps
while (1)
        
    msgt = receive(subt);
    msgt = receive(subt);
    
  target(1,Counter)= msgt.X*100; %%PROVIDE VALUES
  target(2,Counter)= msgt.Y*100;
  target(3,Counter)= msgt.Z*100;
    
   cond = abs(target(1,Counter)) + abs(target(2,Counter)) + abs(target(3,Counter));
   if (cond < 0.0001)
       setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);
        %SETTING TO ZERO
       pause(1);
      Counter=1;
        
   else
        
            if mod(Counter,20)==0
                pk=randi(4000);
            end
     %   target(:,Counter)=posi(:,pk);
        
        msgc = receive(sub);
        posnow(1,Counter)=msgc.Point.X*100;
        posnow(2,Counter)=msgc.Point.Y*100;
        posnow(3,Counter)=msgc.Point.Z*100;
        
        comp=net([inim([2 3 5 6],Counter);target(1:3,Counter);posnow(1:3,Counter)]);
        
        ini(:,Counter+1) =act_range(1,:);%initial pressure of cambers
        inim(:,Counter+1) =act_rangem(1,:);
        
        inim([2 3 5 6],Counter+1)=comp(:);
        
        for jj=1:9
            if  inim(jj,Counter+1)<act_rangem(1,jj)
                inim(jj,Counter+1)=act_rangem(1,jj);
            end
            
            if  inim(jj,Counter+1)>act_rangem(2,jj)
                inim(jj,Counter+1)=act_rangem(2,jj);
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

%         if COMMAND TO_RESET
%             setSup(ini(1,1),ini(2,1),ini(3,1),ini(4,1),ini(5,1),ini(6,1),ini(7,1),ini(8,1),ini(9,1),inim(1,1),inim(2,1),inim(3,1),inim(4,1),inim(5,1),inim(6,1),inim(7,1),inim(8,1),inim(9,1),dev);
%             %%SETTING TO ZERO
%         Counter=1;
        end
        
%         err(Counter)=rssq(posnow(:,Counter)-target(:,Counter))
        Counter
        Counter=Counter+1;
   %end
    
end

setSup(0,0,0,0,0,0,0,0,0,450,450,450,450,450,450,450,450,450,dev);
pause(1);
fclose(dev);

instrreset
