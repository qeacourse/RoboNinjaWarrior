pub = rospublisher('/cmd_vel');
msg = rosmessage(pub);
msg.Linear.X = 0.2;
msg.Angular.Z = -0.5;
send(pub, msg);

prompt = 'Press Enter to Stop Robot';
str = input(prompt,'s');
if isempty(str)
    msg.Linear.X = 0;
    msg.Angular.Z = 0;
    send(pub,msg)
end