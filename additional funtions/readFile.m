% Function for reading the data from a file
% can import both .csv or any other file type
% For .csv the output will be a table, and an array for other types
%Author: Veda Narayana Koraganji
function data = readFile(file)
    [file_path, file_name, file_ext] = fileparts(file);
    if file_ext == '.csv'
        data = readtable(file);
    else 
        delimiterIn =' ';
        headerlinesIn = 1 ;
        data = importdata(file,delimiterIn,headerlinesIn);
    end
end