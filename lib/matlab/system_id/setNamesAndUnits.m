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

function [ model_or_data ] = ...
  setNamesAndUnits( model_or_data, names_and_units )
% add names and units to a model or to data object
% model objects all have input, state and output data
% data objects do not have state data, and may or may not
% have input or output data
%
% Revision History
% 2017-05-11 iddata object intersampling set to first order hold

fields = fieldnames(names_and_units);
nfields = length(fields);

if isa(model_or_data, 'iddata')
  % data
  for k = 1 : nfields
    if ~any(strcmp(fields{k}, {'StateName', 'StateUnit'}))
      model_or_data.(fields{k}) = names_and_units.(fields{k});
    end
  end
  % Set the data intersampling behavior to first order hold
  model_or_data.InterSample = ...
    repmat({'foh'}, size(model_or_data.InterSample));
elseif isa(model_or_data, 'idnlgrey')
  % nonlinear model
  for k = 1 : nfields
    if strcmp(fields{k}, 'StateName')
      names = names_and_units.(fields{k});
      for i=1 : length(names)
        model_or_data.InitialStates(i).Name = names{i};
      end
    elseif strcmp(fields{k}, 'StateUnit')
      units = names_and_units.(fields{k});
      for i = 1 : length(units)
        model_or_data.InitialStates(i).Unit = units{i};
      end
    else
      model_or_data = ...
        set(model_or_data, fields{k}, names_and_units.(fields{k}));
    end
  end
elseif isa(model_or_data, 'idgrey')
  % linear model
  for k = 1 : nfields
    model_or_data.(fields{k}) = names_and_units.(fields{k});
  end
else
  error('Unknown model');
end
end
