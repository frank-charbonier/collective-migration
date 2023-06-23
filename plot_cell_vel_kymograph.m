function plot_cell_vel_kymograph(processed_vel_data, min_vel, max_vel, savename, plot_radial)
% Run plot_cellvel.m first to obtain processed FIDIC data (with regions outside domain removed and
% units adjust from px to um
% Adapted from CreateKymographs.m at https://github.com/elifesciences-publications/FreelyExpandingTissues

% clear;
close all;
% clc;

%% Compute radial and tangential velocity components
load(processed_vel_data);
u_cell_mag = sqrt(u_cell.^2 + v_cell.^2);

%% Plot kymographs
cmap = load('map_cold-hot.dat'); % Load hot-cold colormap data
figure('Position', [1, 1, 900, 300])
tiledlayout(1, 3)

% Velocity magnitude
nexttile
kymo = create_kymograph(u_cell_mag, plot_radial);
imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
title('Cell velocity magnitude');
ax = nexttile(1);
set(ax, 'Color', 'k')   % Set plot background to black
colormap(ax, brewermap([],'YlOrRd')); clim([0 max_vel]); colorbar;

if (plot_radial==1)
    % Radial velocity
    nexttile
    kymo = create_kymograph(ur, plot_radial);
    imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
    title('Cell radial velocity')
    ax = nexttile(2);
    set(ax, 'Color', 'k')   % Set plot background to black
    colormap(ax, cmap);
    % colormap(ax, brewermap([],'RdBu'))
    clim([min_vel max_vel]);
    colorbar;

    % Tangential velocity
    nexttile
    kymo = create_kymograph(ut, plot_radial);
    imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
    title('Cell tangential velocity')
    ax = nexttile(3);
    set(ax, 'Color', 'k')   % Set plot background to black
    colormap(ax, cmap);
    % colormap(ax, brewermap([],'RdBu'))
    clim([min_vel max_vel]);
    colorbar;
else
    % X velocity
    nexttile
    kymo = create_kymograph(u_cell, plot_radial);
    imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
    title('Cell X velocity')
    ax = nexttile(2);
    set(ax, 'Color', 'k')   % Set plot background to black
    colormap(ax, cmap);
    % colormap(ax, brewermap([],'RdBu'))
    clim([min_vel max_vel]);
    colorbar;

    % Y velocity
    nexttile
    kymo = create_kymograph(v_cell, plot_radial);
    imagesc(kymo,"AlphaData",~isnan(kymo))  % use AlphaData property to make naan values transparent
    title('Cell Y velocity')
    ax = nexttile(3);
    set(ax, 'Color', 'k')   % Set plot background to black
    colormap(ax, cmap);
    % colormap(ax, brewermap([],'RdBu'))
    clim([min_vel max_vel]);
    colorbar;
end

print('-dpng','-r300',savename);

