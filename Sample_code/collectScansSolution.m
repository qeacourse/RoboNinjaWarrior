sub = rossubscriber('/scan');

% place Neato at the origin pointing in the ihat_G direction
placeNeato(0,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

% Collect data at the room origin
scan_message = receive(sub);
r_1 = scan_message.Ranges(1:end-1);
theta_1 = deg2rad([0:359]');

% place Neato at origin of G with ihat_N at a 30-degree angle relative to ihat_G
placeNeato(0,0,cos(pi/6),sin(pi/6))

% wait a while for the Neato to fall into place
pause(2);

% Then collect data for the second location
scan_message = receive(sub);
r_2 = scan_message.Ranges(1:end-1);
theta_2 = deg2rad([0:359]');

% place Neato at a new position (1,0)_G with ihat_N oriented parallel to ihat_G
placeNeato(1,0,1,0)

% wait a while for the Neato to fall into place
pause(2);

scan_message = receive(sub);
r_3 = scan_message.Ranges(1:end-1);
theta_3 = deg2rad([0:359]');

% place Neato at (0,-2)_G with ihat_N at a 60-degree angle relative to ihat_G
placeNeato(0,-2,cos(pi/3),sin(pi/3))

% wait a while for the Neato to fall into place
pause(2);

scan_message = receive(sub);
r_4 = scan_message.Ranges(1:end-1);
theta_4 = deg2rad([0:359]');

% Shove everything into a matrix (you can use the matrix or the
% individual r_x and theta_x variables
r_all = [r_1 r_2 r_3 r_4];
theta_all = [theta_1 theta_2 theta_3 theta_4];

% I decided to store the collected data in a .mat file so I could iterate
% on my solution without being connected to the simulator.
save('mydata.mat','r_all','theta_all')
