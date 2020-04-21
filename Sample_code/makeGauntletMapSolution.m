load('mydata.mat','r_all','theta_all');

% The origin of the Neato frame in the Global frame.
% Each row corresponds to the origin for a particular scan
origins = [0 0; 0 0; 1 0; 0 -2];

% the orientation of the Neato relative to the Global frame in radians.
% A positive angle here means the Neato's ihat_N axis was rotated
% counterclockwise from the ihat_G axis.
orientations = [0 pi/6 0 pi/3];

% the origin of the Lidar frame in the Neato frame (ihat_N, jhat_N).
origin_of_lidar_frame = [-0.084 0];

allScansFig = figure;

% for each scan
for i = 1 : size(origins,1)
    cartesianPointsInLFrame = [cos(theta_all(:,i)).*r_all(:,i)...
                               sin(theta_all(:,i)).*r_all(:,i)]';
    figure;
    scatter(cartesianPointsInLFrame(1,:), cartesianPointsInLFrame(2,:));
    title(['Scan ', num2str(i), ' in Lidar frame']);
    
    % add a row of all ones so we can use translation matrices
    cartesianPointsInLFrame(end+1,:) = 1;
    cartesianPointsInNFrame = [1 0 origin_of_lidar_frame(1);...
                               0 1 origin_of_lidar_frame(2);...
                               0 0 1]*cartesianPointsInLFrame;
    figure;
    scatter(cartesianPointsInNFrame(1,:), cartesianPointsInNFrame(2,:));
    title(['Scan ', num2str(i), ' in Neato frame']);
    
    % undo the rotation of the Neato so the points are with respected to
    % the global coordinate axes with the origin located at the Neato's
    % position
    rotatedPoints = [cos(orientations(i)) -sin(orientations(i)) 0;...
                     sin(orientations(i)) cos(orientations(i)) 0;...
                     0 0 1]*cartesianPointsInNFrame;
    figure;
    scatter(rotatedPoints(1,:), rotatedPoints(2,:));
    title(['Scan ', num2str(i), ' in Global frame pre-translation']);

    % translate the points to be relative to the Global origin
    cartesianPointsInGFrame = [1 0 origins(i,1);...
                               0 1 origins(i,2);...
                               0 0 1]*rotatedPoints;

    % plot using the all scans figure
    figure(allScansFig);
    scatter(cartesianPointsInGFrame(1,:), cartesianPointsInGFrame(2,:));
    hold on;
    title('All scans in Global frame');                              
end
% display the figure that contains all of the scans
figure(allScansFig);