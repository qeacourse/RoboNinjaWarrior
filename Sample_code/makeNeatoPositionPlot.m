function makeNeatoPositionPlot(datasetname)
    function processModelStates(sub, msg)
        if ~isvalid(f)
            return
        end
        now = rostime('now');
        deltaT = now - startTime;
        prev = gcf;
        set(0,'CurrentFigure',f);
        for i = 1 : length(msg.Name)
            if strcmp(msg.Name{i}, 'neato_standalone')
                dataset(currIndex,:) = [deltaT.seconds, msg.Pose(i).Position.X, msg.Pose(i).Position.Y];
                subplot(1,2,1);
                plot(dataset(currIndex,2), dataset(currIndex, 3), 'b.');
                subplot(1,2,2);
                plot(dataset(currIndex,1), dataset(currIndex, 2), 'r.');
                plot(dataset(currIndex,1), dataset(currIndex, 3), 'k.');
                currIndex = currIndex + 1;
            end
        end
        if isvalid(prev)
            set(0, 'CurrentFigure', prev);
        end
    end

    function keyPressedFunction(fig_obj, eventData)
        if eventData.Character == ' '
            saveDataAndUnsubscribeIfNeeded();
        end
    end

    function saveDataAndUnsubscribeIfNeeded()
        if dataNeedsToBeSaved
            clear sub_states;
            data = dataset(1:currIndex-1,:);
            dataNeedsToBeSaved = false;
            save(datasetname, 'data');
            dataNeedsToBeSaved = false;
            disp(['dataset ', datasetname,' saved']);
        end
    end

    function myCloseRequest(src,callbackdata)
        saveDataAndUnsubscribeIfNeeded();
        delete(f);
    end

if ~exist('datasetname')
    needName = true;
    datasetNumber = 1;
    while exist(['neato_position_dataset_',num2str(datasetNumber, '%03d'), '.mat'], 'file')
        datasetNumber = datasetNumber + 1;
    end
    datasetname = ['neato_position_dataset_', num2str(datasetNumber, '%03d'), '.mat'];
end

datasetname
dataNeedsToBeSaved = true;
disp('Close figure window or hit spacebar (with focus on the figure window) to stop dataset collection');
currIndex = 1;
startTime = rostime('now');
dataset = zeros(0,3);

sub_states = rossubscriber('/gazebo/model_states', 'gazebo_msgs/ModelStates', @processModelStates);
f = figure('CloseRequestFcn',@myCloseRequest);
subplot(1,2,1);
xlabel('x position');
ylabel('y position');
hold on;

subplot(1,2,2);
xlabel('time (seconds)');
ylabel('position (red is x, black is y)');
hold on;

set(f,'WindowKeyPressFcn', @keyPressedFunction);

end
