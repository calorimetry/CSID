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

function [data_input] = PrepFittingData(run_data, data_labels)
% prepFittingData -- from measured time series data, construct the inputs,
% u, and outputs, y, to be used for fitting and analysis

% determine model type
model_type = run_data.model.type;

%% set the output and input
power_in = run_data.input_power.data;
% one state
if ~isempty(strfind(model_type, 'one state'))
  y = run_data.center_temp.data;
% two state
elseif ~isempty(strfind(model_type, 'two state'))
  y = [run_data.center_temp.data, run_data.middle_temp.data;];
end
u = [power_in, y, run_data.room_temp.data];

%% package the dataset
data_input = iddata(y, u, run_data.delta_time.value, 'Name','Calorimeter Data');
data_input.InterSample(:) = {'foh'};
% name the dataset variables
data_input = setNamesAndUnits(data_input, data_labels);
end
