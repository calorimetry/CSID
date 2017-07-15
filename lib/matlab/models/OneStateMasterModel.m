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

function [dxdt, y] = OneStateMasterModel ...
  (t, x, u, c0, c1, c2, k0, k1, k2, k3, varargin)
% OneStateMasterModel --
% Models nonlinear conductive heat transport and nonlinear heat capacity
% of a calorimeter based on a 1 state model. This function is
% to be used with functions modeling non-linear systems: idnlgrey, nlgrest.
% This model lumps all reactor heat capacity into one node.
% The output y is the measured temperature difference between the inside and the
% enclosure or surroundings. The heat capacity is treated as a capacitor
% that is tied to and unchanging zero Kelvin temperature.
%
% INPUTS
% t - is time
%
% P A R A M E T E R S
% c0   - calorimeter heat capacity, lumped value (J/delta°C)
% c1   - heat capacity tempeature coefficient (J/delta°C^2)
% c2   - heat capacity tempeature coefficient (J/delta°C^3)
% k0   - linear thermal conductance from calorimeter to enclosure (Watts/K)
% k1   - first order thermal conductance from calorimeter to enclosure
%          (Watts/K^2)
% k2   - second order thermal conductance from calorimeter to enclosure
%          (Watts/K^3)
%
% The state, input and output vectors (x,u and y) are
% x = [modeled delta temperature]
% u = [input power, measured delta temperature]
% y = [modeled delta temperature]
% where delta temperature = cell temperature - enclosure temperature
% NOTE: all temperatures are in Celsius.
%% copy states and inputs into clearly named variables
T_mod        = x(1);              % hot temperature
Qin          = u(1);              % applied power in Watts
T_meas       = u(2);              % measured hot temperature
Ts_meas      = u(3);              % thermal ground temperature

%% Compute current values of non-linear capacities and conductances
% TODO : Consider using linear, weighted or other mean value of
% temperatures instead of simple nodal temperatures to calculate parameters
c = c0 + c1 * T_meas + c2 * T_meas .^2;
k = k0 + k1 * T_meas + k2 * T_meas .^2 + k3 * T_meas .^3;

%% Calculate function return values
Qout = k * (T_mod - Ts_meas);
dxdt = (Qin - Qout) / c;  % rate of change in thermal delta
y  = x;                   % the output is the temperature state
