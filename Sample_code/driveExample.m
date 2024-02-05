%define your parameters
vl=0.1;
vr=0.3;
drivetime=7.7; %s

%Connect to your Neato or the Simulator - choose one or the other
[sensors,vels]=neatoSim(); %uncomment for simulator
%[sensors,vels]=neato('192.168.16.106') %uncomment for physical neato
fig = gcf;
disp('press enter to continue');
pause;

tic %%start your timer in Matlab
t=toc; %initiate t as the time since you started
while t<drivetime
    t=toc; %t update t
    vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    %pause(.01) %you can add a short delay to be safe/for communication lag in the physical neato. 
end

vels.lrWheelVelocitiesInMetersPerSecond=[0,0];
pause(1);
close(fig);
