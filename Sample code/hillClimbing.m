pub = rospublisher('/cmd_vel');
vel_msg = rosmessage(pub);


sub_bump = rossubscriber('/bump');
sub_accel = rossubscriber('/accel');

pause(.5)

while 1
    if any(sub_bump.LatestMessage.Data)
        break
    end
    
    side_accel = sub_accel.LatestMessage.Data(2);
    
    turn_amount = side_accel * 5.0;
    
    forward_amount = 0.02;
    
    vel_msg.Linear.X = forward_amount;
    vel_msg.Angular.Z = turn_amount;
    
    pub.send(vel_msg);
    
end

vel_msg.Linear.X = 0;
vel_msg.Angular.Z = 0;
pub.send(vel_msg);