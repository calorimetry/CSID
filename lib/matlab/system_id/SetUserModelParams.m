%{
Copyright 2017 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This is not an official Google product.
%}

function [parameters, varLabels] = ...
  SetUserModelParams(model_type)
% setModelParams --
% based on the model type, initialize the parameters, names and units
% this code is specific to the example calorimeter

%% determine model type
one_state = ~isempty(strfind(model_type, 'one state'));
two_state = ~isempty(strfind(model_type, 'two state'));
linear = ~isempty(strfind(model_type, 'linear'));
%% initialize the parameters in the calorimeter model
if (one_state && linear)
  ca0     = 1e+01;          % calorimeter heat capacity (J/°C)
  ca1     = 0.0;        % heat capacity temp coefficient (J/°C^2)
  ca2     = 0.0;        % heat capacity temp coefficient (J/°C^3)
  
  ka0     = 1e0;       % conductivity out of calorimeter (Watts/°C)
  ka1       = 0.0;      % conductivity coefficient (Watts/°C^2)
  ka2       = 0.0;      % conductivity coefficient (Watts/°C^3)
  ka3       = 0.0;      % conductivity coefficient (Watts/°C^4)
  
  parameters(1) = struct('Name', 'ca0',    'Unit', 'J/°C', 'Value', ca0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(2) = struct('Name', 'ca1',    'Unit', 'J/°C^2', 'Value', ca1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(3) = struct('Name', 'ca2',    'Unit', 'J/°C^3', 'Value', ca2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  parameters(4) = struct('Name', 'ka0', 'Unit','W/°C', 'Value', ka0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(5) = struct('Name', 'ka1', 'Unit','W/°C^2', 'Value', ka1, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', true);
  parameters(6) = struct('Name', 'ka2', 'Unit','W/°C^3', 'Value', ka2, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', true);
  parameters(7) = struct('Name', 'ka3', 'Unit','W/°C^4', 'Value', ka3, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', true);
  
elseif (one_state && ~linear)
  ca0     = 7.8862e+02;          % calorimeter heat capacity (J/°C)
  ca1     = 0.0;        % heat capacity temp coefficient (J/°C^2)
  ca2     = 0.0;        % heat capacity temp coefficient (J/°C^3)
  
  ka0     = 2.4851e-01;       % conductivity out of calorimeter (Watts/°C)
  ka1       = 0.0;      % conductivity coefficient (Watts/°C^2)
  ka2       = 0.0;      % conductivity coefficient (Watts/°C^3)
  ka3       = 0.0;      % conductivity coefficient (Watts/°C^4)
  
  parameters(1) = struct('Name', 'ca0',    'Unit', 'J/°C', 'Value', ca0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(2) = struct('Name', 'ca1',    'Unit', 'J/°C^2', 'Value', ca1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(3) = struct('Name', 'ca2',    'Unit', 'J/°C^3', 'Value', ca2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  parameters(4) = struct('Name', 'ka0', 'Unit','W/°C', 'Value', ka0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(5) = struct('Name', 'ka1', 'Unit','W/°C^2', 'Value', ka1, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', false);
  parameters(6) = struct('Name', 'ka2', 'Unit','W/°C^3', 'Value', ka2, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', false);
  parameters(7) = struct('Name', 'ka3', 'Unit','W/°C^4', 'Value', ka3, ...
    'Minimum', -inf,'Maximum', inf, 'Fixed', false);
  
  
elseif (two_state && linear)
  %0th, 1st and 2nd order non-linear parameters for ca
  % non-linear temrs in heat capacitites can reasonably take on negative values so long as net
  % value of the overall capacitance is positive
  ca0 = 1e-3;
  ca1 = 0;
  ca2 = 0;
  
  cb0 = 4e-1;
  cb1 = 0;
  cb2 = 0;
  
  kas0 = 2e-3;
  kas1 = 0;
  kas2 = 0;
  
  kab0 = 7e-3;
  kab1 = 0;
  kab2 = 0;
  
  kbs0 = 6e-2;
  kbs1 = 0;
  kbs2 = 0;
  
  %0th, 1st and 2nd order non-linear parameters for ca
  parameters(1) = struct('Name', 'ca0', 'Unit', 'J/°C', 'Value',  ca0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(2) = struct('Name', 'ca1', 'Unit', 'J/°C^2', 'Value',  ca1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(3) = struct('Name', 'ca2', 'Unit', 'J/°C^3', 'Value',  ca2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  %0th, 1st and 2nd order non-linear parameters for cb
  parameters(4) = struct('Name', 'cb0', 'Unit', 'J/°C', 'Value',  cb0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(5) = struct('Name', 'cb1', 'Unit', 'J/°C^2', 'Value',  cb1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(6) = struct('Name', 'cb2', 'Unit', 'J/°C^3', 'Value',  cb2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  %1st, 2nd & 3rd order non-linear parameters for kas
  parameters(7) = struct('Name', 'kas0', 'Unit', 'W/°C', 'Value',  kas0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(8) = struct('Name', 'kas1', 'Unit', 'W/°C^2', 'Value',  kas1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(9) = struct('Name', 'kas2', 'Unit', 'W/°C^3', 'Value',  kas2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  %1st, 2nd & 3rd order non-linear parameters for kab
  parameters(10) = struct('Name', 'kab0', 'Unit', 'W/°C', 'Value',  kab0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(11) = struct('Name', 'kab1', 'Unit', 'W/°C^2', 'Value',  kab1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(12) = struct('Name', 'kab2', 'Unit', 'W/°C^3', 'Value',  kab2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
  %1st, 2nd & 3rd order non-linear parameters for kbs
  parameters(13) = struct('Name', 'kbs0', 'Unit', 'W/°C', 'Value',  kbs0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(14) = struct('Name', 'kbs1', 'Unit', 'W/°C^2', 'Value',  kbs1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  parameters(15) = struct('Name', 'kbs2', 'Unit', 'W/°C^3', 'Value',  kbs2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  
elseif (two_state && ~linear)
  %0th, 1st and 2nd order non-linear parameters for ca
  % non-linear temrs in heat capacitites can reasonably take on negative values so long as net
  % value of the overall capacitance is positive
  ca0 = 1e-3;
  ca1 = 0;
  ca2 = 0;
  
  cb0 = 4e-1;
  cb1 = 0;
  cb2 = 0;
  
  kas0 = 2e-3;
  kas1 = 0;
  kas2 = 0;
  
  kab0 = 7e-3;
  kab1 = 0;
  kab2 = 0;
  
  kbs0 = 6e-2;
  kbs1 = 0;
  kbs2 = 0;
  
  %0th, 1st and 2nd order non-linear parameters for ca
  parameters(1) = struct('Name', 'ca0', 'Unit', 'J/°C', 'Value',  ca0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(2) = struct('Name', 'ca1', 'Unit', 'J/°C^2', 'Value',  ca1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(3) = struct('Name', 'ca2', 'Unit', 'J/°C^3', 'Value',  ca2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  
  %0th, 1st and 2nd order non-linear parameters for cb
  parameters(4) = struct('Name', 'cb0', 'Unit', 'J/°C', 'Value',  cb0, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(5) = struct('Name', 'cb1', 'Unit', 'J/°C^2', 'Value',  cb1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(6) = struct('Name', 'cb2', 'Unit', 'J/°C^3', 'Value',  cb2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  
  %1st, 2nd & 3rd order non-linear parameters for kas
  parameters(7) = struct('Name', 'kas0', 'Unit', 'W/°C', 'Value',  kas0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(8) = struct('Name', 'kas1', 'Unit', 'W/°C^2', 'Value',  kas1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(9) = struct('Name', 'kas2', 'Unit', 'W/°C^3', 'Value',  kas2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  
  %1st, 2nd & 3rd order non-linear parameters for kab
  parameters(10) = struct('Name', 'kab0', 'Unit', 'W/°C', 'Value',  kab0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(11) = struct('Name', 'kab1', 'Unit', 'W/°C^2', 'Value',  kab1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(12) = struct('Name', 'kab2', 'Unit', 'W/°C^3', 'Value',  kab2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  
  %1st, 2nd & 3rd order non-linear parameters for kbs
  parameters(13) = struct('Name', 'kbs0', 'Unit', 'W/°C', 'Value',  kbs0, ...
    'Minimum', -inf,    'Maximum', inf, 'Fixed', false);
  parameters(14) = struct('Name', 'kbs1', 'Unit', 'W/°C^2', 'Value',  kbs1, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  parameters(15) = struct('Name', 'kbs2', 'Unit', 'W/°C^3', 'Value',  kbs2, ...
    'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
end


%% initialize labels for state, input and output variables
varLabels.TimeUnit   = 'seconds';
if     one_state
  % State variables:    x = [Ta]
  % Input:              u = [input power, Ta, Ts]
  % Output:             y = [Ta];
  varLabels.StateName  = {'T-Center'};
  varLabels.StateUnit  = {'°C'};
  varLabels.InputName  = {'Input Power', 'T-Cener', 'T_Room'};
  varLabels.InputUnit  = {'Watts', '°C', '°C'};
  varLabels.OutputName = {'T-Core'};
  varLabels.OutputUnit = {'°C'};
  
elseif two_state
  % State variables:    x = [T_a, T_b] Temperatures proximal and distal to heat
  %                                    source respectively
  varLabels.StateName  = {'T_Center', 'T_Middle'};
  varLabels.StateUnit  = {'°C', '°C'};
  % Output:             y = [T_a, T_b];
  varLabels.OutputName = {'T-Center', 'T-Middle'};
  varLabels.OutputUnit = {'°C', '°C'};
  % Input:              u = [input power, T_a, T_b, Ts]
  varLabels.InputName  = {'Input Power','T_Center', ...
    'T_Outer', 'T_Room'};
  varLabels.InputUnit  = {'Watts', '°C', '°C', '°C'};
end
end

