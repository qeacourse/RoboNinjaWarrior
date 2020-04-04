function dataset = runBasicWheelVelocityExperiment(vL, vR)

% these are our target wheel velocities
if ~exist('vL', 'var')
    vL = 0.2;
end
if ~exist('vR', 'var')
    vR = 0.1;
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

% use this instead of tic and toc as the simualtor's clock doesn't go
% exactly at realtime
start = rostime('now');
dataset = zeros(0,3);


% loop until 20 seconds has elapsed
while true
    currTime = rostime('now');
    elapsedTime = currTime - start;
    if elapsedTime.seconds >= 20
        break;
    end
    disp(['Elapsed time: ', num2str(elapsedTime.seconds)]);
    [posX, posY] = getNeatoPosition(receive(sub_states));
    dataset(end+1,:) = [elapsedTime.seconds, posX, posY];
    pause(0.05);
end

% stop the Neato by setting both wheel velocities to 0
msg.Data = [0, 0];
send(pub, msg);

f1 = figure;
plot(dataset(:,2), dataset(:,3), 'b.');
hndl = xlabel('X position (m)');
set(hndl,'FontSize', 20);
hndl = ylabel('Y position (m)');
set(hndl,'FontSize', 20);
hndl = title('Neato Position');
set(hndl, 'FontSize', 28);

f2 = figure;
subplot(2,1,1);
plot(dataset(:,1), dataset(:,2), 'k.');
hndl = xlabel('Time (seconds)');
set(hndl,'FontSize', 20);
hndl = ylabel('X position (m)');
set(hndl,'FontSize', 20);

subplot(2,1,2);
plot(dataset(:,1), dataset(:,3), 'r.');
hndl = xlabel('Time (seconds)');
set(hndl,'FontSize', 20);
hndl = ylabel('Y position (m)');
set(hndl,'FontSize', 20);

function [posX, posY] = getNeatoPosition(msg)
    for i = 1 : length(msg.Name)
        if strcmp(msg.Name{i}, 'neato_standalone')
            posX = msg.Pose(i).Position.X;
            posY = msg.Pose(i).Position.Y;
            return
        end
    end
end

end