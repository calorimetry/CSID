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

function [mGrey, X0] = fitModel(data_input, mGrey, parameters, run_data)
% fitModel -- fit a grey box model of various types to input data

range_fit = run_data.fit.range;
if isfield(run_data.fit, 'fix_x0')
  % defines if initial condition is fixed
  fix_initial_conditions = run_data.fit.fix_x0;
else
  % if the field does not exitst initial condition is floating
  fix_initial_conditions = false;
end

%% determine model type
is_linear = isa(mGrey, 'idgrey');
N_states = numStates(mGrey);

%% determine starting initial conditions
if isfield(run_data.fit, 'x0')
  X0_start = run_data.fit.x0;
else % set initial conditions by averaging the first 10 values
  X0_start = mean(data_input.OutputData(range_fit(1):range_fit(10), :));
end

%% Fit the model parameters to the data
fprintf('\nFitting model %s\n', run_data.model.type);
if isa(mGrey, 'idnlgrey')
  opt = nlgreyestOptions;
  opt.Display = 'on';
  opt.SearchOption.Advanced.RelImprovement = 1e-7; %DKF changed 6/30 (was 1e-6);
  opt.SearchOption.Advanced.TolFun = 1e-7; % (default 1e-5)
  opt.SearchOption.Advanced.TolX = 1e-10; % default is 1e-6
  % set maximum number of iterations
  if isfield(run_data.fit, 'max_iter')
    opt.SearchOption.MaxIter = run_data.fit.max_iter;
  end
  % set starting initial conditions
  for iState=1:N_states;
    if iState <= length(X0_start)
      mGrey.InitialStates(iState).Value = X0_start(iState);
      mGrey.InitialStates(iState).Fixed = fix_initial_conditions;
    else
      mGrey.InitialStates(iState).Value = 0;
      mGrey.InitialStates(iState).Fixed = false;
    end
  end
  %do the fit
  mGrey = nlgreyest(data_input(range_fit), mGrey, opt);

else % model is an idgrey
  opt = greyestOptions;
  if fix_initial_conditions
    opt.InitialState = X0_start;
  else
    opt.InitialState = 'estimate';
  end
  % set maximum number of iterations
  if isfield(run_data.fit,'max_iter')
    opt.SearchOption.MaxIter = run_data.fit.max_iter;
  end
  mGrey = greyest(data_input(range_fit), mGrey, opt);
end

%% report the fitted parameters
reportParams(mGrey, parameters);

if strcmp(mGrey.Report.Termination.WhyStop,...
          'Maximum number of iterations reached')
  warning('\nMax itereations reached, need to extend?\n')
end
fprintf('\nFitting Terminated because: %s\n',...
  mGrey.Report.Termination.WhyStop)

for kfit = 1:length(mGrey.Report.Fit.FitPercent)
  var = mGrey.OutputName{kfit};
  fitval = mGrey.Report.Fit.FitPercent(kfit);
  fprintf('Fit Percentage %.2f%% for %s\n', fitval, var)
end
fprintf('Fit Iterations %d\n', mGrey.Report.Termination.Iterations);

%% Gather and show results
if ~fix_initial_conditions
  % display the initial conditions
  fprintf('Fitted Initial Conditions: \n');
  X0 = mGrey.Report.Parameters.X0;
  switch N_states
    case 1
      if is_linear
        X0std = mGrey.Report.Parameters.X0Covariance(1,1);
      else
        X0std = nan(1,1);
      end
      fprintf('T = %f ± %f \n', X0(1), X0std);
    case 2
      if is_linear
        X0std = mGrey.Report.Parameters.X0Covariance(eye(2)==1);
      else
        X0std = nan(2, 1);
      end
      fprintf('T_a = %f ± %f \nT_b = %f ± %f \n', ...
        X0(1), X0std(1), X0(2), X0std(2));
    case 3
      if is_linear
        X0std = mGrey.Report.Parameters.X0Covariance(eye(3)==1);
      else
        X0std = nan(3, 1);
      end
      fprintf('T_a = %f ± %f \nT_b = %f ± %f \nT_c = %f ± %f \n', ...
        X0(1), X0std(1), X0(2), X0std(2), X0(3), X0std(3));
    otherwise
      warning('number of states not recognized')
  end
else
  X0 = X0_start;
end
end
