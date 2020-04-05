function output = driveforward(distance, speed)
% driveforward is a simple function that controls the NEATO to drive straight forward 
% at a designated speed for a set distance

%This line says we are going to publish to the topic `/raw_vel' 
%which are the left and right wheel velocities
pubvel = rospublisher('/raw_vel') 

%Here we are creating a ROS message
message = rosmessage(pubvel); 

%we need to use a timer to decide when to start / stop the robot.
%if we were using the physical robot, we could just use Matlab's tic and
% toc commands.  Since we are using the simulator, we should use the
% rostime function to account for the fact that the simulator clock might
% go a little bit slower than realtime.
%In this program we are making sure we drive the desired distance by
% finding the necessary time based on speed
start = rostime('now'); 

%Set the right and left wheel velocities 
message.Data = [speed, speed]; 

% Send the velocity commands to the NEATO
send(pubvel, message); 
while 1
    % get the current time from ROS
    current = rostime('now');
    % calculate the delta t from when we started moving
    elapsed = current - start;
    if elapsed.seconds > distance/speed % Here we are saying the if the elapsed time is greater than 
        %distance/speed, we have reached our desired distance and we should stop
        
        message.Data = [0,0]; % set wheel velocities to zero if we have reached the desire distance
        send(pubvel, message); % send new wheel velocities
        break %leave this loop once we have reached the stopping time
    end
end

end
