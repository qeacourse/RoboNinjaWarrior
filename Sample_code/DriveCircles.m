 function  DriveCircles(vL, vR)

% these are our target wheel velocities
if ~exist('vL', 'var')
    vL = -0.3;
end
if ~exist('vR', 'var')
    vR = 0.3;
end

% this publisher lets us command the wheel velocities
pub = rospublisher('/raw_vel');
sub_states = rossubscriber('/gazebo/model_states', 'gazebo_msgs/ModelStates');

msg = rosmessage(pub);

% make sure robot starts out with 0 velocity
msg.Data = [0, 0];
send(pub, msg);
pause(2);

msg.Data = [vL, vR];
send(pub, msg);

% use rostic to access simulator time
rostic;

% Drive for 10s then switch directions
while true
    elapsedTime = rostoc;
    if elapsedTime >= 10
        msg.Data = [-vL, -vR];
        send(pub, msg);
        if elapsedTime >= 20
        break;
        end
    end
    disp(['Elapsed time: ', num2str(elapsedTime)]);
    pause(0.05);
end

% stop the Neato by setting both wheel velocities to 0
msg.Data = [0, 0];
send(pub, msg);
end 
