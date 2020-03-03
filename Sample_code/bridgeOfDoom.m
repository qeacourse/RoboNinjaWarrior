syms u
assume(u,'positive');
assume(u,'real');

a = 0.4;
l = 0.4;
dilation = 4;
timeBounds = [0 4.2*dilation];

R = [-2*a*((l - cos(u/dilation))*cos(u/dilation) + (1 - l));...
     2*a*(l - cos(u/dilation))*sin(u/dilation);...
     0];
 
T = diff(R);
That = T/norm(T);
N = diff(That);
omega = cross(That, N);

fplot(R(1), R(2), timeBounds);
axis equal

figure;

linearSpeed = norm(T);
fplot(linearSpeed, timeBounds);
hold on;
fplot(omega(3), timeBounds);
legend({'Linear velocity', 'Angular velocity'});

pub = rospublisher('cmd_vel');
pause(2);
t_start = tic;
while toc(t_start) < timeBounds(2)
    u_val = toc(t_start);
    msg = rosmessage('geometry_msgs/Twist');
    msg.Linear.X = double(subs(linearSpeed, u, u_val));
    msg.Angular.Z = double(subs(omega(3), u, u_val));
    send(pub, msg);
    pause(0.2);
end
msg = rosmessage('geometry_msgs/Twist');
send(pub, msg);
