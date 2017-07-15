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

function run_data = calcEnergy(run_data)
% DEPRECATED (DKF 2016-06-10) Now use finishEnergyCalcs.m
% calcEnergy --Integrate various power and heat time series and report on
% various energy measures and metrics depending on what is present in
% runData per the following definitions:
% TODO 5/5/16 update the field names in this documentation
% runData.Power = the electrical power input into the calorimeter
% runData.Power_out = the measured power output, typically the sum of heat
%   paths out of the system: sum (k*deltaT)
% runData.ResidualPower = The difference between Power_out and Power (this is
%   an unfortunate definition, consistent with historic usage)
% runData.ResidualPower = "true Residual power" i.e. power that is
%   unexplained by model prediction. Typically k*(deltaT_measured -
%   deltaT_modeled)
% runData.StoredHeat = Heat energy stored in calorimeter. Typically
%   c*deltaT_measured
% runData.StoredHeatModeled = Modeled value for stored heat. Typically
%   c*deltaT_modeled

% define the time span of the energy calculation
range = (run_data.nStart:run_data.nStop)';
mask = ones(length(run_data.Power_in.data), 1); % TODO mask start to stop fit

% get time vector; accommodate varied data structures
if isnumeric(run_data.Time)
  t  = run_data.Time.(range);
elseif isstruct(run_data.Time)
  t  = run_data.Time.data(range);
end

fprintf('\nEnergy over the range %.1f to %.1f seconds\n',...
        t(range(1)), t(range(end)));

% energy in
has_power_in = true;
if isfield(run_data, 'Power')
  power_in = run_data.Power;
elseif isfield(run_data,'Power_in')
  power_in = run_data.Power_in.data;
else
  has_power_in = false;
end
if has_power_in
  run_data.EnergyIn.data  = integrateEnergy(power_in, t, range, mask);
  run_data.EnergyIn.unit = 'Joules';
  fprintf('Energy In:     %21.2f Joules\n', ...
    run_data.EnergyIn.data(end));
end

% energy out - modelled
run_data.EnergyOut_modelled.data = ...
  integrateEnergy(run_data.Power_out_modelled, t, range, mask);
run_data.EnergyOut_modelled.unit = 'Joules';
fprintf('Modelled Energy Out:    %12.2f Joules\n', ...
  run_data.EnergyOut_modelled.data(end));
% energy out - inferred
run_data.EnergyOut_inferred.data = ...
  integrateEnergy(run_data.Power_out_inferred, t, range, mask);
run_data.EnergyOut_inferred.unit = 'Joules';
fprintf('Inferred Energy Out:    %12.2f Joules\n', ...
  run_data.EnergyOut_inferred.data(end));

% residual energy
run_data.ResidualEnergy.data = ...
  integrateEnergy(run_data.ResidualPower, t, range, mask);
run_data.ResidualEnergy.unit = 'Joules';
fprintf('Residual Heat:   %19.2f Joules\n', run_data.ResidualEnergy.data(end));

% modelled stored heat
storedHeat_modelled = run_data.StoredHeat_modelled(run_data.nStop) -...
                      run_data.StoredHeat_modelled(run_data.nStart);
fprintf('Modelled Energy Stored: %12.2f Joules\n', storedHeat_modelled);

% inferred stored heat
storedHeat_inferred = run_data.StoredHeat_inferred(run_data.nStop) -...
                      run_data.StoredHeat_inferred(run_data.nStart);
fprintf('Inferred Energy Stored: %12.2f Joules\n', storedHeat_inferred);

% energy coefficient of performance
% COP refactored by DKF on 6/2/2016
% run_data.COP_modelled = ...
%   (run_data.ResidualEnergy.data(end) + storedHeat_modelled) /...
%   run_data.EnergyIn.data(end) + 1;

run_data.COP_E_modelled.data = ...
  (run_data.EnergyOut_modelled.data + run_data.StoredHeat_modelled) ...
          ./ run_data.EnergyIn.data;
fprintf('Modelled Coefficient of Performance: %f Joules/Joule\n', ...
  run_data.COP_E_modelled.data(end));

run_data.COP_E_inferred.data = ...
  (run_data.EnergyOut_inferred.data + run_data.StoredHeat_inferred) ...
          ./ run_data.EnergyIn.data;
% COP refactored by DKF on 6/2/2016
% run_data.COP_inferred = ...
%   (run_data.ResidualEnergy.data(end) + storedHeat_inferred) /...
%   run_data.EnergyIn.data(end) + 1;
fprintf('Inferred Coefficient of Performance: %f Joules/Joule\n\n', ...
  run_data.COP_E_inferred.data(end));
end
