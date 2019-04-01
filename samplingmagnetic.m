
trackerAPI;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


rng (35353);
Samps=50000;
dev=openSup('COM3')


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

del=0.4;% delay between data collection
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
closeSup(dev)


% for i=1:9300
%     posi(1,i)=pos(i).x(1);
%     posi(2,i)=pos(i).y(1);
%     posi(3,i)=pos(i).z(1);
%     
%     ori(1,i)=pos(i).a(1);
%     ori(2,i)=pos(i).e(1);
%     ori(3,i)=pos(i).r(1);
%  %    scatter3(pos(i).x(1),pos(i).y(1),pos(i).z(1),'g')
%   %  hold on
% end
