function setSup(v1,v2,v3,v4,v5,v6,v7,v8,v9,s1,s2,s3,s4,s5,s6,s7,s8,s9,dev_handle)
% tic

%%%%%%%%%%%%% Servo Range %%%%%%%%%%%%%%%%%%
%280--------------450-------------------550%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RangeMax=150;
RangeMin=720;

if (s1<RangeMax || s1>RangeMin)
    s1=450;
    msgbox('s1,out of range');
    return;
end

s1_temp=dec2bin(s1,16);
s1H=bin2dec(s1_temp(1:8));
s1L=bin2dec(s1_temp(9:16));

if (s2<RangeMax || s2>RangeMin)
    s2=450;
    msgbox('s2,out of range');
    return;
end
s2_temp=dec2bin(s2,16);
s2H=bin2dec(s2_temp(1:8));
s2L=bin2dec(s2_temp(9:16));

if (s3<RangeMax || s3>RangeMin)
    s3=450;
    msgbox('s3,out of range');
    return;
end
s3_temp=dec2bin(s3,16);
s3H=bin2dec(s3_temp(1:8));
s3L=bin2dec(s3_temp(9:16));

if (s4<RangeMax || s4>RangeMin)
    s4=450;
   msgbox('s4,out of range');
    return;
end
s4_temp=dec2bin(s4,16);
s4H=bin2dec(s4_temp(1:8));
s4L=bin2dec(s4_temp(9:16));

if (s5<RangeMax || s5>RangeMin)
    s5=450;
   msgbox('s5,out of range');
    return;
end
s5_temp=dec2bin(s5,16);
s5H=bin2dec(s5_temp(1:8));
s5L=bin2dec(s5_temp(9:16));

if (s6<RangeMax || s6>RangeMin)
    s6=450;
   msgbox('s6,out of range');
    return;
end
s6_temp=dec2bin(s6,16);
s6H=bin2dec(s6_temp(1:8));
s6L=bin2dec(s6_temp(9:16));

if (s7<RangeMax || s7>RangeMin)
    s7=450;
    msgbox('s7,out of range');
    return;
end
s7_temp=dec2bin(s7,16);
s7H=bin2dec(s7_temp(1:8));
s7L=bin2dec(s7_temp(9:16));

if (s8<RangeMax || s8>RangeMin)
    s8=450;
    msgbox('s8,out of range');
    return;
end
s8_temp=dec2bin(s8,16);
s8H=bin2dec(s8_temp(1:8));
s8L=bin2dec(s8_temp(9:16));

if (s9<RangeMax || s9>RangeMin)
    s9=450;
    msgbox('s9,out of range');
    return;
end
s9_temp=dec2bin(s9,16);
s9H=bin2dec(s9_temp(1:8));
s9L=bin2dec(s9_temp(9:16));

%%%%%%%%%%%%% chamber Range %%%%%%%%%%%%%%%%
%0--------------------------------------255%
% if data>255
%    data=uint8(data);//by HW
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DATA=[106,v1,v2,v3,v4,v5,v6,v7,v8,v9,s1L,s1H,s2L,s2H,s3L,s3H,s4L,s4H,s5L,s5H,s6L,s6H,s7L,s7H,s8L,s8H,s9L,s9H];
% time = n_bit *10*(1/BaudRate)= (1+9+18)*10*(1/115200)= circa 2.43 ms

try
    fwrite(dev_handle,DATA);
catch
     h = msgbox('error com port');
end

% toc