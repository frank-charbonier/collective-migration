function compile_displacement_metrics(bead_displacement_savename, displacement_summary_savename)
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
    % cd(baseFolder);
    % cd(folderList{1});
    % bead_disp_data = load(tract_results, 'u', 'v');
    % num_timepoints = length(bead_disp_data.u_rms);

    % Initialize arrays to store compiled metrics
    bead_disp_compiled = nan(num_folders,1);
    % MSD_exponent_compiled = nan(num_folders,1);
    % u_rms_compiled = nan(num_folders, num_timepoints);
    % v_rms_compiled = nan(num_folders, num_timepoints);
    % u_mag_rms_compiled = nan(num_folders, num_timepoints);

    
    for k = 1:length(folderList)
        cd(baseFolder);
        cd(folderList{k});

        disp(pwd);
        % bead_disp_compiled(k,1) = importdata('vel_corr_dist.txt');

        bead_disp_data = load(bead_displacement_savename, 'u', 'v');
        u=bead_disp_data.u;
        v=bead_disp_data.v;
        % bead_disp_compiled(k,:) = mean(sqrt(u(:,:,k).^2+v(:,:,k).^2),"all");
        bead_disp_compiled(k,1) = mean(sqrt(u.^2+v.^2),"all");

        disp('Folder analysis complete');
    end
    
    % Return to original working directory
    cd(baseFolder);

    % Save data

    save(displacement_summary_savename, "bead_disp_compiled");

end