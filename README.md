<p align="center">
<img src="/supporting/CSID_logo.png" width="350" style="text-align: center;">
</p>

### Synopsis

Calorimetry System Identification (CSID) is a MATLAB library for modelling calorimeters using System Identification and Optimization toolboxes.

### Requirements
MATLAB R2016a (Version 9.0), with the following toolboxes:
Optimization ToolboxTM (Version 7.4)
System Identification ToolboxTM (Version 9.4)
Executing these scripts with previous or subsequent versions of MATLAB will likely cause an exception to be raised.

### Installation
Download the CSID repository.
```
git clone https://github.com/fraserparlane-google/csid
```
The CSID library comes with four examples that execute on sample data out-of-the box.  These are located in `/system_id/examples/`.  To add the CSID library to external MATLAB files, add the CSID lib directory to your MATLAB search path by adding the following to your MATLAB script:

```matlab
addpath(‘[your_path]/system_id/lib’)

```
### What is System Identification?
System identification is a family of techniques for developing mathematical models of dynamic systems from experimental data.  System identification typically attempts to fit a model (for example a lumped-element model) to experimental training data (such as time-series data from a calibration experiment) for a given dynamical system (such as a calorimeter).  The training data serves to quantitatively identify the key characteristics of the system.  Once a satisfactory model has been found, it can be used for at least two important functions:   
- **Controller design:** Given a desired output from the system, determine the necessary input signal(s).
- **Input extraction:** Given a measured output, determine an input that could have created it.
For the purposes of analyzing the calorimetry data herein, the second of these functions will be most important. 
An expanded summary on system identification can be found on Wikipedia. The classic textbook on system identification is Lennart Ljung's "System Identification: Theory for the user". 

### System ID Tutorial

Four examples are included in `/system_id/examples/`.  Each example demonstrates a different model: either a one- or two-state model, and either linear or nonlinear.  As included, these examples fit a model to the same set of sample data.

<p align="center">
<img src="/supporting/schematic1.png" width="80%" style="text-align: center;">
</p>

Each example has two MATLAB scripts: a calibration and prediction script.  The calibration script determines the calorimeter-dependent constants for the model by fitting the provided time-resolved temperature data (T1) as a function of the time-resolved input power data (P1). 

<p align="center">
<img src="/supporting/schematic2.png" width="80%:" style="text-align: center;">
</p>

After using the calibration data and script to identify the model parameters, the model can now be used to predict the temperature of a system, given any arbitrary input power. Moreover, the model can also be used to determine the inverse: predict the input power (P2*) from the output temperature data (T2). This is specifically useful in scenarios when an unknown exo/endothermic phenomena is being studied, and the total input power (P2) is unknown.
Each model fits the provided sample data with varying degrees of accuracy.  The accuracy of a model is described by how well the model can predict the system output, as defined by the Normalized Root Mean Square of Error (NRMSE).

[NRMSE equation]

Further, in experiments where the input to the system in known, this model can be used to define the Coefficient of Performance (COP) for power (or energy) of an experiment defined as:
<p align="center">
<img src="https://latex.codecogs.com/gif.latex?COP_{Power}&space;=&space;\frac{P_{inferred}}{P_{input}}" style="text-align: center;">
</p>

Furthermore, we quantify deviation between measured and inferred power (energy) and report them as residuals of the prediction.

<p align="center">
<img src="https://latex.codecogs.com/gif.latex?P_{residual}&space;=&space;P_{inferred}&space;-&space;P_{input}" title="P_{residual} = P_{inferred} - P_{input}" style="text-align: center;">
</p>

### Calibration and Prediction
Each script can operate in two modes: calibration or prediction.  This mode is defined by `run_data.model.action`:

```matlab
run_data.model.action = 'fit';  % fit: Calibration; predict: Prediction
```

### Model Selection
Each calibration and prediction script designates the model to bse used with `run_data.model.type`.  For convenience, each model name is provided in a comment below.

```matlab
run_data.model.type = 'one state master model with 0 Kelvin ground linear';
%        M O D E L    T Y P E S
% 'one state master model with 0 Kelvin ground linear'
% 'one state master model with 0 Kelvin ground'
% 'two state master model zero Kelvin ground linear'
% 'two state master model zero Kelvin ground'
```

### Data Preparation
Each model reads in either the calibration or sample data CSV from the `/system_id/tutorials/` directory.  

### Model Fitting
Successful output from example 1 calibration:

```  
loading data...
Total NaNs encountered while loading dataset: 0
Analyzing dataset of length 987 points.

Fitting model one state master model with 0 Kelvin ground linear

Original and Fitted Model Parameters with standard deviation
-----------------------------------------------------------------
  Symbol   Start Value         Fit Value         Uncertainty
-----------------------------------------------------------------
     ca0   1.0000e+01   2.3011e-03 ± 1.3485e-04   ( 5.860%)
     ca1   0.0000e+00   0.0000e+00 ± 0.0000e+00   (   NaN%)
     ca2   0.0000e+00   0.0000e+00 ± 0.0000e+00   (   NaN%)
     ka0   1.0000e+00   8.6677e-03 ± 3.2243e-04   ( 3.720%)
     ka1   0.0000e+00   0.0000e+00 ± 0.0000e+00   (   NaN%)
     ka2   0.0000e+00   0.0000e+00 ± 0.0000e+00   (   NaN%)
     ka3   0.0000e+00   0.0000e+00 ± 0.0000e+00   (   NaN%)

Fitting Terminated because: Change in parameters was less than the specified tolerance
Fit Percentage 94.77% for T-Core
Fit Iterations 45
Initiating energy calculations...
Completing energy calculations...
Finished.
```
### Generated figures

<p align="center">
<img src="/supporting/example1calibration_figure1.png" width="550" style="text-align: center;">
</p>
The resulting Figure 1 from Example 1 - Calibration

<p align="center">
<img src="/supporting/example1calibration_figure2.png" width="550" style="text-align: center;">
</p>
The resulting Figure 2 from Example 1 - Calibration

<p align="center">
<img src="/supporting/example1calibration_figure3.png" width="550" style="text-align: center;">
</p>
The resulting Figure 3 from Example 1 - Calibration

### Contact
All communication regarding this repository should be directed to calorimetry@google.com.

