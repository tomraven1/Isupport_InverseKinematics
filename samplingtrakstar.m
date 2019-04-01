%addpath('C:\Users\tom\Desktop\matlab_aurora');
rng (666);
%cam=webcam(2);
pause on
trackerAPI;
qm=[450,450,450,450,450,450,450,450,450];
qp=[0,0,0];



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
    for jj=1:5000
        inpall(jj,:,:)=inpa;
        for hh=1
            i=1;
            tic
            for t=1:0.01:5
                
                
                
                while toc<t
                  %  pause(0.001)
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
            setSup(qp(1),0,0,0,0,0,qp(2),qp(3),0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
            % posall(hh,:,:)=pos(:,:);
            posall(:,:)=pos(:,:);
            
            % pause(2);
        end
        
        %  posiall(jj,:,:,:)=posall;
        posiall(jj,:,:)=posall;
        %  varall(:,jj)=var(posall(:,end,:));
        % vib(:,jj)=var(squeeze(posall(1,75:end,:)));
        vib(:,jj)=var(squeeze(posall(75:end,:)));
        %          inpa(1,1:jj)=120;
        %          inpa(2,1:jj)=120;
        
        
        inpa(1,:)=randi(180)*ones(1,500);
        inpa(2,:)=randi(180)*ones(1,500);
        inpa(3,:)=randi(180)*ones(1,500);
                for ll=1:3
                    if inpa(ll,1)>120
                        inpa(ll,1:10)=70;
                    elseif inpa(ll,1)>90
                        inpa(ll,1:10)=170;
                    else
                        inpa(ll,1:10)=150;
                    end
        
                end
        
        
%         pnu_d=rssq(inpa(:,end));
%         omega=minf+(maxf-minf)*pnu_d/maxd;
%         imp_t=round(omega/0.04);
%         
%         coinp=zeros(3,500);
%         coinp(:,imp_t+1)=0.3;
%         coinp(:,1)=0.7;
%         
%         for ll=1:3
%             mama= conv(inpa(ll,:),coinp(ll,:));
%             inpa(ll,:)=mama(1,1:500);
%         end
        
        
        jj
    end
    
    pause(10)
    
    setSup(0,0,0,0,0,0,0,0,0,qm(1),qm(2),qm(3),qm(4),qm(5),qm(6),qm(7),qm(8),qm(9),dev)
    % stop tracking.
    
    
    
    closeSup(dev)
    
catch
    
    closeSup(dev)
    
    
    
end

%  for jj=1:143
%     vib(:,jj)=var(squeeze(posiall(jj,75:end,:)));
%  end



for jj=1:1550
  %  [jk,ind] =max(vib(:,jj));
   dis= rssq(squeeze(posiall(jj,:,:))');
    %    [jk,loc]=findpeaks(dis,'MinPeakDistance',10,'MaxPeakWidth',50);
       [jk,loc]=findpeaks(dis,'MinPeakProminence',0.1);
       
  % [jk,loc]=findpeaks(squeeze(posiall(jj,:,ind)),'MinPeakDistance',15);
    if length(loc)>1 %%&& max(vib(:,jj))>0.1
     %   dfreq(jj)=(loc(end)-loc(end-1))*0.02;
        dfreq(jj)=(loc(end)-loc(end-1))*0.02;
        subt=mean(squeeze(posiall(jj,loc(end-1):loc(end-1)+round((loc(end)-loc(end-1))/2),ind)));
       %  subt=mean(squeeze(dis(1,loc(end-1):loc(end-1)+round((loc(end)-loc(end-1))/2))));
     
        
        asd=log((jk(end-1)-subt)/(jk(end)-subt));
        damp=  1/sqrt(1+(2*pi/asd)^2);
        dratio(jj)=exp(damp*pi/sqrt(1-damp^2))/(1+exp(damp*pi/sqrt(1-damp^2)));
    else
        dfreq(jj)=0;
        dratio(jj)=0;
    end
   
    
    
end
 dratio=real(dratio);
for jj=1:1500
    if dfreq(jj)<1.5&&dfreq(jj)>0.4&&dratio(jj)<0.95
    nfreq(jj)=dfreq(jj)/(sqrt(1-dratio(jj)^2));
    else
        nfreq(jj)=0;
    end
end
nfreq=nfreq(nfreq>0);


count=1;
for jj=1:1500
    
    if dfreq(jj)>0.5&&dfreq(jj)<1
        
        %scatter3(inpall(jj,1,end),inpall(jj,2,end),inpall(jj,3,end),50,dfreq(jj),'filled')
        scatter3(posiall(jj,end,1),posiall(jj,end,2),-posiall(jj,end,3),50,dfreq(jj),'filled')
    
        %          comp(:,count)=[squeeze(inpall(jj,:,end)) dfreq(jj)];
        %         count =count+1;
        hold on
    end
    
end

for jj=1:370
    scatter3(inpall(jj,1,end),inpall(jj,2,end),inpall(jj,3,end),50,sum(vib(:,jj)))
    hold on
end


for jj=1:1500
     if dfreq(jj)>0.4&&dfreq(jj)<1
    %   scatter(rssq(inpall(jj,1:2,end)),dfreq(jj),10,inpall(jj,3,end))
       
         %scatter(rssq(inpall(jj,:,end)),dratio(jj))
      asd=squeeze(posiall(jj,end-1,:))-squeeze(posiall(jj,2,:));
   %   scatter(rssq(asd),dfreq(jj))
      scatter(posiall(jj,end,3),dfreq(jj))
       hold on
     end
end

% for kkk=1:50
%     plot(squeeze(posall(kkk,:,2)))
%   pause(2)
% end
for jj=2:101
vib(jj,:)=std(rssq(squeeze(posiall(jj,100:end,:))'));
end