function findWalls()
    function my_closereq(src,callbackdata)
        % Close request function 
        % to display a question dialog box
        % get rid of subscriptions to avoid race conditions
        clear sub;
        delete(gcf);
    end

    function [bestSeedPoints bestCircle bestInlierSet bestOutlierSet] = RANSAC(cloud, iter, thresh)
        bestSeedPoints = [];
        bestInlierSet = zeros(0,2);
        bestOutlierSet = zeros(0,2);
        bestBiggestAngle = 0;
        bestCircle = zeros(0,2);
        for i=1:iter
            seedPoints = datasample(cloud, 3, 'Replace', false);
            [x_c, y_c, radius] = circfit(seedPoints(:,1), seedPoints(:,2));
            diffs = cloud - repmat([x_c, y_c], [size(cloud, 1) 1]);
            radii = sqrt(sum(diffs.^2,2));
            inliers = abs(radii - radius) < thresh;
            inlier_angles = atan2(diffs(inliers, 2), diffs(inliers, 1));
            inlier_angles = mod(inlier_angles, 2*pi);
            inlier_angles = [inlier_angles; min(inlier_angles)+2*pi];
            gaps = sort(diff(sort(inlier_angles)));
            if length(gaps) < 2
                biggestGap = 0;
            else
                biggestGap = gaps(end-1);
            end
            inlier_diffs = diffs(inliers, :);
            inlier_diffs = real(inlier_diffs./repmat(sum(inlier_diffs.^2, 2), [1 2]));
            biggestAngle = max(max(acos(inlier_diffs*inlier_diffs')));
            if biggestAngle > bestBiggestAngle && sum(inliers) > 5 && radius < 0.2 && biggestGap < .4
                bestInlierSet = cloud(inliers, :);
                bestOutlierSet = cloud(~inliers, :);
                bestSeedPoints = seedPoints;
                bestBiggestAngle = biggestAngle;
                bestCircle = [x_c, y_c, radius];
            end
        end
    end
    visualize = true;
    sub = rossubscriber('/projected_stable_scan');
	f = figure('CloseRequestFcn',@my_closereq);
    while 1
        msg = receive(sub);
        cloud = readXYZ(msg);
        cloud = cloud(:,1:2);
        if visualize
            set(0,'CurrentFigure',f);
            clf;
            plot(cloud(:,1), cloud(:,2), 'b.');
            hold on;
        end
        totalCircles = 1;
        tic;
        prev = gcf;
        for nCircles=1:totalCircles
            [bestSeedPoints bestCircle bestInlierSet cloud] = RANSAC(cloud, 10000, .01);
            if size(bestInlierSet,1) < 5
                break;
            end
            if visualize
                plot(bestInlierSet(:,1), bestInlierSet(:,2), 'k.');
                viscircles([bestCircle(1), bestCircle(2)], bestCircle(3));
            end
        end
        toc;
        if visualize
            xlim([-2 2]);
            ylim([-2 2]);
            pause(.01);
            if isvalid(prev)
                set(0, 'CurrentFigure', prev);
            end
        end
    end
end