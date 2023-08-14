function run_batch_analyses(settings_savename)
% Running velocity analyses as batch
% Choose which functions to run on images in current working directory
% Requires 'analysis-settings.txt' and 'experiment-settings' configuration files to set parameters
% and specify which analyses to perform
%
% Frank Charbonier, Stanford University, 2023

% clear;
close all;
% clc;

%% LOAD SETTINGS
% If analysis/experiment settings have not been passed from the outer folder,
% load settings for the invidual dataset
if ~exist(settings_savename)
    settings_savename = 'config_settings.mat';
    read_settings(settings_savename);
    load(settings_savename);
else
    load(settings_savename);
end

%% Run FIDIC on cell image
if run_cell_FIDIC
    disp('Running FIDIC')
    % run_FIDIC(fname_ref,fname_multipage,savename,w0,d0,inc,image_seq);
    run_FIDIC([],cellname,DICname,w0,d0,inc,image_seq);
end

%% Compute cell velocities
if run_compute_cell_vel
    disp("Computing cell velocities")
    tic
    % compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial, thr)
    compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial, thr);
    % compute_cellvel_non_parallelized(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial, thr);
    disp("Computing cell velocities finished")
    toc
end

%% Plot cell velocities
if run_plot_cell_vel
    disp("Plotting cell velocities")
    tic
    % plot_cellvel(cellname, domainname, DICname, pix_size, min_vel, max_vel, plot_radial, qd, quiver_size)
    plot_cellvel(cellname, cellvel_savename, pix_size, min_vel, max_vel, plot_radial, qd, quiver_size);
    disp("Plotting cell velocities finished")
    toc
end

%% Plot cell velocity summary statistics
if run_plot_cell_vel_summary
    disp("Plotting cell velocity summary statistics")
    tic
    % function plot_cellvel_summary(cellvel_savename, time_increment, plot_radial)
    plot_cellvel_summary(cellvel_savename, time_increment, plot_radial)
    disp("Plotting cell velocity summary statistics finished")
    toc
end

%% Plot kymographs of cell velocity
if run_cell_kym
    disp("Plotting kymographs of cell velocities")
    tic
    % plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel, savename, plot_radial)
    plot_cell_vel_kymograph(cellvel_savename, min_vel, max_vel, 'Kymographs', plot_radial);
    disp("Plotting kymographs of cell velocities finished")
    toc
end

%% Compute cell trajectories
if run_cell_compute_traj
    disp("Computing cell trajectories")
    isisland = 0; % Need to fix this setting in compute_cell_trajectories.m
    compute_cell_trajectories(DICname, domainname, cellname, pix_size, tstart, tend, time_increment, fd, isisland, trajname, thr);
    disp("Computing cell trajectories finished")
end

%% Plot cell velocity MSD
if run_cell_MSD
    disp("Calculating MSD")
    tic
    % Set to [] to make figure visible. Set to 1 to make figure invisible.
    invisible = 1;
    % plot_MSD(trajname, nstart, nend, time_increment, savename_plot, savename_data, insivisble)
    plot_MSD(trajname,nstart,nend,time_increment, 'MSD_plot','MSD_data', invisible)
    disp("MSD calculation completed")
    toc
end

%% Plot cell trajectories
if run_cell_plot_traj
    disp("Plotting cell trajectories")
    tic
    % plot_cell_trajectories(traj_name, nstart, nend, savename, invisible)
    % cell_traj_savename = ["Trajectories_" + num2str(nstart,2) + "_" + num2str(nend,2)];
    plot_cell_trajectories(trajname,nstart,nend,'Trajectories');
    disp("Plotting cell trajectories finished")
    toc
end

%% Plot cell velocity correlation length
if run_cell_vel_corr
    % vel_autocorr_nogrid(fname)
    disp("Calculating cell velocity correlation length")
    tic
    vel_autocorr_nogrid(trajname);
    disp("Finished calculating cell velocity correlation length")
    toc
end

%% Run FIDIC for bead image
if run_beads_FIDIC
    disp("Running FIDIC on bead images")
    tic
    run_FIDIC([],beadname,beadDICname,w0,d0,inc,image_seq);
    disp("FIDIC on beads images complete")
    toc
end

%% Compute cell-substrate tracitions using run_reg_fourier_TFM.m
if run_compute_tractions
    disp("Computing tractions")
    tic
    % run_reg_fourier_TFM(filename, savename, domainname, num_images, crop_val, correct_drift,...
    % pix_size, E, nu)
    run_reg_fourier_TFM(beadDICname, 'tract_results.mat', [], [], crop_val, correct_drift, pix_size, substrate_modulus, substrate_poisson_ratio);
    disp("Computing tractions complete")
    toc
end

%% Plot tractions
if run_plot_tractions
    disp("Plotting tractions")
    tic
    invisible = 1;
%     plot_displ_tractions(cellname, filename, domainname, dirname, savenameheader, umax, tmax, ...
%         num_images, invisible)
    plot_displ_tractions(beadname, 'tract_results.mat', [], 'displ_traction', ...
        [tract_dirname,'/t_'], umax, tmax, [], invisible, pix_size);
    disp("Plotting tractions complete")
    toc
end