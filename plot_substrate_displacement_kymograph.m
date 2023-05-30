function plot_substrate_displacement_kymograph(tract_results, umax, tmax, savename)
    arguments
        % 
        tract_results = 'tract_results.mat';
        % Max value of displ and traction (used for color plot limits)
        umax = 0.1;     % um
        tmax = 600;      % Pa
        savename = 'Substrate_displacement_kymographs';  % Name to save plot 
    end

% Run run_reg_fourier_TFM. first to get tx, ty, u, v
% Adapted from CreateKymographs.m at https://github.com/elifesciences-publications/FreelyExpandingTissues

% clear;
close all;
clc;

%% Compute radial and tangential velocity components
load(tract_results);
u_mag = sqrt(u.^2 + v.^2);

%% Plot kymographs
cmap = load('map_cold-hot.dat'); % Load hot-cold colormap data
figure('Position', [1, 1, 900, 300])
tiledlayout(1, 3)

% Velocity magnitude
nexttile
kymo = create_kymograph(u_mag);
imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
title('Substrate displacement magnitude');
ax = nexttile(1);
set(ax, 'Color', 'k')   % Set plot background to black
colormap(ax, brewermap([],'YlOrRd')); caxis([0 umax]); colorbar;

% % Radial velocity
% nexttile
% kymo = create_kymograph(ur);
% imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
% title('Cell radial velocity')
% ax = nexttile(2);
% set(ax, 'Color', 'k')   % Set plot background to black
% colormap(ax, cmap); 
% % colormap(ax, brewermap([],'RdBu'))
% caxis([min_vel max_vel]); 
% colorbar;
% 
% % Tangential velocity
% nexttile
% kymo = create_kymograph(ut);
% imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
% title('Cell tangential velocity')
% ax = nexttile(3);
% set(ax, 'Color', 'k')   % Set plot background to black
% colormap(ax, cmap); 
% % colormap(ax, brewermap([],'RdBu'))
% caxis([min_vel max_vel]); 
% colorbar;

print('-dpng','-r300',savename);

