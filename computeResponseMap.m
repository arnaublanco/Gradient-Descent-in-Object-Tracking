function [responseMap] = computeResponseMap(myTracker,frame)
    
    % Round positions (myTracker is local here)
    myTracker.position(1) = round(myTracker.position(1));
    myTracker.position(2) = round(myTracker.position(2));

    % Crop frame to twice myTracker size
    posRect = [myTracker.position(1) myTracker.position(2)] - myTracker.size;
    rect = [posRect, 2.*myTracker.size];
    frame = im2double(imcrop(frame,rect));

    % Size of frame
    W = size(frame,2);
    H = size(frame,1);
    
    % Initialize response map as infinite
    responseMap = Inf * ones(H,W);
    
    % Compute response map for all the positions
    for jx = 1 + round(myTracker.size(1)/2) : W - round(myTracker.size(1)/2)
        for jy = 1 + round(myTracker.size(2)/2) : H - round(myTracker.size(2)/2)
            rectTmp = [[jx jy] - round(myTracker.size/2), myTracker.size];
            patch = im2double(imcrop(frame,rectTmp));
            responseMap(jy,jx) = sum((patch(:) - myTracker.appearance(:) ).^2);
        end
    end
    
    responseMap = responseMap(round(myTracker.size(2)/2+1) : H - round(myTracker.size(2)/2), round(myTracker.size(1)/2+1) : W - round(myTracker.size(1)/2));
end

