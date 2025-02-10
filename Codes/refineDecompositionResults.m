function data = refineDecompositionResults(data, anParams)

%% 1) Filter Monopolar Signals
[bH,aH] = butter(2,20/data.fsamp*2,'high'); % DEMUSE default
[bL,aL] = butter(2,500/data.fsamp*2,'low'); % DEMUSE default
data.SIG = cellfun(@(x) filtfilt(bH, aH, x), data.SIG, 'UniformOutput', false);
data.SIG = cellfun(@(x) filtfilt(bL, aL, x), data.SIG, 'UniformOutput', false);
fPL = 50; % powerline frequency (50 Hz in Europe)
for arm = 1:5
    [bN,aN] = butter(2,[fPL*arm-1 fPL*arm+1]/data.fsamp*2,'stop'); % DEMUSE default
    data.SIG = cellfun(@(x) filtfilt(bN, aN, x), data.SIG, 'UniformOutput', false);
end

%% 2) Find MUs Recruitment Order
firstFiringsMUs = cellfun(@(v) v(1), data.MUPulses);
[~, orderMUs] = sort(firstFiringsMUs);

%% 3) Clean MUs Firings with Instantaneous Discharge Rate (IDR) > maxIDR
IDR_MUs = cellfun(@(x) data.fsamp./diff(x), data.MUPulses, 'UniformOutput',false);
indexIDR_MUs = cellfun(@(x) x < anParams.maxIDR, IDR_MUs, 'UniformOutput',false);

%% 4) Sort MUs by Recruitment Order and take only valid firings (IDR < maxIDR)
tmpMUPulses = cell(size(data.MUPulses));
tmpPNR = zeros(size(data.PNR));

for mu = 1:numel(data.MUPulses)
    actMU = orderMUs(mu);
    tmpMUPulses{mu} = data.MUPulses{actMU}(indexIDR_MUs{actMU});
    tmpPNR(mu) = data.PNR(actMU);
end

data.MUPulses = tmpMUPulses;
data.PNR = tmpPNR;

%% 5) Compute IDR of each MU
data.IDR = cellfun(@(x) data.fsamp./diff(x), data.MUPulses, 'UniformOutput',false);
data.IDR = cellfun(@(x) x(x>anParams.minIDR & x<anParams.maxIDR), data.IDR, 'UniformOutput',false);

end



% % 1) Filter Monopolar Signals
% [bH,aH] = butter(2,20/data.fsamp*2,'high'); % DEMUSE default
% [bL,aL] = butter(2,500/data.fsamp*2,'low'); % DEMUSE default
% data.SIG = cellfun(@(x) filtfilt(bH, aH, x), data.SIG, 'UniformOutput', false);
% data.SIG = cellfun(@(x) filtfilt(bL, aL, x), data.SIG, 'UniformOutput', false);
% fPL = 50; % powerline frequency (50 Hz in Europe)
% for arm = 1:5
%     [bN,aN] = butter(2,[fPL*arm-1 fPL*arm+1]/data.fsamp*2,'stop'); % DEMUSE default
%     data.SIG = cellfun(@(x) filtfilt(bN, aN, x), data.SIG, 'UniformOutput', false);
% end
% 
% % 2) Find MUs Recruitment Order
% firstFiringsMUs = cellfun(@(v) v(1), data.MUPulses);
% [~, orderMUs] = sort(firstFiringsMUs);
% 
% % 3) Clean MUs Firings with Instantaneous Discharge Rate (IDR) > maxIDR
% IDR_MUs = cellfun(@(x) data.fsamp./diff(x), data.MUPulses, 'UniformOutput',false);
% indexIDR_MUs = cellfun(@(x) x < anParams.maxIDR, IDR_MUs, 'UniformOutput',false);
% 
% % 4) Sort MUs by Recruitment Order and take only valid firings (IDR < maxIDR)
% tmpMUPulses = cell(size(data.MUPulses));
% tmpPNR = zeros(size(data.PNR));
% 
% for mu = 1:numel(data.MUPulses)
%     actMU = orderMUs(mu);
%     tmpMUPulses{mu} = data.MUPulses{actMU}(indexIDR_MUs{actMU});
%     tmpPNR(mu) = data.PNR(actMU);
% end
% 
% data.MUPulses = tmpMUPulses;
% data.PNR = tmpPNR;
% 
% % 5) Compute IDR of each MU
% data.IDR = cellfun(@(x) data.fsamp./diff(x), data.MUPulses, 'UniformOutput',false);
% data.IDR = cellfun(@(x) x(x>anParams.minIDR & x<anParams.maxIDR), data.IDR, 'UniformOutput',false);
% 
% clear bH aH bL aL fPL arm bN aN
% clear firstFiringsMUs orderMUs
% clear IDR_MUs indexIDR_MUs mu actMU tmpMUPulses tmpPNR
