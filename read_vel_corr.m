function [data] = read_vel_corr()
    %loop_through_folder Loop through all folders in current directory containing 'XY' in folder
    %name and save velocity correlation distances
    %   Later make more generic for any filePattern input (not just 'XY') and function call
    
    % Get list of files and folders in current directory with file pattern 'XY'
    baseFolder = pwd;
    folderInfo = dir('*XY*');
    folderList = {folderInfo.name};
    % celldisp(folderList);

    % Initialize nx2 array to store folder names with output of called function
    data = cell(length(folderList), 2);
    
    for k = 1:length(folderList)
        cd(baseFolder);
        cd(folderList{k});
        
        disp(pwd);
        data{k,1} = folderList{k};
        data{k,2} = importdata('vel_corr_dist.txt');
        disp('Folder analysis complete');
    end
    
    % Return to original working directory
    cd(baseFolder);
end