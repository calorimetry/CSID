<p align="center">
<img src="/supporting/CSID_logo.png" width="350" style="text-align: center;">
</p>

### Synopsis

Calorimetry System Identification (CSID) is a MATLAB library for modelling calorimeters using System Identification and Optimization toolboxes.

### Requirements

MATLAB R2016a (Version 9.0), with the following toolboxes:
- Optimization Toolbox<sup>TM</sup> (Version 7.4)
- System Identification Toolbox<sup>TM</sup> (Version 9.4)
Executing these scripts with previous or subsequent versions of MATLAB will likely cause an exception to be raised.

### What is System Identification?
System identification is a family of techniques for developing mathematical models of dynamic systems from experimental data.  System identification typically attempts to fit a model (for example a lumped-element model) to experimental training data (such as time-series data from a calibration experiment) for a given dynamical system (such as a calorimeter).  The training data serves to quantitatively identify the key characteristics of the system.  Once a satisfactory model has been found, it can be used for at least two important functions:   
- **Controller design:** Given a desired output from the system, determine the necessary input signal(s).
- **Input extraction:** Given a measured output, determine an input that could have created it.
For the purposes of analyzing the calorimetry data herein, the second of these functions will be most important. 
An expanded summary on system identification can be found on [Wikipedia](https://en.wikipedia.org/wiki/System_identification). The classic textbook on system identification is Lennart Ljung's "[System Identification: Theory for the user](https://books.google.ca/books/about/System_Identification.html?id=nHFoQgAACAAJ&redir_esc=y)".





################################################




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

