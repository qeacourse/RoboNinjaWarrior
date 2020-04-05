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
        message.Data = [-0.3, -0.3];
        send(pub, message);
        break;
    end
end
