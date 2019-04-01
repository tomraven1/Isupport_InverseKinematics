%the trained NN will be net
% To use net--- ini(:,i+2)=net([ini(:,i+1);target(:,i);posnow(:,i);targetori(:,i);orinow(:,i)]);
%have to use twice to create two networks

%n=length(posi);
hiddenLayerSize =[40];
n=length(posi);
%x=[inim(1:8,1:n-1);ini(1:6,1:n-1);posi(1:3,2:n);posi(1:3,1:n-1)];

%x=[inim(1:8,1:n-1);ini(1:6,1:n-1);posi(1:3,2:n);posi(1:3,1:n-1);oriv2(3,2:n);oriv2(3,1:n-1)];

%x=[inim(1:8,1:n-1);ini(1:6,1:n-1);posi([1,3],2:n);posi([1,3],1:n-1);oriv2([2,3],2:n);oriv2([1,3],1:n-1)];
x=[inim(1:8,1:n-1);ini(1:6,1:n-1);posi([1:3],2:n);posi([1:3],1:n-1);oriv2([2,3],2:n);oriv2([2,3],1:n-1)];

%output
t =[inim(1:8,2:n);ini(1:6,2:n)];




trainFcn = 'trainbr';  % training algorithm 



net = fitnet(hiddenLayerSize,trainFcn);


net.input.processFcns = {'removeconstantrows','mapminmax'}; % normalization
net.output.processFcns = {'removeconstantrows','mapminmax'};
%net.layers{3}.transferFcn='satlins';
%net.layers{1}.transferFcn='radbas';
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.epochs=50;

net.performFcn = 'mse';  

net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};


[net,tr] = train(net,x,t,{},{});%,err(:,1:n-1));-- if you have data about uncertainty of individual samples


y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

net.performParam.normalization='standard';
trainTargets = t .* tr.trainMask{1};
valTargets = t  .* tr.valMask{1};
testTargets = t  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y )
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)



% test(:,1)=net(x(:,1));
%  test(:,2)=net(x(:,2));
%  
% for i=1:1000
%   
%     test(:,i+2)=net([test(1:6,i+1);posi(i+2,:)';posi(i+1,:)']);
%     
%     if mod(i,30)==0
%         test(:,i+2)=t(:,i+1);
%         test(:,i+1)=t(:,i);
%     end
% end
% plot(test(1,:))
% hold on
% plot(t(1,:))