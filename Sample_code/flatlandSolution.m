function flatlandSolution()
% to calculate wheel velocities for a given angular speed we need to know
% the wheel base of the robot
wheelBase = 0.235;              % meters
% this is the scaling factor we apply to the gradient when calculating our
% step size
lambda = 0.1;

% setup symbolic expressions for the function and gradient
syms x y;
f = x*y - x^2 - y^2 - 2*x - 2*y + 4;
grad = gradient(f, [x, y]);

% the problem description tells us to the robot starts at position 1, -1
% with a heading aligned to the y-axis
heading = [0; 1];
position = [1; -1];

angularSpeed = 0.1;  % radians / second
linearSpeed = 0.05;  % meters / second

% get setup with a publisher so we can modulate the velocity
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
% stop the robot's wheels in case they are running from before
msg.Data = [0, 0];
send(pub, msg);
pause(2);

% put the Neato in the starting location
placeNeato(position(1), position(2), heading(1), heading(2));
% wait a little bit for the robot to land after being positioned
pause(2);

% set a flag to control when we are sufficiently close to the maximum of f
shouldStop = false;

while ~shouldStop
    % get the gradient
    gradValue = double(subs(grad, {x, y}, {position(1), position(2)}));
    % calculate the angle to turn to align the robot to the direction of 
    % gradValue. There are lots of ways to do this. One way is to use the
    % fact that the magnitude of the cross product of two vectors is equal
    % to the product of the vectors' magnitudes times the sine of the angle
    % between them. Moreover, the direction of the vector will tell us
    % what axis to turn around to rotate the first vector onto the second.
    % We'll use that approach here, but contact us for more approaches.
    crossProd = cross([heading; 0], [gradValue; 0]);
    
    % if the z-component of the crossProd vector is negative that means we
    % should be turning clockwise and if it is positive we should turn
    % counterclockwise
    turnDirection = sign(crossProd(3));
    
    % as stated above, we can get the turn angle from the relationship
    % between the magnitude of the cross product and the angle between the
    % vectors
    turnAngle = asin(norm(crossProd)/(norm(heading)*norm(gradValue)))
    
    % this is how long in seconds to turn for
    turnTime = double(turnAngle) / angularSpeed;
    % note that we use the turnDirection here to negate the wheel speeds
    % when we should be turning clockwise instead of counterclockwise
    msg.Data = [-turnDirection*angularSpeed*wheelBase/2,
                turnDirection*angularSpeed*wheelBase/2];
    send(pub, msg);
    % wait record the start time and wait until the appropriate time has
    % elapsed
    startTurn = rostic;
    while rostoc(startTurn) < turnTime
        pause(0.01);
    end
    heading = gradValue;
    % this is how far we are going to move
    forwardDistance = norm(gradValue*lambda)
    % this is how long to take to move there based on desired linear speed
    forwardTime = forwardDistance / linearSpeed;
    msg.Data = [linearSpeed, linearSpeed];
    send(pub, msg);
    % record the start time and wait until the time has elapsed
    startForward = rostic;
    while rostoc(startForward) < forwardTime
        pause(0.01)
    end
    % update the position for the next iteration
    position = position + gradValue*lambda;
    % if our step is too short, flag it so we break out of our loop
    shouldStop = forwardDistance < 0.01;
end

% stop the robot before exiting
msg.Data = [0, 0];
send(pub, msg);

% display the final position (should be the maximum of the function)
position

end
