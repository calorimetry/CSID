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

function run_data = OneStateMasterEnergyCalcs(run_data, data_input, x)
% OneStateMasterEnergyCalcs -- calculate power and energy from model inputs
% and states

  fprintf('Initiating energy calculations...\n');
  model = run_data.model.model;
%% get input data
  time = data_input.SamplingInstants;
  u = data_input.InputData;
  Power.in.all = u(:, 1); % Applied power (Watts)
  T_meas       = u(:, 2); % Measured temperature - hot node
  Ts_meas      = u(:, 3); % Temperature in celcius of surroundings/copper can
  T_mod        = x(:, 1); % Modeled temperature - hot node

%% compute the non-linear model parameters
  % get the model parameters
  fillParameters (model)
  c = ca0 + ca1 * T_meas + ca2 * T_meas .^2;
  k = ka0 + ka1 * T_meas + ka2 * T_meas .^2 + ka3 * T_meas .^3;
  
%% compute energy and power
  % energy in
  Energy.in.all = cumtrapz(time, Power.in.all);
  % energy stored
  Energy.stored.a.modelled  = cumtrapz(c .* [0; diff(T_mod)]);
  Energy.stored.a.inferred  = cumtrapz(c .* [0; diff(T_meas)]);
  % power out
  Power.out.a.modelled  = k .* (T_mod - Ts_meas);
  Power.out.a.inferred  = k .* (T_meas - Ts_meas);
  run_data = finishEnergyCalcs(Energy, Power, time, run_data);
end



