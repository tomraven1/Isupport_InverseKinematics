%tdfread ('C:\Users\tom\Desktop\dynamicexperiments\t2_4hz_40sec_2.tsv');

siz=length(pos);
for i=1:siz
    s=pos{:,i};
    if strcmp(s(5:11), 'MISSING')
        %whole(:,i)=NaN;
        posi(i,1:3)=NaN;
        ori(i,1:3)=NaN;
    else
        [waste,whole(:,i)]=NDIAuroraPoseOrientation(cell2mat(pos(:,i)));
        
        posi(i,:)=whole(i).pose;
        for j=1:3
            if abs(posi(i,j))<400
                posi(i,j)=posi(i,j)/4;
            elseif abs(posi(i,j))>400&&abs(posi(i,j))<1050
                posi(i,j)=(posi(i,j)-250*sign(posi(i,j)))/4;
            elseif abs(posi(i,j))>1700&&abs(posi(i,j))<2400
                posi(i,j)=(posi(i,j)-750*sign(posi(i,j)))/4;
            elseif abs(posi(i,j))>2400
                posi(i,j)=(posi(i,j)-1000*sign(posi(i,j)))/4;
            else
                posi(i,j)=(posi(i,j)-500*sign(posi(i,j)))/4;
            end
        end
        whole(i).orientation=normr(whole(i).orientation);
        quatori(i,:)= whole(i).orientation;
        [ori(i,1),ori(i,2),ori(i,3)]=quat2angle(whole(i).orientation);
        
%         if ori(i,1)<-pi/2&&ori(i-1,1)>pi/2
%             ori(i,1)=ori(i,1)+2*pi;
%         end
%         
%         if ori(i,2)<-pi/2&&ori(i-1,2)>pi/2
%             ori(i,2)=ori(i,2)+2*pi;
%         end
%         if ori(i,3)<-pi/2&&ori(i-1,3)>pi/2
%             ori(i,3)=ori(i,3)+2*pi;
%         end
        
    end
    
end
  orideg=radtodeg(ori);
ori = fliplr(ori);
for i=1:siz
oriv(i,:)=[cos(ori(i,1))*cos(ori(i,2)),sin(ori(i,1))*cos(ori(i,2)),sin(ori(i,2))];
oriv2(i,:)=[sin(ori(i,1))*cos(ori(i,2)),sin(ori(i,2)),cos(ori(i,1))*cos(ori(i,2))];
end
posi=posi';
oriv2=oriv2';
quiver3(posi(:,1),posi(:,2),posi(:,3),oriv2(:,1),oriv2(:,2),oriv2(:,3))

%
% for i=1:siz
%
%     if abs(Tx(i))>2000
%         Tx(i)=NaN;
%         Ty(i)=NaN;
%         Tz(i)=NaN;
%                 Rx(i)=NaN;
%         Ry(i)=NaN;
%         Rz(i)=NaN;
%     end
%       if Rx(i)<-90&&Rx(i-1)>90
%         Rx(i)=Rx(i)+360;
%       end
%
%         if Ry(i)<-90&&Ry(i-1)>90
%         Ry(i)=Ry(i)+360;
%         end
%         if Rz(i)<-90&&Rz(i-1)>90
%         Rz(i)=Rz(i)+360;
%         end
%
% end

% data = [posi(:,1) posi(:,2) posi(:,3) ];
% 
% dates = [today:today+siz-1]';
% txobj = fints(dates, data);
% 
% Txo= fillts(txobj,'se');
% Tx= fts2mat(Txo.series1);
% Ty= fts2mat(Txo.series2);
% Tz= fts2mat(Txo.series3);
% 
% data = [ori(:,1) ori(:,2) ori(:,3) ];
% dates = [today:today+siz-1]';
% txobj = fints(dates, data);
% 
% 
% Txo= fillts(txobj,'se');
% Rx= fts2mat(Txo.series1);
% Ry= fts2mat(Txo.series2);
% Rz= fts2mat(Txo.series3);
% 
% Pos=[Tx Ty Tz];
% Orin=[Rx Ry Rz];
% 
% 
% [Pos,yt]=resample(Pos(11:end,:),tim(1,10:end)',40,'spline');
% 
% Orin=resample(Orin(11:end,:),tim(1,10:end)',40,'spline');
% 
% 
% % Pos(:,1) = smooth(Pos(:,1) ,10,'sgolay');
% % Pos(:,2) = smooth(Pos(:,2) ,10,'sgolay');
% % Pos(:,3) = smooth(Pos(:,3) ,10,'sgolay');
% 
