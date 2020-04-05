% This node drives forward until it smashes into an object (e.g., John's
% Leg), and then drives in reverse

sub = rossubscriber('/bump')

pub = rospublisher('/raw_vel')
message = rosmessage(pub);
message.Data = [0.3, 0.3];
send(pub, message);

while 1
    if (sub.LatestMessage.Data(1) == 1 || ...
        sub.LatestMessage.Data(2) == 1 || ...
        sub.LatestMessage.Data(3) == 1 || ...
        sub.LatestMessage.Data(4) == 1)
        break;
    end
end


% send robot backwards
message.Data = [-0.3, -0.3];
reverseStart = rostime('now');
send(pub, message);

% loop until 5 seconds have elapsed
while 1
    current = rostime('now');
    % calculate the delta t from when we started moving
    elapsed = current - reverseStart;
    if elapsed.seconds > 5
        message.Data = [0,0]; % set wheel velocities to zero if we have reached the desire distance
        send(pubvel, message); % send new wheel velocities
        break;
    end
end
