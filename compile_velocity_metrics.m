function compile_velocity_metrics(plot_radial, RMS_cellvel_savename, experiment_summary_savename)
    %loop_through_folder Loop through all folders in current directory containing 'XY' in folder
    %name and save velocity correlation distances
    %   Later make more generic for any filePattern input (not just 'XY') and function call
    
    % Get list of files and folders in current directory with file pattern 'XY'
    baseFolder = pwd;
    folderInfo = dir('*XY*');
    folderList = {folderInfo.name};
    num_folders = length(folderList);
    % celldisp(folderList);

    % Open first folder to get number of timepoints
    cd(baseFolder);
    cd(folderList{1});
    cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms');
    num_timepoints = length(cellvel_data.u_rms);

    % Initialize arrays to store compiled metrics
    vel_corr_length_compiled = zeros(num_folders,1);
    MSD_exponent_compiled = zeros(num_folders,1);
    u_rms_compiled = zeros(num_folders, num_timepoints);
    v_rms_compiled = zeros(num_folders, num_timepoints);
    u_mag_rms_compiled = zeros(num_folders, num_timepoints);

    if (plot_radial==1)
        cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms', "ur_rms", "ut_rms");
        ur_rms_compiled = zeros(num_folders, num_timepoints);
        ut_rms_compiled = zeros(num_folders, num_timepoints);
    end
    
    for k = 1:length(folderList)
        cd(baseFolder);
        cd(folderList{k});

        disp(pwd);
        vel_corr_length_compiled(k,1) = importdata('vel_corr_dist.txt');

        cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms');
        u_rms_compiled(k,:) = cellvel_data.u_rms;
        v_rms_compiled(k,:)= cellvel_data.v_rms;
        u_mag_rms_compiled(k,:) = cellvel_data.u_mag_rms;

        if (plot_radial==1)
            cellvel_data = load(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms', "ur_rms", "ut_rms");
            ur_rms_compiled(k,:) = cellvel_data.ur_rms;
            ut_rms_compiled(k,:) = cellvel_data.ut_rms;
        end
        
        % Need to fix this later if MSD savename changes
        MSD_savename = "MSD_data_0-1.mat";
        MSD_data = load(MSD_savename, "n");
        MSD_exponent_compiled(k,1) = MSD_data.n;

        disp('Folder analysis complete');
    end
    
    % Return to original working directory
    cd(baseFolder);

    % Save data
    if (plot_radial==1)
        save(experiment_summary_savename, "vel_corr_length_compiled", "MSD_exponent_compiled", ...
            "u_rms_compiled", "v_rms_compiled", "u_mag_rms_compiled", ...
            "ur_rms_compiled", "ut_rms_compiled");
    else
        save(experiment_summary_savename, "vel_corr_length_compiled", "MSD_exponent_compiled", ...
            "u_rms_compiled", "v_rms_compiled", "u_mag_rms_compiled");
    end
end