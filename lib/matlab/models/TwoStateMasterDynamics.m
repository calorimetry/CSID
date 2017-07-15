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

function dxdt = TwoStateMasterDynamics ...
  (t, x, u,...        %time, state and input vectors
  ca0, ca1, ca2,...   %1st, 2nd & 3rd order non-linear parameters for ca
  cb0, cb1, cb2,...   %1st, 2nd & 3rd order non-linear parameters for cb
  kas0, kas1, kas2,...%1st, 2nd & 3rd order non-linear parameters for kab
  kab0, kab1, kab2,...%1st, 2nd & 3rd order non-linear parameters for kab
  kbs0, kbs1, kbs2,...%1st, 2nd & 3rd order non-linear parameters for kbs
  varargin)
% TwoStateMasterDynamics --
% A two state heat transport model with all fluxes non-linear to third order
% This function for use with non-linear modeling functions: idnlgrey, nlgrest.
% A R G U M E N T S
% t - is time
%
% P A R A M E T E R S
% ca  - heat capacity of sample/reaction tube/heater (J/delta°C)
% cb  - heat capacity of insulating jacket (J/delta°C)
% kas - thermal conductance from Ta node to T_surroundings (Watts/K)
% kab - thermal conductance from Ta node to Tb node(Watts/K)
% kbs - thermal conductance from Tb node to T_surroundings node (Watts/K)
%
% The state, input and output vectors (x,u and y) are
% x = [Ta, Tb] % This model works with nodal temperatures
%
% u = [Qin, Ta_meas, Tb_meas, Ts_meas]
%
% y = x (the output is the same as the input, nlgreyest integrator handles
% time evolution)
% NOTE: all temperatures are in Celsius.

%% Copy vectorized states and inputs into clearly named variables
Ta             = x(1);  % Temperature - Ta node
Tb             = x(2);  % Temperature - Tb node
Qin            = u(1); % Applied power (Watts)
Ta_meas        = u(2); % Measured temperature Ta node
Tb_meas        = u(3); % Measured temperature Tb node
Ts_meas        = u(4); % Temperature in celcius of the surroundings/copper can

%% Compute modelled nodal temperature (in °C)
delta_Tab = Ta - Tb;

%% Compute modeled temperature deltas (in °C)
delta_Tas = Ta - Ts_meas;
delta_Tbs = Tb - Ts_meas;

%% Compute current values of non-linear capacities and conductances
% TODO : Consider using linear, weighted or other mean value of
% temperatures instead of simple nodal temperatures to calculate parameters
ca = ca0 + ca1 * Ta_meas + ca2 * Ta_meas.^2;
cb = cb0 + cb1 * Tb_meas + cb2 * Tb_meas.^2;
kas = kas0 + kas1 * Ta_meas + kas2 * Ta_meas.^2;
kab = kab0 + kab1 * Ta_meas + kab2 * Ta_meas.^2;
kbs = kbs0 + kbs1 * Tb_meas + kbs2 * Tb_meas.^2;

%% Compute heat flows
Qas_conducted = kas * delta_Tas;
Qab_conducted = kab * delta_Tab;
Qas_stored    = Qin - Qas_conducted - Qab_conducted;
Qbs_conducted = kbs * delta_Tbs;
Qbs_stored    = Qab_conducted - Qbs_conducted;

%% Calculate function return values
dTa_dt = Qas_stored / ca;
dTb_dt = Qbs_stored / cb;
dxdt = [dTa_dt, dTb_dt]; % rate of change in Temperature deltas
end
