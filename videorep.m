
writerObj = VideoWriter('obs.avi'); % Name it.
writerObj.FrameRate = 4; % How many frames per second.
open(writerObj);
rotate3d on;
set(gcf, 'SelectionType', 'open');
set(gcf,'Position',[10 40 1400 1100]);


if a==0
   % img=img(:,120:480,:,:); %crop
    img=img(:,60:580,:,:);
    a=1;
end

[il,jl,dontcare,kl]=size(img);


%  for k=1:kl
%      for i=1:il
%          for j=1:jl
%              if img(i,j,1,k)>120&&img(i,j,2,k)>120&&img(i,j,3,k)>120
%                  img(i,j,:,k)=[150,150,150];
%              end
%          end
%      end
%  end
%

errnow=target(:,1:end-1)-posnow;
errrms=rssq(errnow);

%errori=targetori(:,1:end-1)-orinow;

%figure;
for i=1:100
    h1=subplot(2,2,[1,3]);
    
    
%     imshow(img(:,:,:,i*5-4))
%     pause(0.03)
%     imshow(img(:,:,:,i*5-3))
%     pause(0.03)
%     imshow(img(:,:,:,i*5-2))
%     pause(0.03)
%     imshow(img(:,:,:,i*5-1))
%     pause(0.03)
%     imshow(img(:,:,:,i*5))
   % imagesc(img(:,:,:,i))%,'Border','tight');
     imshow(img(:,:,:,i))
    filename = sprintf('test_image_%d', i);
      %saveas(gcf, filename, 'eps')
   print (filename,'-dtiff','-r600')
    axis off
    
    
    h2=subplot(2,2,2);
    if mod(i,40)==0
        cla(h2)
    end
    axis([-80,80,-140,180,-200,-50])
    h2(1)=scatter3(target(1,i),target(2,i),target(3,i),40,[0.8 0.3 0.3]);
    hold on
    h2(2)=scatter3(posnow(1,i),posnow(2,i),posnow(3,i),40,[0.3 0.8 0.3],'fill');
    
    %view(0,90)
    
    hTitle  = title ('End-Effector Path');
    hXLabel = xlabel('X(mm)'                     );
    hYLabel = ylabel('Y(mm)'                      );
    hZLabel = zlabel('Z(mm)'                      );
    hLegend = legend( ...
        [h2(1), h2(2)], ...
        'Target' , ...
        'End-Effector Position' , ...
        'location', 'NorthWest' );
    
    set( gca                       , ...
        'FontName'   , 'Helvetica' );
    set([hTitle, hXLabel, hYLabel], ...
        'FontName'   , 'AvantGarde');
    set([hXLabel, hYLabel]  , ...
        'FontSize'   , 10          );
    set( hTitle                    , ...
        'FontSize'   , 12          , ...
        'FontWeight' , 'bold'      );
    
    set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );
    %view(0,90)
    
    %cla
    %quiver3(target(1,:),target(2,:),target(3,:),targetori(1,:),targetori(2,:),targetori(3,:),'g')
    
    h3=subplot(2,2,4);
    
    axis([0,100,0,80])
    plot((1:i),errrms(1:i),'linewidth',3,'marker','.','markersize',4,'color',[0.4 0.4 0.7])
    hold on
    
    
    
    hTitle  = title ('Error in Tracking');
    hXLabel = xlabel('Step'                     );
    hYLabel = ylabel('Error(mm)'                      );
    set( gca                       , ...
        'FontName'   , 'Helvetica' );
    set([hTitle, hXLabel, hYLabel], ...
        'FontName'   , 'AvantGarde');
    set([hXLabel, hYLabel]  , ...
        'FontSize'   , 10          );
    set( hTitle                    , ...
        'FontSize'   , 12          , ...
        'FontWeight' , 'bold'      );
    set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );
    
    %pause(0.1)
    
    frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
    %frame = print(gcf);
    writeVideo(writerObj, frame);
end

close(writerObj);



%
% errnow=target(:,1:end-1)-posnow;
% errrms=rms(errnow);
%
% for i=1:90
% subplot(1,2,1)
% % imshow(img(:,:,:,i*5-4))
% % hold on
% % pause(0.3)
% % imshow(img(:,:,:,i*5-3))
% % pause(0.3)
% % imshow(img(:,:,:,i*5-2))
% % pause(0.3)
% % imshow(img(:,:,:,i*5-1))
% % pause(0.3)
% % imshow(img(:,:,:,i*5))
%
%
% imshow(img(:,:,:,i))
% hold on
%
% subplot(1,2,2)
% axis([0,100,0,50])
% scatter(i,errrms(i),'r','fill')
% hold on
%
% %quiver3(target(1,:),target(2,:),target(3,:),targetori(1,:),targetori(2,:),targetori(3,:),'g')
% end
%




% v = VideoWriter('line.avi');
% open(v)
% writeVideo(v,img)
% close (v)



for i=1:100
    
    filename = sprintf('new_image_%d.tiff', i);
    imwrite(img(1:480,130:510,:,i),filename)
%     filename = sprintf('new_image_%d.tiff', i*5-3);
%     imwrite(img(1:480,130:520,:,i*5-3),filename)
%     filename = sprintf('new_image_%d.tiff', i*5-2);
%     imwrite(img(1:480,130:520,:,i*5-2),filename)
%     filename = sprintf('new_image_%d.tiff', i*5-1);
%     imwrite(img(1:480,130:520,:,i*5-1),filename)
%     filename = sprintf('new_image_%d.tiff', i*5);
%     imwrite(img(1:480,130:520,:,i*5),filename)
    
   
end









errnow=target(:,1:10:end-1)-posnow(:,9:10:end);
errrms=rms(errnow);
errori=targetori(:,1:10:end-1)-orinow(:,9:10:end);



  hLegend = legend( ...
        [h1, h2, h3], ...
        'Roll' , ...
        'Pitch' , ...
        'Yaw' , ...
        'location', 'NorthWest' );
