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

function run_data = TwoStateMasterEnergyCalcs(run_data, data_input, x)
% TwoStateMasterEnergyCalcs -- calculate power and energy for the two
% state master model with zero Kelvin ground
fprintf('Initiating energy calculations...\n');
model = run_data.model.model;
%% get input data
  time = data_input.SamplingInstants;
  u = data_input.InputData;
  Power.in.all = u(:, 1); % Applied power (Watts)
  Ta_meas      = u(:, 2); % Measured temperature - Ta node
  Tb_meas      = u(:, 3); % Measured temperature - Tb node
  Ts_meas      = u(:, 4); % Measured temperature of surroundings
  Ta_mod       = x(:, 1); % Modeled temperature - Ta node
  Tb_mod       = x(:, 2); % Modeled temperature - Tb node

%% compute the non-linear model parameters
  % get the model parameters
  fillParameters (model)
  % compute nonlinear parameters
  ca = ca0 + ca1 * Ta_meas + ca2 * Ta_meas.^2;
  cb = cb0 + cb1 * Tb_meas + cb2 * Tb_meas.^2;
  kas = kas0 + kas1 * Ta_meas + kas2 * Ta_meas.^2;
  % kab = kab0 + kab1 * Ta_meas + kab2 * Ta_meas.^2;
  kbs = kbs0 + kbs1 * Tb_meas + kbs2 * Tb_meas.^2;

%% compute energy and power
  % energy in
  Energy.in.all = cumtrapz(time, Power.in.all);
  % energy stored
  Energy.stored.a.modelled = cumtrapz(ca .* [0; diff(Ta_mod)]);
  Energy.stored.b.modelled = cumtrapz(cb .* [0; diff(Tb_mod)]);
  Energy.stored.a.inferred = cumtrapz(ca .* [0; diff(Ta_meas)]);
  Energy.stored.b.inferred = cumtrapz(cb .* [0; diff(Tb_meas)]);
  % power out
  Power.out.a.modelled = kas .* (Ta_mod  - Ts_meas);
  Power.out.b.modelled = kbs .* (Tb_mod  - Ts_meas);
  Power.out.a.inferred = kas .* (Ta_meas - Ts_meas);
  Power.out.b.inferred = kbs .* (Tb_meas - Ts_meas);
  % complete calculations
  run_data = finishEnergyCalcs(Energy, Power, time, run_data);
end
