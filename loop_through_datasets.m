% Loop through datasets in directory
clear
close all
clc

% Get list of files and folders in current directory with 'XY' in the name
baseFolder = pwd;
folderInfo = dir('*XY*');
folderList = {folderInfo.name};
% celldisp(folderList);

for k = 1:length(folderList)
    cd(baseFolder);
    cd(folderList{k});
    disp(pwd);
    run_batch_analyses;
    disp('Folder analysis complete');
end

cd(baseFolder);