function teleopAndVisualizer()
% This script provides a visualization and teleop interface to the Neato
% robots.  In order to use it, you first must connect to the Neatos
% using the procedure on the webpage.  To launch the application run:
%
%    teleopAndVisualizer()
%
% Running this script will startup a figure window that will show the 
% heading of the robot along with the laser scan data in the odometry
% coordinate system of the robot.
%
% To control the robot with the keyboard, you must have the focus on the
% visualizer window (i.e. click on the window).  The key mappings are:
%     i : forward
%     k : stop
%     j : left
%     l : right
%     , : backward
%     u : forward while turning left
%     o : forward while turning right
%     m : backward while turning left
%     . : backward while turning right
%
% Additionally there are sliders that control the both the forward and
% angular speed of the robot.
%
% To stop execution of the program, simply close the figure window.
    function setLinearVelocity(hObject, eventdata, handles)
        % callback function for the linear velocity slider
        v = get(hObject, 'Value');
    end

    function myCloseRequest(src,callbackdata)
        % Close request function 
        % to display a question dialog box
        % get rid of subscriptions to avoid race conditions
        clear sub_scan;
        delete(gcf)
    end

    function setAngularVelocity(hObject, eventdata, handles)
        % callback function for the angular velocity slider
        w = get(hObject, 'Value');
    end

    function processProjectedScan(sub, msg)
        % Process the point cloud given by the /projected_stable_scan topic
        %
        % This function computes the robot's pose and plots it as a red
        % arrow in the figure.  It also has a visualization of the laser
        % scan projected into the odom coordinate frame.
        odom_pose = getTransform(tftree, 'odom', 'base_link');
        trans = odom_pose.Transform.Translation;
        quat = odom_pose.Transform.Rotation;
        rot = quat2eul([quat.W quat.X quat.Y quat.Z]);
        prev = gcf;
        set(0,'CurrentFigure',f);
        cloud = readXYZ(msg);
        set(gca,'Nextplot','ReplaceChildren');
        plot(cloud(:,1), cloud(:,2),'b.');
        axis manual;
        hold on;
        quiver(trans.X, trans.Y, cos(rot(1)), sin(rot(1)), 'color', 'r', 'maxheadsize', 2, 'linewidth', 1);
        hold off;
        if isvalid(prev)
            set(0, 'CurrentFigure', prev);
        end
    end
    function keyPressedFunction(fig_obj, eventDat)
        % Convert a key pressed event into a twist message and publish it
        ck = get(fig_obj, 'CurrentKey');
        msg = rosmessage(pub);
        switch ck
            case 'i'
                msg.Linear.X = v;
                msg.Angular.Z = 0;
            case 'u'
                msg.Linear.X = v;
                msg.Angular.Z = w;
            case 'j'
                msg.Linear.X = 0;
                msg.Angular.Z = w;
            case 'm'
                msg.Linear.X = -v;
                msg.Angular.Z = -w;
            case 'comma'
                msg.Linear.X = -v;
                msg.Angular.Z = 0;
            case 'period'
                msg.Linear.X = -v;
                msg.Angular.Z = w;
            case 'l'
                msg.Linear.X = 0;
                msg.Angular.Z = -w;
            case 'o'
                msg.Linear.X = v;
                msg.Angular.Z = -w;
            case 'k'
                msg.Linear.X = 0;
                msg.Angular.Z = 0;
        end
        send(pub, msg);
    end
    v = 0.3;
    w = 0.8;

    tftree = rostf;
    pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
    sub_scan = rossubscriber('/projected_stable_scan', 'sensor_msgs/PointCloud2', @processProjectedScan);

	f = figure('CloseRequestFcn',@myCloseRequest);
    xlim([-10 10]);
    ylim([-10 10]);
    set(gca,'position',[.05,.20,.9,.7]);

    sld = uicontrol('Style', 'slider',...
        'Min',0,'Max',0.3,'Value',0.3,...
        'Position', [200 20 120 20],...
        'Callback', @setLinearVelocity);
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[200 45 120 20],...
        'String','Linear Velocity Scale');
    sld = uicontrol('Style', 'slider',...
        'Min',0,'Max',0.6/.248,'Value',w,...
        'Position', [20 20 120 20],...
        'Callback', @setAngularVelocity);
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[20 45 120 20],...
        'String','Angular Velocity Scale');

    set(f,'WindowKeyPressFcn', @keyPressedFunction);
end