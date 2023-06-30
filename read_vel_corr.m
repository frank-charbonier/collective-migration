function [data] = read_vel_corr(plot_radial, RMS_cellvel_savename)
    %loop_through_folder Loop through all folders in current directory containing 'XY' in folder
    %name and save velocity correlation distances
    %   Later make more generic for any filePattern input (not just 'XY') and function call
    
    % Get list of files and folders in current directory with file pattern 'XY'
    baseFolder = pwd;
    folderInfo = dir('*XY*');
    folderList = {folderInfo.name};
    % celldisp(folderList);

    % Initialize nx2 array to store folder names with output of called function
    % Later consider switching to struct instead of cell array
    data = cell(length(folderList), 3);
    
    for k = 1:length(folderList)
        cd(baseFolder);
        cd(folderList{k});
        
        disp(pwd);
        data{k,1} = folderList{k};
        data{k,2} = importdata('vel_corr_dist.txt');
        
        cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms');
        data{k,3} = cellvel_data.u_rms;
        data{k,4} = cellvel_data.v_rms;
        data{k,5} = cellvel_data.u_mag_rms;

        if (plot_radial==1)
            cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms', "ur_rms", "ut_rms");
            data{k,6} = cellvel_data.ur_rms;
            data{k,7} = cellvel_data.ut_rms;
        end
        disp('Folder analysis complete');
    end
    
    % Return to original working directory
    cd(baseFolder);
end