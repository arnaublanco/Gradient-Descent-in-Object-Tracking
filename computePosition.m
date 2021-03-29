function [x,y] = computePosition(myTracker,frame)
    
    % Size of frame
    W = size(frame,2);
    H = size(frame,1);
    
    % Position of myTracker
    x = myTracker.position(1);
    y = myTracker.position(2);
    
    % Initialize gradient as infinite
    diff_Ex = Inf;
    diff_Ey = Inf;
    
    % Parameters for gradient descent
    gamma = 0.0001;
    err = 1;
    counter = 0;
    
    % Gradient descent: Run until the module of nabla E is less than a
    % error and the positions do not reach the borders of the frame.
    if ~(x < 1+round(myTracker.size(1)/2) || x > W - round(myTracker.size(1)/2) || y < 1+round(myTracker.size(2)/2) || y > H - round(myTracker.size(2)/2))
        while(sqrt((gamma*diff_Ex)^2+(gamma*diff_Ey)^2) > err && ~(x < 1+round(myTracker.size(1)/2) || x > W - round(myTracker.size(1)/2) || y < 1+round(myTracker.size(2)/2) || y > H - round(myTracker.size(2)/2)))
            % Compute response map and crop the infinite values of the borders
            D = computeResponseMap(myTracker, frame);

            % Compute gradient of local response map
            [diff_Dx, diff_Dy] = gradient(D);

            % Sum of Dx and Dy (nabla E)
            diff_Ex = sum(diff_Dx(:));
            diff_Ey = sum(diff_Dy(:));

            % Update positions
            x = x - gamma*diff_Ex;
            y = y - gamma*diff_Ey;
            
            disp('Error ' + string(sqrt((gamma*diff_Ex)^2+(gamma*diff_Ey)^2)));

            myTracker.position(1) = x;
            myTracker.position(2) = y;

            % Count the number of iterations and stop when >100
            counter = counter + 1;
            if counter > 100
               break;
            end
        end
        % Round positions because they cannot be decimals
        x = round(x); 
        y = round(y);
    else
        if(x < 1 + round(myTracker.size(1)/2))
            x = 1 + round(myTracker.size(1)/2);
        elseif(x > W - round(myTracker.size(1)/2))
            x = W - round(myTracker.size(1)/2);
        elseif(y < 1+round(myTracker.size(2)/2))
            y = 1 + round(myTracker.size(2)/2);
        elseif(y > H - round(myTracker.size(2)/2))
            y = H - round(myTracker.size(2)/2);
        end
    end
end

