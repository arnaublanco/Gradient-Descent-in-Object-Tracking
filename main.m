close all;
clear all;

%% Data import

videoObj = webcam;
nFrames = 1000;

%% Tracking with SSE and gradient descent

% Compute first downsampled frame and store in myTracker.appearance
pause(1);
downSample = 1/3;
frame = im2double(imresize(snapshot(videoObj),downSample));

figure;
imagesc(frame);
hold on

myTracker = struct('position', [0 0], 'size', [0 0], 'appearance', []);
[x,y] = ginput(2);
myTracker.size = [round(abs(x(2) - x(1))) round(abs(y(2) - y(1)))];
myTracker.position(1) = round(x(1) + myTracker.size(1)/2);
myTracker.position(2) = round(y(1) + myTracker.size(2)/2);

rect = [myTracker.position - round(myTracker.size/2), myTracker.size];
I = rgb2hsv(im2double(imcrop(frame,rect)));
myTracker.appearance = I(:,:,2);

% Plot bounding box
bbox = [[myTracker.position(1),myTracker.position(2)] - round(myTracker.size/2), [myTracker.position(1),myTracker.position(2)] + round(myTracker.size/2)];
plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'g-', 'LineWidth', 2);

% For loop for the video starting at 2
for k = 2:nFrames
    frame = im2double(imresize(snapshot(videoObj),downSample));
    imagesc(frame); % Show current frame
    hold on
    
    % Compute updated position and save it in myTracker
    I = rgb2hsv(frame);
    I = I(:,:,2);
    [x,y] = computePosition(myTracker,I);
    myTracker.position(1) = x;
    myTracker.position(2) = y;

    % Plot bounding box
    bbox = [[x,y] - round(myTracker.size/2), [x,y] + round(myTracker.size/2)];
    plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'g-', 'LineWidth', 2);
    
    % Update title and pause
    title('Frame',k);
    pause(0.05)
end

clear('videoObj');