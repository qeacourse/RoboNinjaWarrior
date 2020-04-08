% This node drives forward until it smashes into an object (e.g., John's
% Leg), and then drives in reverse

sub = rossubscriber('/bump')

pub = rospublisher('/raw_vel')
message = rosmessage(pub);
message.Data = [0.3, 0.3];
send(pub, message);

while 1
    bumpMessage = receive(sub);
    % check if any of the bump sensors are set to 1 (meaning triggered)
    if any(bumpMessage.Data)
        message.Data = [-0.3, -0.3];
        send(pub, message);
        break;
    end
end
