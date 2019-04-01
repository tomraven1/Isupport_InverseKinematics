function data = readTracker

global libstring;
global numBoards;

% Get synchronous Record
% Initialize structure

for kk = 0:(4 * numBoards - 1),
   sm.(['x' num2str(kk)]) = 0;
   sm.(['y' num2str(kk)]) = 0;
   sm.(['z' num2str(kk)]) = 0;
   sm.(['a' num2str(kk)]) = 0;
   sm.(['e' num2str(kk)]) = 0;
   sm.(['r' num2str(kk)]) = 0;
   sm.(['time' num2str(kk)]) = 0;
   sm.(['quality' num2str(kk)]) = 0;  
end

if numBoards == 1
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Four', sm);
elseif numBoards == 2
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Eight', sm);
elseif numBoards == 3
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Twelve', sm);
else 
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Sixting', sm);
end

Error   = calllib(libstring, 'GetAsynchronousRecord',  hex2dec('ffff'), pRecord, 4*numBoards*64);
errorHandler(Error);

Record = get(pRecord, 'Value');
for count = 1:4*numBoards
    data.x(count) = Record.(['x' num2str(count - 1)])*2.54;
    data.y(count) = Record.(['y' num2str(count - 1)])*2.54;
    data.z(count) = Record.(['z' num2str(count - 1)])*2.54;
    data.a(count) = Record.(['a' num2str(count - 1)])*pi/180;
    data.e(count) = Record.(['e' num2str(count - 1)])*pi/180;
    data.r(count) = Record.(['r' num2str(count - 1)])*pi/180;
    data.time(count) = Record.(['time' num2str(count - 1)]);        
    data.quality(count) = Record.(['quality' num2str(count - 1)]); 
end