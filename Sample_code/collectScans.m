sub = rossubscriber('/scan');

% place Neato at the origin pointing in the ihat_G direction
placeNeato(0,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

% Collect data at the room origin
scan_message = receive(sub);
r_1 = scan_message.Ranges(1:end-1);
theta_1 = [0:359]';

% place Neato at the origin pointing in a different direction
% TODO: you must modify this next line of code!
placeNeato(0,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

% Then collect data for the second location
scan_message = receive(sub);
r_2 = scan_message.Ranges(1:end-1);
theta_2 = [0:359]';

% place Neato at a new position (a,b)_G with ihat_N oriented parallel to ihat_G
% TODO: you must modify this next line of code!
placeNeato(0,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

scan_message = receive(sub);
r_3 = scan_message.Ranges(1:end-1);
theta_3 = [0:359]';

% place Neato at an arbitrary position and orientation
% TODO: you must modify this next line of code!
placeNeato(0,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

scan_message = receive(sub);
r_4 = scan_message.Ranges(1:end-1);
theta_4 = [0:359]';

% Gently shove everything into a matrix (you can use the matrix or the
% individual r_x and theta_x variables
r_all = [r_1 r_2 r_3 r_4];
theta_all = [theta_1 theta_2 theta_3 theta_4];
