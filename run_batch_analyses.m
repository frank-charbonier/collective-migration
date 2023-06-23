function run_batch_analyses()
% Running velocity analyses as batch
% Choose which functions to run on images in current working directory
% Requires 'analysis-settings.txt' and 'experiment-settings' configuration files to set parameters
% and specify which analyses to perform
%
% Also requires load_config.m from Tamas Kis (https://github.com/tamaskis/load_config-MATLAB/)
% 
% Frank Charbonier, Stanford University, 2023

% clear;
close all;
% clc;

%% Load analysis settings
analysis_config = load_config('analysis-settings.txt');
cellname = analysis_config{'cellname'};
domainname = analysis_config{'domainname'};
beadname = analysis_config{'beadname'};
DICname = analysis_config{'DICname'};
beadDICname = analysis_config{'beadDICname'};
cellvel_savename = analysis_config{'cellvel_savename'};
trajname = analysis_config{'trajname'};
w0 = analysis_config{"w0"};
d0 = analysis_config{"d0"};
inc = analysis_config{"inc"};
image_seq = analysis_config{"image_seq"};
min_vel = analysis_config{"min_vel"};
max_vel = analysis_config{"max_vel"};
tstart = analysis_config{"tstart"};
tend = analysis_config{"tend"};
nstart = analysis_config{"nstart"};
nend = analysis_config{"nend"};
tract_dirname = analysis_config{"tract_dirname"};
crop_val = analysis_config{"crop_val"};
umax = analysis_config{"umax"};
tmax = analysis_config{"tmax"};
correct_drift = analysis_config{"correct_drift"};

%% Load experimental settings
exp_config = load_config('experiment-settings');
pix_size = exp_config{'pixel size [um]'};
plot_radial = exp_config{"plot_radial"};
time_increment = exp_config{"time increment [min]"};

%% Run FIDIC on cell image
if analysis_config{'run_cell_FIDIC'}
    disp('Running FIDIC')
    % run_FIDIC(fname_ref,fname_multipage,savename,w0,d0,inc,image_seq);
    run_FIDIC([],cellname,DICname,w0,d0,inc,image_seq);
end

%% Compute cell velocities
if analysis_config{'run_compute_cell_vel'}
    disp("Computing cell velocities")
    % compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial)
    compute_cellvel(domainname, DICname, cellvel_savename, pix_size, time_increment, plot_radial)
    disp("Computing cell velocities finished")
end

%% Plot cell velocities
if analysis_config{'run_plot_cell_vel'}
    disp("Plotting cell velocities")
    % plot_cellvel(cellname, domainname, DICname, pix_size, time_increment, min_vel, max_vel, plot_radial)
    plot_cellvel(cellname, cellvel_savename, pix_size, min_vel, max_vel, plot_radial);
    disp("Plotting cell velocities finished")
end

%% Plot cell velocity summary statistics
if analysis_config{'run_plot_cell_vel_summary'}
    disp("Plotting cell velocity summary statistics")
    % function plot_cellvel_summary(cellvel_savename, plot_radial)
    plot_cellvel_summary(cellvel_savename, plot_radial)
    disp("Plotting cell velocity summary statistics finished")
end

%% Plot kymographs of cell velocity
if analysis_config{'run_cell_kym'}
    disp("Plotting kymographs of cell velocities")
    % plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel, savename, plot_radial)
    plot_cell_vel_kymograph(cellvel_savename, min_vel, max_vel, 'Kymographs', plot_radial);
    disp("Plotting kymographs of cell velocities finished")
end

%% Compute cell trajectories
if analysis_config{'run_cell_compute_traj'}
    disp("Computing cell trajectories")
    % Factor by which to downsample data. (Need to be careful here -- final
    % number of grid points should match number of cells.) Must be positive
    % integer.
    fd = 2;
    % State whether geometry is an island. Set this to 1 if yes. For island
    % geometry, code will set origin to be the center of the island
    isisland = 0;
    % Name to save data
    savename = 'cell_trajectories_tstart_end.mat';
    % Threshold to reject spurious displacement data. Any incremental
    % displacement data greater than this value is set to nan. Use a large
    % value to avoid thresholding.
    % Note that units here are um, whereas in some other code units are um/min
    thr = 15; % um
    compute_cell_trajectories(DICname, domainname, cellname, pix_size, tstart, tend, time_increment, fd, isisland, savename, thr);
    disp("Computing cell trajectories finished")
end

%% Plot cell velocity MSD
if analysis_config{'run_cell_MSD'}
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
if analysis_config{'run_cell_plot_traj'}
    disp("Plotting cell trajectories")
    % plot_cell_trajectories(traj_name, nstart, nend, savename, invisible)
    % cell_traj_savename = ["Trajectories_" + num2str(nstart,2) + "_" + num2str(nend,2)];
    plot_cell_trajectories(trajname,nstart,nend,'Trajectories_nstart_nend');
    disp("Plotting cell trajectories finished")
end

%% Plot cell velocity correlation length
if analysis_config{'run_cell_vel_corr'}
    % vel_autocorr_nogrid(fname)
    vel_autocorr_nogrid();
end

%% Run FIDIC for bead image
if analysis_config{'run_beads_FIDIC'}
    run_FIDIC([],beadname,beadDICname,w0,d0,inc,image_seq);
end

%% Compute cell-substrate tracitions using run_reg_fourier_TFM.m
if analysis_config{'run_compute_tractions'}
    disp("Computing tractions")
    % run_reg_fourier_TFM(filename, savename, domainname, num_images, crop_val, correct_drift)
    run_reg_fourier_TFM('beads_DIC_results.mat', 'tract_results.mat', ...
        domainname, [], crop_val, correct_drift);
    disp("Computing tractions complete")
end

%% Plot tractions
    
if analysis_config{'run_plot_tractions'}
    disp("Plotting tractions")
%     plot_displ_tractions(cellname, filename, domainname, dirname, savenameheader, umax, tmax, ...
%         num_images, invisible)
    plot_displ_tractions(cellname, 'tract_results.mat', domainname, 'displ_traction', ...
        [tract_dirname,'/t_'], umax, tmax);
    disp("Plotting tractions complete")
end