function data = computeMUAPsTemplatesFromEMG(data, anParams)

%% Initialization
% Organize data for computation
sigs = {data.SIG; data.SIG_SD; data.SIG_DD}; % extract HD-sEMG signals
sigNames = {'mono','sd','dd'};
MUPulses = data.MUPulses; % extract MUs Pulses
fsamp = data.fsamp; % extract HD-sEMG sampling frequency
winLen4STA = anParams.winLen4STA / 1000; % window length in seconds for STA
halfWinLen4STA = round(winLen4STA * fsamp / 2); % half window length in samples for STA
numMUs = numel(MUPulses); % number of MUs identified

% Loop through each signal type (SIG, SIG_SD, SIG_DD)
for s = 1:numel(sigs)
    % Extract signals data
    sig = sigs{s};
    [nRows, nCols] = size(sig);

    % Initialize structures for metadata (max column and peak-to-peak amplitude)
    data.templateMUAPs.([sigNames{s} '_metadata']).maxColumn = zeros(1, numMUs);
    data.templateMUAPs.([sigNames{s} '_metadata']).maxP2P = zeros(1, numMUs);

    maxP2P = zeros(nCols, numMUs); % to store the peak-to-peak values for each MU

    % Loop through each motor unit (MU)
    for mu = 1:numMUs
        actMUPulses = MUPulses{mu} / fsamp; % convert MU pulses to seconds
        numFirings = numel(actMUPulses); % number of MU firings

        % Define the time window around each pulse (centered around 0)
        timeWindow = (-halfWinLen4STA:halfWinLen4STA); % window in samples
        windowLen = length(timeWindow); % length of the window (samples)

        % Loop through each channel
        for r = 1:nRows
            for c = 1:nCols
                muapWindow = zeros(numFirings, windowLen); % preallocate window for each MU pulse

                % Extract windows for each pulse
                for pulseIdx = 1:numFirings
                    pulse = round(actMUPulses(pulseIdx) * fsamp); % convert pulse to sample index

                    % Define the window around each pulse
                    startIdx = max(1, pulse - halfWinLen4STA);
                    endIdx = min(length(sig{r,c}), pulse + halfWinLen4STA);

                    % Extract the signal window for this pulse and pad if necessary
                    extractedWindow = sig{r,c}(startIdx:endIdx);

                    % Check if the window is too short at the start or end and pad with zeros
                    if length(extractedWindow) < windowLen
                        if pulse - halfWinLen4STA < 1
                            % Pad the start with zeros if near the beginning
                            muapWindow(pulseIdx, :) = [zeros(1, windowLen - length(extractedWindow)), extractedWindow];
                        elseif pulse + halfWinLen4STA > length(sig{r,c})
                            % Pad the end with zeros if near the end
                            muapWindow(pulseIdx, :) = [extractedWindow, zeros(1, windowLen - length(extractedWindow))];
                        end
                    else
                        muapWindow(pulseIdx, :) = extractedWindow;
                    end
                end

                % Compute the average MUAP for this channel
                data.templateMUAPs.(sigNames{s}){r,c,mu} = mean(muapWindow, 1);
                data.templateMUAPs.(sigNames{s}){r,c,mu} = data.templateMUAPs.(sigNames{s}){r,c,mu} - mean(data.templateMUAPs.(sigNames{s}){r,c,mu}); % remove mean value

                % Calculate the peak-to-peak value for this channel and motor unit
                currentP2P = peak2peak(data.templateMUAPs.(sigNames{s}){r,c,mu});
                if abs(currentP2P) > abs(maxP2P(c, mu))
                    maxP2P(c, mu) = abs(currentP2P); % store the maximum peak-to-peak value
                end
            end
        end

        % Find the column with the maximum peak-to-peak value for this MU
        [~, data.templateMUAPs.([sigNames{s} '_metadata']).maxColumn(mu)] = max(maxP2P(:, mu));
        % Store the maximum peak-to-peak value for this MU
        data.templateMUAPs.([sigNames{s} '_metadata']).maxP2P(mu) = max(maxP2P(:, mu));
    end
end

% Normalization step: Normalize each MUAP by its max peak-to-peak value
for s = 1:numel(sigs)
    sig = sigs{s};
    [nRows, nCols] = size(sig);

    for mu = 1:numMUs
        for r = 1:nRows
            for c = 1:nCols
                % Normalize each MUAP template by the maximum peak-to-peak value
                maxP2PVal = data.templateMUAPs.([sigNames{s} '_metadata']).maxP2P(mu);
                if maxP2PVal ~= 0
                    data.templateMUAPs.(sigNames{s}){r,c,mu} = data.templateMUAPs.(sigNames{s}){r,c,mu} / maxP2PVal;
                    % data.templateMUAPs.(sigNames{s}){r,c,mu} = rescale(data.templateMUAPs.(sigNames{s}){r,c,mu});
                    % data.templateMUAPs.(sigNames{s}){r,c,mu} = data.templateMUAPs.(sigNames{s}){r,c,mu} - mean(data.templateMUAPs.(sigNames{s}){r,c,mu});
                end
            end
        end
    end
end

end
