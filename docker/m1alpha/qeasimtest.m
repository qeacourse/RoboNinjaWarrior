function qeasimtest(op, varargin)
% Start or stop the QEA robot simulator.
% Note that >> is used to indicate that the command should be run in the
% MATLAB command window (or in a MATLAB script / livescript if you prefer)
%
% USAGE: >> qeasim start simulator_world
%   Start the simulator with the specified simulator world.  You would replace
%   the word simulator_world with one of the valid options below depending on
%   what you want to do with the robot.
%     - dh (dining hall)
%     - bod_ice_bridge (bridge of doom with icy bridge)
%     - ice_rink (flat world with low friction surface)
%     - empty_no_spawn (flat world)
%     - bod_volcano (the bridge of doom)
%     - flatland_no_spawn (world for the flatland challenge)
%     - gauntlet_final (world for the gauntlet challenge)
%     - CoM (an empty world that we will populate for center of mass
%         activity)
%     - water (a visualization of water at z = 0, suitable for testing
%         dynamically spawned boats)
%     - fourteen_boats (fourteen boats of different shapes used in Boats
%         Week 4 Homework)
%     - comgame (a center of mass guessing game used in Boats Week 4b)
% USAGE: >> qeasim stop
%   Stop the simulator

% we import these to see if the web-based simulator visualization is running
import matlab.net.*
import matlab.net.http.*

% tracks the state of the simulator (useful for some tools)
global qeaSimStarted;

% this is displayed if the code is not started properly
usage = 'USAGE: qeasim start simulator_world\nUSAGE: qeasim stop';

% these are the simulator worlds that work with this script
valid_worlds = {'dh',...
                'bod_ice_bridge',...
                'ice_rink',...
                'empty_no_spawn',...
                'bod_volcano',...
                'flatland_no_spawn',...
                'gauntlet_final',...
                'CoM',...
                'water',...
                'fourteen_boats',...
                'comgame'};

dockerImage = ["testm1",...
               "testm1",...
               "testm1",...
               "testm1",...
               "testm1",...
               "testm1",...
               "testm1",...
               "empty",...
               "testm1boats",...
               "testm1boats",...
               "testm1boats"];

% the host running the master (this runs inside of the Docker conatiner but
% is addressable as localhost since we publish port 11311)
ROS_MASTER_HOST = 'localhost';

% depending on the platform, set location of the docker binary and also the
% node host
if ismac
    % this is where the Docker installer puts Docker by default
    docker_bin = '/usr/local/bin/docker';
    % allow internal ROS nodes to answer to any interface
    ROS_HOSTNAME = '0.0.0.0';
    % Note: host.docker.internal isn't available
    NODE_HOST = '192.168.64.1';
elseif isunix
    % docker is installed in /usr/bin, it is always in the PATH
    docker_bin = 'docker';
    % allow internal ROS nodes to answer to any interface
    ROS_HOSTNAME = '0.0.0.0';
    % this somewhat brittle, but should work for most Linux setups (there
    % is supposed to be a new platform independent way to address the host
    % from the container coming in the next Docker version.
    NODE_HOST = '172.17.0.1';
elseif ispc
    % docker is installed in a directory in the system path
    docker_bin = 'docker';
    NODE_HOST = 'host.docker.internal';
    ROS_HOSTNAME = NODE_HOST;   % on Windows the networking stack requires going back through host.docker.internal
else
    error('Platform not supported')
end

if op == "stop"
    % make sure no additional arguments were supplied since stop doesn't take any
    if size(varargin,1) > 0
        error(['USAGE: ',usage]);
    end
elseif op == "start"
    % make sure the user specified the simulator world they want to run
    if size(varargin,1) ~= 1
        error(['USAGE: ',usage]);
    end
    robotWorld = varargin{1};
    boatWorld = varargin{1};

    % make sure simulator world is one we know about
    if ~any(strcmp(valid_worlds,robotWorld))
        error(strjoin({'Unknown world', 'valid options are', valid_worlds{:}},'\n'));
    end
    selectedImage = dockerImage(find(strcmp(valid_worlds,robotWorld)));
    isRobots = selectedImage == "testm1";

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
disp('Shutting down MATLAB ROS Node in case it is running');
disp('This might take up to 30 seconds');
rosshutdown;
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
    disp('ROS simulator has been succcessfully shutdown');
    return
end

% start the Docker container
docker_cmd = [docker_bin, ' run --rm --name=neato -d --sysctl net.ipv4.ip_local_port_range="32401 32767" -p 11311:11311 -p 8080:8080 -p 9090:9090 -p 32401-32767:32401-32767 -e ROS_HOSTNAME=', ROS_HOSTNAME, ' -e BOAT_WORLD=',boatWorld, ' -e NEATO_WORLD=',robotWorld,' ', char(selectedImage)];

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
        uri = URI('http://localhost:8080');
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
disp('initializing connection from MATLAB to ROS');
rosinit(ROS_MASTER_HOST,11311, 'NodeHost', NODE_HOST);

disp('Connection made.  Checking to see if connection is good.');
% as a quick sanity check we can see if the raw_vel topic exists (we could
% do more, e.g., try to move the robot and make sure the encoders change,
% but let's keep it simple)
topics = rostopic('list');
if isRobots && ~any(strcmp(topics,'/raw_vel'))
    disp('Something is wrong with the list of topics.  Showing the topics in 5 seconds');
    pause(5);
    error(strjoin(string(topics),'\n'));
end

% print out a link to the visualizer and open the web-based visualizer in
% MATLAB's built-in browser.
disp('Connection looks good.  Opening visualizer');
disp('If you need to connect from a different browser, use the following link to see the simulator.');
disp('<a href = "http://localhost:8080">http://localhost:8080</a>');
web('http://localhost:8080','-browser');

qeaSimStarted = true;

end
