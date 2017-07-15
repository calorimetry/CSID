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

function PlotModelParams(model, run_data)
% PlotModelParams - plot the range of model conductances (k's) and
% capacities (c's) over the operating domain (the domain of state vector
% variation) for a nonlinear model
%
% The code assumes that the model parameters are in order by name and that
% the parameter names follow the convention <namea0>, <namea1>,...<nameb0>,
% <nameb1>, ... where the letter signifies the model element and the number
% signifies the parameter coefficient order and name starts with a c or a k
% to denote either heat capacity or thermal conductivity.
%
% If the state vector is available, then the parameters for each node are
% assumed to depend on the state of each node. The node states are assumed
% to be the first states in the state vector.



%% pick off the element polynomial coefficients
current_element_name = model.Parameters(1).Name(1 : end - 1);
kelement = 1;
elements.name{1} = current_element_name;
elements.polynomial{1} = [];
elements.unit{1} = model.Parameters(1).Unit;

nparam = length(model.Parameters);
for kp = 1:nparam
  new_element_name = model.Parameters(kp).Name(1:end - 1);
  if any(strcmp(new_element_name(1), {'c', 'k'})) % element starts with a "c" or a "k"
    if ~strcmp(current_element_name, new_element_name)
      current_element_name = new_element_name;
      kelement = kelement + 1;
      elements.name{kelement} = new_element_name;
      elements.polynomial{kelement} = [];
      elements.unit{kelement} = model.Parameters(kp).Unit;
    end
    elements.polynomial{kelement} = [model.Parameters(kp).Value, ...
      elements.polynomial{kelement}];
  end
end

%% Count up the number of nodes, and grab the state vector array
n_nodes = numel(unique(cellfun(@(x) x(2 : 2), elements.name)));
x_domain = cell(n_nodes, 1);
if isfield(run_data, 'x')
  x_modeled = run_data.x(:, 1 : n_nodes);
else
  warning('\nNonlinear parameter plotting relies on state vector.\n')
end
%% compute the temperature domains
for kt = 1:n_nodes
  x_min = min(x_modeled(:,kt));
  x_max = max(x_modeled(:,kt));
  x_domain{kt} = (x_min:0.05 * (x_max - x_min):x_max)';
end


%% pick off the element polynomial coefficients
current_element_name = model.Parameters(1).Name(1 : end - 1);
kelement = 1;
elements.name{1} = current_element_name;
elements.polynomial{1} = [];
elements.unit{1} = model.Parameters(1).Unit;

for kp = 1:nparam
  new_element_name = model.Parameters(kp).Name(1:end - 1);
  % element starts with a "c" or a "k"
  if any(strcmp(new_element_name(1), {'c', 'k'}))
    if ~strcmp(current_element_name, new_element_name)
      current_element_name = new_element_name;
      kelement = kelement + 1;
      elements.name{kelement} = new_element_name;
      elements.polynomial{kelement} = [];
      elements.unit{kelement} = model.Parameters(kp).Unit;
    end
    elements.polynomial{kelement} = [model.Parameters(kp).Value, ...
      elements.polynomial{kelement}];
  end
end

%% plot the values of each model element over its domain of variation
nelement = length(elements.name);
start_unit = elements.unit{1};
figure;
for kelement = 1:nelement
  name = elements.name{kelement};
  if length(name)>1; % model is multi-nodal, i.e. multi-state
    node_cells = strfind({'a', 'b', 'c', 'd'}, name(2));
    node_index = find(not(cellfun('isempty', node_cells)));
  else % model is one state
    node_index = 1;
  end
  domain = x_domain{node_index};
  y_values = polyval(elements.polynomial{kelement}, domain);
  if strcmp(elements.unit{kelement}, start_unit)
    yyaxis left
  else
    yyaxis right
  end
  plot(domain, y_values, 'LineWidth', 2)
  hold on
  set(gca, 'FontSize', 14)
  ylabel(elements.unit{kelement}, 'FontSize', 20);
  xlabel([run_data.model.model.InitialStates.Name ' (' ...
    run_data.model.model.InitialStates.Unit ')'], 'FontSize', 20);
end
hold off
legend(elements.name, 'Location', 'northeast', 'FontSize', 20)
legend('boxoff')
