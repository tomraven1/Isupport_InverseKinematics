%addpath('C:\Users\tom\Desktop\matlab_aurora');
rng (666);
%cam=webcam(2);
pause on
trackerAPI;

%load('vibtest1_workspace_nomotors_withvibrations_nnik.mat')
load('vibtest1_workspace_nomotors_newwithshaping_ik.mat')
posiall2=posiall;
qm=[450,450,450,450,450,450,450,450,450];
qp=[0,0,0];
tar=ones(1,3)';
maxd=rssq([180,180,180]);
minf=0.56;
maxf=0.84;
try
    % Aurora Comm
    
    dev=openSup('COM6');
    pause(1)
    
    setSup(qp(1),0,0,0,0,0,qp(2),qp(3),0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
    pause(5)
    
    
    %t=0:0.1:1000;
    % inp=20*(1+sin(2*pi*0.5*t));
    % inp=40*ones(1,length(t));
    %pm=20;
    %    for kkk=1:400
    %        inpa(1,(kkk-1)*pm+1:(kkk-1)*pm+pm)=randi([0,5])*inp((kkk-1)*pm+1:(kkk-1)*pm+pm);
    %         inpa(2,(kkk-1)*pm+1:(kkk-1)*pm+pm)=randi([0,5])*inp((kkk-1)*pm+1:(kkk-1)*pm+pm);
    %          inpa(3,(kkk-1)*pm+1:(kkk-1)*pm+pm)=randi([0,5])*inp((kkk-1)*pm+1:(kkk-1)*pm+pm);
    %
    %    end
    inpa(1,:)=180*ones(1,500);
    inpa(2,:)=180*ones(1,500);
    inpa(3,:)=180*ones(1,500);
    for jj=1:2000
        inpall(jj,:,:)=inpa;
        for hh=1
            i=1;
            tic
            for t=1:0.02:5
                
                
                
                while toc<t
                    pause(0.001)
                end
                setSup(qp(1),0,0,inpa(1,i),inpa(2,i),inpa(3,i),qp(2),qp(3),0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
                
                
                val=readTracker;
                pos(i,1)=val.x(1);
                pos(i,2)=val.y(1);
                pos(i,3)=val.z(1);
                
                tim(i)=toc;
                i=i+1;
                
                %        setSup(0,0,0,0,0,0,0,0,0,450,280,450,450,280,450,450,450,450,dev)
                %       run('porcessing.m')
                %       posall(ii,:,:)=posi;
                %        pause(2)
            end
           % setSup(qp(1),0,0,0,0,0,qp(2),qp(3),0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
           
            posall(:,:)=pos(:,:);
            
         %   pause(1);
        end
        
        %  posiall(jj,:,:,:)=posall;
        posiall(jj,:,:)=posall;
        %  varall(:,jj)=var(posall(:,end,:));
        % vib(:,jj)=var(squeeze(posall(1,75:end,:)));
        vib(:,jj)=var(squeeze(posall(75:end,:)));
        %          inpa(1,1:jj)=120;
        %          inpa(2,1:jj)=120;
        
        err(jj)=rssq(tar'-posall(end,:));
%         inpa(1,:)=randi(180)*ones(1,500);
%         inpa(2,:)=randi(180)*ones(1,500);
%         inpa(3,:)=randi(180)*ones(1,500);
     %   tar=squeeze(posiall2(randi(1500),end,:));
        
        tar=squeeze(posiall2(570+2*(mod(jj,2)),end,:));
       asd= round(net(tar));
         inpa(1,:)=asd(1)*ones(1,500);
        inpa(2,:)=asd(2)*ones(1,500);
        inpa(3,:)=asd(3)*ones(1,500);
        
%         dist=sqrt((inps(1,:)-inpa(1,end)).^2+(inps(2,:)-inpa(2,end)).^2+(inps(3,:)-inpa(3,end)).^2);
%         [jk,loc]=min(dist);
%         omega=dfreq(loc);
%         imp_t=round(omega/0.04);

% 
                pnu_d=rssq(inpa(:,end));
        omega=minf+(maxf-minf)*pnu_d/maxd;
        imp_t=round(omega/0.04);
        
        coinp=zeros(3,500);
        coinp(:,imp_t+1)=0.3+jj/200;
        coinp(:,1)=0.7-jj/200;
        
        for ll=1:3
            mama= conv(inpa(ll,:),coinp(ll,:));
            inpa(ll,:)=mama(1,1:500);
        end
        
        
        
%        for ll=1:3
%             if inpa(ll,1)>80
%                 inpa(ll,1:imp_t)=inpa(ll,1)-60;
%             elseif inpa(ll,1)>50
%                 inpa(ll,1:imp_t)=inpa(ll,1)-30;
% %             else
% %                 inpa(ll,1:imp_t)=inpa(ll,1)+40;
%             end
%             
%        end

%    if max(inp(:,end))>100 && min(inp(:,end))>50
%        inpa(:,1:imp_t)=inpa(:,1)-50;
%    elseif max(inp(:,end))<120
%        inpa(:,1:imp_t)=inpa(:,1)+40;
%    elseif min(inp(:,end))<30
%        inpa(:,1:imp_t)=inpa(:,1)/2;
%    else
%        inpa(:,1:imp_t)=inpa(:,1)-30;
%        
%    end
       

     jj
    end
    
    pause(10)
    
    setSup(0,0,0,0,0,0,0,0,0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
    % stop tracking.
    
    
    
    closeSup(dev)
    
catch
      setSup(0,0,0,0,0,0,0,0,0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
  
    closeSup(dev)
    
    
    
end

%  for jj=1:143
%     vib(:,jj)=var(squeeze(posiall(jj,75:end,:)));
%  end

% 
% 
for jj=1:350
   [jk,ind] =max(vib(:,jj));
   [jk,loc]=findpeaks(squeeze(posiall(jj,:,ind)));
   dfreq(jj)=(loc(end)-loc(end-1))*0.02;
end
% 
% count=1;
% for jj=1:350
% 
%     if dfreq(jj)>0.5
% 
%        scatter3(inpall(jj,1,end),inpall(jj,2,end),inpall(jj,3,end),50,dfreq(jj),'filled')
% %          comp(:,count)=[squeeze(inpall(jj,:,end)) dfreq(jj)];
% %         count =count+1;
%         hold on
%     end
% 
% end
% 


rssq(squeeze(posiall(1,1,:,:))');
dis=ans-ans(1);

tim=tim-1;
plot(tim,dis)
[a,b]=findpeaks(dis,tim);
hold on
stem(b,a)

% for kkk=1:50
%     plot(squeeze(posall(kkk,:,2)))
%   pause(2)
% end