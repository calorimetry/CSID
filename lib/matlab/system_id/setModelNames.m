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

function [model_name, energy_calc_code, model_class] = ...
  setModelNames(model_type)
% setModelNames -- Set the model names to be used for system ID
% [model_name, energy_calc_code, model_class] = setModelNames(model_type)
% INPUTS
%   model_type - a string specifying the type of model
% OUTPUTS
%   model_name - model used to fit the experimental observations
%   energy_calc_code - code used to calculate energy and power
%   model_class - the class of the model

if ~isempty(strfind(model_type, ...
    'one state master model'))
  model_name       = 'OneStateMasterModel';
  energy_calc_code = 'OneStateMasterEnergyCalcs';
  model_class      = 'idnlgrey';
elseif ~isempty(strfind(model_type, ...
    'two state master model'))
  model_name       = 'TwoStateMasterModel';
  energy_calc_code = 'TwoStateMasterEnergyCalcs';
  model_class      = 'idnlgrey';
end
end
