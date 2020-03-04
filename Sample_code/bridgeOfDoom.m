% This script pilots the Neato along a parameterized curve (R).  The major
% components of this challenge are to compute the linear and angular
% velocity required to traverse the curve.  While not shown in this code,
% we also require that they set the left and right wheel velocities
% directly (rather than linear and angular velocity as in this example).

% u will be our parameter
syms u;

% these assumptions are not strictly necessary, but they do make some of
% the expressions a bit tidier.
assume(u,'positive');
assume(u,'real');

% dilation is the conversion from the raw parameterization of the curve
% to time.  Larger dilation means that the robot will traverse the curve
% more slowly (taking a longer time)
dilation = 4;
timeBounds = [0 4.2*dilation];

% these are parameters of the specific curve
a = 0.4;
l = 0.4;

% this is the parameterized function defining the bridge
R = [-2*a*((l - cos(u/dilation))*cos(u/dilation) + (1 - l));...
     2*a*(l - cos(u/dilation))*sin(u/dilation);...
     0];

% tangent vector
T = diff(R);

% normalized tangent vector
That = T/norm(T);

% normal vector
N = diff(That);

% angular velocity vector
omega = cross(That, N);

% the instantaneous speed of the robot
linearSpeed = norm(T);

% plot the path itself
figure;
fplot(R(1), R(2), timeBounds);
axis equal;

figure;

% plot the angular velocity and linear speed over time
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
    % subsitute the current time into the computed expressions
    msg.Linear.X = double(subs(linearSpeed, u, u_val));
    msg.Angular.Z = double(subs(omega(3), u, u_val));
    % send to the robot
    send(pub, msg);
    % wait a little bit before the next iteration
    pause(0.2);
end
% stop the robot
msg = rosmessage('geometry_msgs/Twist');
send(pub, msg);
