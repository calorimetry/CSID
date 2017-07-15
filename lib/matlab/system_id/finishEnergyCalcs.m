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

function run_data = finishEnergyCalcs(Energy, Power, time, run_data)
% finishEnergyCalcs -- given model specific energy and power constructions,
% complete the calculation of energy, power, coefficient of performance and
% residuals and then place that information into the run_data structure.

fprintf('Completing energy calculations...\n');
%% compute energy and power sums
mi_fields    = {'modelled', 'inferred'};
struct_names = {'Energy', 'Power'};
so_fields    = {'stored', 'out'};

% sum modelled and inferred, power.out and energy.stored, for all nodes
for kv = 1:length(struct_names)
  var = eval(struct_names{kv});
  so_field = so_fields{kv};
  if (~isfield(var.(so_field), 'all')) % don't do sum if already done
    nodefields = fieldnames(var.(so_field));
    for kmi = 1:length(mi_fields)
      var.(so_field).all.(mi_fields{kmi}) = ...
        zeros(size(var.(so_field).(nodefields{1}).(mi_fields{kmi})));
      for knode = 1:length(nodefields)
        var.(so_field).all.(mi_fields{kmi}) = ...
          var.(so_field).all.(mi_fields{kmi}) + ...
          var.(so_field).(nodefields{knode}).(mi_fields{kmi});
      end
    end
  end
  eval([struct_names{kv}, '=var;']); % store the result in the structure
end

% sum the power and energy in all nodes
for kv = 1:length(struct_names)
  var = eval(struct_names{kv});
  if (~isfield(var.in, 'all')) % don't do sum if already done
    nodefields = fieldnames(var.in);
    var.in.all = ...
      zeros(size(var.in.(nodefields{1})));
    for knode = 1:length(nodefields)
      var.in.all = ...
        var.in.all + ...
        var.in.(nodefields{knode});
    end
  end
  eval([struct_names{kv}, '=var;']); % store the result in the structure
end

clear var

%% compute power from energy derivative and energy from power integral
% integrate power out to compute energy out
Energy.out = integrateStruct(Power.out, time);
% differentiate stored energy to get power going into storage
Power.stored = derivStruct(Energy.stored, time);

%% coefficient of performance and residuals
% define the threshold above which there is sufficient input energy to
% commence meaningful computation of COPs and residuals
Ein_range = Energy.in.all > run_data.fit.input_energy_threshold;

% computations
Energy = calcCOP(Energy, Ein_range);
Power  = calcCOP(Power,  Ein_range);
Energy = calcResidual(Energy, Ein_range);
Power  = calcResidual(Power,  Ein_range);

%% return power and energy results
run_data.Energy = nanpad(Energy, size(run_data.Time.data), run_data.fit.range);
run_data.Power  = nanpad(Power, size(run_data.Time.data), run_data.fit.range);
end
