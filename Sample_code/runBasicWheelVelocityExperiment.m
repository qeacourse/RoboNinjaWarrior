pub = rospublisher('/raw_vel');
msg = rosmessage(pub);

vL = 0.3;
vR = 0.9;
msg.Data = [vL, vR];
send(pub, msg);

prompt = 'Press Enter to Stop Robot';
str = input(prompt,'s');
if isempty(str)
    msg.Data=[0,0];
    send(pub,msg)
end