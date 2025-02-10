%% Initialization
% Clearing
clearvars
close all
clc

% Results Path Definition
decompResPath  = './trap20_trials_edited_diff_HLT.mat';
data = load(decompResPath, 'MUPulses', 'PNR', 'SIG', 'fsamp', 'ref_signal', 'IED', 'IPTs');

% Analysis Parameters
anParams.fsamp = data.fsamp; % sampling frequency of HD-sEMG signals (Hz, sps)
anParams.winLen4STA = 40; % window for Spike-Triggered Averaging (STA) (ms)
anParams.minIDR = 4; % minimum Interspike Interval allowed (Hz, pps). Usually, IDR < 4 Hz could derive from decomposition errors or spiking pauses
anParams.maxIDR = 50; % maximum Interspike Interval allowed (Hz, pps). Usually, one can set a maximum IDR on DEMUSE (e.g., 50 Hz); if not used, leave a value between around 30 and 50.
anParams.numTrials = 5; % number of trials performed, [] otherwise
anParams.trialDur = 30; % duration of trials if applicable (s), [] otherwise

clear decompResPath

%% Refine Decomposition Data (Filtering, Cleaning, Sorting)
data = refineDecompositionResults(data, anParams);

%% Compute Differential Signals and MUAPs Templates
% Compute Single Differential (SD) and Double Differential (DD) Signals
data = computeDifferentialSig(data);

% Compute MUAPs Templates
data = computeMUAPsTemplatesFromEMG(data, anParams);

%% Plot: EMG Signals
xTimeFlag = false; % decide if set x-axis in time or samples
MSDFlags = [true, true, true]; % flags to plot monopolar, single differential and/or double differential EMG signals
trialToPlot = 2; % [] is trials is not applicable, otherwise specify the trial to plot
samplesToPlot = 1+(anParams.trialDur*anParams.fsamp*(trialToPlot-1)):anParams.trialDur*anParams.fsamp*(trialToPlot); % do not change. it will be [] if trials is not applicable; [] for all trials, start:end for the specified trial
forcePlotFlag = false; % decide if plot reference signal overlayed to EMG signals

% plotEMGSignals(data, xTimeFlag, MSDFlags, samplesToPlot, forcePlotFlag);

clear xTimeFlag MSDFlags trialToPlot samplesToPlot forcePlotFlag

%% Plot: Force Signal with MUs' Istantaneous Firing Rates
xTimeFlag = false;

% plotForceWithMUsIDR(data, anParams, xTimeFlag)

clear xTimeFlag

%% Plot: Force Signal with MUs' Firing Instants
xTimeFlag = false;

% plotForceWithMUsPulses(data, anParams, xTimeFlag)

clear xTimeFlag

%% Plot: MUAPs Templates
MSDFlags = [true, true, true]; % flags to plot MUAPs Templates obtained from monopolar, single differential and/or double differential signals

% plotMUAPsTemplatesConcatenated(data, MSDFlags);

clear xTimeFlag MSDFlags
