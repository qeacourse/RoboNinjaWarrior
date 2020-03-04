function makePotentials()
    function my_closereq(src,callbackdata)
        % Close request function 
        % to display a question dialog box
        % get rid of subscriptions to avoid race conditions
        clear sub;
        delete(gcf)
    end

    function d = robotDistance(x, y, p)
       robotRadius = 0.10;
       d = sqrt((x(:) - p(1)).^2 + (y(:) - p(2)).^2);
       d = max(d - robotRadius, zeros(size(d)));
    end

    function [z, Fx, Fy] = Vx(x, y, cloud)
        z = cg ./ robotDistance(x, y, x_g);
        for i=1:size(cloud,1)
            z = z - co ./ robotDistance(x, y, cloud(i,:));
        end
        z = reshape(z, size(x));
        [Fx, Fy] = gradient(z, step, step);
    end
    co = 1;
    cg = 1000;
    sub = rossubscriber('/projected_stable_scan');
    pub = rospublisher('/cmd_vel');
    vel_msg = rosmessage(pub);
    tftree = rostf;
	f = figure('CloseRequestFcn',@my_closereq);
    goal_initialized = false;
    x_g = [1.75; 0];
    step = .1;
    while 1
        msg = receive(sub);
        cloud = readXYZ(msg);
        cloud = cloud(:,1:2);
        
        % get the pose
        odom_pose = getTransform(tftree, 'odom', 'base_link');
        trans = odom_pose.Transform.Translation;
        quat = odom_pose.Transform.Rotation;
        rot = quat2eul([quat.W quat.X quat.Y quat.Z]);
        heading = rot(1);

        [x y] = meshgrid([trans.X-2:step:trans.X+2], [trans.Y-2:step:trans.Y+2]);

        if ~goal_initialized
            x_g_rotated = [cos(heading) -sin(heading); sin(heading) cos(heading)]*x_g;
            x_g = [x_g_rotated(1) + trans.X; x_g_rotated(2) + trans.Y];
            goal_initialized = true;
        end
        
        prev = gcf;
        set(0,'CurrentFigure',f);
        clf;
        plot(cloud(:,1), cloud(:,2), 'b.');
        hold on;
        [z Fx Fy] = Vx(x,y,cloud);
        mag = sqrt(Fx.^2 + Fy.^2);
        quiver(x, y, Fx./mag, Fy./mag);
        [xm ym] = meshgrid([trans.X-0.05 trans.X trans.X +.05],[trans.Y-0.05 trans.Y trans.Y+.05]);
        [dc forceX forceY] = Vx(xm, ym, cloud);
        forceX = forceX(2,2);
        forceY = forceY(2,2);
        quiver(trans.X, trans.Y, cos(heading), sin(heading), 'color', 'r', 'maxheadsize', 2, 'linewidth', 1);

        u_desired = [forceX; forceY] ./ norm([forceX; forceY])
        u_current = [cos(heading); sin(heading)];
        delta = cross([u_desired; 0], [u_current; 0]);
        delta_yaw = asin(delta(3))
        k = 0.3;
        vel_msg.Angular.Z = -delta_yaw*k;
        
        goal_distance = norm([trans.X; trans.Y] - x_g)
        % stop when we hit the goal
        if goal_distance < .2
            vel_msg.Linear.X = 0.0;
            vel_msg.Angular.Z = 0.0;
        else
            speed_multiplier = max(0.0, cos(delta_yaw*2));
            vel_msg.Linear.X = 0.05*speed_multiplier;
        end
        send(pub, vel_msg);
        %[vel_msg.Linear.X vel_msg.Angular.Z]
        xlim([trans.X-2 trans.X+2]);
        ylim([trans.Y-2 trans.Y+2]);
        pause(.01);
        if isvalid(prev)
            set(0, 'CurrentFigure', prev);
        end
    end
end