function findWalls()
    function my_closereq(src,callbackdata)
        % Close request function 
        % to display a question dialog box
        % get rid of subscriptions to avoid race conditions
        clear sub;
        delete(gcf)
    end

    function [bestSeedPoints bestEndPoints bestInlierSet bestOutlierSet] = RANSAC(cloud, iter, thresh)
        bestSeedPoints = [];
        bestInlierSet = zeros(0,2);
        bestOutlierSet = zeros(0,2);
        bestEndPoints = zeros(0,2);

        for i=1:iter
            seedPoints = datasample(cloud, 2, 'Replace', false);
            v = (seedPoints(1,:) - seedPoints(2,:))';
            if norm(v) == 0
                continue;
            end
            orthv = [-v(2); v(1)];
            diffs = cloud - repmat(seedPoints(2,:), [size(cloud, 1) 1]);
            orthdists = diffs*orthv / norm(orthv);
            inliers = abs(orthdists) < thresh;
            biggestGap = max(diff(sort(diffs(inliers,:)*v/norm(v))));
            if biggestGap < 0.2 && sum(inliers) > size(bestInlierSet,1)
                bestInlierSet = cloud(inliers,:);
                bestOutlierSet = cloud(~inliers, :);
                bestSeedPoints = seedPoints;
                projectedCoordinate = diffs(inliers, :)*v/norm(v);
                bestEndPoints = [min(projectedCoordinate); max(projectedCoordinate)]*v'/norm(v) + repmat(seedPoints(2, :), [2, 1]);
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
            prev = gcf;
            set(0,'CurrentFigure',f);
            clf;
            plot(cloud(:,1), cloud(:,2), 'b.');
            hold on;
        end
        totalLines = 10;
        tic;
        for nlines=1:totalLines
            [bestSeedPoints bestEndPoints bestInlierSet cloud] = RANSAC(cloud, 1000, .005);
            if size(bestInlierSet,1) < 5
                break;
            end
            if visualize
                plot(bestInlierSet(:,1), bestInlierSet(:,2), 'k.');
                plot(bestEndPoints(:,1), bestEndPoints(:,2), 'r');
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