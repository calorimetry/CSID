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

function modelParam = reportParams(model, parameters)
% reportParams -- Report model parameters after a fit is performed
% Inputs
% model - the model (class idgrey or idnlgrey) resulting from estimation
% parameters - parameters, either cell array or struct depending on the
%              model type. These parameters are the ones used to start the
%              model estimation.
% Outputs
% parameters - parameters resulting from the model fit, stored in the
%              appropriate class (cell array or struct) to create a new
%              grey box model
%
[pvec, pvec_sd] = getpvec(model);
if isempty(pvec_sd)
  pvec_sd = nan(length(pvec),1);
end
nparam = length(parameters);
modelParam = parameters;
fprintf('\nOriginal and Fitted Model Parameters with standard deviation\n');
fprintf('%s\n', repmat('-', 1, 65));
fprintf('  Symbol   Start Value         Fit Value         Uncertainty\n');
fprintf('%s\n', repmat('-', 1, 65));
for k = 1:nparam
  if isa(model, 'idnlgrey')              % user is using an nlgrey model
    modelParam(k).Value = pvec(k);       % fit value
    start_value = parameters(k).Value;   % start value
    name = model.Parameters(k).Name;     % parameter symbol
  else   
    if isstruct(parameters)              % start value and name
      start_value = parameters(k).Value;
      modelParam(k).Value = pvec(k);
    else
      start_value = parameters{k, 2};
      modelParam{k, 2} = pvec(k);          
    end
    name = model.Structure.Parameters(k).Name;
  end
  fprintf('%8s   %10.4e   %10.4e ± %10.4e   (%6.3f%%)\n', ...
    name, start_value, pvec(k), pvec_sd(k),...
    100 * pvec_sd(k) ./ abs(pvec(k)));
end

end

