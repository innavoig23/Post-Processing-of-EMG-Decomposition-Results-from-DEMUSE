function plotForceWithMUsPulses(data)

%% Initialization
% Check if force signal is available
refSigAvailability = ~isempty(data.ref_signal);
if refSigAvailability
    forceSig = data.ref_signal * 100; % Convert force signal to %MVC
end
MUPulses = data.MUPulses; % Extract MUs Pulses
fsamp = data.fsamp; % Extract HD-sEMG sampling frequency
timeVector = (1:size(data.IPTs, 2)) / fsamp; % Time vector

% Define colormap for MU pulses
cmap = jet(numel(MUPulses));

%% Plot and set y-axis properties
% Create figure
fig = figure('Name', 'MU Pulses', 'WindowState', 'maximized');

% Left axis (Always for MU Pulses)
if refSigAvailability, yyaxis left; end
hold on;
for mu = 1:numel(MUPulses)
    pulses = MUPulses{mu} / fsamp; % convert to time (s)
    line([pulses; pulses], [(mu - 0.45) * ones(1, length(pulses)); (mu + 0.45) * ones(1, length(pulses))], ...
        'LineStyle', '-', 'Marker', 'none', 'Color', cmap(mu, :)); % plot vertical pulse markers
end
hold off;

% Set y-axis ticks and labels for MU Numbers
yticks(1:numel(MUPulses)); % Center ticks on each MU
yticklabels(1:numel(MUPulses));
ylabel('MU Number', 'FontWeight', 'bold');

% Check if force signal is available
if refSigAvailability
    % Right axis (Force % MVC)
    yyaxis right
    plot(timeVector, forceSig, 'k', 'LineWidth', 2), axis padded;
    ylabel('Force (% MVC)', 'FontWeight', 'bold');
    ylim([-1, max(forceSig) * 1.1]);
end

%% Set x-axis properties
xlim([timeVector(1) timeVector(end)]);
xlabel('Time (s)', 'FontWeight', 'bold');

%% Set plot settings
set(gca, 'FontSize', 16);

end