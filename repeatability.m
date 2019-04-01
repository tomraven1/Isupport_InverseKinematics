x=[posiCopy(:,1),posiCopy1(:,1),posiCopy2(:,1),posiCopy3(:,1)];
y=[posiCopy(:,2),posiCopy1(:,2),posiCopy2(:,2),posiCopy3(:,2)];
z=[posiCopy(:,3),posiCopy1(:,3),posiCopy2(:,3),posiCopy3(:,3)];

xr=[oridegCopy(:,1),oridegCopy1(:,1),oridegCopy2(:,1),oridegCopy3(:,1)];
yr=[oridegCopy(:,2),oridegCopy1(:,2),oridegCopy2(:,2),oridegCopy3(:,2)];
zr=[oridegCopy(:,3),oridegCopy1(:,3),oridegCopy2(:,3),oridegCopy3(:,3)];

xm=mean(x,2);
ym=mean(y,2);
zm=mean(z,2);

xmr=mean(xr,2);
ymr=mean(yr,2);
zmr=mean(zr,2);

for i=1:4
    errx(100*(i-1)+1:100*i,1)=x(:,i)-xm;
    erry(100*(i-1)+1:100*i,1)=y(:,i)-ym;
    errz(100*(i-1)+1:100*i,1)=z(:,i)-zm;
    
    errxr(100*(i-1)+1:100*i,1)=xr(:,i)-xmr;
    erryr(100*(i-1)+1:100*i,1)=yr(:,i)-ymr;
    errzr(100*(i-1)+1:100*i,1)=zr(:,i)-zmr;
    
    
end
%xstd=std(x,0,2);