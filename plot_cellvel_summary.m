function plot_cellvel_summary(cellvel_savename, pix_size, min_vel, max_vel, plot_radial)
% PLOT_CELLVEL_SUMMARY Plot cell velocity summary statistics
%
% First run compute_cellvel.m, then use this for plotting
% Written by Frank Charbonier, Stanford University, 2023

% clear;
close all;
% clc;

%% --- MAKE PLOTS ---
savename = 'RMS velocity';

% Load data
load(cellvel_savename);

% Loop over all correlations
K = size(u_cell,3);
v_rms = NaN(1,K);

for k=1:K
    % Load cell velocity for current frame
    u_cell_k = u_cell(:,:,k);
    v_cell_k = v_cell(:,:,k);
    u_cell_mag = sqrt(u_cell_k.^2 + v_cell_k.^2);   % Compute vleocity magnitude
    v_rms_k = rms(u_cell_mag, "all", "omitnan");
    
    if(plot_radial==1)
        % Load cell velocity for current frame
        ur_k = ur(:,:,k);
        ut_k = ut(:,:,k);

    end

    % Update values
    v_rms(k) = v_rms_k;
end

% Plot and save
plot(v_rms);
% plot(v_rms, '.r');
ylabel('v_{RMS}');
xlabel('Time')
print('-dpng','-r300',savename);
% Add labels

    % 
    % hf = make_fig([0.2 0.2 2 1.4]);
    % set(hf,'DefaultAxesPosition',[0.03 0.05 .95 .89]);
    %  set(gcf,'PaperPositionMode','auto','InvertHardCopy','off');
    % print('-dpng','-r300',[savenameheader,num2str(k,'%0.3d'),'-',num2str(k+1,'%0.3d')]);
    % 
    % close(hf);

end