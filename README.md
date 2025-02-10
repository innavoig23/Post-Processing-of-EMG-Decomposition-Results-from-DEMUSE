# Post-Processing of EMG Decomposition Results from DEMUSE

## Overview

This repository contains scripts for post-processing the decomposition results of EMG signals (HD-sEMG or iEMG) obtained from [DEMUSE®](https://demuse.feri.um.si/) or from custom-written decomposition algorithms, provided that the results are saved in a format similar to DEMUSE.

These scripts (and others) were used in my [**MSc Thesis at Politecnico di Torino**](https://webthesis.biblio.polito.it/33655/), which focused on analyzing Motor Unit (MU) behavior and functional performance in patients with brachial plexus injuries following nerve transfer surgery.

If you need to process multiple decomposition result files in batch mode, you can transform the main script into a function (for example, `function processDecompositionResults(decompResPath)`) that takes the file path as an input argument. This allows for automated processing of multiple subjects or trials without manually modifying the script each time.

### **Upcoming Features**
In the near future, additional functionalities will be included to compute various neuromuscular metrics, such as:
- **Instantaneous Discharge Rate (IDR) computation**
- **Coefficient of Variation of Interspike Intervals (CoV-ISI) computation**
- **Cumulative Spike Train (CST) computation**
- **Coherence analysis between CST of two different MU groups**
- **Coherence analysis between CST and exerted force**
- **Automatic computation of Conduction Velocity (CV) for individual MUs**
- **Estimation of MU Territory**

Additionally, a **Graphical User Interface (GUI)** might be developed in the future to simplify the processing and visualization of results.


## Analysis Parameters (`anParams` struct)

To perform the analyses, several key parameters must be specified in the `anParams` struct before running the scripts.

- **1. Sampling Frequency (`fsamp`)**: Defines the sampling frequency of the HD-sEMG signals (Hz or sps).
- **2. Spike-Triggered Averaging (STA) Window Length (`winLen4STA`)**: It is used to extract the Motor Unit Action Potential (MUAP) shape from the EMG signals using the STA technique. This parameter defines the window length (ms) around each detected MU firing.
- **3. Minimum and Maximum Instantaneous Discharge Rate (IDR) (`minIDR` and `maxIDR`)**: Setting minimum and maximum IDR values ensures that 3a) very low IDR values (< 4 pps) are excluded, as they may be caused by decomposition errors or spiking pauses, and 3b) in some cases, a known physiological upper bound can be imposed (e.g., 50 pps).during manual editing of the decomposition results. Additionally, for visualization purposes, setting an upper limit helps normalize the IDR plot and ensure all MUs are plotted on the same scale.
- **4. Trial Information (`numTrials` and `trialDur`)**: 	These parameters are useful when more than one trial are performed as a continuous recording. For example, they allow for: plotting only specific trials, defining the x-axis format (time, samples, trial numbers), computing per-trial metrics (such as mean firing rate, Coefficient of Variation of Interspike Intervals (CoV-ISI), coherence between Cumulative Spike Trains (CST) of different MU groups, and coherence between CST of all identified MUs and exerted force).
