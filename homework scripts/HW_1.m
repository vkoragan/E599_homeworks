% HW-1 for E599 course 
% Author: Veda Narayana Koraganji
clear
% Load data from the CSV file using the readFile function, into a table
file = 'ECG_hw1.csv';
fileData = readFile(file);

% Extract the data from table into arrays for easy manipulation
ecgData = table2array(fileData(:,1));
timeMs = (1:length(ecgData))';

%%%% Question 1 
% plot the data and set annotations for the locations
plot(timeMs, ecgData);
xlabel('Time(ms)');
ylabel('ECG(mV)');
title('Fig. 1: Electrocardiogram Analysis')
grid on
annotation('textarrow',[0.4925 0.394],[0.7938 0.5772],'String','Loc. 1')
annotation('textarrow',[0.7311 0.6441],[0.79 0.6524],'String','Loc. 2')

% For live scripts only: resize the figure to increase the width, this
% change will be applies to all figures unless explicitly changed again
% set(gcf,'Position',[0,0,2000,1000])

% plot the first 10 seconds of the signal
plot(timeMs(1:10000),ecgData(1:10000))
xlabel('Time(ms)');
ylabel('ECG(mV)');
title('Fig. 2: Electrocardiogram Analysis zoomed in')
grid on;

%%%% Question 2
% As per the instructions in the assignment
% Simple code for implementing without using inbuilt funtions

%initialize the variables to store outputs
heartBeats = {};
peak = [];
trough = [];
peak(1) = 0;
trough(1) = 0;

%minProminence will set the sensitivity of the peak detection
minProminence = 400;

%minPeakDistance will select peaks if they are seperated by this variable
minPeakDistance = 450;

j = 1;

for i = 2:length(ecgData)-1
    % detect a peak using the below code
    if ((ecgData(i - 1) < ecgData(i)) && (ecgData(i) > ecgData(i + 1))) &&...
            (ecgData(i) > 0)
        peak = [peak; ecgData(i)];
        
        % check the prominence of the peak with the last known trough
        if (peak(end) - trough(end)) > minProminence && (j == 1)
            heartBeats = [heartBeats; {ecgData(i),i}];   
            j = j + 1;
        elseif (peak(end) - trough(end)) > minProminence &&...
                ((timeMs(i) - cell2mat(heartBeats(j-1,2))) > minPeakDistance)
            heartBeats = [heartBeats; {ecgData(i),i}];   
            j = j + 1;
        end
        
        % detect the trough, needed for confirming prominence
    elseif ((ecgData(i - 1) > ecgData(i)) && (ecgData(i) < ecgData(i + 1)))
        trough = [trough; ecgData(i)];
    end
end

% converting the cell to matrix
heartBeats = cell2mat(heartBeats);

% To make my future self life easier i'll be using functions in the signal...
% processing toolbox
%   [heartBeats, locations] = findpeaks(ecgData,"MinPeakProminence",400,...
%       "MinPeakDistance",450);
%   heartBeats = [heartBeats, locations];

% Write the heart beat data to a file in the 
writetable(array2table([heartBeats(:,2)/1000, heartBeats(:,1)],...
    "VariableNames",{'Time of beat occurence(seconds)',...
    'Signal value at beat(mV)'}),'Heartbeat_data',"FileType",...
    'text',"Delimiter",'tab');

plot(timeMs, ecgData, timeMs(heartBeats(:,2)), heartBeats(:,1), 'or');
xlabel('Time(ms)');
ylabel('ECG(mV)');
title('Fig. 3: ECG Data with Peaks highlighted')
legend('ECG signal','Peaks/Heart beats')
grid on


%%%% Question 3
% As per the instructions in the assignment
% Simple code for implementing without using inbuilt funtions

heartRate = {};

for i = [2:length(heartBeats(:,2))]
    heartRate = [heartRate; {60 / ((heartBeats(i,2) - heartBeats(i-1,2))...
            / 1000), heartBeats(i,2)}];        
end

heartRate = cell2mat(heartRate);

% implementation using built in funtions
%  heartRate2 = diff(heartBeats(:,2));
%  heartRate2 = [60./(heartRate2/1000), heartBeats(2:end,2)];

subplot(4,1,1)
plot(timeMs, ecgData);
xlabel('Time(ms)');
ylabel('ECG(mV)');
title('Fig. 4: ECG Data and Heart rate in two time scales')

subplot(4,1,2)
plot(timeMs(1:30000), ecgData(1:30000));
xlabel('Time(ms)');
ylabel('ECG(mV)');

subplot(4,1,3)
plot(heartRate(:,2), heartRate(:,1));
xlabel('Time(ms)');
ylabel({'Heart rate','(beats per minute)'});

subplot(4,1,4)
plot(heartRate((heartRate(:,2)<30000),2), heartRate(1:length(heartRate((heartRate(:,2)<30000),2)),1));
xlabel('Time(ms)');
ylabel({'Heart rate','(beats per minute)'});


