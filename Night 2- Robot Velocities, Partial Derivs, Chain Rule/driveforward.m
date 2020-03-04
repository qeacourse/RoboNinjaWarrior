function output = driveforward(distance, speed);
% driveforward is a simple function that controls the NEATO to drive straight forward 
% at a designated speed for a set distance

pubvel = rospublisher('/raw_vel') %This line says we are going to publish to the topic `/raw_vel' 
%which are the left and right wheel velocities

message = rosmessage(pubvel); %Here we are creating a ROS message

tic %in Matlab tic and toc start and stop a timer. In this program we are making sure we 
%drive the desired distance by finding the necessary time based on speed

message.Data = [speed, speed]; %Set the right and left wheel velocities 

send(pubvel, message); % Send the velocity commands to the NEATO

while 1
    if toc > distance/speed % Here we are saying the if the elapsed time is greater than 
%distance/speed, we have reached our desired distance and we should stop
        
        message.Data = [0,0]; % set wheel velocities to zero if we have reached the desire distance
        send(pubvel, message); % send new wheel velocities
        break %leave this loop once we have reached the stopping time
    end
end

end