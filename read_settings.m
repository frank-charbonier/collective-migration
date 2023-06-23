function read_settings(settings_mat_file)
    %LOAD_SETTINGS 
    %   Later fix this to read in settings from any arbitray text file
    %   Loop over all keys in the dictionary without having to specify explicitly here

%% Load analysis settings
analysis_config = load_config('analysis-settings.txt');

run_cell_FIDIC = analysis_config{'run_cell_FIDIC'};
run_compute_cell_vel = analysis_config{'run_compute_cell_vel'};
run_plot_cell_vel = analysis_config{'run_plot_cell_vel'};
run_plot_cell_vel_summary = analysis_config{'run_plot_cell_vel_summary'};
run_cell_kym = analysis_config{'run_cell_kym'};
run_cell_compute_traj = analysis_config{'run_cell_compute_traj'};
run_cell_plot_traj = analysis_config{'run_cell_plot_traj'};
run_cell_MSD = analysis_config{'run_cell_MSD'};
run_cell_vel_corr = analysis_config{'run_cell_vel_corr'};
run_beads_FIDIC = analysis_config{'run_beads_FIDIC'};
run_compute_tractions = analysis_config{'run_compute_tractions'};
run_plot_tractions = analysis_config{'run_plot_tractions'};

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
fd = analysis_config{"fd"};
thr = analysis_config{"thr"};
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
% isisland = exp_config{"isisland"};
time_increment = exp_config{"time increment [min]"};

%% Save all settings to mat file
save(settings_mat_file);
end

