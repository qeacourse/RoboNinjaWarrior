function output = driveforward(distance, speed)
% driveforward is a simple function that controls the NEATO to drive straight forward 
% at a designated speed for a set distance

%This line says we are going to publish to the topic `/raw_vel' 
%which are the left and right wheel velocities
pubvel = rospublisher('/raw_vel') 

%Here we are creating a ROS message
message = rosmessage(pubvel);  

%Set the right and left wheel velocities 
message.Data = [speed, speed]; 

% Send the velocity commands to the NEATO
send(pubvel, message);

% rostic allows us to do timing based on the simulator clock
rostic;
while 1
    % calculate the delta t from when we started moving using rostoc
    elapsed = rostoc;
    if elapsed > distance/speed % Here we are saying the if the elapsed time is greater than 
        %distance/speed, we have reached our desired distance and we should stop
        
        message.Data = [0,0]; % set wheel velocities to zero if we have reached the desire distance
        send(pubvel, message); % send new wheel velocities
        break %leave this loop once we have reached the stopping time
    end
end

end
