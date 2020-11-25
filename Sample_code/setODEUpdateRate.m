function setODEUpdateRate(dt)
    s = rossvcclient('/gazebo/get_physics_properties');
    m = rosmessage(s);
    currentPhysics = call(s, m);
    clear s;
    s = rossvcclient('/gazebo/set_physics_properties');
    m = rosmessage(s);
    m.OdeConfig = currentPhysics.OdeConfig;
    m.Gravity = currentPhysics.Gravity;
    m.TimeStep = dt;
    m.MaxUpdateRate = round(1/dt);
    call(s, m);
    clear s;
end