function plotForceWithMUsIDR(data, anParams, xTimeFlag)

%% Initialization
% Get data for plot
refSigAvailability = ~isempty(data.ref_signal); % check if ref_signal (i.e., force) is available
if refSigAvailability
    forceSig = data.ref_signal * 100; % extract force signal and express it as a percentage of MVC
end
MUPulses = data.MUPulses; % extract MUs Pulses
fsamp = data.fsamp; % extract HD-sEMG sampling frequency

timeVector = (1:size(data.IPTs, 2)) / fsamp; % time vector

trialsFlag = ~isempty(anParams.numTrials); % check if signals of different trials are concatenated
if ~trialsFlag
    xTimeFlag = true; % if there is a single trial, set automatically xTimeFlag to true
end

cmap = lines(numel(MUPulses)); % define colormap for MUs pulses


%% Plot and set y-axis properties
% Create figure
fig = figure('Name', 'IDR of MUs', 'WindowState','maximized');

% Define IDR axis (always on the right)
yyaxis left
hold on;
maxIDR = anParams.maxIDR; % maximum Interspike Interval allowed (Hz, pps)
minIDR = anParams.minIDR; % minimum Interspike Interval allowed (Hz, pps)

for mu = 1:numel(MUPulses)
    idr = fsamp ./ diff(MUPulses{mu}); % compute Instantaneous Discharge Rate (IDR)
    pulses = MUPulses{mu} / fsamp; % get pulses instant (s)
    pulses = pulses(2:end);
    pulses = pulses(idr >= minIDR); % ensure to filter out IDR < minIDR
    idr = idr(idr >= minIDR);
    plot(pulses, idr + (maxIDR * (mu - 1)), 'o', 'Color', cmap(mu, :))
end
hold off;

% Set y-axis ticks for IDR (always on the right)
ytickValues = [];
for mu = 0:numel(MUPulses)-1
    ytickValues = [ytickValues, [10, 20, 30] + mu * maxIDR];
end
yticks(ytickValues);
if refSigAvailability
    yticklabels(reshape([repmat({'10'}, numel(MUPulses), 1), ...
                         arrayfun(@(mu) sprintf('MU %d  20', mu), 1:numel(MUPulses), 'UniformOutput', false)', ...
                         repmat({'30'}, numel(MUPulses), 1)]', [], 1));
else
    yticklabels(repmat({'10', '20', '30'}, 1, numel(MUPulses)));
end
ylabel('IDR (pps)', 'FontWeight', 'bold');
ylim([0 (maxIDR * numel(MUPulses) + 10)]);

% Check if force signal is available
yyaxis right
if refSigAvailability
    % If force signal is available:
    % - Left y-axis -> Force (% MVC)
    
    plot(timeVector, forceSig, 'k', 'LineWidth', 2), axis padded
    ylabel('Force (% MVC)', 'FontWeight', 'bold');
    ylim([-1 max(forceSig) * 1.1]);

else
    % If force signal is NOT available:
    % - Left y-axis -> Motor Unit (MU number)
    
    yticks(1:numel(MUPulses)); % Set MU numbers as y-ticks
    yticklabels(arrayfun(@(mu) sprintf('MU %d', mu), 1:numel(MUPulses), 'UniformOutput', false));
    ylabel('MU Number', 'FontWeight', 'bold');
end

%% Set x-axis properties
% Limits
xlim([timeVector(1) timeVector(end)])

% Ticks and Labels
% Decide to set x-axis with trials (if applicable) or time
if xTimeFlag
    xlabel('Time (s)', FontWeight='bold');
    xticks('auto'); % use default tick locations
else
    trialDur = anParams.trialDur;
    numTrials = anParams.numTrials;
    trialLen = trialDur * fsamp;
    xTickValues = trialLen * (0.5:1:numTrials - 0.5) / fsamp; % midpoints for each trial (s)
    xticks(xTickValues)
    xTickLabels = arrayfun(@(x) sprintf('%d', x), 1:numTrials, 'UniformOutput', false); % labels for each trial (1, 2, 3, ...)
    xticklabels(xTickLabels)
    xlabel('Trial', FontWeight='bold');
end

%% Set plot settings
set(gca, 'FontSize', 16);

end
