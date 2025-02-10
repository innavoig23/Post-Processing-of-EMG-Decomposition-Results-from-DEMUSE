function ax = plotEMGSignals(data, xTimeFlag, MSDFlags, samplesToPlot, forcePlotFlag)

%% Elements Needed for Plots
if isempty(samplesToPlot)
    samplesToPlot = 1:length(data.SIG{1,1});
end

if xTimeFlag
    time = (samplesToPlot-1)/data.fsamp;
    xLabelString = "Time (s)";
else
    time = samplesToPlot;
    xLabelString = "Sample";
end

yLabelString = "Channel Row";
[nRows, nCols] = size(data.SIG);
ax = [];


RMS_MONO = cellfun(@rms, data.SIG, 'UniformOutput', false);
RMS_SD = cellfun(@rms, data.SIG_SD, 'UniformOutput', false);
RMS_DD = cellfun(@rms, data.SIG_DD, 'UniformOutput', false);

rms.RMS_MONO = max(max(cellfun(@max, RMS_MONO)));
rms.RMS_SD = max(max(cellfun(@max, RMS_SD)));
rms.RMS_DD = max(max(cellfun(@max, RMS_DD)));
rmsScaleFactor = 12;

%% Figure with uitab Creation
signalsToPlot = {'SIG', 'SIG_SD', 'SIG_DD'};
rmsNames = {'RMS_MONO', 'RMS_SD', 'RMS_DD'};
tabTitles = {'Monopolar (MONO) Signals', 'Single Differential (SD) Signals', 'Double Differential (DD) Signals'};
numSignalsToPlot = sum(MSDFlags);

if numSignalsToPlot > 1
    fig = figure(Name="HD-sEMG Signals Plot", WindowState="maximized");
    tabgp = uitabgroup(fig);
else
    fig = figure(Name="HD-sEMG Signals Plot", WindowState="maximized");
end

%% For loop to plot MONO, SD, and/or DD
for i = 1:length(signalsToPlot)
    if MSDFlags(i)
        if numSignalsToPlot > 1
            tab = uitab(tabgp, 'Title', tabTitles{i});
            t = tiledlayout(tab, 1, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');
        else
            t = tiledlayout(fig, 1, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');
        end
        title(t, tabTitles{i});

        numRowsCurrent = nRows - (i - 1); % adjust the number of rows based on signal type

        for actCol = 1:nCols
            ax(end+1) = nexttile(t);
            hold on;
            for actRow = numRowsCurrent:-1:1
                offset = numRowsCurrent - actRow + 1;
                sigData = data.(signalsToPlot{i}){actRow, actCol}(samplesToPlot) / rms.(rmsNames{i})/rmsScaleFactor + offset;
                plot(time, sigData);
            end

            if forcePlotFlag
                forceSig = data.ref_signal(samplesToPlot,1)';
                forceSig = rescale(forceSig) * (numRowsCurrent+1);
                plot(time, forceSig, 'Color', [0 0 0 0.4], 'LineWidth', 0.5);
            end
            ylim([0 numRowsCurrent+1])
            xlim([samplesToPlot(1) samplesToPlot(end)])
            hold off;
        end
        xlabel(t, xLabelString);
        ylabel(t, yLabelString);
    end
end

%% Axis Linking
% if numSignalsToPlot > 1
    linkaxes(ax, 'x');
% end

end

