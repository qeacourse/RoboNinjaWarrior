function driveEllipse()
    syms t;
    dilation = 5;
    t_max = 100;
    %R = symfun([.2*cos(t); t/dilation], t);
    R = symfun([0.5*cos(t/dilation); 0.3*sin(t/dilation)], t);
    track = R(linspace(0, t_max, 100));
    xlimits = [min(double(track{1})) - 1, max(double(track{1})) + 1];
    ylimits = [min(double(track{2})) - 1, max(double(track{2})) + 1];

    T = diff(R,t);
    T_hat = symfun(T(t) ./ norm(T(t)), t);
    N = diff(T_hat, t);
    
    V = symfun(norm(T(t)), t);
    omega = symfun(cross([T_hat(t); 0],[N(t); 0]), t);
    
    pub = rospublisher('/cmd_vel');
    msg = rosmessage(pub);

    f = figure();
    hold on;
    xlim(xlimits);
    ylim(ylimits);
    daspect([1 1 1]);

    tic;
    t_elapsed = 0.0;
    while t_elapsed <= t_max
        t_elapsed = toc;
        V_t = double(V(t_elapsed));
        omega_t = double(omega(t_elapsed));
        msg.Linear.X = V_t(1);
        msg.Angular.Z = omega_t(3);
        send(pub, msg);
        
        % visualize some stuff
        R_t = double(R(t_elapsed));
        T_t = double(T(t_elapsed));
        N_t = double(N(t_elapsed));
        
        plot(R_t(1), R_t(2), 'b.');
        quiver(R_t(1), R_t(2), T_t(1), T_t(2));
        quiver(R_t(1), R_t(2), N_t(1), N_t(2));
        pause(0.1);
    end
    msg.Linear.X = 0.0;
    msg.Angular.Z = 0.0;
    send(pub, msg);
end