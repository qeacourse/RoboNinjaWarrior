close all;
max_points=3000;
encoder_data=zeros(max_points,3);
iter=0;
vl=.2;
vr=.1;
drivetime=20;


[sensors,vels]=neatoSim(); %uncomment for simulator
%[sensors,vels]=neato('192.168.16.144') %uncomment for physical neato
fig = gcf;
disp('press enter to continue');
pause;

tic;
s=toc; 
while s<drivetime
    iter=iter+1;
    if iter<=max_points
        encoder_data(iter,:)=[s,sensors.encoders(1),sensors.encoders(2)];
    end
    s=toc; % s updates as the time since you started
    vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    pause(.20) % you can add a short delay to be safe/for communication lag. 
end
encoder_data=encoder_data(1:iter,:);
vels.lrWheelVelocitiesInMetersPerSecond=[0,0]; 

% Plot encoder data
encFigure = figure;
% make sure we set the focus back to the figure in case it changes
figure(encFigure);
scatter(encoder_data(:,1),encoder_data(:,2:3));
set(gca,'FontSize',24);
xlabel("Time (s)")
ylabel("Linear Travel (m)")
legend('Left Wheel','Right Wheel','Location','northwest');
