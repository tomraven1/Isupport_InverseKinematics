function [s]=trm(s)

lent=length(s);
s=s';
for i=1:lent
    
    for j=1:3
        if abs(s(i,j))<400
            s(i,j)=s(i,j)/4;
        elseif abs(s(i,j))>400&&abs(s(i,j))<1000
            s(i,j)=(s(i,j)-250*sign(s(i,j)))/4;
        else
            s(i,j)=(s(i,j)-500*sign(s(i,j)))/4;
        end
    end
end
s=s';

end