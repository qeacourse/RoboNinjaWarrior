pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
tic;
msg.Data = [0.1186, 0.1956];
send(pub, msg);

prompt = 'Press Enter to Stop Robot';
str = input(prompt,'s');
if isempty(str)
    msg.Data=[0,0];
    send(pub,msg)
    toc
end
