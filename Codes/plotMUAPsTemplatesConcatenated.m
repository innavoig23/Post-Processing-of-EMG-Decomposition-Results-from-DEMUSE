function plotMUAPsTemplatesConcatenated(data, MSDFlags)

%% Elements Needed for Plots
signalsToPlot = {'mono', 'sd', 'dd'};
numMUs = numel(data.templateMUAPs.mono(1,1,:)); % Number of MU
colors = lines(numMUs);

lineWidth = 1.5;

xLabelString = "Column No.";
yLabelString = "Row No.";
xGlobalLabelString = "Time (a.u.)";
yGlobalLabelString = "Normalized MUAP (a.u.)";

% Define the gap between columns (1/5 of the template length)
gapFactor = 1/5;

%% Adjust layout dynamically based on number of MUs
numColsLayout = 3;  % Use 3 columns
numRowsLayout = ceil(numMUs / numColsLayout); % Determine number of rows

% %% Loop through each signal type (Mono, SD, DD) based on flags
% for s = 1:numel(signalsToPlot)
%     if MSDFlags(s) % Check if the user wants to plot this signal type
%         fig = figure('Name', ['Concatenated MUAPs - ' upper(signalsToPlot{s})], 'WindowState', 'maximized');
% 
%         % Create tiled layout and set global y-label
%         t = tiledlayout(fig, numRowsLayout, numColsLayout, 'TileSpacing', 'tight', 'Padding', 'tight'); % Dynamic layout
%         xlabel(t, xGlobalLabelString, 'FontSize', 18, 'FontWeight','bold'); % Global x-label for the entire figure
%         ylabel(t, yGlobalLabelString, 'FontSize', 18, 'FontWeight','bold'); % Global y-label for the entire figure
% 
%         % Extract signal data and number of rows/cols
%         [nRows, nCols] = size(data.templateMUAPs.(signalsToPlot{s})(:,:,1));
% 
%         % Loop through each MU
%         for mu = 1:numMUs
%             ax = nexttile; % Create a new tile and get its axes handle
%             hold on;
%             actPNR = data.PNR(mu);
% 
%             % Concatenate signals for each row separately
%             concatenatedSignalPerRow = cell(nRows, 1); % Cell array to store concatenated signals for each row
%             colCenters = zeros(1, nCols); % Array to store the center positions of each concatenated column
% 
%             % Loop through each row
%             for actRow = 1:nRows
%                 concatenatedRow = []; % Initialize empty array for concatenated row
%                 colStartIdx = 1; % Track the start index of each column
% 
%                 % Loop through each column and concatenate the signals with NaN gaps
%                 for actCol = 1:nCols
%                     muapTemplate = data.templateMUAPs.(signalsToPlot{s}){actRow, actCol, mu};
%                     concatenatedRow = [concatenatedRow; muapTemplate(:)]; % Append the signal from current column
% 
%                     % Store the center position for x-axis label
%                     colLength = length(muapTemplate);
%                     colCenter = colStartIdx + floor(colLength / 2);
%                     colCenters(actCol) = colCenter;
% 
%                     % Update start index for next column
%                     colStartIdx = colStartIdx + colLength;
% 
%                     if actCol < nCols
%                         % Add NaN gap between columns
%                         gapLength = round(gapFactor * length(muapTemplate));
%                         concatenatedRow = [concatenatedRow; NaN(gapLength, 1)];
%                         colStartIdx = colStartIdx + gapLength; % Update start index to account for gap
%                     end
%                 end
% 
%                 % Store the concatenated row in the cell array
%                 concatenatedSignalPerRow{actRow} = concatenatedRow;
%             end
% 
%             % Plot all concatenated signals for each row with an offset
%             for actRow = 1:nRows
%                 offset = actRow; % nRows - actRow + 1; % Offset for each row
%                 plot(concatenatedSignalPerRow{actRow} + offset, 'LineWidth',lineWidth, 'Color',0.2*ones(1,3)); % Plot concatenated signal with offset
%             end
% 
%             % Set plot properties for each tile
%             title(sprintf('MU %d', mu));
%             subtitle(sprintf('PNR = %.2f', actPNR));
% 
%             % Only set ylabel for tiles in the first column
%             if mod(mu-1, numColsLayout) == 0
%                 ylabel(ax, yLabelString);
%                 yticks(1:nRows);
%                 yticklabels(fliplr(1:nRows)); % Flip the row labels so that the topmost row is 1
%             else
%                 yticklabels([]); % Remove y-tick labels for other tiles
%             end
% 
%             % Only set xlabel for tiles in the last row
%             if mu > numMUs - numColsLayout
%                 xlabel(ax, xLabelString);
%                 xticks(colCenters);
%                 xticklabels(1:nCols); % Custom x-tick labels at the center of each concatenated column
%             else
%                 xticklabels([]); % Remove x-tick labels for other tiles
%             end
% 
%             ylim([0 nRows + 1]);
%             xlim([0 length(concatenatedSignalPerRow{1})]);
% 
%             hold off;
% 
%             % Other plot settings
%             set(gca, 'FontSize', 16);
%         end
%     end
% end

%% Loop through each signal type (Mono, SD, DD) based on flags
for s = 1:numel(signalsToPlot)
    if MSDFlags(s) % Check if the user wants to plot this signal type
        fig = figure('Name', ['MUAPs Templates - ' upper(signalsToPlot{s})], 'WindowState', 'maximized');

        % Create tiled layout and set global y-label
        t = tiledlayout(fig, numRowsLayout, numColsLayout, 'TileSpacing', 'compact', 'Padding', 'tight'); % Dynamic layout
        % xlabel(t, xGlobalLabelString, 'FontSize', 18, 'FontWeight','bold'); % Global x-label for the entire figure
        ylabel(t, yGlobalLabelString, 'FontSize', 18, 'FontWeight','bold'); % Global y-label for the entire figure

        % Extract signal data and number of rows/cols
        [nRows, nCols] = size(data.templateMUAPs.(signalsToPlot{s})(:,:,1));

        % Loop through each MU
        for mu = 1:numMUs
            ax = nexttile; % Create a new tile and get its axes handle
            hold on;
            actPNR = data.PNR(mu);

            % Concatenate signals for each row separately
            concatenatedSignalPerRow = cell(nRows, 1); % Cell array to store concatenated signals for each row
            colCenters = zeros(1, nCols); % Array to store the center positions of each concatenated column

            % Loop through each row
            for actRow = 1:nRows
                concatenatedRow = []; % Initialize empty array for concatenated row
                colStartIdx = 1; % Track the start index of each column

                % Loop through each column and concatenate the signals with NaN gaps
                for actCol = 1:nCols
                    muapTemplate = data.templateMUAPs.(signalsToPlot{s}){actRow, actCol, mu};
                    concatenatedRow = [concatenatedRow; muapTemplate(:)]; % Append the signal from current column

                    % Store the center position for x-axis label
                    colLength = length(muapTemplate);
                    colCenter = colStartIdx + floor(colLength / 2);
                    colCenters(actCol) = colCenter;

                    % Update start index for next column
                    colStartIdx = colStartIdx + colLength;

                    if actCol < nCols
                        % Add NaN gap between columns
                        gapLength = round(gapFactor * length(muapTemplate));
                        concatenatedRow = [concatenatedRow; NaN(gapLength, 1)];
                        colStartIdx = colStartIdx + gapLength; % Update start index to account for gap
                    end
                end

                % Store the concatenated row in the cell array
                concatenatedSignalPerRow{actRow} = concatenatedRow;
            end

            % Plot all concatenated signals for each row with an offset
            for actRow = 1:nRows
                offset = actRow; % nRows - actRow + 1; % Offset for each row
                plot(concatenatedSignalPerRow{actRow} + offset, 'LineWidth',lineWidth, 'Color',0.2*ones(1,3)); % Plot concatenated signal with offset
            end

            % Set plot properties for each tile
            title(sprintf('MU %d', mu));
            % subtitle(sprintf('PNR = %.2f', actPNR));

            % Only set ylabel for tiles in the first column
            if mod(mu-1, numColsLayout) == 0
                ylabel(ax, yLabelString);
            end

            % Only set xlabel for tiles in the last row
            if mu > numMUs - numColsLayout
                xlabel(ax, xLabelString);
            end

            ylim([0 nRows + 1]);
            xlim([0 length(concatenatedSignalPerRow{1})]);
            yticks(1:nRows);
            yticklabels(fliplr(1:nRows)); % Flip the row labels so that the topmost row is 1

            % Set custom x-ticks and x-tick labels at the center of each concatenated column
            xticks(colCenters);
            xticklabels(1:nCols);

            hold off;

            % Other plot settings
            set(gca, 'FontSize', 16);
            set(gca, 'box','off')
            % axis off
        end
    end
end

end



% ticks labels always
