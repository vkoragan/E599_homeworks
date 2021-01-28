% HW-1 for E599 course 
% Author: Veda Narayana Koraganji
clc;

file = 'ECG_hw1.csv';
fileData = readFile(file);

ecgData = table2array(fileData(:,1));
timeMs = [1:length(ecgData)]';

plot(timeMs, ecgData);
xlabel('Time(ms)');
ylabel('ECG(mV)');

heartBeats = {};

% As per the instructions in the assignment
% Simple code for implementing without using inbuilt funtions
j = 1;
for i = 2:length(ecgData)-1
    if ((ecgData(i - 1) < ecgData(i)) && (ecgData(i) > ecgData(i + 1))) && (ecgData(i) > 400)
        heartBeats = [heartBeats; {ecgData(i),i}];
        j = j + 1;
    end
end

% To make my future self life easier....
heartBeats2 = ecgData(islocalmax(ecgData,'MinProminence',400));
