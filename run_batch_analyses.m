function run_batch_analyses()
% Running velocity analyses as batch
% Choose which functions to run on images in current working directory
% Frank Charbonier, Stanford University, 2023
% clear;
close all;
% clc;

%% Load config file
config = load_config('analysis-settings.txt');

cellname = config{'cellname'};
domainname = config{'domainname'};
w0 = str2double(config{"w0"});
d0 = str2double(config{"d0"});
% w0 = 16;
% d0=4;
image_seq = config{"image_seq"};

%% USER INPUTS (not yet added to config file)
% Frames to include for cell trajectories and MSD (0 to 1)
nstart= 0;
nend = 1;
% Trajectory data from compute_cell_trajectories.m
trajname = 'cell_trajectories_tstart_end.mat';
% Output file info
tract_dirname = 'displ_traction'; % Name of a folder to put traction plots in
% How much to crop substrate displacement data (default is 10)
crop_val = 10;
% Set to zero to skip drift-correction (if previously applied before FIDIC)
correct_drift = 0;
%Plotting limits for cell velocity plots and kymographs
min_vel = -0.25;
max_vel = 0.25;
% Plotting limits for substrate displacements and tractions
umax = 1;     % um
tmax = 500;      % Pa
% Set inc to 0 for cumulative; 1 for incremental comparison (used in run_FIDIC)
inc = 1;
%% Run FIDIC on cell image
if config{'run_cell_FIDIC'}
%     run_FIDIC(fname_ref,fname_multipage,savename,w0,d0,inc,image_seq);
    run_FIDIC([],cellname,'cells_DIC_results.mat',w0,d0,inc,image_seq);
end

%% Compute cell velocities
if config{'run_cell_vel'}
    disp("Computing cell velocities")
    plot_cellvel(max_vel=max_vel);
%     TO ADD: separate functions for computing and plotting the processed velocity data
%       TO ADD: input min_vel and max_vel for plotting
    disp("Computing cell velocities finished")
end

%% Plot kymographs of cell velocity
if config{'run_cell_kym'}
    disp("Plotting kymographs of cell velocities")
    % plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel)
    plot_cell_vel_kymograph('cellvel_processed.mat', min_vel, max_vel);
end

%% Compute cell trajectories
if config{'run_cell_compute_traj'}
    % compute_cell_trajectories(DICname, domainname, cellname, fd, isisland, savename, thr);
    compute_cell_trajectories();
end

%% Plot cell velocity MSD
if config{'run_cell_MSD'}
    % plot_MSD(trajname, nstart, nend, savename_plot, savename_data, insivisble)
%     MSD_savename_plot = ['MSD_' num2str(nstart,2) '_' num2str(nend,2)];
%     MSD_savename_data = [MSD_savename_plot + ".mat"];
%     plot_MSD('cell_trajectories_tstart_end.mat', nstart, nend, ...
%         MSD_savename_plot, MSD_savename_data);
        plot_MSD(trajname,nstart,nend,'MSD_plot_nstart_nend','MSD_nstart_nend.mat')
        plot_MSD(trajname, nstart, nend);
        disp("MSD calculation completed")
end

%% Plot cell trajectories
if config{'run_cell_plot_traj'}
    % plot_cell_trajectories(traj_name, nstart, nend, savename, invisible)
    % cell_traj_savename = ["Trajectories_" + num2str(nstart,2) + "_" + num2str(nend,2)];
    plot_cell_trajectories(trajname,nstart,nend,'Trajectories_nstart_nend');
    disp("Cell trajectory plotting complete")
end

%% Plot cell velocity correlation length
if config{'run_cell_vel_corr'}
    % vel_autocorr_nogrid(fname)
    vel_autocorr_nogrid();
end

%% Run FIDIC for bead image
if config{'run_beads_FIDIC'}
    fname_ref = [];
    fname_multipage = 'beads.tif';
    savename = 'beads_DIC_results_w0=16.mat';
    inc = 1;
    w0 = str2double(config{"w0"});
    d0 = str2double(config{"d0"});
    % w0 = 16;
    % d0=4;
    image_seq = config{"image_seq"};
    % image_seq = [];
    run_FIDIC(fname_ref,fname_multipage,savename,w0,d0,inc,image_seq);
end

%% Compute cell-substrate tracitions using run_reg_fourier_TFM.m
if config{'run_compute_tractions'}
    disp("Computing tractions")
    % run_reg_fourier_TFM(filename, savename, domainname, num_images, crop_val, correct_drift)
    run_reg_fourier_TFM('beads_DIC_results.mat', 'tract_results.mat', ...
        domainname, [], crop_val, correct_drift);
    disp("Computing tractions complete")
end

%% Plot tractions
    
if config{'run_plot_tractions'}
    disp("Plotting tractions")
%     plot_displ_tractions(cellname, filename, domainname, dirname, savenameheader, umax, tmax, ...
%         num_images, invisible)
    plot_displ_tractions(cellname, 'tract_results.mat', domainname, 'displ_traction', ...
        [tract_dirname,'/t_'], umax, tmax);
    disp("Plotting tractions complete")
end