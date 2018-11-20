function [ seg ] = lowLevelfgCrit( seg )
% Calculate low-level foreground criteria for entire video.

% Optical flow.
flow = lowLevelComputeFlow( seg ); 
fprintf('Computing flow component deviation from respective frame medians.\n');
flow_x = flow(:,:,:,1); 
flow_y = flow(:,:,:,2);
flow_mag = (flow_x.^2 + flow_y.^2).^0.5;
flow_ang = atan2d(flow_y, flow_x);

% Find deviation from median for x and y flow vectors and flow magnitude.
seg.cur.flowMedx = zeros(seg.cur.vid_size(3),1); 
seg.cur.flowMedy = zeros(seg.cur.vid_size(3),1);
seg.cur.flowMedMag = zeros(seg.cur.vid_size(3),1);
flowMedVidx = zeros(seg.cur.vid_size); 
flowMedVidy = zeros(seg.cur.vid_size);
flowMedVidMag = zeros(seg.cur.vid_size);
for i = 1:seg.cur.vid_size(3);
    a = flow_x(:,:,i); b = flow_y(:,:,i); c = flow_mag(:,:,i);
    seg.cur.flowMedx(i) = median(a(:)); 
    seg.cur.flowMedy(i) = median(b(:));
    seg.cur.flowMedMag(i) = median(c(:));
    flowMedVidx(:,:,i) = seg.cur.flowMedx(i);
    flowMedVidy(:,:,i) = seg.cur.flowMedy(i);
    flowMedVidMag(:,:,i) = seg.cur.flowMedMag(i);
end
seg.cur.flow_x_medDev = flow_x - flowMedVidx;
seg.cur.flow_y_medDev = flow_y - flowMedVidy;
seg.cur.flow_mag_medDev = flow_mag - flowMedVidMag;

% Find deviation from median flow angle.
seg.cur.flowMedAng = zeros(seg.cur.vid_size(3),1); flowMedVidAng = zeros(seg.cur.vid_size);
for i = 1:seg.cur.vid_size(3);
    seg.cur.flowMedAng(i) = refineMedianAngle( flow_ang(:,:,i) );
    flowMedVidAng(:,:,i) = seg.cur.flowMedAng(i);
end
flow_ang_medDev = flow_ang - flowMedVidAng;
seg.cur.flow_ang_medDev = normalizeAngleMtx(flow_ang_medDev);

% Find criteria outliers.
for i = 1:seg.cur.vid_size(3);
    seg.cur.x{i} = interquartile( seg.cur.flow_x_medDev(:,:,i), seg.param.WOk );
    seg.cur.y{i} = interquartile( seg.cur.flow_y_medDev(:,:,i), seg.param.WOk );
    seg.cur.ang{i} = interquartile( seg.cur.flow_ang_medDev(:,:,i), seg.param.WOk );
    seg.cur.mag{i} = interquartile( seg.cur.flow_mag_medDev(:,:,i), seg.param.WOk );
end

%% Nested functions.

    function med = refineMedianAngle( angMtx )
        % Offset data so median angle is 0.
        med = median(angMtx(:));
        medTemp = 1;
        while abs(medTemp)>0.01;
            flowMedAngDevTemp = angMtx - med;
            flowMedAngDevTemp = normalizeAngleMtx(flowMedAngDevTemp);
            medTemp = median(flowMedAngDevTemp(:));
            med = med + medTemp;
        end
    end
        
    function angMtx = normalizeAngleMtx( angMtx )
        % Offset all angle to be within +/- 180 degrees.
        gtr180Idx_i = find( angMtx > 180 );
        lsN180Idx_i = find( angMtx < -180 );
        angMtx(gtr180Idx_i) = angMtx(gtr180Idx_i) - 360;
        angMtx(lsN180Idx_i) = angMtx(lsN180Idx_i) + 360;
    end

    function [ out ] = interquartile( dataMtx, k )
        % Find interquartile range and outliers for data.
        tmpVctr = prctile(dataMtx(:), [25 75]);
        out.Q1 = tmpVctr(1); out.Q3 = tmpVctr(2);
        out.O1 = out.Q1 - k * (out.Q3 - out.Q1);
        out.O3 = out.Q3 + k * (out.Q3 - out.Q1);
        out.outIdx = [find( dataMtx(:) > out.O3 ); find( dataMtx(:) < out.O1 )];
        out.outRatio = length( out.outIdx ) / length( dataMtx(:) );
        if out.outRatio > 0;
            dataMtx = abs(dataMtx);
            out.outScale = sum( dataMtx(out.outIdx) ) / sum( dataMtx(:) );
        else; out.outScale = 0; end;
    end

end