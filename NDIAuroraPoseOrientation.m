function [ error, frames ] = NDIAuroraPoseOrientation ( s )
    error = 0;
    frames = [];
    if strcmp(s(1:2), 'ER')
        error = hex2dec(s(6:7));
        return
    end
    nhandles = hex2dec(s(1:2));
    for i = 1:nhandles
        portHandle = hex2dec(s(3:4));
        pose = [];
        orientation = [];
        frameID = -1;
        errorMsg = 'OK';
        trackingError = -1;
        portStatus = '';

        if strcmp(s(5:11), 'MISSING')
            errorMsg = 'MISSING';
        elseif strcmp(s(5:12), 'DISABLED')
            errorMsg = 'DISABLED';
        elseif strcmp(s(5:14), 'UNOCCUPIED')
            errorMsg = 'UNOCCUPIED';
        else
            orientation = [0 0 0 0];
            pose = [0 0 0];

            orientation(1:1) = hex2dec(s(6:10))/10000;
            if strcmp(s(5:5), '-')
                orientation(1:1) = -orientation(1:1);
            end

            orientation(2:2) = hex2dec(s(12:16))/10000;
            if strcmp(s(11:11), '-')
                orientation(2:2) = -orientation(2:2);
            end

            orientation(3:3) = hex2dec(s(18:22))/10000;
            if strcmp(s(17:17), '-')
                orientation(3:3) = -orientation(3:3);
            end

            orientation(4:4) = hex2dec(s(24:28))/10000;
            if strcmp(s(23:23), '-')
                orientation(4:4) = -orientation(4:4);
            end

            pose(1:1) = hex2dec(s(30:35))/100;
            if strcmp(s(29:29), '-')
                pose(1:1) = -pose(1:1);
            end

            pose(2:2) = hex2dec(s(37:42))/100;
            if strcmp(s(36:36), '-')
                pose(2:2) = -pose(2:2);
            end

            pose(3:3) = hex2dec(s(44:49))/100;
            if strcmp(s(43:43), '-')
                pose(3:3) = -pose(3:3);
            end
        end

        trackingError = hex2dec(s(51:55))/10000;
        if strcmp(s(50:50), '-')
            trackingError = -trackingError;
        end
        
        portStatus = hex2dec(s(56:63));
        frameID = hex2dec(s(64:71));

        frames = [frames;
            struct(...
                'error_message', errorMsg, ...
                'tracking_error', trackingError, ...
                'port_handle', portHandle, ...
                'port_status', portStatus, ...
                'pose', pose, ...
                'orientation', orientation, ...
                'frame_id', frameID ...
            )];
    end
    frames = frames;
end