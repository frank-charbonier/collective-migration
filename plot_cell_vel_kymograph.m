function plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel, savename)
    arguments
        % 
        processed_vel_data = 'cellvel_processed.mat';
        % Max velocity for color plots
        min_vel = -0.1;  % units: um/min
        max_vel = 0.1;  % units: um/min
        savename = 'Kymographs';  % Name to save plot 
    end

% Run plot_cellvel.m first to obtain processed FIDIC data (with regions outside domain removed and
% units adjust from px to um
% Adapted from CreateKymographs.m at https://github.com/elifesciences-publications/FreelyExpandingTissues

% clear;
close all;
clc;

%% Compute radial and tangential velocity components
load(processed_vel_data);
u_cell_mag = sqrt(u_cell.^2 + v_cell.^2);

%% Plot kymographs
cmap = load('map_cold-hot.dat'); % Load hot-cold colormap data
figure('Position', [1, 1, 900, 300])
tiledlayout(1, 3)

% Velocity magnitude
nexttile
kymo = create_kymograph(u_cell_mag);
imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
title('Cell velocity magnitude');
ax = nexttile(1);
set(ax, 'Color', 'k')   % Set plot background to black
colormap(ax, brewermap([],'YlOrRd')); caxis([0 max_vel]); colorbar;

% Radial velocity
nexttile
kymo = create_kymograph(ur);
imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
title('Cell radial velocity')
ax = nexttile(2);
set(ax, 'Color', 'k')   % Set plot background to black
colormap(ax, cmap); 
% colormap(ax, brewermap([],'RdBu'))
caxis([min_vel max_vel]); 
colorbar;

% Tangential velocity
nexttile
kymo = create_kymograph(ut);
imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
title('Cell tangential velocity')
ax = nexttile(3);
set(ax, 'Color', 'k')   % Set plot background to black
colormap(ax, cmap); 
% colormap(ax, brewermap([],'RdBu'))
caxis([min_vel max_vel]); 
colorbar;

print('-dpng','-r300',savename);

