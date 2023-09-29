% LOOP_THROUGH_DATASETS.M
% 
% Loop through all datasets in current directory with 'XY' in the name and call run_batch_analyses.m
% Frank Charbonier, Stanford University, 2023

% Loop through datasets in directory
clear
close all
% clc

%% LOCATE DATASETS TO ANALYZE
% Get list of files and folders in current directory with 'XY' in the name
baseFolder = pwd;
folderInfo = dir('*XY*');
folderList = {folderInfo.name};
% celldisp(folderList);

%% LOAD SETTINGS
settings_savename = 'config_settings.mat';
read_settings(settings_savename);
load(settings_savename);

%% LOOP THROUGH DATASETS 
for k = 1:length(folderList)
    cd(baseFolder);
    cd(folderList{k});
    disp("Analyzing folder: ")
    disp(pwd);
    if exist(settings_savename)
        delete (settings_savename)
    end
    copyfile(fullfile(baseFolder,settings_savename));
    run_batch_analyses(settings_savename);
    disp('Folder analysis complete');
end

% Return to base folder
% In the future, use filepaths rather than moving directories
cd(baseFolder);

% Later move this into analysis settings
if (run_multifolder_compilation)
    disp('Running multifolder compilation')
    % Later add this filename to analysis file
    RMS_cellvel_savename = 'cellvel_summary.mat';
    experiment_summary_savename = 'exp_summary.mat';
    compile_velocity_metrics(plot_radial, RMS_cellvel_savename, experiment_summary_savename);
    % Old version
    % exp_summary = read_vel_corr(plot_radial, RMS_cellvel_savename);
    % save(experiment_summary_savename, 'exp_summary');
    disp('Multifolder compilation complete')
end

%% Play sound when finished running
% load handel
% sound(y,Fs)

clear