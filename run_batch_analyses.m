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
    % compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial)
    compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial)
    disp("Computing cell velocities finished")
end

%% Plot cell velocities
if run_plot_cell_vel
    disp("Plotting cell velocities")
    % plot_cellvel(cellname, domainname, DICname, pix_size, time_increment, min_vel, max_vel, plot_radial)
    plot_cellvel(cellname, cellvel_savename, pix_size, min_vel, max_vel, plot_radial);
    disp("Plotting cell velocities finished")
end

%% Plot cell velocity summary statistics
if run_plot_cell_vel_summary
    disp("Plotting cell velocity summary statistics")
    % function plot_cellvel_summary(cellvel_savename, plot_radial)
    plot_cellvel_summary(cellvel_savename, plot_radial)
    disp("Plotting cell velocity summary statistics finished")
end

%% Plot kymographs of cell velocity
if run_cell_kym
    disp("Plotting kymographs of cell velocities")
    % plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel, savename, plot_radial)
    plot_cell_vel_kymograph(cellvel_savename, min_vel, max_vel, 'Kymographs', plot_radial);
    disp("Plotting kymographs of cell velocities finished")
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
    % Set to [] to make figure visible. Set to 1 to make figure invisible.
    invisible = 1;
    % plot_MSD(trajname, nstart, nend, time_increment, savename_plot, savename_data, insivisble)
    plot_MSD(trajname,nstart,nend,time_increment, 'MSD_plot','MSD_data.mat', invisible)
    disp("MSD calculation completed")
end

%% Plot cell trajectories
if run_cell_plot_traj
    disp("Plotting cell trajectories")
    % plot_cell_trajectories(traj_name, nstart, nend, savename, invisible)
    % cell_traj_savename = ["Trajectories_" + num2str(nstart,2) + "_" + num2str(nend,2)];
    plot_cell_trajectories(trajname,nstart,nend,'Trajectories_nstart_nend');
    disp("Plotting cell trajectories finished")
end

%% Plot cell velocity correlation length
if run_cell_vel_corr
    % vel_autocorr_nogrid(fname)
    vel_autocorr_nogrid(trajname);
end

%% Run FIDIC for bead image
if run_beads_FIDIC
    run_FIDIC([],beadname,beadDICname,w0,d0,inc,image_seq);
end

%% Compute cell-substrate tracitions using run_reg_fourier_TFM.m
if run_compute_tractions
    disp("Computing tractions")
    % run_reg_fourier_TFM(filename, savename, domainname, num_images, crop_val, correct_drift)
    run_reg_fourier_TFM('beads_DIC_results.mat', 'tract_results.mat', ...
        domainname, [], crop_val, correct_drift);
    disp("Computing tractions complete")
end

%% Plot tractions
if run_plot_tractions
    disp("Plotting tractions")
%     plot_displ_tractions(cellname, filename, domainname, dirname, savenameheader, umax, tmax, ...
%         num_images, invisible)
    plot_displ_tractions(cellname, 'tract_results.mat', domainname, 'displ_traction', ...
        [tract_dirname,'/t_'], umax, tmax);
    disp("Plotting tractions complete")
end