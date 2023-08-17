function plot_cellvel_summary(cellvel_savename, time_increment, plot_radial)
% PLOT_CELLVEL_SUMMARY Plot cell velocity summary statistics
%
% First run compute_cellvel.m, then use this for plotting
% Written by Frank Charbonier, Stanford University, 2023

% clear;
close all;
% clc;

%% --- COMPUTE RMS VELOCITIES ---
savename = 'RMS velocities';

% Explicitly initialize computed velocity data
% Convert from um/min to um/hr
if (plot_radial==1)
    cellvel_data = load(cellvel_savename,"u_cell", "v_cell", "x_cell", "y_cell", "ur", "ut");
    ur = 60 * cellvel_data.ur;
    ut = 60* cellvel_data.ut;
else
    cellvel_data = load(cellvel_savename,"u_cell", "v_cell", "x_cell", "y_cell");
    ur = [];
    ut = [];
    plot_radial = plot_radial;
end
u_cell = 60 * cellvel_data.u_cell;
v_cell = 60* cellvel_data.v_cell;


% Loop over all correlations
K = size(u_cell,3);
u_rms = NaN(1,K);
v_rms = NaN(1,K);
u_mag_rms = NaN(1,K);
ur_rms = NaN(1,K);
ut_rms = NaN(1,K);
div_rms = NaN(1,K);
for k=1:K
% parfor k=1:K
    % Load cell velocity for current frame
    u_cell_k = u_cell(:,:,k);
    v_cell_k = v_cell(:,:,k);
    u_cell_mag_k = sqrt(u_cell_k.^2 + v_cell_k.^2);   % Compute vleocity magnitude
    % Compute RMS velocity for x,y components and velocity magnitude
    u_rms_k = rms(u_cell_k, "all", "omitnan");
    v_rms_k = rms(v_cell_k, "all", "omitnan");
    u_mag_rms_k = rms(u_cell_mag_k, "all", "omitnan");
    % Compute divergence of velocity field
    div_k = divergence(u_cell_k, v_cell_k);
    div_rms_k = rms(div_k, "all", "omitnan");
    
    if(plot_radial==1)
        % Load cell velocity for current frame
        ur_k = ur(:,:,k);
        ut_k = ut(:,:,k);
        ur_rms_k = rms(ur_k, "all", "omitnan");
        ut_rms_k = rms(ut_k, "all", "omitnan");
    end

    % Update values
    u_rms(k) = u_rms_k;
    v_rms(k) = v_rms_k;
    u_mag_rms(k) = u_mag_rms_k;
    div_rms(k) = div_rms_k;

    if(plot_radial==1)
        ur_rms(k) = ur_rms_k;
        ut_rms(k) = ut_rms_k;
    end

end

%% ----- PLOT AND SAVE -----
set(0,'DefaultFigureVisible','off')
x_t = linspace(time_increment, time_increment*K, K);
plot(x_t, u_mag_rms);
hold on
legend('v_{mag RMS}');
if (plot_radial==1)
    plot(x_t, ur_rms, 'DisplayName', 'u_{r RMS}')
    plot(x_t, ut_rms, 'DisplayName', 'u_{t RMS}')
else
    plot(x_t, u_rms, 'DisplayName','u_{RMS}')
    plot(x_t, v_rms, 'DisplayName','v_{RMS}')
end

xlabel('Time [min]')
ylabel('Velocity component [ \mum/hr ]')
print('-dpng','-r300',savename);
hold off

plot(x_t, div_rms)
ylabel('RMS of divergence [hr^{-1}]')
print('-dpng','-r300', 'Divergence');

% Later add this filename to analysis file
RMS_cellvel_savename = 'cellvel_summary.mat';

if (plot_radial==1)
    % writematrix(v_rms,'cellvel_summary.txt');
    save(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms', "ur_rms", "ut_rms");
else
    save(RMS_cellvel_savename, 'u_rms', 'v_rms','u_mag_rms');
end

close all

end