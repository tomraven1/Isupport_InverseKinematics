len=length(pos);
%len=10;
%asd=asd(:,1:len);
posi=[];
ori=[];
quatori=[];
orideg=[];
err=[];
for i=2:len
    
    [waste,whole(:,i)]=NDIAuroraPoseOrientation(cell2mat(pos(:,i)));
    
    posi(i,:)=whole(i).pose;
    for j=1:3
        if abs(posi(i,j))<400
            posi(i,j)=posi(i,j)/4;
        elseif abs(posi(i,j))>400&&abs(posi(i,j))<1000
            posi(i,j)=(posi(i,j)-250*sign(posi(i,j)))/4;
        else
            posi(i,j)=(posi(i,j)-500*sign(posi(i,j)))/4;
        end
    end
    whole(i).orientation=normr(whole(i).orientation);
    quatori(i,:)= whole(i).orientation;
    [ori(i,1),ori(i,2),ori(i,3)]=quat2angle(whole(i).orientation);

    err(i,1)=whole(i).tracking_error;
    err(i,2)=whole(i).tracking_error;
    err(i,3)=whole(i).tracking_error;
    err(i,4)=whole(i).tracking_error;
    err(i,5)=whole(i).tracking_error;
    err(i,6)=whole(i).tracking_error;
end
err=1./err;


     orideg=radtodeg(ori);
     for i=1:len
         if orideg(i,3)>90
             orideg(i,3)=orideg(i,3)-360;
         elseif orideg(i,1)<-90
             orideg(i,1)=orideg(i,1)+360;
         end
     end

% asd=asd';
% mindata = min(asd);
% maxdata = max(asd);
% minmaxdata = bsxfun(@rdivide, bsxfun(@minus, asd, mindata), maxdata - mindata);
% asdnorm=minmaxdata'; 



% i=1;
% for k=1:1960
%     
%     if err(k,1)<1
%        toremov(i)=k;
%        i=i+1;
%     end
% end
% 
% posi(toremov,:)=[];
% asd(:,toremov)=[];
% orideg(toremov,:)=[];
% quatori(toremov,:)=[];
ori = fliplr(ori);
for i=1:1900
quiver3(posi(i,1),posi(i,2),posi(i,3),cos(ori(i,1))*cos(ori(i,2)),sin(ori(i,1))*cos(ori(i,2)),sin(ori(i,2)),10)
hold on
end

errori=targetori(:,1:81)-orinow;
errpos=rms(target(:,1:81)-posnow);



errost=[errpos errposCopy errposCopy1 errposCop2]

% for j=0:49
%     count=1;
%     for i=1:49
%         a=err(i+1+j*50);
%         b=err(i+j*50);
%         if round(a*1000)==round(b*1000)&&count==1
%             step(j+1)=i;
%             count=0;
%
%
%         end
%     end
% end

%[yaw, pitch, roll]--quat2angle