function qeasim(op, varargin)
% Start or stop the QEA robot simulator.
% Note that >> is used to indicate that the command should be run in the
% MATLAB command window (or in a MATLAB script / livescript if you prefer)
%
% USAGE: >> qeasim start simulator_world
%   Start the simulator with the specified simulator world.  You would
%   replace the word simulator_world with one of the valid options below
%   depending on what you want to do with the robot.
%     - dh (dining hall)
%     - bod_ice_bridge (bridge of doom with icy bridge)
%     - ice_rink (flat world with low friction surface)
%     - empty_no_spawn (flat world)
%     - bod_volcano (the bridge of doom)
%     - flatland_no_spawn (world for the flatland challenge)
%     - gauntlet_final (world for the gauntlet challenge)
%     - empty_world (an empty world that we will populate for center of mass
%         activity)
%     - water (a visualiuzation of water at z = 0, suitable for testing
%         dynamically spawned boats)
%     - water_realistic (a visualization of water at z = 0, suitable for
%         testing dynamically spawned boats.  Also has cool waves!)
%     - fourteen_boats (fourteen boats of different shapes used in Boats
%         Week 4 Homework)
%     - fourteen_boats_realistic (same as fourteen boats but with waves!)
%     - comgame (a center of mass guessing game used in Boats Week 4b)
% USAGE: >> qeasim stop
%   Stop the simulator
% we import these to see if the web-based simulator visualization is running
import matlab.net.*
import matlab.net.http.*
% tracks the state of the simulator (useful for some tools)
global qeaSimStarted;
% this is displayed if the code is not started properly
usage = 'USAGE: qeasim start simulator_world\nUSAGE: qeasim start physical IPADDRESS\nUSAGE: qeasim stop';
% depending on the platform, set location of the Docker binary
if ismac
    % this is where the Docker installer puts Docker by default
    docker_bin = '/usr/local/bin/docker';
    homeDir = getenv('HOME');
elseif isunix
    % docker is installed in /usr/bin, it is always in the PATH
    docker_bin = 'docker';
    homeDir = getenv('HOME');
elseif ispc
    % docker is installed in a directory in the system path
    docker_bin = 'docker';
    homeDir = getenv('USERPROFILE');
else
    error('Platform not supported')
end
% these are the simulator worlds that work with this script
valid_worlds = {'dh',...
                'bod_ice_bridge',...
                'ice_rink',...
                'empty_no_spawn',...
                'bod_volcano',...
                'bod_volcano_with_camera',...
                'flatland_no_spawn',...
                'gauntlet_final',...
                'empty_world',...
		'physical',...
                'water',...
                'water_realistic',...
                'fourteen_boats',...
                'fourteen_boats_realistic',...
                'comgame'};
rosPkgs = ["neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "neato_gazebo",...
           "gazebo_ros",...
           "neato_node",...
           "usv_gazebo_plugins",...
           "usv_gazebo_plugins",...
           "usv_gazebo_plugins",...
           "usv_gazebo_plugins",...
           "usv_gazebo_plugins"];
if op == "stop"
    % make sure no additional arguments were supplied since stop doesn't take any
    if size(varargin,1) > 0
        error(sprintf(usage));
    end
elseif op == "start"
    % make sure the user specified the simulator world they want to run
    if size(varargin,2) == 0
        error(sprintf(usage));
    end
    launchName = varargin{1};
    if size(varargin,2) ~= 2 && launchName == "physical"
        error(sprintf(usage));
    end
    if size(varargin,2) ~= 1 && launchName ~= "physical"
        error(sprintf(usage));
    end
    % make sure simulator world is one we know about
    if ~any(strcmp(valid_worlds,launchName))
        error(strjoin({'Unknown world', 'valid options are', valid_worlds{:}},'\n'));
    end
    rosPkg = rosPkgs(find(strcmp(valid_worlds,launchName)));
    isRobots = rosPkg == "neato_gazebo";
else
    error('unknown:operation',['Invalid operation\n',usage]);
end
disp('Making sure docker is running');
maxDockerRetryCount = 5;
for retryCount = 1 : maxDockerRetryCount
    % docker ps is a good command to see if docker is running
    [exit_code, cmd_out] = system([docker_bin, ' ps']);
    % exit_code 0 means that command didn't throw an eror
    if exit_code == 0
        break
    end
    disp('Waiting for docker to be ready.  This could take a while');
    if retryCount == maxDockerRetryCount
        disp('Had trouble connecting to Docker, contact a teaching team member');
        error(cmd_out);
    end
    % wait for a while and see if Docker is running
    pause(10);
end
disp('Docker is ready');
% stop the sim in case it is running (this causes all sorts of problems)
disp('Shutting down docker container in case it is running');
[status, cmd_out] = system([docker_bin, ' stop neato']);
if status ~= 0 && status ~= 1
    disp('Got an unexpected exit code from docker stop neato');
    error(cmd_out);
end
[status, cmd_out] = system([docker_bin, ' rm --force neato']);
if status ~= 0 && status ~= 1
    disp('Got an unexpected exit code from docker rm --force neato');
    error(cmd_out);
end
disp('You will have to manually close any simulator visualizations in your browser');
qeaSimStarted = false;
if op == "stop"
    disp('ROS simulator has been successfully shutdown');
    return
end
if isRobots
   launchFile = ['"neato_no_spawn.launch neato_world:=',launchName,'"'];
else
   if strcmp(launchName, 'physical')
       ipAddr = varargin{2};
       launchFile = ['"bringup_minimal.launch host:=', ipAddr,' use_udp:=false"'];
   else
       launchFile = [launchName,'.launch'];
   end
end
% start the Docker container
docker_cmd = [docker_bin, ' run -d --rm --name=neato -p 9090:9090 -p 8081:8081 -e ROS_PKG=', char(rosPkg), ' -e LAUNCH_FILE=', launchFile, ' -v ', homeDir, ':/root/hosthome -v ', fullfile(homeDir, 'R2020a_licenses'), ':/root/.matlab/R2020a_licenses qeacourse/robodocker:spring2021'];
% warn the user since if they haven't pulled the QEA image it will pull it
% now and print tons of output
disp('If you have yet to download the software, you will see a ton of output');
pause(2);
% we will run the container in background mode.  We can interact with it
% through its name "neato"
status = system(docker_cmd);
if status ~= 0
    disp('Had trouble starting the docker container');
    error(cmd_out);
end
disp('ROS launched.  Waiting for ROS to be ready.');
maxRetries = 10;
% Now we poll the Gazebo Web Visualizer every few seconds to see if it is
% ready.  Once it is, we move on.
for retryCount = 1 : maxRetries
    try
        r = RequestMessage;
        uri = URI('http://localhost:8081');
        [resp, completedRequest, history] = send(r,uri);
    catch e
        % even when it is running we get an HTTPException
        if isa(e,'matlab.net.http.HTTPException')
            % the following two exceptions mean the server is not running
            % yet.  If it is any other error, we are good to go.
            if strcmp(e.identifier,'MATLAB:webservices:ConnectionRefused') == 1 || ...
                strcmp(e.identifier,'MATLAB:webservices:CopyContentToDataStreamError') == 1
                % server not running yet
                disp('ROS not yet ready');
                pause(5);
                continue;
            end
        end
        if retryCount == maxRetries
            error('Visualization server is not coming up.  Please contact the QEA teaching team');
        end
    end
    % didn't get an error or the HTTPException was one that indicates that
    % the server is running
    break;
end
% print out a link to the visualizer and open the web-based visualizer in
% the default browser
disp('Connection looks good.  Opening visualizer');
disp('If you need to connect from a different browser, use the following link to see the simulator.');
disp('<a href = "http://localhost:8081">http://localhost:8081</a>');
web('http://localhost:8081','-browser');
qeaSimStarted = true;
end
